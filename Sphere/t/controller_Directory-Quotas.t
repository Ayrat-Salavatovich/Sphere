use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Quotas;

ok( request('/quotas')->is_success, 'Request should succeed' );
done_testing();
