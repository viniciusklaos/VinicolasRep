cores_gnu () {
	VERMELHO="\033[01;31;40m"
	VERDE="\033[01;32;40m"
	AMARELO="\033[01;33;40m"
	AZUL="\033[01;34;40m"
	ROSA="\033[01;35;40m"
	CIANO="\033[01;36;40m"
	RESET="\033[00;37;40m"
}
verificaip () {
	ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -f1 -d/ | sort > ips.info
	cat /etc/mailips | cut -d: -f2 | sed 's/ //g' | sort > ipdedicado.info
	IPSLIVRE=`diff ipdedicado.info ips.info | grep ^\> | sed 's/> //g'`
	if [ -z "$IPSLIVRE" ]
	then
		clear
		echo -e "${VERMELHO} Sem IPS livres para dedicar na maquina${RESET}"
		sleep 3
		exit
	else
		echo -e "${AMARELO}Qual IP deseja dedicar para o domínio:${VERDE} $dominio ?"
		echo ""
		echo -e "${VERDE}IPS Disponiveis:"
		echo $IPSLIVRE | sed 's/ /\n/g'
		echo -e "${RESET}"
		instalar_ip;
	fi
	rm -Rf ips.info ipdedicado.info
}
instalar_ip () {
	read ipdd
	if grep -w -q $ipdd ips.info; then
		if grep -q -w $ipdd /etc/mailips; then
			clear
			echo "IP já utilizado por outro cliente, por favor escolha outro"
			sleep 1
			echo -e "${VERDE}."
			sleep 1
			echo -e "${AMARELO}."
			sleep 1
			echo -e "${VERMELHO}."
			sleep 1
			clear
			verificaip;
		fi
	else
			clear
	    echo -e "${VERMELHO}IP não disponível neste servidor."
			sleep 1
			echo -e "${VERDE}."
			sleep 1
			echo -e "${AMARELO}."
			sleep 1
			echo -e "${VERMELHO}."
			sleep 1
			clear
			verificaip;
	fi
}
instala_caminhos () {
	echo "/home/vtinstall
	/home/vtinstall/vartemp
	/home/vtinstall/menu
	/home/vtinstall/menusistema
	/home/vtinstall/scripts
	/home/vtinstall/spamtraps
	/home/vtinstall/update
	/home/vtinstall/vtbackups" > /home/caminhos.temp
	for CAMINHO in `cat caminhos.temp`; do
		[ -d $CAMINHO ] || mkdir $CAMINHO; cd $CAMINHO; done
	rm -Rf /home/caminhos.temp
}
verificadominio () {
	BASE=/home/vtinstall/vartemp/dominiobase
	if [ -z "$BASE" ]; then
		dominioprincipal=`cat /home/vtinstall/vartemp/dominiobase`
		clear
		echo -e "${AMARELO}Domínio principal:${VERDE} $dominioprincipal"
		sleep 3
	else
		echo $dominio > /home/vtinstall/vartemp/dominiobase
		dominioprincipal=`cat /home/vtinstall/vartemp/dominiobase`
		clear
		echo "Configurando novo VPS de dominio: $dominio"
		sleep 3
	fi
}
verificalogin () {
	cd /home/vtinstall/vartemp
	tr -dc "a-z" < /home/vtinstall/vartemp/domaintemp > /home/vtinstall/vartemp/lgtmp
	logindaconta=`cat /home/vtinstall/vartemp/lgtmp | cut -c 1-8`
	## -- Verificando se já existe uma conta com este nome:
	if [ -d /home/$logindaconta ]; then
		echo $logindaconta > /home/vtinstall/vartemp/loginconflito
		loginconflito=`cat /home/vtinstall/vartemp/loginconflito`
		logincerto=`echo $loginconflito | cut -c 1-7`
		numerologin=`echo $loginconflito | cut -c 8`
		if [[ $numerologin = [[:digit:]] ]]; then
			echo "${logincerto}$((${numerologin}+1))" > /home/vtinstall/vartemp/loginconflito
	else
			echo "${logincerto}1" > /home/vtinstall/vartemp/loginconflito
		fi
		logindaconta=`cat /home/vtinstall/vartemp/loginconflito`
		#rm -rf /home/vtinstall/vartemp/loginconflito
		clear
		echo ""
		echo -e "${AMARELO}Este login da conta já existe, e o mesmo foi alterado para:${VERDE} $logindaconta ${RESET}"
		sleep 3
		else
			#clear
			echo ""
			echo -e "${VERDE}Login da conta OK"
			sleep 1
			#clear
	fi
	iemlogin=`echo $dominio | cut -d. -f1`
}
instala_vt_libs () {
	cd /usr/local/bin
	> ips
	> dominios
	echo "ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}' | cut -f1 -d/" > ips
	echo "cat /etc/trueuserdomains | cut -d: -f1" > dominios
	chmod a+x ips
	chmod a+x dominios
	rm -rf dedicar; curl -O http://rep.vitalhost.com.br/v4/semcpanel/dedicar; chmod a+x dedicar;
	rm -rf remover; curl -O http://rep.vitalhost.com.br/v4/semcpanel/remover; chmod a+x remover;
	rm -rf contar; curl -O http://rep.vitalhost.com.br/v4/semcpanel/contar; chmod a+x contar;
	rm -rf suspender; curl -O http://rep.vitalhost.com.br/v4/semcpanel/suspender; chmod a+x suspender;
	rm -rf unsuspender; curl -O http://rep.vitalhost.com.br/v4/semcpanel/unsuspender; chmod a+x unsuspender;
	rm -rf ipuso; curl -O http://rep.vitalhost.com.br/v4/semcpanel/ipuso; chmod a+x ipuso;
	## -- Instalando vtbackup
	cd /home; rm -rf instalarbackup.sh; wget rep.vitalhost.com.br/v4/backup/instalarbackup.sh && sh instalarbackup.sh; rm -rf instalarbackup.sh
}
gera_spf () {
	IPS=`ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -f1 -d/`
	echo "$IPS" > /home/vtinstall/vartemp/ips.txt
	IPS=`cat /home/vtinstall/vartemp/ips.txt`
	cat /home/vtinstall/vartemp/ips.txt | cut -f1-3 -d. > /home/vtinstall/vartemp/ipspf.info
	sort /home/vtinstall/vartemp/ipspf.info | uniq > /home/vtinstall/vartemp/spf.info
	sed -i 's/^/+ip4:/' /home/vtinstall/vartemp/spf.info
	sed -i 's/$/.0\/24 /' /home/vtinstall/vartemp/spf.info
	sed -i ':a;$!N;s/\n//;ta;' /home/vtinstall/vartemp/spf.info
	SPF=`cat /home/vtinstall/vartemp/spf.info`
}
whm_config () {
	# - Fazendo as configurações do "Basic"
	if grep "ADDR " /etc/wwwacct.conf; then
	  if grep "ADDR $ipprincipal" /etc/wwwacct.conf; then
	    sleep 0
	  else
	    sed -i '/ADDR /d' /etc/wwwacct.conf
	    echo "ADDR $ipprincipal" >> /etc/wwwacct.conf
	  fi
	else
		   echo "Nao encontrado ADDR no servidor: $dominio" | mail -s "ADDR FAIL $dominio" vinicius@centraldousuario.com.br
	fi
	if grep "NS " /etc/wwwacct.conf; then
	  if grep "NS ns1.$dominio" /etc/wwwacct.conf; then
	    sleep 0
	  else
	    sed -i '/NS /d' /etc/wwwacct.conf
	    echo "NS ns1.$dominio" >> /etc/wwwacct.conf
	  fi
	else
	  echo "Nao encontrado NS no servidor: $dominio" | mail -s "NS FAIL $dominio" vinicius@centraldousuario.com.br
	fi
	if grep "CONTACTEMAIL " /etc/wwwacct.conf; then
	  if grep "CONTACTEMAIL root@server.$dominio" /etc/wwwacct.conf; then
	    sleep 0
	  else
	    sed -i '/CONTACTEMAIL /d' /etc/wwwacct.conf
	    echo "CONTACTEMAIL root@server.$dominio" >> /etc/wwwacct.conf
	  fi
	else
	  echo "Nao encontrado CONTACTEMAIL no servidor: $dominio" | mail -s "CONTACTEMAIL FAIL $dominio" vinicius@centraldousuario.com.br
	fi
	if grep "NS2 " /etc/wwwacct.conf; then
	  if grep "NS2 ns2.$dominio" /etc/wwwacct.conf; then
	    sleep 0
	  else
	    sed -i '/NS2 /d' /etc/wwwacct.conf
	    echo "NS2 ns2.$dominio" >> /etc/wwwacct.conf
	  fi
	else
	  echo "Nao encontrado NS2 no servidor: $dominio" | mail -s "NS2 FAIL $dominio" vinicius@centraldousuario.com.br
	fi
	if grep "HOST " /etc/wwwacct.conf; then
	  if grep "HOST server.$dominio" /etc/wwwacct.conf; then
	    sleep 0
	  else
	    sed -i '/HOST /d' /etc/wwwacct.conf
	    echo "HOST server.$dominio" >> /etc/wwwacct.conf
	  fi
	else
	  echo "Nao encontrado HOST no servidor: $dominio" | mail -s "HOST FAIL $dominio" vinicius@centraldousuario.com.br
	fi
	# - Desabilitando o Ipv6
	perl -p -i -e 's/NETWORKING_IPV6="yes"/NETWORKING_IPV6="no"/g' /etc/sysconfig/network
	perl -p -i -e 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/*
	chkconfig --level 123456 ip6tables off
	echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
	echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
}
tweak_settings () {
	# - Fazendo as configurações do "Tweak Settings"
	sed -i '/defaultmailaction/d' /var/cpanel/cpanel.config
	sed -i "/disable-php-as-reseller-security/i defaultmailaction=fail" /var/cpanel/cpanel.config
	sed -i '/skipspamassassin/d' /var/cpanel/cpanel.config
	sed -i "/skipspambox/i skipspamassassin=1" /var/cpanel/cpanel.config
}
configura_exim () {
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
}
configura_php () {
	# - Configurando o PHP 5.5
	perl -p -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /opt/cpanel/ea-php55/root/etc/php.d/local.ini
	perl -p -i -e 's/max_input_time = 60/max_input_time = 300/g' /opt/cpanel/ea-php55/root/etc/php.d/local.ini
	perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /opt/cpanel/ea-php55/root/etc/php.d/local.ini
	perl -p -i -e 's/vmemory_limit = 64M/memory_limit = 1024M/g' /opt/cpanel/ea-php55/root/etc/php.d/local.ini
	#
	perl -p -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /opt/cpanel/ea-php55/root/etc/php.ini
	perl -p -i -e 's/max_input_time = 60/max_input_time = 300/g' /opt/cpanel/ea-php55/root/etc/php.ini
	perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /opt/cpanel/ea-php55/root/etc/php.ini
	perl -p -i -e 's/vmemory_limit = 64M/memory_limit = 1024M/g' /opt/cpanel/ea-php55/root/etc/php.ini
	# - Configurando o PHP 5.6
	perl -p -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /opt/cpanel/ea-php56/root/etc/php.d/local.ini
	perl -p -i -e 's/max_input_time = 60/max_input_time = 300/g' /opt/cpanel/ea-php56/root/etc/php.d/local.ini
	perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /opt/cpanel/ea-php56/root/etc/php.d/local.ini
	perl -p -i -e 's/vmemory_limit = 64M/memory_limit = 1024M/g' /opt/cpanel/ea-php56/root/etc/php.d/local.ini
	#
	perl -p -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /opt/cpanel/ea-php56/root/etc/php.ini
	perl -p -i -e 's/max_input_time = 60/max_input_time = 300/g' /opt/cpanel/ea-php56/root/etc/php.ini
	perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /opt/cpanel/ea-php56/root/etc/php.ini
	perl -p -i -e 's/vmemory_limit = 64M/memory_limit = 1024M/g' /opt/cpanel/ea-php56/root/etc/php.ini
	# - Configurando o PHP 7.0
	perl -p -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /opt/cpanel/ea-php70/root/etc/php.d/local.ini
	perl -p -i -e 's/max_input_time = 60/max_input_time = 300/g' /opt/cpanel/ea-php70/root/etc/php.d/local.ini
	perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /opt/cpanel/ea-php70/root/etc/php.d/local.ini
	perl -p -i -e 's/vmemory_limit = 64M/memory_limit = 1024M/g' /opt/cpanel/ea-php70/root/etc/php.d/local.ini
	#
	perl -p -i -e 's/max_execution_time = 30/max_execution_time = 300/g' /opt/cpanel/ea-php70/root/etc/php.ini
	perl -p -i -e 's/max_input_time = 60/max_input_time = 300/g' /opt/cpanel/ea-php70/root/etc/php.ini
	perl -p -i -e 's/upload_max_filesize = 2M/upload_max_filesize = 8M/g' /opt/cpanel/ea-php70/root/etc/php.ini
	perl -p -i -e 's/vmemory_limit = 64M/memory_limit = 1024M/g' /opt/cpanel/ea-php70/root/etc/php.ini
}
motd () {
	# - MOTD
	echo "" > /etc/motd
	echo "Server: server.$dominioprincipal"
	echo "" >> /etc/motd
	echo "Bem vindo" >> /etc/motd
	echo "Vital Host 2018 - SmartCpanel" >> /etc/motd
	echo "" >> /etc/motd
}
pagina_suspensao () {
	WEBTEMP=/var/cpanel/webtemplates
	ROOT=/var/cpanel/webtemplates/root
	ENGLISH=/var/cpanel/webtemplates/root/english
	if [ -e "$WEBTEMP" ]; then
	  cd /var/cpanel/webtemplates
	else
	  cd /var/cpanel
	  mkdir webtemplates
	  cd webtemplates
	fi
	if [ -e "$ROOT" ]; then
	  cd /var/cpanel/webtemplates/root
	else
	  cd /var/cpanel/webtemplates
	  mkdir root
	  cd root
	fi
	if [ -e "$ENGLISH" ]; then
	  cd /var/cpanel/webtemplates/root/english
	else
	  cd /var/cpanel/webtemplates/root
	  mkdir english
	  cd english
	fi
	chattr -i suspended.tmpl
	> suspended.tmpl
	##  - Página de suspensão com chat
	echo "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\">
	<html>
	<head>
	<title>Conta Suspensa!!</title>
	<meta http-equiv=\"Content-Type\" content=\"text/html; charset=iso-8859-1\">
	</head>
	<body bgcolor=\"#CCCCCC\">
	<center>
	<table width=\"633\" border=\"0\" cellpadding=\"0\" cellspacing=\"0\" bgcolor=\"#FFFFFF\">
	<!--DWLayoutTable-->
	<tr>
	  <td width=\"23\" height=\"17\"></td>
	  <td width=\"590\"></td>
	  <td width=\"20\"></td>
	</tr>
	<tr>
	  <td height=\"310\"></td>
	  <td valign=\"top\"><p align=\"center\">&nbsp;</p>
	    <p align=\"center\"><font size=\"4\" face=\"verdana\"><strong>Sua conta de Email Marketing est&aacute;
	      suspensa por motivos administrativos!</strong></font></p>
	    <p align=\"center\"><font size=\"2\" face=\"verdana\">Para ativ&aacute;-la novamente
	      ou at&eacute; mesmo verificar o que houve, entre em contato conosco
	      atrav&eacute;s dos telefones abaixo: </font></p>
	    <p><font size=\"2\" face=\"verdana\"> (31) 2565 9120 - Belo Horizonte <br>
	      (31) 4063 9358 - Belo Horizonte<br>
	      (11) 4063 6505 - SP Voip<br>
	      (21) 4063 7590 - Rio de Janeiro<br>
	      (41) 4063 7742 - Curitiba</font></p>
	    <p><font size=\"2\" face=\"verdana\"><font color=\"#FF0000\" size=\"1\"><em>Segunda &agrave; Sexta-Feira
	      9:00 &aacute;s 18:00Hs - *exceto feriados</em></font></font></p>
	    <p align=\"center\"><font size=\"2\" face=\"verdana\"><em>Se preferir clique
	      no link abaixo para abrir um Ticket/Chamado.</em><br>
	      <a href=\"http://www.centraldousuario.com.br/submitticket.php?step=2&deptid=1\">[Abrir
	      Ticket]</a></font></p>

	       <p><font size=\"2\" face=\"verdana\"><font color=\"#FF0000\" size=\"1\"><em>Nosso CHAT ON-LINE est&aacute;  disponivel para melhor atende-lo no fim desta p&aacute;gina.</em></font></font></p>


	    </td>
	  <td></td>
	</tr>
	<tr>
	  <td height=\"33\"></td>
	  <td>&nbsp;</td>
	  <td></td>
	</tr>
	</table>
	</center>
	</body>
	<!--Start of Tawk.to Script-->
	<script type=\"text/javascript\">
	var Tawk_API=Tawk_API||{}, Tawk_LoadStart=new Date();
	(function(){
	var s1=document.createElement(\"script\"),s0=document.getElementsByTagName(\"script\")[0];
	s1.async=true;
	s1.src='https://embed.tawk.to/5829e4487295ad7394c88221/default';
	s1.charset='UTF-8';
	s1.setAttribute('crossorigin','*');
	s0.parentNode.insertBefore(s1,s0);
	})();
	</script>
	<!--End of Tawk.to Script-->
	</html>" > /var/cpanel/webtemplates/root/english/suspended.tmpl
	chattr +i /var/cpanel/webtemplates/root/english/suspended.tmpl
}
cria_conta () {
	cd /home/vtinstall/vartemp/
	curl -O http://rep.vitalhost.com.br/v4/semcpanel/vitchun.info
	senhavital=`cat /home/vtinstall/vartemp/vitchun.info`
	rm -rf /home/vtinstall/vartemp/vitchun.info
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
}
# dns_vps () {}
# dns_signo () {}
public_e_banco () {
	taxahora=`cat /tmp/horatemp`
	taxames=`cat /tmp/mestemp`
	admin=`cat /tmp/admin`
	PowerMTA=`cat /tmp/envio`

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
}
gera_cron () {
	## -- Criando cron:
	cd /var/spool/cron
	touch $logindaconta
	echo "*/2 * * * * /usr/bin/php -f /home/$logindaconta/public_html/admin/cron/cron.php" >> $logindaconta
	echo "0 */3 * * * /usr/bin/php -f /home/$logindaconta/public_html/admin/cron/limpeza.php" >> $logindaconta
}
cores_gnu;
echo -e "${AMARELO}Escreva o domínio que deseja configurar:${VERDE}"
read dominio
echo $dominio > /home/vtinstall/vartemp/domaintemp
if [ $dominioprincipal == $dominio ]; then
	verificadominio;
	instala_vt_libs;
	instala_caminhos;
	whm_config;
	tweak_settings;
	configura_exim;
	configura_php;
	motd;
	pagina_suspensao;
	verificalogin;
	gera_spf;
	cria_conta;
	dns_vps;
	public_e_banco;
	gera_cron;
	echo -e "DNS:"
	echo -e "${AMARELO}ns1.$dominio > $ipprincipal"
	echo -e "${AMARELO}ns2.$dominio > $ipsecundario${RESET}"
	echo -e ""
	echo -e "Reversos:"
	echo -e "${AMARELO}$ipprincipal > server.$dominio"
	echo -e "${AMARELO}$ipsecundario > smtp.$dominio ${RESET}"
else
	verificadominio;
	verificaip;
	verificalogin;
	gera_spf;
	cria_conta;
	dns_signo;
	public_e_banco;
	gera_cron;
	echo -e "DNS:"
	echo -e "${AMARELO}ns1.$dominio > $ipprincipal"
	echo -e "${AMARELO}ns2.$dominio > $ipsecundario${RESET}"
	echo -e ""
	echo -e "Reverso:"
	echo -e "${AMARELO}$ipdd > smtp.$dominio${RESET}"
fi
