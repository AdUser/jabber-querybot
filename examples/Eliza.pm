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

jabber-querybot - eliza module

=head1 DESCRIPTION

This perl modules was not taken into debian packaging. Please install 
modules manually if they does not work.

use Chatbot::Eliza;

my $query = new Chatbot::Eliza;

=head1 RESSOURCES

http://packages.qa.debian.org/c/chatbot-eliza.html

=cut


use Chatbot::Eliza;
my $query = new Chatbot::Eliza;

use vars qw(@EXPORT @ISA);
use Exporter;

@ISA               = qw(Exporter);
@EXPORT            = qw(run_query $ident $service_name $bot_admin $hostname
  $port $timeout $user $password);

our $stanza_penalty_calc_default = 60;

our $hostname		= "";
our $user		= "";
our $password		= "";
our $ident		= "elizabot";
our $bot_admin		= "\@swissjabber.ch";
our $port		= "5222";
our $timeout		= "5";
our $service_name	= "$user\@$hostname";
our $bot_description	= "Eliza talking bot
A stupied talking bot";

sub run_query  #################################################################
 {
  my $msg	 	= shift;
  my $jid		= shift;
  my $bare_jid		= shift;
  my $digest_jid	= shift;

unless ($msg =~ /^[\-A-Za-z0-9\?\!\.\,\'\s]*$/)
 {
  return ("error",406,"Some characters are not allowed, please try again.");
 }


my $answer  = $query->transform($msg);



return (0,0,$answer);
 }

1;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2012 Marco Balmer <marco@balmer.name>

The Debian packaging is licensed under the 
GPL, see `/usr/share/common-licenses/GPL-3'.

=cut
