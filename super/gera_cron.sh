## -- Criando cron:
cd /var/spool/cron
touch $logindaconta
echo "*/2 * * * * /usr/bin/php -f /home/$logindaconta/public_html/admin/cron/cron.php" >> $logindaconta
echo "0 */3 * * * /usr/bin/php -f /home/$logindaconta/public_html/admin/cron/limpeza.php" >> $logindaconta
