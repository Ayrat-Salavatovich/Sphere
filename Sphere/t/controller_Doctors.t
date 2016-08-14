use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Doctors;

ok( request('/doctors')->is_success, 'Request should succeed' );
done_testing();
