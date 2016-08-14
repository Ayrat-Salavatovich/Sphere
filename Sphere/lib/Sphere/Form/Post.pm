package Sphere::Form::Post;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'post_name' => ( type => 'Text', required => 1, );
has_field 'post_status' => ( type => 'PosInteger', required => 1, );
has_field 'post_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
