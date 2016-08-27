package Sphere::Form::Directory::Schedule;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'schedule_hour' => ( type => 'PosInteger', required => 1, );
has_field 'schedule_minute' => ( type => 'PosInteger', required => 1, );
has_field 'schedule_patient' => ( type => 'PosInteger', required => 0, );
has_field 'schedule_flag' => ( type => 'PosInteger', required => 1, );
has_field 'schedule_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
