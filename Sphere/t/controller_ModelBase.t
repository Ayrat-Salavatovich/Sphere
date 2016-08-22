use strict;
use warnings;
use Test::More;


use Catalyst::Test 'Sphere';
use Sphere::Controller::ModelBase;

ok( request('/modelbase')->is_success, 'Request should succeed' );
done_testing();
