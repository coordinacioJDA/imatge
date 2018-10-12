#!/usr/bin/perl
#Instal·lar sudo cpan -i 'String:Random'
#Instal·lar sudo cpan -i 'Email:Send:SMTP:Gmail'.

use strict;
use warnings;
use utf8;
use String::Random qw(random_regex random_string);
#use Email::Send::SMTP::Gmail;

sub netejar(){
  my $cadena= $_[0];
  $cadena=~ s/[ ]//g;
  $cadena=~ s/[\']//g;
  $cadena=~ tr/àáäéèëíìïóòöúùüçñªº/aaaeeeiiiooouuucnao/;
  return($cadena);
}

sub enviar_correu(){
  my $email= $_[0];
  my $usuari= $_[1]; 
  my $password= $_[2];
  my $useremail= $_[3];
  #Enviament correu amb les dades LDAP a l'alumne   
  $email->send(-to=>$useremail, -subject=>'Usuari LDAP',-body=>'Bon dia
Ja és possible que accedeixis als ordinadors de les aules amb un usuari propi, $
usuari:'.$usuari.'
contrasenya: '.$password.'
Si vols canviar el password, pots fer servir l\'ordre passwd
Coordinació Informàtica
');
}

#Configuració correu
#my $mail=Email::Send::SMTP::Gmail->new( -smtp=>'smtp.gmail.com',
                                       # -login=>'sergi.perez@iesjoandaustria.org',
                                       # -pass=>'2013bcn2014');

open SMX1A,">:encoding(utf8)", "smx1A.csv";
open SMX1B,">:encoding(utf8)", "smx1B.csv";
open SMX2A,">:encoding(utf8)", "smx2A.csv";
open SMX2B,">:encoding(utf8)", "smx2B.csv";
open ASIX1,">:encoding(utf8)", "asix1.csv";
open ASIX2,">:encoding(utf8)", "asix2.csv";
open DAW1,">:encoding(utf8)", "daw1.csv";
open DAW2,">:encoding(utf8)", "daw2.csv";
open LDIF,">:encoding(utf8)", "usuaris.ldif";
open USERS,"<:encoding(utf8)",'users.csv';
my $number=3001;
while (my $line = <USERS>) {
    chomp ($line);
    my $user;
    my ($givenname, $surname, $grup,$useremail) = split(',', $line);
    my $givenname_net=&netejar($givenname);
    my $surname_net=&netejar($surname);
    my $password=random_string(".....");

    $user->{'user'} = lc($givenname_net).".".lc($surname_net);
    $user->{'givenname'} = ucfirst($givenname);
    $user->{'surname'} = ucfirst($surname);
    $user->{'password'} = $password;
    $user->{'password'}=~ s/[\"]/i/;    
    #&crear_ldif($user->{'user'},$user->{password},$user->{givenname},$user->{surname},$number,$useremail,LDIF);
    #Comprovar existència usuari
    my $num=1;
    system('ldapsearch -D "cn=zentyal,dc=jda,dc=ins" -w aSrft98YT3gRKORm2Utz -b "cn=alumnes,ou=Groups,dc=jda,dc=ins" uid=$user->{"user"} -h 127.0.0.1 -p 390');
    while(index(*STDOUT,"numEntries")>0){
        $user->{'user'} = $user->{'user'}.".".$num;
        system('ldapsearch -D "cn=zentyal,dc=jda,dc=ins" -w aSrft98YT3gRKORm2Utz -b "cn=alumnes,ou=Groups,dc=jda,dc=ins" uid=$user->{"user"} -h 127.0.0.1 -p 390');
        $num++;
    }

    print LDIF "#Usuari ".$user->{'user'}."\n"; 
    print LDIF "dn: cn=".$user->{'givenname'}.$user->{'surname'}.",cn=alumnes,ou=Groups,dc=jda,dc=ins\n";
    print LDIF "objectclass: inetOrgPerson\n";
    print LDIF "objectclass: systemQuotas\n";
    print LDIF "cn: ".$user->{'givenname'}."\n";
    print LDIF "sn: ".$user->{'surname'}."\n";
    print LDIF "uid:".$user->{'user'}."\n";
    print LDIF "userpassword:".$password."\n";
    print LDIF "homeDirectory:/home/".$user->{'user'}."\n";
    print LDIF "mail: ".$useremail."\n";
    print LDIF "uidNumber:".$number."\n";
    print LDIF "gidNumber: 51176\n";
    print LDIF "####################\n"; 
    system('ldapadd  -D "cn=zentyal,dc=jda,dc=ins" -w aSrft98YT3gRKORm2Utz -f usuaris.ldif -p 390 -h 127.0.0.1');
    print("3".*STDOUT."\n");
    eval('print '.$grup.'"'.$user->{'user'}.','.$user->{password}.','.$user->{givenname}.' '.$user->{surname}.'\n"');
    #&enviar_correu($mail,$user->{'user'},$user->{password},$useremail);
    $number++;	
}

close (LDIF);
close (USERS);
close (SMX1A);
close (SMX1B);
close (SMX2A);
close (SMX2B);
close (ASIX1);
close (ASIX2);
close (DAW1);
close (DAW2);
#Enviament dels correus als tutors
my $text_tutors='Bones
 Els alumnes ja han rebut un correu amb les seves dades LDAP, però per si hi ha$
 Tingues un bon dia
 Coordinació informàtica';

my $subject_tutors='Usuaris LDAP';


#$mail->send(-to=>'estanis.casanova@iesjoandaustria.org', -subject=>$subject_tu$
#            -attachments=>'smx1A.csv');
#$mail->send(-to=>'manel.lopez@iesjoandaustria.org', -subject=>$subject_tutors,$
#            -attachments=>'smx1B.csv');
#$mail->send(-to=>'joaquim.sabria@iesjoandaustria.org', -subject=>$subject_tuto$
#            -attachments=>'smx2A.csv');
#$mail->send(-to=>'jordi.hernandez@iesjoandaustria.org', -subject=>$subject_tut$
#            -attachments=>'smx2B.csv');
#$mail->send(-to=>'sergi.perez@iesjoandaustria.org', -subject=>$subject_tutors, $
#            -attachments=>'asix1.csv');
#$mail->send(-to=>'raul.sala@iesjoandaustria.org', -subject=>$subject_tutors, -$
#            -attachments=>'daw1.csv');

#$mail->bye;


1;









