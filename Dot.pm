package Acme::Dot;

use 5.006;
use strict;
use warnings;

our $VERSION = '1.0';

my ($call_pack, $call_pack2);

sub import { 
    no strict 'refs';
    $call_pack = (caller())[0];
    *{$call_pack."::import"} = sub { $call_pack2 = (caller())[0]; };
    eval <<EOT
 package $call_pack;
use overload "." => sub { 
    my (\$obj, \$stuff) = \@_;
    \@_ = (\$obj, \@{\$stuff->{data}});
    goto \&{\$obj->can(\$stuff->{name})};
}, fallback => 1;

EOT
    ;
}

CHECK {
   # At this point, everything is ready, and $call_pack2 contains
   # the calling package's calling package.
   no strict;
   if ($call_pack2) {
   eval "
   package $call_pack2;
   *AUTOLOAD = sub { 
        \$AUTOLOAD =~ /.*::(.*)/;
        return if \$1 eq \"DESTROY\";
        return { data => \\\@_, name => \$1 }
   }
   ";
   }
}

1;
__END__
# Below is stub documentation for your module. You'd better edit it!

=head1 NAME

Acme::Dot - Call methods with the dot operator

=head1 SYNOPSIS

  package Foo;
  use Acme::Dot;
  sub new { bless {}, shift }
  sub hello { print "Hi there! (@_)\n" }

  package main;
  my $x = new Foo;
  $x.hello(1,2,3); # Calls the method

  $y = "Hello";
  sub world { return " World!"}
  print $y.world(); # Behaves as normal

=head1 DESCRIPTION

This module, when imported into a class, allows objects of that class to
have methods called using the dot operator as in Ruby, Python and other
OO languages.

However, since it doesn't use source filters or any other high magic,
it only affects the class it was imported into; objects of other classes
and ordinary scalars can use concatenation as normal.

=head1 BUGS

Occasionally has problems distinguishing between methods and
subroutines. But then, don't we all? This will be fixed in the next
release.

=head1 AUTHOR

Simon Cozens, C<simon@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright 2003 by Simon Cozens

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
