# wordpress_install
This is a bash file to install wordpress. it assumes you have lamp installed

Steps
1) `git clone https://github.com/knowhalim/wordpress_install.git`
2) `cd wordpress_install`
3) `chmod +x wordpress_setup.sh`
4) `sudo ./wordpress_setup.sh`
5) `sudo chown -R www-data:www-data /var/www/yourdomain.com/public_html`

Then go to your domain and install your wordpress.

Other optional stuffs (but useful if you are scraping):
`sudo apt update`
`sudo apt install php-curl`
`sudo apt install php7.4-curl`
`nano /etc/php/7.4/apache2/php.ini`
Look for `;extension=curl` and change to `extension=curl`
`sudo systemctl restart apache2`
`sudo systemctl restart php7.4-fpm`
