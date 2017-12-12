# - Adicionando "message_logs = false"
# - /etc/exim.conf
cp /etc/exim.conf /etc/exim.conf.bkp
grep message_logs /etc/exim.conf | cut -d= -f2 | sed 's/ //g' > /home/vtinstall/vartemp/disable_msglog.conf
MSGLOG=`cat /home/vtinstall/vartemp/disable_msglog.conf`
if [ "$MSGLOG" == "false" ]; then
sed  -i 's/message_logs = false/sempai/g' /etc/exim.conf
sed  -i 's/sempai/message_logs = false/g' /etc/exim.conf
elif [ "$MSGLOG" == "true" ]; then
sed  -i 's/message_logs = true/message_logs = false/g' /etc/exim.conf
else
sed -i '3i\message_logs = false\' /etc/exim.conf
fi
# - /etc/exim.conf.local
echo "@AUTH@

@BEGINACL@

@CONFIG@
daemon_smtp_ports = 465 : 25 : 587
message_logs = false

@DIRECTOREND@

@DIRECTORMIDDLE@

@DIRECTORSTART@

@ENDACL@

@POSTMAILCOUNT@

@PREDOTFORWARD@

@PREFILTER@

@PRELOCALUSER@

@PRENOALIASDISCARD@

@PREROUTERS@

@PREVALIASNOSTAR@

@PREVALIASSTAR@

@PREVIRTUALUSER@

@RETRYEND@

@RETRYSTART@

@REWRITE@

@ROUTEREND@

@ROUTERMIDDLE@

@ROUTERSTART@

@TRANSPORTEND@

@TRANSPORTMIDDLE@

@TRANSPORTSTART@" > /etc/exim.conf.local
# - Desabilitando o EximStats
/usr/local/cpanel/libexec/tailwatchd --disable=Cpanel::TailWatch::Eximstats
service exim restart
## -- Aumentando performance do Exim
#
perl -p -i -e 's/queue_only_load = 24/queue_only_load = 18/g' /etc/exim.conf
perl -p -i -e 's/deliver_queue_load_max = 12/deliver_queue_load_max = 18/g' /etc/exim.conf
perl -p -i -e 's/remote_max_parallel = 10/remote_max_parallel = 20/g' /etc/exim.conf
perl -p -i -e 's/smtp_accept_queue_per_connection = 30/smtp_accept_queue_per_connection = 0/g' /etc/exim.conf
perl -p -i -e 's/timeout_frozen_after = 5d/timeout_frozen_after = 2h/g' /etc/exim.conf
perl -p -i -e 's/ignore_bounce_errors_after = 1d/ignore_bounce_errors_after = 1h/g' /etc/exim.conf
perl -p -i -e 's/auto_thaw = 7d/auto_thaw = 1d/g' /etc/exim.conf
perl -p -i -e 's/smtp_connect_backlog = 50/smtp_connect_backlog = 200/g' /etc/exim.conf
perl -p -i -e 's/smtp_accept_max = 100/smtp_accept_max = 5000/g' /etc/exim.conf
