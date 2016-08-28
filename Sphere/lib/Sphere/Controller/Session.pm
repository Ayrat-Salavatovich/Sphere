package Sphere::Controller::Session;

use Moose;
use namespace::autoclean;

use Sphere::HTTP::API::Google::OAuth2;

BEGIN { extends 'Catalyst::Controller'; }

with 'Sphere::HTTP::UserAgent';

=head1 NAME

Sphere::Controller::Session - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path : Args(0) {
    my ( $self, $c ) = @_;

    # Hello World
    $c->response->body( $c->welcome_message );
}

sub login :Path('login') : Args(0) {
    my ( $self, $c ) = @_;

    my $auth_uri = Sphere::HTTP::API::Google::OAuth2::authorize_uri(
	client_id => $c->config->{'Plugin::Authentication'}{default}{credential}{client_id},
	redirect_uri => $c->uri_for('oauth2callback'),
	scope => $c->config->{'Plugin::Authentication'}{default}{credential}{scopes},
    );

    $c->response->redirect($auth_uri);
}

sub oauth2callback :Path('oauth2callback') : Args(0) {
    my ( $self, $c ) = @_;

    my $params = $c->req->params;
    my $oauth2_client = Sphere::HTTP::API::Google::OAuth2->new(
	client_id => $c->config->{'Plugin::Authentication'}{default}{credential}{client_id},
	client_secret => $c->config->{'Plugin::Authentication'}{default}{credential}{client_secret},
	redirect_uri => $c->uri_for('oauth2callback'),
	scopes => $c->config->{'Plugin::Authentication'}{default}{credential}{scopes},
    );
    
    my $userinfo = $oauth2_client->get_userinfo($params->{code}, $params->{state});

    $c->response->redirect('/');
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
