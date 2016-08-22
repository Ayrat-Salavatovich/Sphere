use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::API::Patients;

ok( request('/api/patients')->is_success, 'Request should succeed' );
done_testing();
