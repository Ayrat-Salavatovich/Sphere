package Sphere::Controller::Directory::Accounts;

use Moose;
use namespace::autoclean;

BEGIN { extends 'Sphere::Controller::Directory'; }

__PACKAGE__->config(model_name => 'SphereAppDB::Account',
		    model_search_attrs => {
			columns  => [qw/pk email name role_fk description status_fk/],
		        order_by => 'name',
		    },
);

use Sphere::Form::Directory::Account;

=head1 NAME

Sphere::Controller::Directory::Accounts - Catalyst Controller

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

sub base : Chained('../directory') PathPart('accounts') CaptureArgs(0) {
    my ( $self, $c ) = @_;

    $c->stash( accounts => $c->model('SphereAppDB::Account') );
    $c->stash( roles    => $c->model('SphereAppDB::Role') );
    $c->stash( statuses => $c->model('SphereAppDB::Status') );
}

sub add : Chained('base') PathPart('add') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Directory::Account->new;
	my $result = $form->run( params => $params );
	if ($result->has_errors) {
	    $c->stash->{error_msg} = "Parameters is incorrect.";
	} elsif ($c->stash->{accounts}->count_literal("name LIKE ?", $params->{account_name}."%") > 0 ||
		 $c->stash->{accounts}->count_literal("email LIKE ?", $params->{account_email}."%") > 0) {
	    $c->stash->{error_msg} = "Name or email already exists.";
	} else {
	    $c->forward('save');
	}
    } else {
	$c->forward('form');
    }
}

sub remove : Chained('object') PathPart('remove') Args(0) {
    my ( $self, $c ) = @_;

    my $account = $c->stash->{entry};
    $account->delete;
    $c->res->redirect( $c->req->referer() );
}

sub edit : Chained('object') PathPart('edit') Args(0) {
    my ( $self, $c ) = @_;
    
    if (lc $c->req->method eq 'post') {
	my $params = $c->req->params;
	my $form = Sphere::Form::Directory::Account->new;
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
    my $role = $c->stash->{roles}->find({ pk => int($params->{account_role}) });
    my $status = $c->stash->{statuses}->find({ pk => int($params->{account_status}) });
    if ($role and $status) {
	if ($c->stash->{entry}) {
	    # Update the account
	    my $account = $c->stash->{entry};
	    $account->update({
		email => $params->{account_email},
		name => $params->{account_name},
		role => $role,
		description => $params->{account_description},
		status => $status,
	    });
	} else {
	    # Create the account
	    $c->stash->{accounts}->create({
		email => $params->{account_email},
		name => $params->{account_name},
		role => $role,
		description => $params->{account_description} || '',
		status => $status,
	    });
	}
	$c->response->redirect( $c->uri_for( $self->action_for('list') ) );
    } else {
	$c->stash->{error_msg} = "Fields 'role' or 'status' do not exist or you do not have permission.";
    }
}

sub form : Private {
    my ( $self, $c ) = @_;
    
    if ($c->stash->{entry}) {
	$c->stash( template => 'directory/accounts/edit.tt' );
    } else {
	$c->stash( template => 'directory/accounts/add.tt' );
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
