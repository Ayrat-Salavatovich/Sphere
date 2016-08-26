use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Directory::Accounts;

ok( request('/directory/accounts')->is_success, 'Request should succeed' );
done_testing();
