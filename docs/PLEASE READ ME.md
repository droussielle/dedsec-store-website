# BACKEND SIDE
Doc and additional feature WIP.

## Installation
1. Install [composer](https://getcomposer.org/download/) in global scope(check their doc) if possible
2. Import `web-programming.sql` to your own mysql database
3. Change .env file's content to your own database credentials
4. cd php && composer install && php -S localhost:8000
5. Import `postman_collection.json` to your postman
6. Create an account in `users` by register endpoint and change its role to `admin` in database
7. Sending request to localhost:8000 using postman or your frontend

## Todos
- [x] Product quantity realisation
    - [x] Product add/update to cart's quantity check
    - [x] Cart checkout product quantity mass check
    - [] Inconsistensy when multiple user checkout the same product at low quantity => Better avoided than code this
- [x] Product short description realisation
    - [x] Product short description get/add/update
    - [x] Product short description in document
- [x] Promotion state realisation
    - [x] Can only delete inactive promotion
    - [x] Can only add active promotion
    - [x] Promotion'state warning in cart
- [x] Cart order restricted to its owner
- [x] Refactor code
