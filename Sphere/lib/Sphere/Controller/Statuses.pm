package Sphere::Controller::Statuses;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Sphere::Controller::Statuses - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
    
sub index : Path Args(0) {
    my ( $self, $c ) = @_;
    $c->detach('list');
}

sub base : Chained('/') PathPart('statuses') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    
    $c->stash(statuses => $c->model('SphereAppDB::Status'));
}

sub status : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found');
    } else {
	my $status = $c->stash->{statuses}->find({ pk => int($id) });
	if (not defined $status) { # Could not find a status with ID.
	    $c->detach('/not_found');
	} else {
	    $c->stash->{status} = $status;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;    
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if(lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	if (not defined $params->{status_name}) {
	    $c->stash->{error_msg} = "No name.";
	} elsif ($c->stash->{statuses}->count_literal("name LIKE ?", $params->{status_name}."%") > 0) {
	    $c->stash->{error_msg} = "Status already exists.";
	} else {
	    # Create the status
	    my $new_status = $c->stash->{statuses}->create({
		name => $params->{status_name},
		description => $params->{status_description} || '',
            });
	    $c->response->redirect( $c->uri_for( $self->action_for('list') ) );
	}
    }
}

sub remove : Chained('status') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $status = $c->stash->{status};
    $status->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('status') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $status = $c->stash->{status};
	
	# Update status's name and/or description
	$status->update({
	    name => $params->{status_name},
	    description => $params->{status_description},
        });
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    }
}

sub show : Chained('status') PathPart('show') Args(0) {
    my ( $self, $c ) = @_;
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
