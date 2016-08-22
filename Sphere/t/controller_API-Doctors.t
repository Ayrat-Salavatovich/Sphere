use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::API::Doctors;

ok( request('/api/doctors')->is_success, 'Request should succeed' );
done_testing();
