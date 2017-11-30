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
