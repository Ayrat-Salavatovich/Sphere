package Sphere::Controller::API::Doctors;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::API'; }

__PACKAGE__->config(
    result => 'SphereAppDB::Doctor',
);
with 'Sphere::Controller::AutoBase';

=head1 NAME

Sphere::Controller::API::Doctors - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('../api') : PathPart('doctors') : CaptureArgs(0) { }

sub doctors : Chained('base') PathPart('') Args(0) ActionClass('REST') {
}

sub doctors_GET {
    my ( $self, $c ) = @_;

    my $doctors = $c->stash->{collection}->search;
    my %data;
    $data{doctors} = [
	map {
	    my $row = $_;
	    +{
		(
		 map { $_ => $row->{$_} } qw/pk first_name middle_name last_name post_fk cabinet/
		),
	    }
	} $c->stash->{collection}->as_hashref->all
    ];
    $data{count} = $doctors->count;
    $self->status_ok(
	$c,
	entity => \%data,
    );
}

sub end : Private {
    my ( $self, $c ) = @_;

    $c->forward($c->view('JSON'));
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
