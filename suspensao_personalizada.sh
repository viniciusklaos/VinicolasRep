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
