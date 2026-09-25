#!/bin/bash
set -e

# 7 Langkah Deploy Laravel
php artisan down
git pull origin main
composer install --no-interaction --prefer-dist --optimize-autoloader
php artisan migrate --force
php artisan optimize:clear
npm run build
php artisan up