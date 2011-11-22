#!/usr/bin/perl -w
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


package Log;

use strict;
use Sys::Syslog;
use Exporter;
use vars qw(@EXPORT @ISA);


@ISA               = qw(Exporter);
@EXPORT            = qw(querybot_log);

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
1;
