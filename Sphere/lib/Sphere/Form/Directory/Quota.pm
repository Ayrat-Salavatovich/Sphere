package Sphere::Form::Directory::Quota;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'quota_limit' => ( type => 'PosInteger', required => 1, );
has_field 'quota_doctor' => ( type => 'PosInteger', required => 1, );
has_field 'quota_year' => ( type => 'PosInteger', required => 1, );
has_field 'quota_month' => ( type => 'PosInteger', required => 1, );
has_field 'quota_day' => ( type => 'Text', required => 1, );
has_field 'quota_status' => ( type => 'PosInteger', required => 1, );
has_field 'quota_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
