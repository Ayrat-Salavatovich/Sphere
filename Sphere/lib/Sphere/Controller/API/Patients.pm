package Sphere::Controller::API::Patients;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::API'; }

__PACKAGE__->config(
    result => 'SphereAppDB::Patient',
);
with 'Sphere::Controller::API::AutoBase';

=head1 NAME

Sphere::Controller::API::Patients - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('../api') : PathPart('patients') : CaptureArgs(0) { }

sub patients : Chained('base') PathPart('') Args(0) ActionClass('REST') {
}

sub patients_GET {
    my ( $self, $c ) = @_;

    my $patients = $c->stash->{collection}->search;
    my %data;
    $data{patients} = [
	map {
	    my $row = $_;
	    +{
		(
		 map { $_ => $row->{$_} } qw/pk account_fk first_name middle_name card/
		),
	    }
	} $c->stash->{collection}->as_hashref->all
    ];
    $data{count} = $patients->count;
    $self->status_ok(
	$c,
	entity => \%data,
    );
    $c->forward( $c->view('JSON') );
}

=encoding utf8

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

1;
