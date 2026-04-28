import os
from datetime import datetime, timedelta, timezone
from functools import wraps
from hashlib import sha256

import jwt
from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from werkzeug.security import check_password_hash, generate_password_hash


app = Flask(__name__)
CORS(app)

database_url = os.environ.get("DATABASE_URL")
if database_url and database_url.startswith("postgres://"):
    database_url = database_url.replace("postgres://", "postgresql://", 1)

app.config["SQLALCHEMY_DATABASE_URI"] = database_url
app.config["SQLALCHEMY_TRACK_MODIFICATIONS"] = False
app.config["JWT_SECRET"] = os.environ.get("JWT_SECRET", "change-this-secret-on-render")

db = SQLAlchemy(app)


class User(db.Model):
    id = db.Column(db.String(120), primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(160), unique=True, nullable=False, index=True)
    phone = db.Column(db.String(40), nullable=False, default="")
    password_hash = db.Column(db.String(255), nullable=False)
    role = db.Column(db.String(20), nullable=False)
    state = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    address = db.Column(db.Text, nullable=True)
    service_type = db.Column(db.String(80), nullable=True)
    price = db.Column(db.Integer, nullable=False, default=0)
    created_at = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))

    def to_dict(self):
        data = {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "phone": self.phone,
            "role": self.role,
            "state": self.state,
            "city": self.city,
            "address": self.address,
            "serviceType": self.service_type,
            "price": self.price,
        }
        if self.role == "customer":
            data["completionCode"] = customer_completion_code(self.id)
        return data


class Mechanic(db.Model):
    id = db.Column(db.String(80), primary_key=True)
    name = db.Column(db.String(120), nullable=False)
    email = db.Column(db.String(160), nullable=False)
    phone = db.Column(db.String(40), nullable=False, default="")
    role = db.Column(db.String(20), nullable=False, default="mechanic")
    service_type = db.Column(db.String(80), nullable=False)
    state = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    address = db.Column(db.Text, nullable=True)
    rating = db.Column(db.Float, nullable=False, default=0)
    rating_count = db.Column(db.Integer, nullable=False, default=0)
    jobs_completed = db.Column(db.Integer, nullable=False, default=0)
    is_available = db.Column(db.Boolean, nullable=False, default=True)
    price = db.Column(db.Integer, nullable=False, default=0)
    distance = db.Column(db.Float, nullable=False, default=0)

    def to_dict(self):
        return {
            "id": self.id,
            "name": self.name,
            "email": self.email,
            "phone": self.phone,
            "role": self.role,
            "serviceType": self.service_type,
            "state": self.state,
            "city": self.city,
            "address": self.address,
            "rating": self.rating,
            "ratingCount": self.rating_count,
            "jobsCompleted": self.jobs_completed,
            "isAvailable": self.is_available,
            "price": self.price,
            "distance": self.distance,
        }


class CustomerRating(db.Model):
    customer_id = db.Column(db.String(120), primary_key=True)
    customer_name = db.Column(db.String(120), nullable=False)
    rating = db.Column(db.Float, nullable=False, default=0)
    rating_count = db.Column(db.Integer, nullable=False, default=0)

    def to_dict(self):
        return {
            "customerId": self.customer_id,
            "customerName": self.customer_name,
            "rating": self.rating,
            "ratingCount": self.rating_count,
        }


