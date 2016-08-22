package Sphere::Controller::ModelBase;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Sphere::Controller::ModelBase - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $model = $c->model( $self->{model_name} );
	my $entry = $model->find({ pk => int($id), key => 'primary' });
	if (not defined $entry) { # Could not find a entry with ID.
	    $c->stash->{error_msg} = "Entry not found.";
	    $c->detach('/not_found', []);
	} else {
	    $c->stash(entry => $entry);
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;

    my $model = $c->model( $self->{model_name} );
    my $condition = $self->{model_search_condition} || {};
    my $attrs = $self->{model_search_attrs} || {};
    my $entries = $model->search($condition, $attrs);
    $c->stash(entries => $entries);
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
