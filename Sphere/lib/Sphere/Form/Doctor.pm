package Sphere::Form::Doctor;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'doctor_first_name' => ( type => 'Text', required => 1, );
has_field 'doctor_middle_name' => ( type => 'Text', required => 1, );
has_field 'doctor_last_name' => ( type => 'Text', required => 0, );
has_field 'doctor_post' => ( type => 'PosInteger', required => 1, );
has_field 'doctor_cabinet' => ( type => 'Text', required => 1, );
has_field 'doctor_status' => ( type => 'PosInteger', required => 1, );
has_field 'doctor_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
