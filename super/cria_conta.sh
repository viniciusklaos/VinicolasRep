chattr -i /etc/mailips
cat /etc/mailips > /etc/mailips.vt.temp
sort /etc/mailips.vt.temp > /etc/mailips.vt
rm -Rf /etc/mailips.vt.temp
chattr -i /etc/mailhelo
cat /etc/mailhelo > /etc/mailhelo.vt.temp
sort /etc/mailhelo.vt.temp > /etc/mailhelo.vt
rm -Rf /etc/mailhelo.vt.temp
/scripts/createacct $dominio $logindaconta $senhavital
/scripts/addpop contato@$dominio $senhavital 0 250
/scripts/addpop abuse@$dominio $senhavital 0 250
/scripts/addpop postmaster@$dominio $senhavital 0 250
/scripts/addpop erros@$dominio $senhavital 0 250
cat /etc/mailips.vt > /etc/mailips
cat /etc/mailhelo.vt > /etc/mailhelo
chattr +i /etc/mailips
chattr +i /etc/mailhelo
