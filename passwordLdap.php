<html>
<head>
	<style type="text/css">
	input{
		display:inline;	
	}
	input[type="submit"]{
		float:right;
	}
	label{
		display:inline;
		font-weight:bold;
		margin-right:5px;
	}
	form{
		background-color:white;
		width:600px;
		margin-right:auto;
		margin-left:auto;
		margin-top:15px;
	}
	form>fieldset>img{
		background-image:URL('http://www.insjoandaustria.org/templates/spanish_red/images/spanish_joomla_logo.png');
		background-repeat:no-repeat;
		width:356px;
		height:81px;
		display:block;
		margin-bottom:10px;
	}
	body{
		background-color:#092748;
	}
	.camp{
		padding:5px;		
	}
	</style>
</head>
<body>
<?php
if (isset($_POST["uid"])){

// using ldap bind
$admindn  = 'cn=admin,dc=jda,dc=ins';     // ldap rdn or dn
$adminpass = 'profe';

// connect to ldap server
$ldapconn = ldap_connect("127.0.0.1")
    or die("Could not connect to LDAP server.");

if ($ldapconn) {

    // binding to ldap server
    $ldapbind = ldap_bind($ldapconn,$admindn,$adminpass);

    // verify binding
    if ($ldapbind) {
	ldap_set_option($ldapconn, LDAP_OPT_PROTOCOL_VERSION, 3);
	$dn = "dc=jda,dc=ins";
	$filter="(uid=".$_POST["uid"].")";	
	$justthese = array("cn","dn");
	$sr=ldap_search($ldapconn, $dn, $filter, $justthese);
	$info = ldap_get_entries($ldapconn, $sr);
	$dnusuari=$info[0]["dn"];
	echo $dnusuari;
	echo $_POST["password"];
 	//comprovar usuari i contrasenya
	$binduser = ldap_bind($ldapconn,$dnusuari,$_POST["password"]);
	if ($binduser){
	        $param["userPassword"] = $_POST["noupassword"];
		$sr=ldap_modify($ldapconn, $dnusuari, $param);
	}
	else{
		echo "Usuari incorrecte";
	}
    }
}

 }
else{
    ?>
<form action="passwordLdap.php" method="post">
<fieldset>
    <img id="logo"/>
    <div class="camp"><label for="uid">Usuari LDAP</label><input type="text" name="uid" required/></div>
    <div class="camp"><label for="password">Contrasenya actual</label><input type="password" name="password" required /></div>
    <div class="camp"><label for="noupassword">Escriu la nova contrasenya</label><input type="password" name="noupassword" required/></div>
    <div class="camp"><label for="renoupassword">Reescriu la nova contrasenya</label><input type="password" name="renoupassword" required/></div>
    <input type="submit" />
</fieldset>
</form>
<?php
}
?>
</body>
</html>
