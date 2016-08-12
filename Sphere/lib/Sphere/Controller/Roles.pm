package Sphere::Controller::Roles;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Sphere::Controller::Roles - Catalyst Controller

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

sub base : Chained('/') PathPart('roles') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash(roles => $c->model('SphereAppDB::Role'));
    $c->stash(statuses => $c->model('SphereAppDB::Status'));
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $role = $c->stash->{roles}->find({ pk => int($id), key => 'primary' });
	if (not defined $role) { # Could not find a status with ID.
	    $c->detach('/not_found', []);
	} else {
	    $c->stash->{role} = $role;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;    
}

Sphere->register_profile(
    method  => 'add',
    profile => {
	role_name => {
	    required => 1,
	    allow    => qr/^\w+$/,
	},
	role_status => {
	    required => 1,
	    allow    => qr/^\d+$/,
	},
	role_description => {
	    required => 0,
	},
    },
);

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if(lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	if (not $c->check_params) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} elsif ($c->stash->{roles}->count_literal("name LIKE ?", $params->{role_name}."%") > 0) {
	    $c->stash->{error_msg} = "Role already exists.";
	} else {
	    my $status = $c->stash->{statuses}->find({ pk => int($params->{role_status}) });
	    if ($status) { 
		# Create the role
		my $new_status = $c->stash->{roles}->create({
		    name => $params->{role_name},
		    status => $status,
		    description => $params->{role_description} || '',
		});
		$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
	    } else {
		$c->stash->{error_msg} = "Status does not exist.";
	    }
	}
    }
}

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $role = $c->stash->{role};
    $role->delete;
    $c->res->redirect( $c->req->referer() );
}

Sphere->register_profile(
    method  => 'edit',
    profile => {
	role_name => {
	    required => 1,
	    allow    => qr/^\w+$/,
	},
	role_status => {
	    required => 1,
	    allow    => qr/^\d+$/,
	},
	role_description => {
	    required => 0,
	},
    },
);

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	if (not $c->check_params) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} else {
	    my $params = $c->req->params;
	    my $role = $c->stash->{role};
    
	    my $status = $c->stash->{statuses}->find({ pk => int($params->{role_status}) });
	    if ($status) { 
		# Update role's name and/or description
		$role->update({
		    name => $params->{role_name},
		    description => $params->{role_description},
                });
		$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
	    } else {
		$c->stash->{error_msg} = "Status does not exist.";
	    }
	}
    }
}

sub view : Chained('object') PathPart('view') Args(0) {
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
