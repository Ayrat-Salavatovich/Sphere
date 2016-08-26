use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Directory::Roles;

ok( request('/directory/roles')->is_success, 'Request should succeed' );
done_testing();
