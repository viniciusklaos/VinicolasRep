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
# - Desabilitando o Ipv6
perl -p -i -e 's/NETWORKING_IPV6="yes"/NETWORKING_IPV6="no"/g' /etc/sysconfig/network
perl -p -i -e 's/IPV6INIT="yes"/IPV6INIT="no"/g' /etc/sysconfig/network-scripts/*
chkconfig --level 123456 ip6tables off
echo "net.ipv6.conf.default.disable_ipv6=1" >> /etc/sysctl.conf
echo "net.ipv6.conf.all.disable_ipv6 = 1" >> /etc/sysctl.conf
