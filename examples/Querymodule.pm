#!/usr/bin/perl -w
#
# This file is part of querybot (-a modular perl jabber bot)
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

package Querymodule;

use strict;

=head1 NAME

jabber-querybot - example bot

=head1 DESCRIPTION

This is an example how you can create jabber bots with this jabber-querybot
framework.

=cut

use JabberQuerybot;


use vars qw(@EXPORT @ISA);
use Exporter;

@ISA               = qw(Exporter);
@EXPORT            = qw(run_query $ident $service_name $bot_admin $hostname
  $port $timeout $user $password);

our $stanza_penalty_calc_default = 60;

=head1 OPTIONS

Please have a lookt at manpage of jabber-querybot how you configure
this options.

=cut

our $hostname		= "jabberserver.tld";
our $user		= "";
our $password		= "";
our $ident		= "Testbot";
our $bot_admin		= "\@swissjabber.ch";
our $port		= "5222";
our $timeout		= "5";
our $service_name	= "$user\@$hostname";
my  $useragent_desc     = "jabber-querybot - http://github.com/micressor/jabber-querybot";
our $bot_description	= "Bot help title
Bot description";

=head1 METHODS

=cut

sub run_query  #################################################################
 {
  my $msg	 	= shift;
  my $user              = shift;
  my $bare_jid          = shift;
  my $digest_jid        = shift;
  my $xml_result;

=head2 run_query()

If your module was loaded from jabber-querybot with:

use Querymodule;

Everytime a jabber messages comes in, run_query() is called and you
can decide what happens.

It is important to check which characters we allow to handle:

unless ($msg =~ /^[\!\-A-Za-z0-9äöüÄÖÜ\s]*$/)
 {
  return ("error",102,"Some characters are not allowed, please try again.");
 }

=cut

unless ($msg =~ /^[\!\-A-Za-z0-9äöüÄÖÜ\s]*$/)
 {
  return ("error",102,"Some characters are not allowed, please try again.");
 }

  # Do something
  $msg .= " (reply)";

=head2

Now we create an answer on different ways:

Sending an e-mail:

=over 4

send_mail(from,to,subject,body);

send_mail("email\@adress.com","to\@mail.com","subject","body");

=back

Return a message:

=over 4

return ($returnstatus,$jabberstatuscode,$message);

=back

Return status:

=over 2

=item * 0 = normal message response

=item * error = error message stanza

=item * presence = error as presence stanza

=item * ignore= ignore message

=back

=cut

  #return (0,0,"hi");
  #send_mail("email\@adress.com","to\@mail.com","subject","body");
  return (0,0,$msg);

 }

1;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2012 Marco Balmer <marco@balmer.name>

The Debian packaging is licensed under the 
GPL, see `/usr/share/common-licenses/GPL-3'.

=cut