class Booking(db.Model):
    id = db.Column(db.String(120), primary_key=True)
    customer_id = db.Column(db.String(120), nullable=False)
    customer_name = db.Column(db.String(120), nullable=False)
    customer_phone = db.Column(db.String(40), nullable=True)
    mechanic_id = db.Column(db.String(120), nullable=False)
    mechanic_name = db.Column(db.String(120), nullable=False)
    mechanic_phone = db.Column(db.String(40), nullable=True)
    service_id = db.Column(db.String(80), nullable=True)
    service_name = db.Column(db.String(80), nullable=False)
    service_type = db.Column(db.String(80), nullable=False)
    booking_date = db.Column(db.DateTime(timezone=True), nullable=False)
    time_slot = db.Column(db.String(40), nullable=False)
    address = db.Column(db.Text, nullable=False)
    state = db.Column(db.String(80), nullable=False)
    city = db.Column(db.String(80), nullable=False)
    status = db.Column(db.String(30), nullable=False, default="pending")
    price = db.Column(db.Float, nullable=False)
    notes = db.Column(db.Text, nullable=True)
    created_at = db.Column(db.DateTime(timezone=True), nullable=False, default=lambda: datetime.now(timezone.utc))
    completed_at = db.Column(db.DateTime(timezone=True), nullable=True)
    customer_rating = db.Column(db.Integer, nullable=True)
    customer_rating_comment = db.Column(db.Text, nullable=True)
    mechanic_rating = db.Column(db.Integer, nullable=True)
    mechanic_rating_comment = db.Column(db.Text, nullable=True)

    def to_dict(self):
        return {
            "_id": self.id,
            "id": self.id,
            "customerId": self.customer_id,
            "customerName": self.customer_name,
            "customerPhone": self.customer_phone,
            "mechanicId": self.mechanic_id,
            "mechanicName": self.mechanic_name,
            "mechanicPhone": self.mechanic_phone,
            "serviceId": self.service_id,
            "serviceName": self.service_name,
            "serviceType": self.service_type,
            "bookingDate": self.booking_date.isoformat(),
            "timeSlot": self.time_slot,
            "address": self.address,
            "state": self.state,
            "city": self.city,
            "status": self.status,
            "price": self.price,
            "notes": self.notes,
            "createdAt": self.created_at.isoformat(),
            "completedAt": self.completed_at.isoformat() if self.completed_at else None,
            "customerRating": self.customer_rating,
            "customerRatingComment": self.customer_rating_comment,
            "mechanicRating": self.mechanic_rating,
            "mechanicRatingComment": self.mechanic_rating_comment,
        }


def parse_datetime(value):
    if not value:
        return datetime.now(timezone.utc)
    return datetime.fromisoformat(value.replace("Z", "+00:00"))


def require_json_fields(data, fields):
    missing = [field for field in fields if data.get(field) in (None, "")]
    if missing:
        return jsonify({"message": f"Missing required fields: {', '.join(missing)}"}), 400
    return None


def normalize(value):
    return (value or "").strip().lower()


def apply_average(current_average, current_count, new_rating):
    total = current_average * current_count + new_rating
    count = current_count + 1
    return round(total / count, 2), count


def customer_completion_code(customer_id):
    digest = sha256(str(customer_id).encode("utf-8")).hexdigest()
    return str(1000 + (int(digest[:8], 16) % 9000))


def mechanic_user_payload(user):
    data = user.to_dict()
    mechanic = Mechanic.query.get(user.id) if user.role == "mechanic" else None
    if mechanic:
        data.update(mechanic.to_dict())
    return data


def refresh_mechanic_stats(mechanic_id):
    mechanic = Mechanic.query.get(mechanic_id)
    if not mechanic:
        return

    completed_count = Booking.query.filter_by(
        mechanic_id=mechanic_id,
        status="completed",
    ).count()
    ratings = [
        booking.mechanic_rating
        for booking in Booking.query.filter_by(mechanic_id=mechanic_id).all()
        if booking.mechanic_rating is not None
    ]

    mechanic.jobs_completed = completed_count
    mechanic.rating_count = len(ratings)
    mechanic.rating = round(sum(ratings) / len(ratings), 2) if ratings else 0


def make_token(user):
    payload = {
        "sub": user.id,
        "email": user.email,
        "role": user.role,
        "exp": datetime.now(timezone.utc) + timedelta(days=30),
    }
    return jwt.encode(payload, app.config["JWT_SECRET"], algorithm="HS256")


