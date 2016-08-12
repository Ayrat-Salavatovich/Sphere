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

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $status = $c->stash->{statuses}->find({ pk => int($id), key => 'primary' });
	if (not defined $status) { # Could not find a status with ID.
	    $c->detach('/not_found', []);
	} else {
	    $c->stash->{status} = $status;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;
    
    my $statuses = $c->stash->{statuses}->search(
	{},
	{
	    columns  => [qw/pk name description/],
	    order_by => 'name',
	}
    );
    $c->stash(statuses => $statuses);
}

Sphere->register_profile(
    method  => 'add',
    profile => {
	status_name => {
	    required => 1,
	    allow    => qr/^\w+$/,
	},
	status_description => {
	    required => 0,
	},
    },
);

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if(lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	if (not $c->check_params) {
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

    my $status = $c->stash->{status};
    $status->delete;
    $c->res->redirect( $c->req->referer() );
}

Sphere->register_profile(
    method  => 'edit',
    profile => {
	status_name => {
	    required => 1,
	    allow    => qr/^\w+$/,
	},
	status_description => {
	    required => 0,
	},
    },
);

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $status = $c->stash->{status};
	
	if (not $c->check_params) {
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
    if ($c->stash->{status}) {
	# Update the status
	$c->stash->{status}->update({
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
    
    if ($c->stash->{status}) {
	$c->stash( template => 'statuses/edit.tt' );
    } else {
	$c->stash( template => 'statuses/add.tt' );
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
