##  --  --  --  --  --
##      Instalação v3.0
##  --  --  --  --  --
##
##  --  Change Logs:
##  - Adicionado PHP 5.6
##  - Adicionado limpeza de caixas de e-mail
##
##  -----------------------------------------------------------------------------------------------------------------
##
##  --  --  --  --  --
##      Instalação v3.0.1
##  --  --  --  --  --
##
##  --  Change Logs:
##  - Alterado o "yaml" para dbuser (antes userdb - corrigindo erro na hora de gerar o backup)
##  - Ajustado mensagens de erro que aparecia por motivos de pastas já criadas sendo criadas novamente
##  - Adicionado public_html e banco com Admin e PowerMTA
##  - Instalações podem ser executadas em paralelo
##
##  -----------------------------------------------------------------------------------------------------------------
##
##  --  --  --  --  --
##      Instalação v3.0.2
##  --  --  --  --  --
##
##  --  Change Logs:
##  - Adicionado remoção do EximStats
##  - Adicionado remoção do Exim Mainlogs
##  - Adicionado spamtraps.sql
##  - VPS agora envia do IP secundário com EXIM (Antes somente com PMTA)
##  - Removido Backup DAILY do CPANEL
##  - Adicionado Backup para o tv2.revendabrasil.com.br
##
##  -----------------------------------------------------------------------------------------------------------------
##
##  --  --  --  --  --
##      Instalação v3.1.0
##  --  --  --  --  --
##
##  --  Change Logs:
##  - Evita duplicidade de contas
##  - Gera backup do Mailips e Mailhelo
##  - Novo IPUSO AO VIVO
##	- Apresenta lista de IPS disponíveis na hora da configuração
##	- Relatório de DNS e rDNS apresentado ao final da instalação
##
##
##  -----------------------------------------------------------------------------------------------------------------
##
##  --  --  --  --  --
##      Instalação v3.1.1
##  --  --  --  --  --
##
##  --  Change Logs:
##	- Impossível instalação de conta em IP que não esteja na máquina
##	- Impossível instalação de conta em IP que já esteja em uso
##	- Correção do transparente.png
##	- Correção de Mailhelo
##	- Correção da zona de DNS
##	- Correção do 'adminnotify_email'
##
##  -----------------------------------------------------------------------------------------------------------------
##
##  --  --  --  --  --
##      Instalação v3.1.2
##  --  --  --  --  --
##
##  --  Change Logs:
##	- PHP configurado de fato
##
##  -----------------------------------------------------------------------------------------------------------------
##
##  --  --  --  --  --
##      Instalação v3.1.3
##  --  --  --  --  --
##
##  --  Change Logs:
##	--
## 	-- Interspire sem links externos;
## 	-- Base de spamtraps atualizada;
## 	-- Zona de DNS corrigida;
## 	-- Campo de configuração por hora/mês travado;
## 	-- Campo de configuração por hora/mês alterado automaticamente;
## 	-- Instalação mais leve e fluída.
##
######################################################
## CORES ##
######################################################
VERMELHO="\033[01;31;40m"
VERDE="\033[01;32;40m"
AMARELO="\033[01;33;40m"
AZUL="\033[01;34;40m"
ROSA="\033[01;35;40m"
CIANO="\033[01;36;40m"
######################################################
RESET="\033[00;37;40m"
######################################################
##
##  --  --  --  --  --
##  --  Início do script:
##
##  -- Verificando se tem IPS disponíveis:
IPS=`ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -f1 -d/`
echo "$IPS" > ips.temp
sort ips.temp > ips.info
rm -Rf ips.temp
## IPS dedicados
cat /etc/mailips | cut -d: -f2 | sed 's/ //g' > ipdedicado.temp
sort ipdedicado.temp > ipdedicado.info
rm -Rf ipdedicado.temp
## IPS Livres
diff ipdedicado.info ips.info | grep ^\> > livres.info
sed -i 's/> /Disponível: /g' livres.info
IPSLIVRE=`cat livres.info`
if [ -z "$IPSLIVRE" ]
then
	echo -e "${VERMELHO} Sem IPS livres para dedicar na maquina${RESET}"
	sleep 3
	exit
