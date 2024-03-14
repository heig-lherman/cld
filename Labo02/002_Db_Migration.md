# Database migration

In this task you will migrate the Drupal database to the new RDS database instance.

![Schema](./img/CLD_AWS_INFA.PNG)

## Task 01 - Securing current Drupal data

### [Get Bitnami MariaDb user's password](https://docs.bitnami.com/aws/faq/get-started/find-credentials/)

```bash
[INPUT]
//help : path /home/bitnami/bitnami_credentials

[OUTPUT]
```

### Get Database Name of Drupal

```bash
[INPUT]
//add string connection

show databases;

[OUTPUT]
```

### [Dump Drupal DataBases](https://mariadb.com/kb/en/mariadb-dump/)

```bash
[INPUT]

[OUTPUT]
```

### Create the new Data base on RDS

```sql
[INPUT]
CREATE DATABASE bitnami_drupal;
```

### [Import dump in RDS db-instance](https://mariadb.com/kb/en/restoring-data-from-dump-files/)

Note : you can do this from the Drupal Instance. Do not forget to set the "-h" parameter.

```sql
[INPUT]
mysql -h <rds-end-point> -u <rds_admin_user> -p <db_target> < <pathToDumpFileToImport>.sql

[OUTPUT]
```

### [Get the current Drupal connection string parameters](https://www.drupal.org/docs/8/api/database-api/database-configuration)

```bash
[INPUT]
//help : same settings.php as before

[OUTPUT]
//at the end of the file you will find connection string parameters
//username = bn_drupal
//password = XXXXXXX
```

### Replace the current host with the RDS FQDN

```
//settings.php

$databases['default']['default'] = array (
   [...] 
  'host' => 'dbi-devopsteam99.cshki92s4w5p.eu-west-3.rds.amazonaws.com',
   [...] 
);
```

### [Create the Drupal Users on RDS Data base](https://mariadb.com/kb/en/create-user/)

Note : only calls from both private subnets must be approved.
* [By Password](https://mariadb.com/kb/en/create-user/#identified-by-password)
* [Account Name](https://mariadb.com/kb/en/create-user/#account-names)
* [Network Mask](https://cric.grenoble.cnrs.fr/Administrateurs/Outils/CalculMasque/)

```sql
[INPUT]
CREATE USER bn_drupal@'10.0.[XX].0/[Subnet Mask - A]]' IDENTIFIED BY '<Drupal password>';

GRANT ALL PRIVILEGES ON bitnami_drupal.* TO '<yourNewUser>';

//DO NOT FOREGT TO FLUSH PRIVILEGES
```

```sql
//validation
[INPUT]
SHOW GRANTS for 'bn_drupal'@'10.0.[XX].0/[yourMask]]';

[OUTPUT]
+----------------------------------------------------------------------------------------------------------------------------------+
| Grants for <yourNewUser>                                                                                                         |
+----------------------------------------------------------------------------------------------------------------------------------+
| GRANT USAGE ON *.* TO <yourNewUser> IDENTIFIED BY PASSWORD 'XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX'                           |
| GRANT ALL PRIVILEGES ON `bitnami_drupal`.* TO <yourNewUser>                                                                      |
+----------------------------------------------------------------------------------------------------------------------------------+
```

### Validate access (on the drupal instance)

```sql
[INPUT]
mysql -h dbi-devopsteam[XX].xxxxxxxx.eu-west-3.rds.amazonaws.com -u bn_drupal -p

[INPUT]
show databases;

[OUTPUT]
+--------------------+
| Database           |
+--------------------+
| bitnami_drupal     |
| information_schema |
+--------------------+
2 rows in set (0.001 sec)
```

* Repeat the procedure to enable the instance on subnet 2 to also talk to your RDS instance.