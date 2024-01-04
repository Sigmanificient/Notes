# Install a local server

*First part of original post: https://www.marcogomiero.com/posts/2018/wordpress-arch/*

### Install Apache

First, you need to install and configure Apache, the web server.
```sh
pacman -S apache
```

After the installation you have to start Apache and if you want you can set the
auto-start at boot time with the enable command.

```sh
systemctl start httpd
systemctl enable httpd
```

At this point you have to change some configurations of Apache.
Open the httpd.conf file

```sh
nano /etc/httpd/conf/httpd.conf
```

and uncomment (remove the #) the following string.
```apacheconf
#LoadModule unique_id_module modules/mod_unique_id.so
```

At this point you have to restart Apache to apply the changes.
```sh
systemctl restart httpd
```

### Install PHP

Now it is the time to install PHP with the following command.

```sh
pacman -S php7 php7-cgi php7-gd php7-pgsql php7-apache
```

As you can image, you need to configure some stuff. Open the httpd.conf file

```sh
nano /etc/httpd/conf/httpd.conf
```

comment (add a ‘#') this line

```apacheconf
LoadModule mpm_event_module modules/mod_mpm_event.so
```

and uncomment (remove the ‘#') this one.
```apacheconf
#LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
```

Finally, you have to add these lines at the bottom of the file.

```apacheconf
LoadModule php7_module modules/libphp7.so
AddHandler php7-script php
Include conf/extra/php7_module.conf
```

Now it’s the time to configure the php.ini. Open the file
```sh
nano /etc/php7/php.ini
```
and uncomment (remove the ‘;') the following lines.
```ini
;extension=mysqli.so
;extension=gd
```
and restart the httpd service.
```sh
systemctl restart httpd
```

## Install Maria DB

Now you have to install and create the database.
You are going to install Maria DB, the implementation of MySQL for Arch Linux

```sh
pacman -S mariadb libmariadbclient mariadb-clients
```

After installation, you have to set some base configuration with this command.
```sh
mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
```

As you guess, you need to start and enable the service.
```sh
systemctl start mysqld
systemctl enable mysqld
```

you have to set the root password and some other configurations. You can do it with this command

```sh
mysql_secure_installation
```