def auth_required(fn):
    @wraps(fn)
    def wrapper(*args, **kwargs):
        auth_header = request.headers.get("Authorization", "")
        if not auth_header.startswith("Bearer "):
            return jsonify({"message": "Missing bearer token"}), 401

        token = auth_header.removeprefix("Bearer ").strip()
        try:
            payload = jwt.decode(token, app.config["JWT_SECRET"], algorithms=["HS256"])
        except jwt.PyJWTError:
            return jsonify({"message": "Invalid or expired token"}), 401

        user = User.query.get(payload["sub"])
        if not user:
            return jsonify({"message": "User not found"}), 401

        request.current_user = user
        return fn(*args, **kwargs)

    return wrapper


def seed_mechanics():
    if Mechanic.query.first():
        return

    mechanics = [
        ("m1", "Rajesh Kumar", "Plumbing", "Maharashtra", "Pune", 299, 4.8),
        ("m2", "Amit Sharma", "Electrician", "Maharashtra", "Pune", 250, 4.6),
        ("m3", "Sunil Verma", "AC Repair", "Maharashtra", "Pune", 499, 4.9),
        ("m4", "Arun Gupta", "Carpentry", "Maharashtra", "Mumbai", 349, 4.7),
        ("m5", "Mohan Lal", "Painting", "Maharashtra", "Pune", 650, 4.8),
        ("m6", "Rohan Mehta", "Deep Cleaning", "Maharashtra", "Nagpur", 849, 4.5),
        ("m7", "Suresh Babu", "Daily Cleaning", "Maharashtra", "Pune", 149, 4.3),
        ("m8", "Naveen Kumar", "Pest Control", "Maharashtra", "Pune", 749, 4.8),
        ("m9", "Tarun Bhatia", "Water Purifier", "Maharashtra", "Pune", 299, 4.6),
    ]

    for mechanic_id, name, service, state, city, price, rating in mechanics:
        db.session.add(
            Mechanic(
                id=mechanic_id,
                name=name,
                email=f"{mechanic_id}@fixitpro.example",
                phone="+91 9876543210",
                service_type=service,
                state=state,
                city=city,
                address=f"{city}, {state}",
                price=price,
                rating=rating,
                rating_count=20,
                jobs_completed=50,
                distance=2.0,
            )
        )
    db.session.commit()


@app.before_request
def ensure_schema():
    db.create_all()
    seed_mechanics()


@app.get("/health")
def health():
    return jsonify({"ok": True, "service": "fixit-pro-flask-api"})


@app.post("/api/auth/register")
def register():
    data = request.get_json(force=True)
    error = require_json_fields(
        data,
        ["name", "email", "phone", "password", "role", "state", "city"],
    )
    if error:
        return error

    email = normalize(data["email"])
    if User.query.filter_by(email=email).first():
        return jsonify({"message": "Email is already registered"}), 409

    role = str(data["role"])
    if role not in ["customer", "mechanic"]:
        return jsonify({"message": "Invalid role"}), 400

    if role == "mechanic" and not data.get("serviceType"):
        return jsonify({"message": "Mechanics must select serviceType"}), 400

    user = User(
        id=data.get("id") or f"{role[0]}_{int(datetime.now(timezone.utc).timestamp() * 1000)}",
        name=str(data["name"]).strip(),
        email=email,
        phone=str(data["phone"]).strip(),
        password_hash=generate_password_hash(str(data["password"])),
        role=role,
        state=str(data["state"]).strip(),
        city=str(data["city"]).strip(),
        address=data.get("address"),
        service_type=data.get("serviceType"),
        price=int(data.get("price") or 0),
    )
    db.session.add(user)

    if user.role == "mechanic":
        mechanic = Mechanic(
            id=user.id,
            name=user.name,
            email=user.email,
            phone=user.phone,
            service_type=user.service_type,
            state=user.state,
            city=user.city,
            address=user.address,
            price=user.price,
            rating=0,
            rating_count=0,
            jobs_completed=0,
            is_available=True,
            distance=0,
        )
        db.session.add(mechanic)

    db.session.commit()
    return jsonify({"token": make_token(user), "user": mechanic_user_payload(user)}), 201


