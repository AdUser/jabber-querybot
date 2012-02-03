#
# This file is part of Querybot (-a modular perl jabber bot)
# http://github.com/micressor/jabber-querybot
#
# Copyright (C) 2009-2012 Marco Balmer <marco@balmer.name>
#
# Querybot is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Querybot is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Querybot. If not, see <http://www.gnu.org/licenses/>.

package JabberQuerybot;

=head1 NAME

JabberQuerybot - Modular xmpp/jabber bot

=cut

use 5.010001;
use strict;
use warnings;

require Exporter;

our @ISA = qw(Exporter);

# Items to export into callers namespace by default. Note: do not export
# names by default without a very good reason. Use EXPORT_OK instead.
# Do not simply export all your public functions/methods/constants.

# This allows declaration	use JabberQuerybot ':all';
# If you do not need this, moving things directly into @EXPORT or @EXPORT_OK
# will save memory.
our %EXPORT_TAGS = ( 'all' => [ qw(
	
) ] );

our @EXPORT_OK = ( @{ $EXPORT_TAGS{'all'} } );

our @EXPORT = qw(
querybot_log
send_mail
	
);

our $VERSION = '0.1.0';


# Preloaded methods go here.

use Sys::Syslog;

sub querybot_log
 {

  # BOT logging function. it loggs to stdout and to syslog

  my $type = shift;
  my $msg  = shift;
  
  unless($type eq "debug")
   {
    eval
     {
      syslog($type,$msg);
     };
    if($@)
     {
      syslog($type,"Problem to log a message (possible utf8?) -- ignore\n");
     }
   }
   print "$type ---> $msg\n";

} ### END of querybot_log()


use Net::SMTP;

$SIG{ALRM}      = sub { die "Unexepted Timeout" };

sub send_mail
#
#  Description: 
#
 {
  my $mail_host		= "localhost";
# no authentication, since we're using localhost :)
#  my $mail_user		= "";
#  my $mail_password	= "";
  my $mail_from		= shift;
  my $mail_to           = shift;
  my $mail_subject      = shift;
  my $mail_body 	= shift;

  #
  # Generate MIME mail message
  #
#  my $mime_mail = MIME::Lite->new(
#   			From    =>$mail_from,
#      			To      =>$mail_to,
#  	    		Subject =>$mail_subject,
#  			Type	=>"text/plain",
#      			Data    =>$mail_body
#         			);

eval {
  alarm(10);
  my $smtp = Net::SMTP->new(	$mail_host, 
  				Timeout => 10,
				Hello 	=>$mail_host,
				Debug 	=> 0
				);

# no authentication, since we're using localhost :)
#  $smtp->auth($mail_user,$mail_password);

  $smtp->mail($mail_from);
  $smtp->to($mail_to);

  $smtp->data();
  $smtp->datasend("X-Mailer: querybot.pl\n");
  $smtp->datasend("Content-type: text/plain;charset=UTF-8\n");
  $smtp->datasend("From: $mail_from\n");
  $smtp->datasend("To: $mail_to\n");
  $smtp->datasend("Subject: $mail_subject\n");
  $smtp->datasend("\n");
  $smtp->datasend($mail_body);
  $smtp->datasend("\n");
  $smtp->dataend();
  $smtp->quit;
  alarm(0);
  };
  if($@)
  {
    return 1;
  }

  return 0;
 } ### send_mail
1;

1;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2012 Marco Balmer <marco@balmer.name>

The Debian packaging is licensed under the 
GPL, see `/usr/share/common-licenses/GPL-3'.

=cut
