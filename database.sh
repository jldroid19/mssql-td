#!/bin/bash

echo "Let's configure this container!"
uname=SA
pwrd=Password1!
bakitup=AdventureWorksLT2019.bak

echo "Creating backup directory"
docker exec -i mssql mkdir /var/opt/mssql/backup

echo "Copying .bak to container"
docker cp AdventureWorksLT2019.bak mssql:/var/opt/mssql/backup

echo "LOADING DATABASE LOGICAL FILES"
docker exec -i mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U $uname -P $pwrd -Q 'RESTORE FILELISTONLY FROM DISK = "/var/opt/mssql/backup/'$bakitup'"' | tr -s ' ' | cut -d ' ' -f 1-2

echo "RESTORING DATABASE"
docker exec -i mssql /opt/mssql-tools/bin/sqlcmd -S localhost -U $uname -P $pwrd -Q 'RESTORE DATABASE AdventureWorksLT2012 FROM DISK = "/var/opt/mssql/backup/'$bakitup'" WITH MOVE "AdventureWorksLT2012_data" TO "/var/opt/mssql/data/AdventureWorksLT2019.mdf", MOVE "AdventureWorksLT2012_Log" TO "/var/opt/mssql/data/AdventureWorksLT2012_log.ldf"'

echo "DATABASE CONNECTION INFORMATION"
echo "Container IP: "
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' mssql
echo "Username: " $uname
echo "Password: " $pwrd