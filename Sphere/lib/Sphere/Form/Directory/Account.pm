package Sphere::Form::Directory::Account;

use HTML::FormHandler::Moose;
extends 'HTML::FormHandler';

use namespace::autoclean;

has_field 'account_email' => ( type => 'Email', required => 1, );
has_field 'account_name' => ( type => 'Text', required => 1, );
has_field 'account_role' => ( type => 'PosInteger', required => 1, );
has_field 'account_status' => ( type => 'PosInteger', required => 1, );
has_field 'account_description' => ( type => 'Text', required => 0, );

__PACKAGE__->meta->make_immutable;
