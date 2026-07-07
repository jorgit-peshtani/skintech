#!/bin/sh

# Exit immediately if a command exits with a non-zero status
set -e

echo "Applying database migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

# Seed database if it's empty (optional, depending on requirements)
# python manage.py loaddata local_data_dump.json || true

echo "Starting Gunicorn..."
exec gunicorn skintech_django.wsgi:application --bind 0.0.0.0:8000 --workers 3 --timeout 120
