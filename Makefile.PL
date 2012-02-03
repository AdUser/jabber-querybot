use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
 NAME             => 'JabberQuerybot',
 VERSION_FROM     => 'lib/JabberQuerybot.pm', # finds $VERSION
 PREREQ_PM        => {
			Net::Jabber,
			Net::XMPP,
			Digest::MD5,
			Time::HiRes,
			Sys::Syslog,
			Sys::CpuLoad,
			XML::Smart,
			Encode }, # e.g., Module::Name => 1.1
 ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
  (ABSTRACT_FROM  => 'lib/JabberQuerybot.pm', # retrieve abstract from module
   AUTHOR         => 'Marco balmer <marco@balmer.name>') : ()),
 MAN1PODS         => {
  'jabber-querybot'    => 'blib/man1/jabber-querybot.1p',
  'examples/Telsearch.pm'    => 'blib/man1/Telsearch.1p',
  'examples/querytest.pl'    => 'blib/man1/Querytest.1p',
  'examples/Toppreise.pm'    => 'blib/man1/Toppreise.1p',
  'examples/Woerterbuch.pm'    => 'blib/man1/Woerterbuch.1p',
  'examples/Eliza.pm'    => 'blib/man1/Eliza.1p' }
);

