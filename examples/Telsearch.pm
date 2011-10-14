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

# This perl modules was not taken into debian packaging. Please install
# modules manually if they does not work.
use LWP::Simple;
use LWP::UserAgent;
use URI::URL;

use vars qw(@EXPORT @ISA);
use Exporter;

@ISA               = qw(Exporter);
@EXPORT            = qw(run_query $ident $service_name $bot_admin $hostname
  $port $timeout $user $password);

our $stanza_penalty_calc_default = 60;

our $hostname		= "";
our $user		= "";
our $password		= "";
our $ident		= "telsearchch";
our $bot_admin		= "\@swissjabber.ch";
our $port		= "5222";
our $timeout		= "5";
our $service_name	= "$user\@$hostname";
our $bot_description	= "
Switzerland Phonebook by tel.search.ch
You can search addresses and phonenumbers of peoples living in switzerland.

search examples:
[firstname] [lastname]
[firstname] [lastname] [residence]
muster
hans muster
hans muster bern
";

sub run_query  #################################################################
 {
  my $msg	 	= shift;
  my @parameter		= split(/\s/,$msg);
  my $was		= $parameter[0]." ".$parameter[1];
  my $wo		= $parameter[2];
  my $jid               = shift;
  my $bare_jid          = shift;
  my $digest_jid        = shift;

unless ($msg =~ /^[\-A-Za-z0-9äöüÄÖÜ\s]*$/)
 {
  return ("error",406,"Some characters are not allowed, please try again.");
 }

my $url = url("http://tel.search.ch/api");
if($wo)
 { $url->query_form(was=>$was,wo=>$wo); }
else
 { $url->query_form(was=>$was); }

#
# Prepare request
#
my $ua = LWP::UserAgent->new;
$ua->timeout(5);
$ua->agent($ident);
my $request = HTTP::Request->new('GET', $url);
my $response = $ua->request($request);

#
# Exepction handling
#
unless ($response->is_success) {
   print "Internal problem: ".$response->status_line;
   return ("error",500,
   "This service is temporary not available. Try again later or contact 
your admin $bot_admin");
   }

my $url_response = $response->content;
print "<debug>\n$url_response\n</debug>";
my $tel_result		= XML::Smart->new($url_response);
my $total_results 	= $tel_result->{"feed"}{"openSearch:totalResults"};
my ($output,$entry,$details);

$output .= "\nSearching for $was in $wo...\n";

for (my $i=0;$i<=3;$i++)
 {
  $entry 	 = $tel_result->{"feed"}[0]{"entry"}[$i]{"content"};
  $details 	 = $tel_result->{"feed"}[0]{"entry"}[$i]{"link"}('[@]','href');
  unless($entry)
   { last; }
  $output 	.= "\n$entry\n$details\n";
 } ### for (my $i=0;$i<=5;$i++)
 
 unless ($total_results == 1)
  { $output .= "\nTotal $total_results results "; }

 if ($total_results > 4 )
  { $output .= "\nMore results: http://tel.search.ch/result.html?search=Suchen&was=$msg&maxnum=20#pos5"; }

 $output .="\nPowered by http://tel.search.ch";

  return (0,0,$output);
 }

1;
