# ==========================================
# TAHAP 1: Builder
# ==========================================
FROM php:8.4-cli-alpine AS builder

# Install dependensi sistem dasar untuk composer & ekstensi PHP
RUN apk add --no-cache git unzip zip libzip-dev \
    && docker-php-ext-install zip pdo_mysql

# Kunci versi Composer
COPY --from=composer:2.8 /usr/bin/composer /usr/bin/composer

WORKDIR /app

# Salin file composer terlebih dahulu untuk caching
COPY composer.json composer.lock ./
# Install tanpa require-dev untuk mengurangi ukuran
RUN composer install --no-scripts --no-autoloader --no-dev

# Salin seluruh kode aplikasi
COPY . .

# 1. Generate autoloader DULU agar vendor/autoload.php terbuat
RUN composer dump-autoload --optimize

# 2. BARU jalankan artisan key:generate
RUN cp .env.example .env && php artisan key:generate

# ==========================================
# TAHAP 2: Runtime (Kecil, aman, dan bersih)
# ==========================================
FROM php:8.4-cli-alpine

# Install ekstensi yang wajib saja saat runtime
RUN apk add --no-cache libzip-dev \
    && docker-php-ext-install zip pdo_mysql

WORKDIR /app

# Salin HANYA file yang sudah jadi dari tahap builder
COPY --from=builder /app /app

# Keamanan: Buat user non-root dan berikan hak akses direktori
RUN addgroup -S laravel && adduser -S laravel -G laravel \
    && chown -R laravel:laravel /app \
    && chmod -R 775 /app/storage /app/bootstrap/cache

# Gunakan user tersebut
USER laravel

EXPOSE 8000

# Healthcheck untuk memantau status container
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=3 \
    CMD wget -qO- http://127.0.0.1:8000/api/tugas > /dev/null || exit 1

CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]