package Sphere::Form::Directory::Status;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'status_name' => ( type => 'Text', required => 1, );
has_field 'status_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
