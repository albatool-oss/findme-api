FROM php:8.2-apache

# تثبيت الأدوات المطلوبة
RUN apt-get update && apt-get install -y \
    libpng-dev libonig-dev libxml2-dev zip unzip git curl \
    && docker-php-ext-install pdo pdo_mysql mbstring exif pcntl xml \
    && rm -rf /var/lib/apt/lists/*

# تفعيل mod_rewrite في Apache
RUN a2enmod rewrite

# نسخ Composer من الصورة الرسمية
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# نسخ ملفات المشروع إلى مجلد Apache
COPY . /var/www/html

# ضبط أذونات المجلد
RUN chown -R www-data:www-data /var/www/html