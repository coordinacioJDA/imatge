#!/usr/bin/perl
#Instal·lar sudo cpan -i 'String:Random'
#Instal·lar sudo cpan -i 'Email:Send:SMTP:Gmail'.
#Instal·lar ebox per ubuntu sudo apt-get install "^ebox-.*"
#Documentació Zentyal users.pm https://github.com/Zentyal/zentyal/blob/3.2/main/users/src/EBox/Users.pm (línia 1150)

use strict;
use warnings;
use utf8;
use EBox;
use EBox::UsersAndGroups::User;
use String::Random qw(random_regex random_string);
use Email::Send::SMTP::Gmail;


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
Ja és possible que accedeixis als ordinadors de les aules amb un usuari propi, les dades són:
usuari:'.$usuari.'
contrasenya: '.$password.'
Si vols canviar el password, pors fer servir la següent pàgina web:
http://garnatxa.jda.ins:8888
Aquestes pàgines web únicament estan accessibles des del centre
Coordinació Informàtica
');
}

EBox::init();
#Configuració correu
my $mail=Email::Send::SMTP::Gmail->new( -smtp=>'smtp.gmail.com',
                                        -login=>'sergi.perez@iesjoandaustria.org',
                                        -pass=>'2013bcn2014');

open SMX1A,">:encoding(utf8)", "smx1A.csv";
open SMX1B,">:encoding(utf8)", "smx1B.csv";
open SMX2A,">:encoding(utf8)", "smx2A.csv";
open SMX2B,">:encoding(utf8)", "smx2B.csv";
open ASIX1,">:encoding(utf8)", "asix1.csv";
open ASIX2,">:encoding(utf8)", "asix2.csv";
open DAW1,">:encoding(utf8)", "daw1.csv";
open DAW2,">:encoding(utf8)", "daw2.csv";
open USERS,"<:encoding(utf8)",'users.csv';

while (my $line = <USERS>) {
    chomp ($line);
    my $user;
    my ($givenname, $surname, $grup,$useremail) = split(',', $line);
    my $givenname_net=&netejar($givenname);
    my $surname_net=&netejar($surname);
    my $password=random_string(".....");
    #utf8::encode($givenname);
    #utf8::encode($surname);

    #my $password="";
    $user->{'user'} = lc($givenname_net).".".lc($surname_net);
    $user->{'givenname'} = ucfirst($givenname);
    $user->{'surname'} = ucfirst($surname);
    $user->{'password'} = $password;
    $user->{'password'}=~ s/[\"]/i/;    
    eval('print '.$grup.'"'.$user->{'user'}.','.$user->{password}.','.$user->{givenname}.' '.$user->{surname}.'\n"');
    my $num=1;
    while(EBox::UsersAndGroups::User->userByUID($user->{'user'})){
    $user->{'user'} = $user->{'user'}.".".$num;
        $num++;
    }
    my $newUser = EBox::UsersAndGroups::User->create($user, 0);
    my $group = new EBox::UsersAndGroups->group("alumnes");
    $newUser->addGroup("alumnes")
    &enviar_correu($mail,$user->{'user'},$user->{password},$useremail);
}

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
 Els alumnes ja han rebut un correu amb les seves dades LDAP, però per si hi ha algun despistat tens en l\'adjunt les dades dels alumnes de la teva tutoria.
 Tingues un bon dia
 Coordinació informàtica';

my $subject_tutors='Usuaris LDAP';

$mail->send(-to=>'estanis.casanova@iesjoandaustria.org', -subject=>$subject_tutors, -body=>$text_tutors,
            -attachments=>'smx1A.csv');
$mail->send(-to=>'manel.lopez@iesjoandaustria.org', -subject=>$subject_tutors, -body=>$text_tutors,
            -attachments=>'smx1B.csv');
$mail->send(-to=>'joaquim.sabria@iesjoandaustria.org', -subject=>$subject_tutors, -body=>$text_tutors,
            -attachments=>'smx2A.csv');
$mail->send(-to=>'jordi.hernandez@iesjoandaustria.org', -subject=>$subject_tutors, -body=>$text_tutors,
            -attachments=>'smx2B.csv');
$mail->send(-to=>'sergi.perez@iesjoandaustria.org', -subject=>$subject_tutors, -body=>$text_tutors,
            -attachments=>'asix1.csv');
$mail->send(-to=>'raul.sala@iesjoandaustria.org', -subject=>$subject_tutors, -body=>$text_tutors,
            -attachments=>'daw1.csv');
$mail->bye;


1;