@app.post("/api/auth/login")
def login():
    data = request.get_json(force=True)
    error = require_json_fields(data, ["email", "password", "role"])
    if error:
        return error

    user = User.query.filter_by(email=normalize(data["email"])).first()
    if not user or not check_password_hash(user.password_hash, str(data["password"])):
        return jsonify({"message": "Invalid email or password"}), 401
    if user.role != str(data["role"]):
        return jsonify({"message": "Account role does not match selected role"}), 403

    return jsonify({"token": make_token(user), "user": mechanic_user_payload(user)})


@app.get("/api/mechanics")
def get_mechanics():
    query = Mechanic.query
    service_type = request.args.get("serviceType")
    state = request.args.get("state")
    city = request.args.get("city")

    if service_type:
        query = query.filter(db.func.lower(Mechanic.service_type) == normalize(service_type))
    if state:
        query = query.filter(db.func.lower(Mechanic.state) == normalize(state))
    if city:
        query = query.filter(db.func.lower(Mechanic.city) == normalize(city))

    return jsonify([mechanic.to_dict() for mechanic in query.order_by(Mechanic.rating.desc()).all()])


@app.post("/api/mechanics")
@auth_required
def upsert_mechanic():
    data = request.get_json(force=True)
    error = require_json_fields(
        data,
        ["id", "name", "email", "phone", "serviceType", "state", "city", "price"],
    )
    if error:
        return error

    mechanic = Mechanic.query.get(str(data["id"]))
    if not mechanic:
        mechanic = Mechanic(id=str(data["id"]))
        db.session.add(mechanic)

    mechanic.name = str(data["name"])
    mechanic.email = str(data["email"])
    mechanic.phone = str(data["phone"])
    mechanic.service_type = str(data["serviceType"])
    mechanic.state = str(data["state"])
    mechanic.city = str(data["city"])
    mechanic.address = data.get("address")
    mechanic.price = int(data["price"])
    mechanic.is_available = bool(data.get("isAvailable", True))

    user = User.query.get(mechanic.id)
    if user:
        user.name = mechanic.name
        user.email = mechanic.email
        user.phone = mechanic.phone
        user.service_type = mechanic.service_type
        user.state = mechanic.state
        user.city = mechanic.city
        user.address = mechanic.address
        user.price = mechanic.price
    db.session.commit()
    return jsonify(mechanic.to_dict()), 201


@app.post("/api/bookings")
@auth_required
def create_booking():
    data = request.get_json(force=True)
    error = require_json_fields(
        data,
        [
            "id",
            "customerId",
            "customerName",
            "mechanicId",
            "mechanicName",
            "serviceName",
            "bookingDate",
            "timeSlot",
            "address",
            "state",
            "city",
            "price",
        ],
    )
    if error:
        return error

    booking = Booking(
        id=str(data["id"]),
        customer_id=str(data["customerId"]),
        customer_name=str(data["customerName"]),
        customer_phone=data.get("customerPhone"),
        mechanic_id=str(data["mechanicId"]),
        mechanic_name=str(data["mechanicName"]),
        mechanic_phone=data.get("mechanicPhone"),
        service_id=data.get("serviceId"),
        service_name=str(data["serviceName"]),
        service_type=str(data.get("serviceType") or data["serviceName"]),
        booking_date=parse_datetime(data["bookingDate"]),
        time_slot=str(data["timeSlot"]),
        address=str(data["address"]),
        state=str(data["state"]),
        city=str(data["city"]),
        status=str(data.get("status") or "pending"),
        price=float(data["price"]),
        notes=data.get("notes"),
        created_at=parse_datetime(data.get("createdAt")),
    )
    db.session.add(booking)
    db.session.commit()
    return jsonify(booking.to_dict()), 201


