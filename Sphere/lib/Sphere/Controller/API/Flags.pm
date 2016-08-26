package Sphere::Controller::API::Flags;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::API'; }

__PACKAGE__->config(
    result => 'SphereAppDB::Flag',
);
with 'Sphere::Controller::API::AutoBase';

=head1 NAME

Sphere::Controller::API::Flags - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub base : Chained('../api') : PathPart('flags') : CaptureArgs(0) { }

sub flags : Chained('base') PathPart('') Args(0) ActionClass('REST') {
}

sub flags_GET {
    my ( $self, $c ) = @_;

    my $flags = $c->stash->{collection}->search;
    my %data;
    $data{flags} = [
	map {
	    my $row = $_;
	    +{
		(
		 map { $_ => $row->{$_} } qw/pk name/
		),
	    }
	} $c->stash->{collection}->as_hashref->all
    ];
    $data{count} = $flags->count;
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
