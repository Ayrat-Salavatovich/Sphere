package Sphere::Controller::Posts;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::ModelBase'; }

__PACKAGE__->config(model_name => 'SphereAppDB::Post',
		    model_search_attrs => {
			columns  => [qw/pk name description status_fk/],
		        order_by => 'name',
		    },
);

use Sphere::Form::Post;

=head1 NAME

Sphere::Controller::Posts - Catalyst Controller

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

sub base : Chained('/') PathPart('posts') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( posts    => $c->model('SphereAppDB::Post') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Post->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} elsif ($c->stash->{posts}->count_literal("name LIKE ?", $params->{post_name}."%") > 0) {
	    $c->stash->{error_msg} = "Post already exists.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $post = $c->stash->{entry};
    $post->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Post->new;
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
    my $status = $c->stash->{statuses}->find({ pk => int($params->{post_status}) });
    if ($status) {
	if ($c->stash->{entry}) {
	    # Update the post
	    my $post = $c->stash->{entry};
	    $post->update({
		name => $params->{post_name},
		description => $params->{post_description},
		status => $status,
	    });
	} else {
	    # Create the post
	    $c->stash->{posts}->create({
		name => $params->{post_name},
		description => $params->{post_description} || '',
		status => $status,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Status does not exist.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{entry}) {
	$c->stash( template => 'posts/edit.tt' );
    } else {
	$c->stash( template => 'posts/add.tt' );
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
