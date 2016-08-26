package Sphere::Controller::Directory;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::Directory::ModelBase'; }

sub directory : Chained PathPrefix CaptureArgs(0) {
}

__PACKAGE__->meta->make_immutable;

1;