else
	echo -e "${RESET}"
fi
rm -Rf ips.info ipdedicado.info
## -- Domínio
echo -e "${AMARELO}Escreva o domínio que deseja configurar:${VERDE}"
read dominio
## -- Verificando se já tem o domínio principal
BASE=/home/vtinstall/vartemp/dominiobase
if [ -e "$BASE" ]; then
	dominioprincipal=`cat /home/vtinstall/vartemp/dominiobase`
	echo -e "${AMARELO}Domínio principal:${VERDE} $dominioprincipal"
	echo $dominio > /home/vtinstall/vartemp/domaintemp
## -- Se não tiver, faz a instalação:
else
	echo -e  "${VERDE}Vamos instalar os ${AMARELO}arquivos VITAIS:${RESET}"
	sleep 1
	## -- Verificando se existe e criando pasta VTINSTALL:
	VTINSTALL=/home/vtinstall
	if [ -e "$VTINSTALL" ] ; then
	  echo -e  "${VERDE}Servidor já contém a pasta de instalações e manutenções."
	  sleep 0.5
	else
	    cd /home
	  mkdir vtinstall
	  echo -e  "${VERDE}Pasta de instalações e manutenções criada."
	  sleep 0.5
	fi
	## -- Verificando se existe e criando pasta VARTEMP:
	VARTEMP=/home/vtinstall/vartemp
	if [ -e "$VARTEMP" ] ; then
	  echo -e  "${VERDE}Servidor já contém a pasta de variáveis temporárias."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir vartemp
	    echo -e  "${VERDE}Pasta de variáveis temporárias criada."
	    sleep 0.5
	fi
	## -- Verificando se existe e criando pasta MENU:
	MENU=/home/vtinstall/menu
	if [ -e "$MENU" ] ; then
	  echo -e "${VERDE}Servidor já contém a pasta de menus de manutenções."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir menu
	    echo -e "${VERDE}Pasta de menus de manutenções criada."
	    sleep 0.5
	fi
	## -- Verificando se existe e criando pasta MENUSISTEMA:
	MENUSISTEMA=/home/vtinstall/menusistema
	if [ -e "$MENUSISTEMA" ] ; then
	  echo -e "${VERDE}Servidor já contém a pasta de menus do sistema."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir menusistema
	    echo -e "${VERDE}Pasta de menus do sistema criada."
	    sleep 0.5
	fi
	## -- Verificando se existe e criando pasta SCRIPTS:
	SCRIPTS=/home/vtinstall/scripts
	if [ -e "$SCRIPTS" ] ; then
	  echo -e "${VERDE}Servidor já contém a pasta de scripts de instalação."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir scripts
	    echo -e "${VERDE}Pasta de scripts de instalação criada."
	    sleep 0.5
	fi
	## -- Verificando se existe e criando pasta SPAMTRAPS:
	SPAMTRAPS=/home/vtinstall/spamtraps
	if [ -e "$SPAMTRAPS" ] ; then
	  echo -e "${VERDE}Servidor já contém a pasta de remoção de spamtraps."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir spamtraps
	    echo -e "${VERDE}Pasta de remoção de spamtraps criada."
	    sleep 0.5
	fi
	## -- Verificando se existe e criando pasta UPDATE:
	UPDATE=/home/vtinstall/update
	if [ -e "$UPDATE" ] ; then
	  echo -e "${VERDE}Servidor já contém a pasta de atualização global."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir update
	    echo -e "${VERDE}Pasta de atualização global criada."
	    sleep 0.5
	fi
	## -- Verificando se existe e criando pasta VTBACKUPS:
	VTBACKUPS=/home/vtinstall/vtbackups
	if [ -e "$VTBACKUPS" ] ; then
	  echo -e "${VERDE}Servidor já contém a pasta de backups manuais e limpeza de e-mails."
	  sleep 0.5
	else
	    cd /home/vtinstall
	    mkdir vtbackups
	    echo -e "${VERDE}Pasta de backups manuais e limpeza de e-mails criada."
	    sleep 0.5
	fi
	echo ""
	echo -e "${VERDE}As pastas instalação já foram criadas, já se pode iniciar a instalação."
	echo ""
	echo -e "${VERDE}A segunda etapa se inicia em:"
	echo -e "${AMARELO}3"
	sleep 1
	echo -e "2"
	sleep 1
	echo -e "1"
	sleep 1
	echo $dominio > /home/vtinstall/vartemp/dominiobase
	dominioprincipal=`cat /home/vtinstall/vartemp/dominiobase`
	echo $dominio > /home/vtinstall/vartemp/domaintemp
