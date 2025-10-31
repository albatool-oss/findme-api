# ---------- Build stage (composer) ----------
FROM composer:2 AS composer

# ---------- Production image ----------
FROM php:8.2-apache

# تثبيت حزم نظام مطلوبة
RUN apt-get update && apt-get install -y \
    libzip-dev zip unzip git curl libpng-dev libonig-dev libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# تثبيت امتدادات PHP المطلوبة
RUN docker-php-ext-configure zip --with-libzip \
&& docker-php-ext-install pdo pdo_mysql zip mbstring exif pcntl xml

# تفعيل mod_rewrite في Apache
RUN a2enmod rewrite

# نسخ Composer من الصورة الأولية
COPY --from=composer /usr/bin/composer /usr/bin/composer

# نسخ كامل الشيفرة للمسار الافتراضي في Apache
COPY . /var/www/html

# العمل داخل المسار
WORKDIR /var/www/html

# تثبيت الحزم عبر Composer (production)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# صلاحيات على مجلدات التخزين والـ cache
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
&& chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# إعداد Apache ليوجه إلى public
#COPY ./000-default.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 80
CMD ["apache2-foreground"]