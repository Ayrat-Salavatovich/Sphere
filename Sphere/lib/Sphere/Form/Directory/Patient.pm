package Sphere::Form::Directory::Patient;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'patient_account' => ( type => 'PosInteger', required => 1, );
has_field 'patient_first_name' => ( type => 'Text', required => 1, );
has_field 'patient_middle_name' => ( type => 'Text', required => 1, );
has_field 'patient_last_name' => ( type => 'Text', required => 0, );
has_field 'patient_card' => ( type => 'Text', required => 1, );
has_field 'patient_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
