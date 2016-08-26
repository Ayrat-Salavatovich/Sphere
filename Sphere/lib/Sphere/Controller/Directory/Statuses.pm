package Sphere::Controller::Directory::Statuses;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::Directory'; }

__PACKAGE__->config(model_name => 'SphereAppDB::Status',
		    model_search_attrs => {
			columns  => [qw/pk name description/],
		        order_by => 'name',
		    },
);

use Sphere::Form::Status;

=head1 NAME

Sphere::Controller::Directory::Statuses - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut
sub base : Chained('../directory') PathPart('statuses') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Status->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "No name.";
	} elsif ($c->stash->{statuses}->count_literal("name LIKE ?", $params->{status_name}."%") > 0) {
	    $c->stash->{error_msg} = "Status already exists.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $status = $c->stash->{entry};
    $status->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $status = $c->stash->{status};
	my $form = Sphere::Form::Status->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "No name.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub view : Chained('object') PathPart('view') Args(0) {
    my ( $self, $c ) = @_;
}

sub save : Private {
    my ($self, $c) = @_;
    
    my $params = $c->req->params;
    if ($c->stash->{entry}) {
	# Update the status
	my $status = $c->stash->{entry};
	$status->update({
	    name => $params->{status_name},
	    description => $params->{status_description},
	});
    } else {
	# Create the status
	$c->stash->{statuses}->create({
	    name => $params->{status_name},
	    description => $params->{status_description} || '',
	});
    }
    $c->response->redirect( $c->uri_for( $self->action_for('list') ) );
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{entry}) {
	$c->stash( template => 'directory/statuses/edit.tt' );
    } else {
	$c->stash( template => 'directory/statuses/add.tt' );
    }
}

sub end : Private {
    my ( $self, $c ) = @_;

    $c->forward($c->view('Web'));
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
