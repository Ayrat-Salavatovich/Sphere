use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::Directory::Posts;

ok( request('/directory/posts')->is_success, 'Request should succeed' );
done_testing();
