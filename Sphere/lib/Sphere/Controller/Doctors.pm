package Sphere::Controller::Doctors;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use Sphere::Form::Doctor;

=head1 NAME

Sphere::Controller::Doctors - Catalyst Controller

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

sub base : Chained('/') PathPart('doctors') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( doctors  => $c->model('SphereAppDB::Doctor') );
    $c->stash( posts    => $c->model('SphereAppDB::Post') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $doctor = $c->stash->{doctors}->find({ pk => int($id), key => 'primary' });
	if (not defined $doctor) { # Could not find a doctor with ID.
	    $c->stash->{error_msg} = "Doctor not found.";
	    $c->detach('/not_found', []);
	} else {
	    $c->stash->{doctor} = $doctor;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;
    
    my $doctors = $c->stash->{doctors}->search(
	{},
	{
	    columns  => [qw/pk first_name middle_name last_name post_fk cabinet description status_fk/],
	    order_by => [qw/post_fk middle_name/],
	}
    );
    $c->stash(doctors => $doctors);
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Doctor->new;
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

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $doctor = $c->stash->{doctor};
    $doctor->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Doctor->new;
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
    my $post = $c->stash->{posts}->find({ pk => int($params->{doctor_post}) });
    my $status = $c->stash->{statuses}->find({ pk => int($params->{doctor_status}) });
    if ($post and $status) {
	if ($c->stash->{doctor}) {
	    # Update the doctor
	    $c->stash->{doctor}->update({
		first_name => $params->{doctor_first_name},
		middle_name => $params->{doctor_middle_name},		
		last_name => $params->{doctor_last_name},
		post => $post,
		cabinet => $params->{doctor_cabinet},
		description => $params->{doctor_description},
		status => $status,
	    });
	} else {
	    # Create the doctor
	    $c->stash->{doctors}->create({
		first_name => $params->{doctor_first_name},
		middle_name => $params->{doctor_middle_name},		
		last_name => $params->{doctor_last_name} || '',
		post => $post,
		cabinet => $params->{doctor_cabinet},
		description => $params->{doctor_description} || '',
		status => $status,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Fields 'post' or 'status' do not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{doctor}) {
	$c->stash( template => 'doctors/edit.tt' );
    } else {
	$c->stash( template => 'doctors/add.tt' );
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
