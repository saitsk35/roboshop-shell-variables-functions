source common.sh
component=shipping
java_setup

mysql -h mysql-dev.saikrishna.shop -uroot -pRoboShop@1 < /app/db/schema.sql
mysql -h mysql-dev.saikrishna.shop -uroot -pRoboShop@1 < /app/db/app-user.sql
mysql -h mysql-dev.saikrishna.shop -uroot -pRoboShop@1 < /app/db/master-data.sql

