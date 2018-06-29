#!/bin/bash
composer create-project --prefer-dist laravel/laravel .
chmod 777 -R /var/www/html/storage && chmod 777 -R /var/www/html/bootstrap/cache
php artisan config:clear && php artisan config:cache
npm install
npm run dev
npm run watch-poll