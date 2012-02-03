use 5.010001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'JabberQuerybot',
    VERSION_FROM      => 'lib/JabberQuerybot.pm', # finds $VERSION
    PREREQ_PM         => {
				Net::Jabber
			}, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT_FROM  => 'lib/JabberQuerybot.pm', # retrieve abstract from module
       AUTHOR         => 'Marco balmer <marco@balmer.name>') : ()),
);