fi
sleep 1
clear
echo ""
echo -e "${VERDE}Perfeito...${RESET}"
sleep 2
clear
if [ $dominioprincipal == $dominio ]; then
	## -- Pegando os IPS
	IPS=`ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -f1 -d/`
	## -- Salvando na viariável
	echo "$IPS" > /home/vtinstall/vartemp/ips.txt
	## -- Gerando nova variável com o caminho
	IPS=`cat /home/vtinstall/vartemp/ips.txt`
	## -- Quantidade = 1
	COUNT=1
	## -- Fazendo cada IP ir para um arquivo (ip1...10.txt)
	for IP in `cat /home/vtinstall/vartemp/ips.txt`; do echo "$IP" > /home/vtinstall/vartemp/ip$COUNT.txt; COUNT=`expr $COUNT + 1`; done;
else
	echo ""
fi
## -- Pegando os IPS e colocando na viarável
cd /home/vtinstall/vartemp/
wget http://rep.vitalhost.com.br/v4/semcpanel/vitchun.info
ipprincipal=`cat /home/vtinstall/vartemp/ip1.txt`
ipsecundario=`cat /home/vtinstall/vartemp/ip2.txt`
senhavital=`cat /home/vtinstall/vartemp/vitchun.info`
rm -rf /home/vtinstall/vartemp/vitchun.info
echo $ipprincipal > /home/vtinstall/vartemp/iptemp
echo $ipsecundario > /home/vtinstall/vartemp/ip2temp
## -- Pegando o login da conta do usuario e do cpanel
cd /home/vtinstall/vartemp
tr -dc ‘a-z’ < domaintemp > lgtmp
logindacontatmp=`cat /home/vtinstall/vartemp/lgtmp`
logindaconta=`echo $logindacontatmp | cut -c 1-8`
## -- Verificando se já existe uma conta com este nome:
CONTA=/home/$logindaconta
if [ -e "$CONTA" ]; then
	echo $logindaconta > /home/vtinstall/vartemp/loginconflito
	loginconflito=`cat /home/vtinstall/vartemp/loginconflito`
	logincerto=`echo $loginconflito | cut -c 1-7`
	echo $logincerto > /home/vtinstall/vartemp/loginconflito
	sed -i 's/$/2/' /home/vtinstall/vartemp/loginconflito
	logindaconta=`cat /home/vtinstall/vartemp/loginconflito`
	rm -rf /home/vtinstall/vartemp/loginconflito
	clear
	echo ""
	echo -e "${AMARELO}Este login da conta já existe, e o mesmo foi alterado para:${VERDE} $logindaconta ${RESET}"
	sleep 3
else
	clear
	echo ""
	echo -e "${VERDE}Login da conta OK"
	sleep 1
	clear
