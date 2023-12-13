# Wordpress installation wizard
This is a bash file to install wordpress. it assumes you have lamp installed

Steps
1) `git clone https://github.com/knowhalim/wordpress_install.git`
2) `cd wordpress_install`
3) `chmod +x wordpress_setup.sh`
4) `sudo ./wordpress_setup.sh`
5) `sudo chown -R www-data:www-data /var/www/yourdomain.com/public_html`

Then go to your domain and install your wordpress.

# Common Problems
You might encounter problems during the installation if you did not point your domain to your IP before running step 4.

Solution: Point domain to your IP.

# Optional 
Other optional stuffs (but useful if you are scraping):
1) `sudo apt update`
2) `sudo apt install php-curl`
3) `sudo apt install php7.4-curl`
4) `nano /etc/php/7.4/apache2/php.ini`
5) Look for `;extension=curl` and change to `extension=curl`
6) `sudo systemctl restart apache2`
7) `sudo systemctl restart php7.4-fpm`
