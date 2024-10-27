#! /bin/bash

# CREATED BY MASTERBOOTRECORD32 FOR LOTHRINGER OPENAURORE: https://openaurore.ddns.net/
# LICENSED UNDER CUSTOM MOZILLA PUBLIC LICENSE version 2.0

# VARIABLES
webdir=/path/to/your/webdir # FOR EXAMPLE /var/www
backupdir=/path/to/your/backupdir # FOR EXAMPLE /var/lib/backup/web
recipient_email=youremail@yourdomain.com
keep_day=120 # NUMBER OF DAYS YOU WANT TO KEEP OLDER BACKUPS
webfiles1=yourVirtualHost1 # THE NAME OF THE FIRST VIRTUAL HOST YOU WANT TO BACKUP
webfiles2=yourVirtualHost2 # THE NAME OF THE SECOND VIRTUAL HOST YOU WANT TO BACKUP
zipfile1=${backupdir}/${webfiles1}-$(date +%d-%m-%Y_%H-%M-%S).zip # THE NAME OF THE FIRST ZIP BACKUP
zipfile2=${backupdir}/${webfiles2}-$(date +%d-%m-%Y_%H-%M-%S).zip # THE NAME OF THE SECOND ZIP BACKUP

# BACKUP CREATION & COMPRESSION 
### VIRTUAL HOST 1 FILES BACKUP
zip -r -P yourStrongPassword ${zipfile1} ${webdir}/${webfiles1} # CREATES A ZIP FILE OF THE CONTENT OF YOUR VHOST: -r ADDS ALL FILES LOCATED IN THE DIRECTORY AND SUB-DIRECTORIES AND -P SECURES THE ZIP WITH A PASSWORD 
if [ $? -eq 0 ]; then
  echo 'The backup was successfully created' 
else
  echo 'Error creating backup for your' ${webfiles1} | mail -s 'Backup was not created!' ${recipient_email} # IF THE BACKUP FAILS TO BE CREATED, AN E-MAIL IS SENT TO ADMIN (NEEDS EXIM4 OR SENDMAIL TO BE CONFIGURED)
  exit
fi
echo 'Backup for your' ${webfiles1} 'was successfully created and is located in' ${zipfile1} | mail -s 'Backup was successfully created!' ${recipient_email} # IF THE BACKUP IS SUCCESSFULLY CREATED, AN E-MAIL IS SENT TO ADMIN

### VIRTUAL HOST 2 FILES BACKUP
zip -r -P yourStrongPassword ${zipfile2} ${webdir}/${webfiles2} # CREATES A ZIP FILE OF THE CONTENT OF YOUR VHOST
if [ $? -eq 0 ]; then
  echo 'The backup was successfully created' 
else
  echo 'Error creating backup for your' ${webfiles2} | mail -s 'Backup was not created!' ${recipient_email} # IF THE BACKUP FAILS TO BE CREATED, AN E-MAIL IS SENT TO ADMIN
  exit                                                                                                                                                                                        
fi                                                                                                                                                                                            
echo 'Backup for your' ${webfiles1} 'was successfully created and is located in' ${zipfile2} | mail -s 'Backup was successfully created!' ${recipient_email} # IF THE BACKUP IS SUCCESSFULLY CREATED, AN E-MAIL IS SENT TO ADMIN
                       
                                                                                                                                                                                              
# OLD BACKUPS DELETION                                                                                                                                                                        
find ${backupdir} -mtime +${keep_day} -delete # DELETES BACKUPS OLDER THAN THE NUMBER OF DAYS CHOSEN IN ${keep_day}
