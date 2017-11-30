# - Fazendo as configurações do "Tweak Settings"
sed -i '/defaultmailaction/d' /var/cpanel/cpanel.config
sed -i "/disable-php-as-reseller-security/i defaultmailaction=fail" /var/cpanel/cpanel.config
sed -i '/skipspamassassin/d' /var/cpanel/cpanel.config
sed -i "/skipspambox/i skipspamassassin=1" /var/cpanel/cpanel.config
