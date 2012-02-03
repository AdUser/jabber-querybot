#!/usr/bin/perl
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

use strict;

=head1 NAME

querytest.pl - Test framework without jabber connection

=cut

use Querymodule;

my $cmd = $ARGV[0];

my $ret = run_query($cmd);

print "\nquerybot dev script\n";
print "\nResponse:\n$ret\n";

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2009-2012 Marco Balmer <marco@balmer.name>

The Debian packaging is licensed under the 
GPL, see `/usr/share/common-licenses/GPL-3'.

=cut
