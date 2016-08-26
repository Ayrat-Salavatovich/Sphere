use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Directory::Statuses;

ok( request('/directory/statuses')->is_success, 'Request should succeed' );
done_testing();
