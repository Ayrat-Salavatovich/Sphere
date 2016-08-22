use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::API::Accounts;

ok( request('/api/accounts')->is_success, 'Request should succeed' );
done_testing();
