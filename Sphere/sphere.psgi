use strict;
use warnings;

use Plack::Builder;
use Sphere;

builder {
	enable_if { $_[0]->{REMOTE_ADDR} eq '127.0.0.1' } "Plack::Middleware::ReverseProxy";
	my $app = Sphere->apply_default_middlewares(Sphere->psgi_app);
	$app;
};
