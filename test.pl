use strict;
use warnings;

my $temp = "123";
substr($temp, 0, 1, '');
print $temp;
