#!/usr/bin/perl -w
#
# This file is part of querybot (-a modular perl jabber bot)
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

package Querymodule;

use strict;
#use LWP::Simple;
#use LWP::UserAgent;
#use URI::URL;
use vars qw(@EXPORT @ISA);
use Exporter;

@ISA               = qw(Exporter);
@EXPORT            = qw(run_query $ident $service_name $bot_admin $hostname
  $port $timeout $user $password);

our $hostname		= "swissjabber.ch";
our $user		= "";
our $password		= "";
our $ident		= "Testbot";
our $bot_admin		= "\@swissjabber.ch";
our $port		= "5222";
our $timeout		= "5";
our $service_name	= "$user\@$hostname";
our $bot_description	= "Bot help title
Bot description";

my  $useragent_desc		 = "jabber-querybot - http://github.com/micressor/jabber-querybot";

our $stanza_penalty_calc_default = 60;


sub run_query  #################################################################
 {
  my $msg	 	= shift;
  my $user              = shift;
  my $bare_jid          = shift;
  my $digest_jid        = shift;
  my $xml_result;

unless ($msg =~ /^[\!\-A-Za-z0-9äöüÄÖÜ\s]*$/)
 {
  return ("error",102,"Some characters are not allowed, please try again.");
 }

  $msg .= " (reply)";
  #
  # Return status:
  # error 	= error message stanza
  # presence 	= error as presence stanza
  # ignore	= ignore message
  #
  return (0,0,$msg);

 }

1;