fi
iemlogin=`echo $dominio | cut -d. -f1`
## -- Pegando as taxas hora/mes/admin
taxahora=`cat /tmp/horatemp`
taxames=`cat /tmp/mestemp`
admin=`cat /tmp/admin`
## -- Se o domínio principal for igual o domínio (VPS):
if [ $dominioprincipal == $dominio ]; then
ipprincipal=`cat /home/vtinstall/vartemp/iptemp`
# - Desabilitando o Ipv6
perl -p -i -e 's/NETWORKING_IPV6="yes"/NETWORKING_IPV6="no"/g' /etc/sysconfig/network
perl -p -i -e 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/*
chkconfig --level 123456 ip6tables off
echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
# - Fazendo as configurações do "Basic"
sed -i '/ADDR /d' /etc/wwwacct.conf
sed -i "/NSTTL /i ADDR $ipprincipal" /etc/wwwacct.conf
sed -i '/NS /d' /etc/wwwacct.conf
sed -i "/HOMEDIR /i NS ns1.$dominio" /etc/wwwacct.conf
sed -i '/CONTACTEMAIL /d' /etc/wwwacct.conf
sed -i "/HOST /i CONTACTEMAIL root@server.$dominio" /etc/wwwacct.conf
sed -i '/NS2 /d' /etc/wwwacct.conf
sed -i "/HOMEMATCH /i NS2 ns2.$dominio" /etc/wwwacct.conf
sed -i '/HOST /d' /etc/wwwacct.conf
sed -i "/DEFWEBMAILTHEME /i HOST server.$dominio" /etc/wwwacct.conf
# - Fazendo as configurações do "Tweak Settings"
sed -i '/defaultmailaction/d' /var/cpanel/cpanel.config
sed -i "/disable-php-as-reseller-security/i defaultmailaction=fail" /var/cpanel/cpanel.config
sed -i '/skipspamassassin/d' /var/cpanel/cpanel.config
sed -i "/skipspambox/i skipspamassassin=1" /var/cpanel/cpanel.config
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
clear
# - Configurando o backup do cpanel:
echo "BACKUPDIR /backup
GZIPRSYNCOPTS --rsyncable
DIEIFNOTMOUNTED no
BACKUPTYPE ftp
BACKUPENABLE yes
BACKUPFTPPASSIVE yes
BACKUPFTPTIMEOUT 120
BACKUPBWDATA no
BACKUPRETMONTHLY 1
BACKUPFILES no
PREBACKUP 0
BACKUPINT weekly
COMPRESSACCTS yes
BACKUP2 yes
BACKUPFTPHOST tv.revendabrasil.com.br
POSTBACKUP 0
BACKUPRETDAILY 0
BACKUPDAYS 0,2,4,6
BACKUPRETWEEKLY 1
LOCALZONESONLY no
LINKDEST no
BACKUPLOGS no
BACKUPACCTS yes
MYSQLBACKUP both
BACKUPINC no
BACKUPMOUNT no
BACKUPCHECK yes
BACKUPFTPDIR /backupmkt/$dominio
BACKUPFTPUSER backupvp" > /etc/cpbackup.conf
# - Configurando senha do backup
echo "BACKUPFTPPASS $senhavital" > /etc/cpbackup.conf.shadow
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
#
cd /usr/local/bin
> ips
> dominios
echo "ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print \$2}' | cut -f1 -d/" > ips
echo "cat /etc/trueuserdomains | cut -d: -f1" > dominios
chmod a+x ips
chmod a+x dominios
rm -rf dedicar; wget http://rep.vitalhost.com.br/v4/semcpanel/dedicar; chmod a+x dedicar;
rm -rf remover; wget http://rep.vitalhost.com.br/v4/semcpanel/remover; chmod a+x remover;
rm -rf contar; wget http://rep.vitalhost.com.br/v4/semcpanel/contar; chmod a+x contar;
rm -rf suspender; wget http://rep.vitalhost.com.br/v4/semcpanel/suspender; chmod a+x suspender;
rm -rf unsuspender; wget http://rep.vitalhost.com.br/v4/semcpanel/unsuspender; chmod a+x unsuspender;
rm -rf ipuso; wget http://rep.vitalhost.com.br/v4/semcpanel/ipuso; chmod a+x ipuso;
## -- Instalando vtbackup
cd /home; rm -rf instalarbackup.sh; wget rep.vitalhost.com.br/v4/backup/instalarbackup.sh && sh instalarbackup.sh; rm -rf instalarbackup.sh
# - MOTD
echo "" > /etc/motd
echo "Server: server.$dominioprincipal"
echo "Esse servidor contém:" >> /etc/motd
echo "" >> /etc/motd
echo "ipuso - dedicar - remover - contar" >> /etc/motd
echo "ips - dominios - suspender - unsuspender" >> /etc/motd
echo "" >> /etc/motd
echo "Bem vindo" >> /etc/motd
echo "Vital Host 2017 - SmartCpanel" >> /etc/motd
echo "" >> /etc/motd
## -- Página de suspensão personalizada:
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
## -- Ativando o Mailhelo e MailIPS
#
sed -i '/acl_requirehelo=/d' /etc/exim.conf.localopts
sed -i '/acl_requirehelonoforge=/d' /etc/exim.conf.localopts
sed -i '/acl_requirehelonold=/d' /etc/exim.conf.localopts
sed -i '/callouts=/d' /etc/exim.conf.localopts
sed -i '/custom_mailhelo=/d' /etc/exim.conf.localopts
sed -i '/custom_mailips=/d' /etc/exim.conf.localopts
sed -i '/filter_spam_rewrite=/d' /etc/exim.conf.localopts
sed -i '/globalspamassassin=/d' /etc/exim.conf.localopts
sed -i '/senderverify=/d' /etc/exim.conf.localopts
sed -i '/setsenderheader=/d' /etc/exim.conf.localopts
sed -i '/acl_requirehelosyntax=/d' /etc/exim.conf.localopts
echo "acl_requirehelo=1
acl_requirehelonoforge=1
acl_requirehelonold=0
acl_requirehelosyntax=1
callouts=0
custom_mailhelo=1
custom_mailips=1
filter_spam_rewrite=0
globalspamassassin=0
senderverify=0
setsenderheader=0" >> /etc/exim.conf.localopts
#
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
else
IPS=`ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -f1 -d/`
echo "$IPS" > /home/vtinstall/vartemp/ips.txt
echo "$IPS" > ips.temp
sort ips.temp > ips.info
rm -Rf ips.temp
cat /etc/mailips | cut -d: -f2 > ipdedicado.temp
sed -i 's/ //g' ipdedicado.temp
sort ipdedicado.temp > ipdedicado.info
rm -Rf ipdedicado.temp
diff ipdedicado.info ips.info | grep ^\> > livres.info
sed -i 's/> /Disponível: /g' livres.info
sed -i "/\<$ipprincipal\>/d" livres.info
cat livres.info
rm -Rf livres.info
echo ""
echo -e "${AMARELO}Qual IP deseja dedicar para o domínio:${VERDE} $dominio ?"
echo "read ipdd
if grep -q -w \$ipdd /etc/mailips; then
		echo "IP já utilizado por outro cliente, por favor escolha outro:"
		sh /home/vtinstall/vartemp/verificarip
else
	echo "\$ipdd" > /home/vtinstall/vartemp/ipddtemp
fi" > /home/vtinstall/vartemp/verificarip
sh /home/vtinstall/vartemp/verificarip
ipdd=`cat /home/vtinstall/vartemp/ipddtemp`
fi
rm -rf /home/vtinstall/vartemp/verificarip
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
## -- Gerando SPF:
cat /home/vtinstall/vartemp/ips.txt | cut -f1-3 -d. > /home/vtinstall/vartemp/ipspf.info
sort /home/vtinstall/vartemp/ipspf.info | uniq > /home/vtinstall/vartemp/spf.info
sed -i 's/^/+ip4:/' /home/vtinstall/vartemp/spf.info
sed -i 's/$/.0\/24 /' /home/vtinstall/vartemp/spf.info
sed -i ':a;$!N;s/\n//;ta;' /home/vtinstall/vartemp/spf.info
SPF=`cat /home/vtinstall/vartemp/spf.info`
if [ $dominioprincipal == $dominio ]; then
/usr/local/cpanel/bin/dkim_keys_uninstall $LOGIN
sleep 1
/usr/local/cpanel/bin/spf_uninstaller $LOGIN
sleep 1
## -- Zona de DNS:
echo "; cPanel first:11.54.0.21 (update_time):1460480627 11.54.0.21: Cpanel::ZoneFile::VERSION:1.3 hostname:${dominio} latest:11.54.0.21
; Zone file for ${dominio}
\$TTL 14400
@      86400    IN      SOA     ns1.${dominio}. root.server.${dominio}. (
2016041203      ; serial, todays date+todays
3600            ; refresh, seconds
7200            ; retry, seconds
1209600         ; expire, seconds
86400 )         ; minimum, seconds
${dominio}. 86400 IN NS ns1.${dominio}.
${dominio}. 86400 IN NS ns2.${dominio}.
${dominio}. IN A 			${ipprincipal}
${dominio}. IN MX 0 		${dominio}.
mail IN CNAME 		${dominio}.
www IN CNAME 		${dominio}.
ftp IN A 			${ipprincipal}
cpanel IN A 		${ipprincipal}
webdisk IN A 		${ipprincipal}
cpcalendars IN A 	${ipprincipal}
cpcontacts IN A 	${ipprincipal}
whm IN A 			${ipprincipal}
webmail IN A 			${ipprincipal}
;
;
;											
;							NAMESERVERS, SPF, DMARC E DKIM		
;											
;
;
ns1		3600	IN	A	${ipprincipal}
ns2		3600	IN	A	${ipsecundario}
server		3600	IN	A	${ipprincipal}
smtp		3600	IN	A	${ipsecundario}
_dmarc		3600	IN	TXT	\"v=DMARC1; p=none; sp=none; aspf=r; adkim=s; rua=mailto:postmaster@${dominio}\"
${dominio}.	14400	IN	TXT	\"v=spf1 +a +mx ${SPF}~all\"" > /var/named/$dominio.db
sleep 1
/usr/local/cpanel/bin/dkim_keys_install $logindaconta
sleep 1
chattr -i /etc/mailips
chattr -i /etc/mailhelo
echo "$dominio: $ipsecundario" >> /etc/mailips
echo "*: $ipprincipal" >> /etc/mailips
echo "$dominio: smtp.$dominio" >> /etc/mailhelo
chattr +i /etc/mailips
chattr +i /etc/mailhelo
else
/usr/local/cpanel/bin/dkim_keys_uninstall $LOGIN
sleep 1
/usr/local/cpanel/bin/spf_uninstaller $LOGIN
sleep 1
## -- Zona de DNS:
echo "; cPanel first:11.54.0.21 (update_time):1460480627 11.54.0.21: Cpanel::ZoneFile::VERSION:1.3 hostname:${dominio} latest:11.54.0.21
; Zone file for ${dominio}
\$TTL 14400
@      86400    IN      SOA     ns1.${dominio}. root.server.${dominio}. (
2016041203      ; serial, todays date+todays
3600            ; refresh, seconds
7200            ; retry, seconds
1209600         ; expire, seconds
86400 )         ; minimum, seconds
${dominio}. 86400 IN NS ns1.${dominio}.
${dominio}. 86400 IN NS ns2.${dominio}.
${dominio}. IN A 			${ipprincipal}
${dominio}. IN MX 0 		${dominio}.
mail IN CNAME 		${dominio}.
www IN CNAME 		${dominio}.
ftp IN A 			${ipprincipal}
cpanel IN A 		${ipprincipal}
webdisk IN A 		${ipprincipal}
cpcalendars IN A 	${ipprincipal}
cpcontacts IN A 	${ipprincipal}
whm IN A 			${ipprincipal}
webmail IN A 			${ipprincipal}
;
;
;											
;							NAMESERVERS, SPF, DMARC E DKIM		
;											
;
;
ns1		3600	IN	A	${ipprincipal}
ns2		3600	IN	A	${ipsecundario}
smtp		3600	IN	A	${ipdd}
_dmarc		3600	IN	TXT	\"v=DMARC1; p=none; sp=none; aspf=r; adkim=s; rua=mailto:postmaster@${dominio}\"
${dominio}.	14400	IN	TXT	\"v=spf1 +a +mx ${SPF}~all\"" > /var/named/$dominio.db
sleep 1
/usr/local/cpanel/bin/dkim_keys_install $logindaconta
sleep 1
chattr -i /etc/mailips
chattr -i /etc/mailhelo
sed -i '1i\'$dominio': '$ipdd'\' /etc/mailips
echo "$dominio: smtp.$dominio" >> /etc/mailhelo
chattr +i /etc/mailips
chattr +i /etc/mailhelo
fi
## -- Banco de dados:
mysql -e "create database ${logindaconta}_banco;"
mysql -Be "grant all privileges on ${logindaconta}_banco.* to '${logindaconta}_dbuser'@'localhost' identified by \"phCA24bgK\";"
## -- Se enviar a mais de 25.001 por hora, instala PMTA:
taxamax=`echo 25001`
if [ $taxahora -ge $taxamax ]; then
  cd /home
  PowerMTA=1
  wget http://rep.vitalhost.com.br/v2/pmta4.0.2015/install.sh
  chmod 777 install.sh
  sh install.sh
  echo ""
  perl -p -i -e 's/DOMINIO/'$dominio'/g' /etc/pmta/config
  perl -p -i -e 's/74.208.205.236/'$ipsecundario'/g' /etc/pmta/config
  perl -p -i -e 's/server/smtp/g' /etc/pmta/config
  perl -p -i -e 's/wM5JH7rC/red17pmta/g' /etc/pmta/config
  /etc/rc.d/init.d/pmta restart
  /etc/rc.d/init.d/pmta reload
  /etc/rc.d/init.d/pmta restart
  /etc/rc.d/init.d/pmta restart
  clear
else
  PowerMTA=0
  sleep 1
fi
#
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
#
## -- Criando cron:
cd /var/spool/cron
touch $logindaconta
echo "*/2 * * * * /usr/bin/php -f /home/$logindaconta/public_html/admin/cron/cron.php" >> $logindaconta
echo "0 */3 * * * /usr/bin/php -f /home/$logindaconta/public_html/admin/cron/limpeza.php" >> $logindaconta
## -- Upgrade Vital:
UPGRADASSO=/home/vtinstall/update
if [ -e "$UPGRADASSO" ]; then
cd /home/vtinstall/update
else
cd /home/vtinstall
mkdir update
cd update
fi
UP=/home/vtinstall/update/upgrade.sh
if [ -e "$UP" ]; then
chmod 777 upgrade.sh
else
wget http://rep.vitalhost.com.br/v4/update/upgrade.sh
chmod 777 upgrade.sh
fi
sed -i '/upgrade.sh/d' /var/spool/cron/root
echo "0 9 * * * sh /home/vtinstall/update/upgrade.sh" >> /var/spool/cron/root
## -- YAML pra gerar banco:
echo "---
MYSQL:
  dbs:
    ${logindaconta}_banco: 63.143.33.60


  dbusers:
    ${logindaconta}_dbuser:

      dbs:
        ${logindaconta}_banco: 63.143.33.60
      server: 69.162.82.108
  noprefix: {}

  owner: ${logindaconta}
  server: 63.143.33.60" > /var/cpanel/databases/$logindaconta.yaml
