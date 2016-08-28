package Sphere::Controller::Directory::Schedules;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::Directory'; }

__PACKAGE__->config(model_name => 'SphereAppDB::Schedule',
		    model_search_attrs => {
                        columns  => [qw/pk quota_fk hour minute patient_fk description flag_fk/],
                        order_by => [qw/quota_fk/],
                    },
);

use Sphere::Form::Directory::Schedule;

=head1 NAME

Sphere::Controller::Directory::Schedules - Catalyst Controller

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

sub quota : Chained('../directory') PathPart('quotas') CaptureArgs(1) {
    my ( $self, $c, $id ) = @_;

    my $quota = $c->model('SphereAppDB::Quota')->find({ pk => int($id), key => 'primary' });
    $self->{model_search_condition}->{ quota_fk } = $quota->pk;
    
    $c->stash( quota => $quota );
}

sub base : Chained('quota') PathPart('schedules') CaptureArgs(0) {
    my ( $self, $c, $quota_id ) = @_;

    $c->stash( schedules => $c->model('SphereAppDB::Schedule') );
    $c->stash( patients  => $c->model('SphereAppDB::Patient') );
    $c->stash( flags     => $c->model('SphereAppDB::Flag') );
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Directory::Schedule->new;
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

    my $schedule = $c->stash->{entry};
    $schedule->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Directory::Schedule->new;
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
    my $flag = $c->stash->{flags}->find({ pk => int($params->{schedule_flag}) });
    if ($flag) {
	if ($c->stash->{entry}) {
	    # Update the schedule hour minute description and flag_fk
	    my $schedule = $c->stash->{entry};
	    $schedule->update({
		quota => $c->stash->{quota},
		hour => $params->{schedule_hour},
		minute => $params->{schedule_minute},
		description => $params->{schedule_description},
		flag => $flag,
	    });
	} else {
	    # Create the schedule
	    $c->stash->{schedules}->create({
		quota => $c->stash->{quota},
		hour => $params->{schedule_hour},
		minute => $params->{schedule_minute},
		description => $params->{schedule_description} || '',
		flag => $flag,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list'), [ $c->stash->{quota}->pk ] ) );
    } else {
	$c->stash->{error_msg} = "Field 'flag' do not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{entry}) {
	$c->stash( template => 'directory/schedules/edit.tt' );
    } else {
	$c->stash( template => 'directory/schedules/add.tt' );
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
