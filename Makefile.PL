use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
 NAME             => 'JabberQuerybot',
 VERSION_FROM     => 'lib/JabberQuerybot.pm', # finds $VERSION
 PREREQ_PM        => {
			Net::Jabber }, # e.g., Module::Name => 1.1
 ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
  (ABSTRACT_FROM  => 'lib/JabberQuerybot.pm', # retrieve abstract from module
   AUTHOR         => 'Marco balmer <marco@balmer.name>') : ()),
 MAN1PODS         => {
  'jabber-querybot'    => 'blib/man1/jabber-querybot.1',
  'examples/Telsearch.pm'    => 'blib/man3/Telsearch.3pm',
  'examples/querytest.pl'    => 'blib/man3/Querytest.3pl',
  'examples/Toppreise.pm'    => 'blib/man3/Toppreise.3pm',
  'examples/Woerterbuch.pm'    => 'blib/man3/Woerterbuch.3pm',
  'examples/Eliza.pm'    => 'blib/man3/Eliza.3pm' }
);
