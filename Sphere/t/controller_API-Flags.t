use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::API::Flags;

ok( request('/api/flags')->is_success, 'Request should succeed' );
done_testing();
