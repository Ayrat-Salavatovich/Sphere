use strict;
use warnings;

use Sphere;

my $app = Sphere->apply_default_middlewares(Sphere->psgi_app);
$app;

