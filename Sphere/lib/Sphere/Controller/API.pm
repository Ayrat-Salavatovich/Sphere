package Sphere::Controller::API;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller::REST'; }

__PACKAGE__->config( default => 'application/json' );

sub api : Chained PathPrefix CaptureArgs(0) {
}

__PACKAGE__->meta->make_immutable;

1;
