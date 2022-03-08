create database db_app;
create user 'user'@'localhost' identified by 'user';
grant all on db_app.* to 'user'@'localhost'; 