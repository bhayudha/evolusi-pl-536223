# Gunakan image PHP dengan CLI (karena kita akan pakai php artisan serve)
FROM php:8.4-cli

# Install dependensi sistem dasar yang dibutuhkan Laravel dan Composer
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libzip-dev \
    && docker-php-ext-install pdo_mysql zip

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set direktori kerja di dalam container
WORKDIR /app

# SALIN COMPOSER.JSON SEBELUM KODE APLIKASI (Untuk optimasi Cache)
COPY composer.json composer.lock ./

# Install dependensi Laravel (Ini akan di-cache selama composer.json tidak berubah)
RUN composer install --no-scripts --no-autoloader

# Salin seluruh sisa kode aplikasi
COPY . .

# 1. Optimasi autoload composer DULU (agar vendor/autoload.php terbuat)
RUN composer dump-autoload --optimize

# 2. BARU jalankan perintah artisan
RUN cp .env.example .env && php artisan key:generate

# Buka port 8000
EXPOSE 8000

# Perintah untuk menjalankan server Laravel
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]