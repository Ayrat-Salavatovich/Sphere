package Sphere::Form::Directory::Role;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'role_name' => ( type => 'Text', required => 1, );
has_field 'role_status' => ( type => 'PosInteger', required => 1, );
has_field 'role_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
