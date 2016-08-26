package Sphere::Controller::API::Statuses;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::API'; }

__PACKAGE__->config(
    result => 'SphereAppDB::Status',
);
with 'Sphere::Controller::API::AutoBase';

=head1 NAME

Sphere::Controller::API::Statuses - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('../api') : PathPart('statuses') : CaptureArgs(0) { }

sub statuses : Chained('base') PathPart('') Args(0) ActionClass('REST') {
}

sub statuses_GET {
    my ( $self, $c ) = @_;

    my $statuses = $c->stash->{collection}->search;
    my %data;
    $data{statuses} = [
	map {
	    my $row = $_;
	    +{
		(
		 map { $_ => $row->{$_} } qw/pk name/
		),
	    }
	} $c->stash->{collection}->as_hashref->all
    ];
    $data{count} = $statuses->count;
    $self->status_ok(
	$c,
	entity => \%data,
    );
    $c->forward( $c->view('JSON') );
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
