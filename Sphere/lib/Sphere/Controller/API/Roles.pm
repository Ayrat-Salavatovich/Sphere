package Sphere::Controller::API::Roles;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::API'; }

__PACKAGE__->config(
    result => 'SphereAppDB::Role',
);
with 'Sphere::Controller::API::AutoBase';

=head1 NAME

Sphere::Controller::API::Roles - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('../api') : PathPart('roles') : CaptureArgs(0) { }

sub roles : Chained('base') PathPart('') Args(0) ActionClass('REST') {
}

sub roles_GET {
    my ( $self, $c ) = @_;

    my $roles = $c->stash->{collection}->search;
    my %data;
    $data{roles} = [
	map {
	    my $row = $_;
	    +{
		(
		 map { $_ => $row->{$_} } qw/pk name/
		),
	    }
	} $c->stash->{collection}->as_hashref->all
    ];
    $data{count} = $roles->count;
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
