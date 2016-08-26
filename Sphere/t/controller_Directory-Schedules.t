use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Schedules;

ok( request('/schedules')->is_success, 'Request should succeed' );
done_testing();
