use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Flags;

ok( request('/flags')->is_success, 'Request should succeed' );
done_testing();
