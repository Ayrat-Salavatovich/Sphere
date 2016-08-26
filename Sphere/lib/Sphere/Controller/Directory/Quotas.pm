package Sphere::Controller::Directory::Quotas;

use Moose;
use Time::Piece;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::Directory'; }

__PACKAGE__->config(model_name => 'SphereAppDB::Quota',
		    model_search_attrs => {
                        columns  => [qw/pk quota_limit quota_value doctor_fk year month day description status_fk/],
                        order_by => [qw/doctor_fk/],
                    },
);

use Sphere::Form::Quota;

=head1 NAME

Sphere::Controller::Directory::Quotas - Catalyst Controller

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

sub base : Chained('../directory') PathPart('quotas') CaptureArgs(0) {
    my ( $self, $c ) = @_;
    my $params = $c->req->params;
    my $t = localtime;
    my $year  = $params->{ year }  // int($t->year);
    my $month = $params->{ month } // int($t->mon);
    my $day   = $params->{ day }   // int($t->mday);

    $self->{ model_search_condition }->{ year }  = $year;
    $self->{ model_search_condition }->{ month } = $month;
    $self->{ model_search_condition }->{ day }   = $day;    

    $c->stash( quotas   => $c->model('SphereAppDB::Quota') );
    $c->stash( doctors  => $c->model('SphereAppDB::Doctor') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Quota->new;
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

    my $quota = $c->stash->{entry};
    $quota->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Quota->new;
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
    my $doctor = $c->stash->{doctors}->find({ pk => int($params->{quota_doctor}) });
    my $status = $c->stash->{statuses}->find({ pk => int($params->{quota_status}) });
    if ($doctor and $status) {
	if ($c->stash->{entry}) {
	    # Update the quota quota_limit quota_value doctor_fk post_fk year month day description status_fk
	    my $quota = $c->stash->{entry};
	    $quota->update({
		quota_limit => $params->{quota_limit},
		quota_value => $params->{quota_limit},
		doctor => $doctor,
		year => $params->{quota_year},
		month => $params->{quota_month},
		day => $params->{quota_day},
		description => $params->{quota_description},
		status => $status,
	    });
	} else {
	    # Create the quota
	    $c->stash->{quotas}->create({
		quota_limit => $params->{quota_limit},
		quota_value => $params->{quota_limit},
		doctor => $doctor,
		year => $params->{quota_year},
		month => $params->{quota_month},
		day => $params->{quota_day},
		description => $params->{quota_description} || '',
		status => $status,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Fields 'doctor' or 'status' do not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{entry}) {
	$c->stash( template => 'directory/quotas/edit.tt' );
    } else {
	$c->stash( template => 'directory/quotas/add.tt' );
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
