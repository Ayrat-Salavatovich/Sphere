package Sphere::Controller::Patients;
use Moose;
use namespace::autoclean;

BEGIN { extends 'Catalyst::Controller'; }

use Sphere::Form::Patient;

=head1 NAME

Sphere::Controller::Patients - Catalyst Controller

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

sub base : Chained('/') PathPart('patients') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( patients => $c->model('SphereAppDB::Patient') );
    $c->stash( accounts => $c->model('SphereAppDB::Account') );
}

sub object : Chained('base') PathPart('') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;
    
    if ($id =~ /\D/) { # Misuse of URL, ID does not contain only digits.
	$c->detach('/not_found', []);
    } else {
	my $patient = $c->stash->{patients}->find({ pk => int($id), key => 'primary' });
	if (not defined $patient) { # Could not find a patient with ID.
	    $c->stash->{error_msg} = "Patient not found.";
	    $c->detach('/not_found', []);
	} else {
	    $c->stash->{patient} = $patient;
	}
    }
}

sub list : Chained('base') PathPart('list') Args(0) {
    my ( $self, $c ) = @_;
    
    my $patients = $c->stash->{patients}->search(
	{},
	{
	    columns  => [qw/pk account_fk first_name middle_name last_name card description is_valid_policy_number/],
	    order_by => [qw/middle_name first_name/],
	}
    );
    $c->stash(patients => $patients);
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Patient->new;
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

    my $patient = $c->stash->{patient};
    $patient->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Patient->new;
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
    my $account = $c->stash->{accounts}->find({ pk => int($params->{patient_account}) });
    if ($account) {
	if ($c->stash->{patient}) {
	    # Update the patient
	    $c->stash->{patient}->update({
		account => $account,
		first_name => $params->{patient_first_name},
		middle_name => $params->{patient_middle_name},		
		last_name => $params->{patient_last_name},
		card => $params->{patient_card},
		description => $params->{patient_description},
	    });
	} else {
	    # Create the patient
	    $c->stash->{patients}->create({
		account => $account,
		first_name => $params->{patient_first_name},
		middle_name => $params->{patient_middle_name},		
		last_name => $params->{patient_last_name} || '',
		card => $params->{patient_card},
		description => $params->{patient_description} || '',
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Account does not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{patient}) {
	$c->stash( template => 'patients/edit.tt' );
    } else {
	$c->stash( template => 'patients/add.tt' );
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