@app.get("/api/bookings/customer/<customer_id>")
@auth_required
def customer_bookings(customer_id):
    bookings = Booking.query.filter_by(customer_id=customer_id).order_by(Booking.created_at.desc()).all()
    return jsonify([booking.to_dict() for booking in bookings])


@app.get("/api/bookings/mechanic/<mechanic_id>")
@auth_required
def mechanic_bookings(mechanic_id):
    bookings = Booking.query.filter_by(mechanic_id=mechanic_id).order_by(Booking.created_at.desc()).all()
    return jsonify([booking.to_dict() for booking in bookings])


@app.put("/api/bookings/<booking_id>")
@auth_required
def update_booking(booking_id):
    booking = Booking.query.get_or_404(booking_id)
    status = (request.get_json(force=True).get("status") or "").strip()
    if status not in ["pending", "accepted", "inProgress", "verificationPending", "completed", "cancelled", "rejected"]:
        return jsonify({"message": "Invalid status"}), 400

    if status == "completed":
        if request.current_user.role != "mechanic" or request.current_user.id != booking.mechanic_id:
            return jsonify({"message": "Only the assigned mechanic can request completion"}), 403
        booking.status = "verificationPending"
        booking.completed_at = None
    else:
        booking.status = status
        if status != "completed":
            booking.completed_at = None

    refresh_mechanic_stats(booking.mechanic_id)
    db.session.commit()
    return jsonify(booking.to_dict())


@app.post("/api/bookings/<booking_id>/verify-completion")
@auth_required
def verify_completion(booking_id):
    booking = Booking.query.get_or_404(booking_id)
    data = request.get_json(force=True)
    code = str(data.get("code") or "").strip()

    if request.current_user.id != booking.customer_id:
        return jsonify({"message": "Only the assigned customer can verify completion"}), 403
    if booking.status != "verificationPending":
        return jsonify({"message": "This booking is not waiting for customer verification"}), 400
    if code != customer_completion_code(booking.customer_id):
        return jsonify({"message": "Invalid completion code"}), 400

    booking.status = "completed"
    booking.completed_at = datetime.now(timezone.utc)
    refresh_mechanic_stats(booking.mechanic_id)
    db.session.commit()
    return jsonify(booking.to_dict())


@app.post("/api/bookings/<booking_id>/rate-mechanic")
@auth_required
def rate_mechanic(booking_id):
    booking = Booking.query.get_or_404(booking_id)
    data = request.get_json(force=True)
    rating = int(data.get("rating") or 0)
    if rating < 1 or rating > 5:
        return jsonify({"message": "Rating must be between 1 and 5"}), 400

    booking.mechanic_rating = rating
    booking.mechanic_rating_comment = data.get("comment")
    refresh_mechanic_stats(booking.mechanic_id)
    db.session.commit()
    return jsonify(booking.to_dict())


@app.post("/api/bookings/<booking_id>/rate-customer")
@auth_required
def rate_customer(booking_id):
    booking = Booking.query.get_or_404(booking_id)
    data = request.get_json(force=True)
    rating = int(data.get("rating") or 0)
    if rating < 1 or rating > 5:
        return jsonify({"message": "Rating must be between 1 and 5"}), 400

    booking.customer_rating = rating
    booking.customer_rating_comment = data.get("comment")
    customer_rating = CustomerRating.query.get(booking.customer_id)
    if not customer_rating:
        customer_rating = CustomerRating(
            customer_id=booking.customer_id,
            customer_name=booking.customer_name,
        )
        db.session.add(customer_rating)
    customer_rating.customer_name = booking.customer_name
    customer_rating.rating, customer_rating.rating_count = apply_average(
        customer_rating.rating,
        customer_rating.rating_count,
        rating,
    )
    db.session.commit()
    return jsonify(booking.to_dict())


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=int(os.environ.get("PORT", 5000)))
