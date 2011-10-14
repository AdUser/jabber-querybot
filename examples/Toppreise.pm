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

use LWP::Simple;
use LWP::UserAgent;
use URI::URL;

use vars qw(@EXPORT @ISA);
use Exporter;

@ISA               = qw(Exporter);
@EXPORT            = qw(run_query $ident $service_name $bot_admin $hostname
  $port $timeout $user $password);

our $stanza_penalty_calc_default = 60;

# This example works *and* need access rights from toppreise.ch administrators.
# Access to this API is restricted.

our $hostname		= "jabberserver.tld";
our $user		= "";
our $password		= "";
our $ident		= "Toppreise";
our $bot_admin		= "\@swissjabber.ch";
our $port		= "5222";
our $timeout		= "5";
our $service_name	= "$user\@$hostname";
our $bot_description		 = "Toppreise.ch - Preisvergleich
Realtime Preisvergleich. Dieser Bot ist direkt mit der Toppreise.ch Datenbank verbunden.

Search examples:
Canon Digitalkamera

This service is also available via
the following instant messaging systems:
";

sub run_query  #################################################################
{
my $msg	 	= shift;
my $jid               = shift;
my $bare_jid          = shift;
my $digest_jid        = shift;

unless ($msg =~ /^[\-A-Za-z0-9äöüÄÖÜ\.\?\s]*$/) {
  return ("error",401,"Some characters are not allowed, please try again.");
}

my $url = url("http://www.toppreise.ch/im/imQuery.php/");
$url->query_form(client => $digest_jid,  search=>$msg);
my $ua = LWP::UserAgent->new;
$ua->timeout(5);
$ua->agent($ident);
my $request = HTTP::Request->new('GET', $url);
my $response = $ua->request($request);
my $url_response = $response->content;

# Return result message an the time for processing
return (0,0,$url_response);

}

1;
