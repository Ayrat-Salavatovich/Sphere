use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::API::Statuses;

ok( request('/api/statuses')->is_success, 'Request should succeed' );
done_testing();
