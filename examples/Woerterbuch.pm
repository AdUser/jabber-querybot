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

# This example works *and* need access rights from woerterbuch.info
# administrators. Access to this API is restricted.

our $hostname		= "jabberserver.tld";
our $user		= "";
our $password		= "";
our $ident		= "woerterbuchinfo";
our $bot_admin		= "\@swissjabber.ch";
our $port		= "5222";
our $timeout		= "5";
our $service_name	= "$user\@$hostname";
our $bot_description		 = "
woerterbuch.info - Deutsch-Englisch Übersetzung mit Synonym Suche
Synonym-Suche zu Wörtern und Ausdrücken sowie Deutsch-Englisch-Deutsch
Abfragen von Englisch/Deutsch Übersetzungen.

Search examples:
wort
explain
-syn wort
-syn explain

This service is also available via
the following instant messaging systems:

jabber: woerterbuch.info\@swissjabber.org
";

sub run_query  #################################################################
 {
  my $msg	 	= shift;
  my $jid               = shift;
  my $bare_jid          = shift;
  my $digest_jid        = shift;
  my $query_s		= "dict";

unless ($msg =~ /^[\*\-A-Za-z0-9äöüÄÖÜ\s]*$/)
 {
  return ("error",406,"Some characters are not allowed, please try again.");
 }

my $url = url("http://xml.woerterbuch.info");

#
# Definition of the query to HTTP or an XML Interface
# $msg is the message which received from the bot.
#
if($msg =~ /-syn/)
 {
  $msg 		=~ s/-syn//g;
  $query_s	= "thesaurus";
 }

my $digest_im_type;

if($bare_jid =~ /msn/) 		{ $digest_im_type = "msn_"; }
elsif($bare_jid =~ /icq/) 	{ $digest_im_type = "icq_"; }
elsif($bare_jid =~ /aim/) 	{ $digest_im_type = "aim_"; }
elsif($bare_jid =~ /yahoo/) 	{ $digest_im_type = "yahoo_"; }
else
{ $digest_im_type .="jabber_"; }

my $digest_jid_and_type = $digest_im_type . $digest_jid;

  $url->query_form(	query=>$msg, 
  			s=>$query_s, 
			source=>"swissjabber", 
			id=>$digest_jid_and_type);



my $ua = LWP::UserAgent->new;
$ua->timeout(5);
$ua->agent($ident);
my $request = HTTP::Request->new('GET', $url);
my $response = $ua->request($request);
my $url_response = $response->content;

$url_response =~  s/^\n//;

$response = $ua->request($request);

unless ($response->is_success) 
 {
  return ("error",500,"xml not well-formed (invalid token), please contact xmpp/jabber: $bot_admin\n\n".$response->status_line);
 }

# Analyze the response with the XML::Smart perl-module.
my ($xml_result,@xml_result_dict_de,@xml_result_dict_en,@xml_result_thesaurus_de,@xml_result_thesaurus_en,$selected_lang,$xml_ads_title,$xml_ads_description,$xml_ads_url,$xml_more,$xml_querylimit);

eval 
 {
  $xml_result		=       XML::Smart->new($url_response);
  # ADS
  $xml_ads_title		=       $xml_result->{"woerterbuch"}{"ads"}{"title0"};
  $xml_ads_description		=       $xml_result->{"woerterbuch"}{"ads"}{"description0"};
  $xml_ads_url			=       $xml_result->{"woerterbuch"}{"ads"}{"tracking_url0"};
  $xml_more			=       $xml_result->{"woerterbuch"}{"more"};
  $xml_querylimit		=       $xml_result->{"woerterbuch"}{"querylimit"};
 };

if($@)
 {
  querybot_log("info","run_query($digest_jid): xml not well-formed (invalid token) string: `$msg`");
  return ("error",500,"xml not well-formed (invalid token), please contact xmpp/jabber: $bot_admin");
 }

  # Did you mean
  my $result_woerterbuch= "";

  my $xml_did_u_mean 		=       $xml_result->{"woerterbuch"}{"did_u_mean"}{"value"};
  if($xml_did_u_mean eq "true")
   {
    my $xml_did_u_mean_message	=       $xml_result->{"woerterbuch"}{"did_u_mean"}{"message"};
    $result_woerterbuch .= $xml_did_u_mean_message."\n\n";
   }
  # END Did you mean

  # Querylimit???
  if ($xml_querylimit)
   {
    return ("error",402,$xml_querylimit);
   }


  # Check if it is enlish or german
    my ($check_lang_deen_de,$check_lang_deen_en,$check_lang_ende_de,$check_lang_ende_en);
    
    # dict or thesaurus?
    if($query_s eq "dict")
     {
       $check_lang_deen_de	= $xml_result->{"woerterbuch"}{"de_en"}{"de"}{"result0"};
       $check_lang_deen_en	= $xml_result->{"woerterbuch"}{"de_en"}{"en"}{"result0"};
       $check_lang_ende_de	= $xml_result->{"woerterbuch"}{"en_de"}{"de"}{"result0"};
       $check_lang_ende_en	= $xml_result->{"woerterbuch"}{"en_de"}{"en"}{"result0"};
     }
    else
     {
       $check_lang_deen_de = $xml_result->{"woerterbuch"}{"thesaurus_de"}{"result0"}{"record0"};
     }

    if($check_lang_deen_de)
     {
      if($query_s eq "dict") 
       { 
        $selected_lang="de_en"; 
       }
      else
       {
        $selected_lang="de"; 
       }
     }
    else
     {
      if ($query_s eq "dict")
       {
       $selected_lang="en_de";
       }
      else
       {
       $selected_lang="en";
       }
     }


  # Read translations
 
 my $result_counter = 0;
 for (my $resultset=0;$resultset<=9;$resultset++)
  {
  for (my $record=0;$record<=9;$record++)
   {
    $result_counter++;
    if ($query_s eq "dict")
     {
      if ( $result_counter < 10)
       {
        $xml_result_dict_de[$result_counter]	= $xml_result->{"woerterbuch"}{"$selected_lang"}{"de"}{"result$record"};
        $xml_result_dict_en[$result_counter]	= $xml_result->{"woerterbuch"}{"$selected_lang"}{"en"}{"result$record"};
       }
     }
    if ($query_s eq "thesaurus")
     {
      $xml_result_thesaurus_de[$result_counter]	= $xml_result->{"woerterbuch"}{"thesaurus_de"}{"result$resultset"}{"record$record"};
      $xml_result_thesaurus_en[$result_counter]	= $xml_result->{"woerterbuch"}{"thesaurus_en"}{"result$resultset"}{"record$record"};
     } ### END of if ($query_s eq "thesaurus")
   } ### END of for for (my $record=0;$record<=9;$record++)
  } ### END of for (my $resultset=0;$resultset<=9;$restultset++)


  if ($query_s eq "dict")
   {
    $result_woerterbuch .= generate_dict_results(	$selected_lang,
    							$check_lang_deen_de,
    							$check_lang_deen_en,
    							$check_lang_ende_de,
    							$check_lang_ende_en,
    							\@xml_result_dict_en,
							\@xml_result_dict_de);
   }

  if ($query_s eq "thesaurus")
   {
    $result_woerterbuch .= generate_thesaurus_results(	$selected_lang,
    							\@xml_result_thesaurus_en,
							\@xml_result_thesaurus_de);
   }

$result_woerterbuch .= $xml_more;
$result_woerterbuch .= "\n\n$xml_ads_title\n$xml_ads_description\n$xml_ads_url";

  # Return result message an the time for processing
  
  return (0,0,$result_woerterbuch);

 }

