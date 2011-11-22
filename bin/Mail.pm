#!/usr/bin/perl
#
# This file is part of Querybot (-a modular perl jabber bot)
# http://github.com/micressor/jabber-querybot
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

package Mail;

use strict;
use vars qw(@EXPORT @ISA);
use Exporter;
use Log;
use Net::SMTP;

@ISA               = qw(Exporter);
@EXPORT            = qw( send_mail );
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