chmod 640 /var/cpanel/databases/$logindaconta.yaml;
chown root.$logindaconta /var/cpanel/databases/$logindaconta.yaml;
rm -Rf /var/cpanel/databases/*.json;
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
if [ $dominioprincipal == $dominio ]; then
	echo -e "DNS:"
	echo -e "${AMARELO}ns1.$dominio > $ipprincipal"
	echo -e "${AMARELO}ns2.$dominio > $ipsecundario${RESET}"
	echo -e ""
	echo -e "Reversos:"
	echo -e "${AMARELO}$ipprincipal > server.$dominio"
	echo -e "${AMARELO}$ipsecundario > smtp.$dominio ${RESET}"
	echo -e ""
	echo -e ""
	echo -e "${VERMELHO}Copiou a informação?${RESET}"
	read fodas
else
	echo -e "DNS:"
	echo -e "${AMARELO}ns1.$dominio > $ipprincipal"
	echo -e "${AMARELO}ns2.$dominio > $ipsecundario${RESET}"
	echo -e ""
	echo -e "Reverso:"
	echo -e "${AMARELO}$ipdd > smtp.$dominio${RESET}"
	echo -e ""
	echo -e ""
	echo -e "${VERMELHO}Copiou a informação?${RESET}"
	read fodas
fi