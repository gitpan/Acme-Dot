use 5.006;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'Acme::Dot',
    'VERSION_FROM'	=> 'lib/Acme/Dot.pm', # finds $VERSION
    'PREREQ_PM'		=> {}, # e.g., Module::Name => 1.1
    ($] >= 5.005 
        ? 
            (AUTHOR     => 'Curtis "Ovid" Poe <1napc-pmetsuilbup@yahoo.com>') 
        : ()
    ),
);

# reverse the name to email me
