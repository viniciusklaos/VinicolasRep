verificaip () {
	ip a | grep 'inet ' | grep -v 127.0.0.1 | awk '{print $2}' | cut -f1 -d/ | sort > ips.info
	cat /etc/mailips | cut -d: -f2 | sed 's/ //g' | sort > ipdedicado.info
	IPSLIVRE=`diff ipdedicado.info ips.info | grep ^\> | sed 's/> /Disponível: /g'`
	if [ -z "$IPSLIVRE" ]
	then
		clear
		echo -e "${VERMELHO} Sem IPS livres para dedicar na maquina${RESET}"
		sleep 3
		exit
	else
		clear
	fi
	rm -Rf ips.info ipdedicado.info
}
verificadominio () {
	BASE=/home/vtinstall/vartemp/dominiobase
	if [ -e "$BASE" ]; then
		dominioprincipal=`cat /home/vtinstall/vartemp/dominiobase`
		echo -e "${AMARELO}Domínio principal:${VERDE} $dominioprincipal"
	else
		echo $dominio > /home/vtinstall/vartemp/dominiobase
		dominioprincipal=`cat /home/vtinstall/vartemp/dominiobase`
		echo "Configurando novo VPS de dominio: $dominio"
		sleep 3
	fi
}
verificalogin () {
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
whm_config () {}
tweak_settings () {}
configura_exim () {}
configura_php () {}
motd () {}
pagina_suspensao () {}
configura_mysql () {}
cria_conta () {}
dns_vps () {}
dns_signo () {}
public_e_banco () {}
gera_cron () {}
echo -e "${AMARELO}Escreva o domínio que deseja configurar:${VERDE}"
read dominio
verificaip;
verificadominio;
echo $dominio > /home/vtinstall/vartemp/domaintemp
if [ $dominioprincipal == $dominio ]; then
	insala_vt_libs;
	whm_config;
	tweak_settings;
	configura_exim;
	configura_php;
	motd;
	pagina_suspensao;
	configura_mysql;
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
