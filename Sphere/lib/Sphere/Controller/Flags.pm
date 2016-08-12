package Sphere::Controller::Flags;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

=head1 NAME

Sphere::Controller::Flags - Catalyst Controller

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

sub base : Chained('/') PathPart('flags') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( flags => $c->model('SphereAppDB::Flag') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $flag = $c->stash->{flags}->find({ pk => int($id), key => 'primary' });
	if (not defined $flag) { # Could not find a flag with ID.
	    $c->detach('/not_found', []);
	} else {
	    $c->stash->{flag} = $flag;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;    
        my $flags = $c->stash->{flags}->search(
	{},
	{
	    columns  => [qw/pk name description status_fk/],
	    order_by => 'name',
	}
    );
    $c->stash(flags => $flags);
}

Sphere->register_profile(
    method  => 'add',
    profile => {
	flag_name => {
	    required => 1,
	    allow    => qr/^\w+$/,
	},
	flag_status => {
	    required => 1,
	    allow    => qr/^\d+$/,
	},
	flag_description => {
	    required => 0,
	},
    },
);

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	if (not $c->check_params) {
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

Sphere->register_profile(
    method  => 'edit',
    profile => {
	flag_name => {
	    required => 1,
	    allow    => qr/^\w+$/,
	},
	flag_status => {
	    required => 1,
	    allow    => qr/^\d+$/,
	},
	flag_description => {
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
	$c->stash->{error_msg} = "Status does not exist.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{flag}) {
	$c->stash( template => 'flags/edit.tt' );
    } else {
	$c->stash( template => 'flags/add.tt' );
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
