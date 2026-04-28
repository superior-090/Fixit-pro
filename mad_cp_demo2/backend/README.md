# FixIt Pro Flask Backend

Flask + PostgreSQL backend for Render.

## Render Deploy

1. Push this repo to GitHub.
2. In Render, choose **Blueprint** and select this repo.
3. Render will read `backend/render.yaml`, create a PostgreSQL database, install `requirements.txt`, and run:

```bash
gunicorn app:app
```

Use the Render web service URL when building Flutter:

```bash
flutter build apk --release --dart-define=BASE_URL=https://your-render-service.onrender.com
```

The Flutter app now requires `BASE_URL`; local emulator URLs were removed.

## API

- `GET /health`
- `POST /api/auth/register`
- `POST /api/auth/login`
- `GET /api/mechanics?serviceType=Plumbing&state=Maharashtra&city=Pune`
- `POST /api/mechanics`
- `POST /api/bookings`
- `GET /api/bookings/customer/:customerId`
- `GET /api/bookings/mechanic/:mechanicId`
- `PUT /api/bookings/:id`
- `POST /api/bookings/:id/rate-mechanic`
- `POST /api/bookings/:id/rate-customer`

Protected endpoints require:

```text
Authorization: Bearer <jwt-token>
```

Mechanics are filtered by `state` and `city`, so Pune customers only see Pune mechanics when their profile has `state=Maharashtra` and `city=Pune`.
flask
flask-cors
flask-sqlalchemy
psycopg2-binary
gunicorn
