# Deployment Guide

## Backend

The backend is now Flask + PostgreSQL and is ready for Render.

Files:

- `backend/app.py`
- `backend/requirements.txt`
- `backend/render.yaml`

Deploy with Render Blueprint from your GitHub repo. Render will create the PostgreSQL database and set `DATABASE_URL`.
It also generates `JWT_SECRET` for signed login tokens.

## APK Build

The Flutter app no longer has a local API fallback. Build with your Render URL:

```bash
flutter build apk --release --dart-define=BASE_URL=https://your-render-service.onrender.com
```

## Location Logic

Register/login use JWT:

```text
POST /api/auth/register
POST /api/auth/login
```

Protected requests send:

```text
Authorization: Bearer <jwt-token>
```

Users and mechanics now carry:

- `state`
- `city`

Mechanic search calls:

```text
GET /api/mechanics?serviceType=Plumbing&state=Maharashtra&city=Pune
```

So Pune users only see Pune mechanics.

## Ratings

Customers can rate mechanics after completed bookings:

```text
POST /api/bookings/:id/rate-mechanic
```

Mechanics can rate customers after completed bookings:

```text
POST /api/bookings/:id/rate-customer
```