sub generate_dict_results
 {
  my $lang		= shift;
  my $check_lang_deen_de= shift;
  my $check_lang_deen_en= shift;
  my $check_lang_ende_de= shift;
  my $check_lang_ende_en= shift;
  my $array_de		= shift;
  my $array_en		= shift;

  my @xml_result_en = @{$array_de};
  my @xml_result_de = @{$array_en};

  my $result;

  # GENERATE OUTPUT
# German output

if($check_lang_deen_de)
{
if($xml_result_de[1])
{
 $result = "Deutsch ---> Englisch:\n";
 for (my $i=0;$i<=100;$i++)
 {
  if($xml_result_de[$i])
   {
    $result .= $xml_result_de[$i]." --> ".$xml_result_en[$i]."\n"; 
   } ### END of f($xml_result_de[$i])
 } ### END of for (my $i=0;$i<=9;$i++)
} ### END of if($xml_result_de[1])
} ### END of if($check_lang_deen_de[1] or $check_lang_ende_de)


$result .= "\n";

# English output
  
if($check_lang_ende_en)
{
if($xml_result_en[1])
{
 $result .= "Englisch ---> Deutsch:\n";
 for (my $i=0;$i<=100;$i++)
 {
  if($xml_result_en[$i])
   {
    $result .= $xml_result_en[$i]." --> ".$xml_result_de[$i]."\n"; 
   } ### END of f($xml_result_de[$i])
 } ### END of for (my $i=0;$i<=9;$i++)
} ### END of if($xml_result_de[1])
} ### END of if($check_lang_deen_de[1] or $check_lang_ende_de[1])

# Return results

return (0,$result);
} ### END of generate_dict_results()

sub generate_thesaurus_results
 {
  my $lang		= shift;
  my $array_de		= shift;
  my $array_en		= shift;

  my @xml_result_en = @{$array_de};
  my @xml_result_de = @{$array_en};
  my $result;

# GENERATE OUTPUT
# German output

if($xml_result_de[1])
{
$result = "Synonyme in Deutsch:\n";
for (my $i=0;$i<=5;$i++)
 {
  if($xml_result_de[$i])
    {
      $result .= $xml_result_de[$i]."\n"; 
    } ### END of if($xml_result_dict_de[$i])
 } ### END of for (my $i=0;$i<=9;$i++)
} ### END of if(@xml_result_de))  


$result .= "\n";

# English output

if($xml_result_en[1])
{
$result .= "Synonyme in Englisch:\n";
for (my $i=0;$i<=5;$i++)
 {
  if($xml_result_en[$i])
    {
      $result .= $xml_result_en[$i]."\n"; 
    } ### END of if($xml_result_dict_en[$i])
 } ### END of for (my $i=0;$i<=9;$i++)
} ### END of (@xml_result_en)

# Return results

return (0,$result);

 }

1;
