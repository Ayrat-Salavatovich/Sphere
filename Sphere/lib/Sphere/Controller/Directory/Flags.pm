package Sphere::Controller::Directory::Flags;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::Directory'; }

__PACKAGE__->config(model_name => 'SphereAppDB::Flag',
		    model_search_attrs => {
			columns  => [qw/pk name description status_fk/],
		        order_by => 'name',
		    },
);

use Sphere::Form::Directory::Flag;

=head1 NAME

Sphere::Controller::Directory::Flags - Catalyst Controller

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

sub base : Chained('../directory') PathPart('flags') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( flags    => $c->model('SphereAppDB::Flag') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Directory::Flag->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} elsif ($c->stash->{flags}->count_literal("name LIKE ?", $params->{flag_name}."%") > 0) {
	    $c->stash->{error_msg} = "Flag already exists.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $flag = $c->stash->{flag};
    $flag->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Directory::Flag->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
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
    my $status = $c->stash->{statuses}->find({ pk => int($params->{flag_status}) });
    if ($status) {
	if ($c->stash->{flag}) {
	    # Update the flag
	    $c->stash->{flag}->update({
		name => $params->{flag_name},
		description => $params->{flag_description},
		status => $status,
	    });
	} else {
	    # Create the flag
	    $c->stash->{flags}->create({
		name => $params->{flag_name},
		description => $params->{flag_description} || '',
		status => $status,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Status does not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{flag}) {
	$c->stash( template => 'directory/flags/edit.tt' );
    } else {
	$c->stash( template => 'directory/flags/add.tt' );
    }
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
