use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Session;

ok( request('/session')->is_success, 'Request should succeed' );
done_testing();
