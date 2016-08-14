package Sphere::Form::Flag;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'flag_name' => ( type => 'Text', required => 1, );
has_field 'flag_status' => ( type => 'PosInteger', required => 1, );
has_field 'flag_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
