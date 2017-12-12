taxahora=`cat /tmp/horatemp`
taxames=`cat /tmp/mestemp`
admin=`cat /tmp/admin`

mysql -e "create database ${logindaconta}_banco;"
mysql -Be "grant all privileges on ${logindaconta}_banco.* to '${logindaconta}_dbuser'@'localhost' identified by \"phCA24bgK\";"
if [ "$admin" == '0' ] && [ "$PowerMTA" == '0' ] ; then # Não é administrador e envia com EXIM:
  cd /home/$logindaconta/public_html
  wget http://rep.vitalhost.com.br/v4/semcpanel/public.tar.gz
  tar -vxzf public.tar.gz
  rm -Rf public.tar.gz
  tar -vxzf base.tar.gz
  rm -Rf base.tar.gz
  mysql "$logindaconta"_banco < base1.sql
  rm -rf base1.sql
  chown -R $logindaconta.$logindaconta *
elif [ "$admin" == '1' ] && [ "$PowerMTA" == '0' ] ; then # É adminsitrador e envia com EXIM:
  cd /home/$logindaconta/public_html
  wget http://rep.vitalhost.com.br/v4/semcpanel/public_adm.tar.gz
  tar -vxzf public_adm.tar.gz
  rm -Rf public_adm.tar.gz
  tar -vxzf base.tar.gz
  rm -Rf base.tar.gz
  mysql "$logindaconta"_banco < base1.sql
  rm -rf base1.sql
  chown -R $logindaconta.$logindaconta *
elif [ "$admin" == '1' ] && [ "$PowerMTA" == '1' ] ; then # É administrador e envia com PMTA:
  cd /home/$logindaconta/public_html
  wget http://rep.vitalhost.com.br/v4/semcpanel/public_adm_pmta.tar.gz
  tar -vxzf public_adm_pmta.tar.gz
  rm -Rf public_adm_pmta.tar.gz
  tar -vxzf base.tar.gz
  rm -Rf base.tar.gz
  mysql "$logindaconta"_banco < base1.sql
  rm -rf base1.sql
  chown -R $logindaconta.$logindaconta *
else
  clear
fi
## -- Injetando banidos:
cd /home/$logindaconta/public_html
wget http://rep.vitalhost.com.br/v4/semcpanel/spamtraps.tar.gz
tar -vxzf spamtraps.tar.gz
rm -Rf spamtraps.tar.gz
mysql "$logindaconta"_banco < spamtraps.sql
rm -Rf spamtraps.sql

## -- Config.php
echo "<?php

define('SENDSTUDIO_DATABASE_TYPE', 'mysql');
define('SENDSTUDIO_DATABASE_USER', '"$logindaconta"_dbuser');
define('SENDSTUDIO_DATABASE_PASS', '"$senhavital"');
define('SENDSTUDIO_DATABASE_HOST', 'localhost');
define('SENDSTUDIO_DATABASE_NAME', '"$logindaconta"_banco');
define('SENDSTUDIO_DATABASE_UTF8PATCH', '1');
define('SENDSTUDIO_TABLEPREFIX', 'email_');
define('SENDSTUDIO_LICENSEKEY', 'Intecorp');
define('SENDSTUDIO_APPLICATION_URL', 'http://"$dominio"');
define('SENDSTUDIO_IS_SETUP', 1);" > /home/$logindaconta/public_html/admin/includes/config.php
## Alteraçao no bacno
mysql -u root ${logindaconta}_banco -e "UPDATE email_config_settings SET areavalue = 'erros@${dominio}' WHERE area = 'BOUNCE_ADDRESS';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_config_settings SET areavalue = 'contato@${dominio}' WHERE area = 'EMAIL_ADDRESS';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET emailaddress = 'contato@${dominio}';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET usertimezone = 'GMT-3:00';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET username = '${iemlogin}' WHERE username ='changeme';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET perhour = '${taxahora}' WHERE perhour ='500';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET permonth = '${taxames}' WHERE permonth ='50000';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET htmlfooter = '<img title="Novidade" alt="Novidade" height="42" width="242" src="http://${dominio}/transparente.png">';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET textfooter = '';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_users SET adminnotify_email = 'contato@${dominio}';"
mysql -u root ${logindaconta}_banco -e "UPDATE user_script SET username = '${iemlogin}' WHERE username = 'gemeosvt';"
mysql -u root ${logindaconta}_banco -e "UPDATE email_config_settings SET areavalue = '${taxahora}' WHERE area = 'MAXHOURLYRATE'; "
mysql -u root ${logindaconta}_banco -e "UPDATE email_config_settings SET areavalue = '${taxames}' WHERE area = 'MAXOVERSIZE';"
#
