package Sphere::HTTP::API::Google::OAuth2;

use strict;
use warnings;

use Moose;
use MooseX::ClassAttribute;

use Carp;
use Digest::SHA;
use Time::HiRes;
use URI;
use JSON;

with 'Sphere::HTTP::UserAgent';

has client_id => ( is => 'ro', required => 1 );
has client_secret => ( is => 'ro', required => 1 );
has redirect_uri => ( is => 'ro', required => 1 );
has access_type => ( is => 'ro', default => sub { return 'offline' } );
has scopes => (
    is => 'rw',
    clearer => 1,
    required => 1,
);

class_has auth_uri => (
    is => 'ro',
    default => sub { return 'https://accounts.google.com/o/oauth2/auth' }
);

class_has token_uri => (
    is => 'ro',
    default => sub { return 'https://accounts.google.com/o/oauth2/token' }
);

class_has userinfo_uri => (
    is => 'ro',
    default => sub { return 'https://www.googleapis.com/oauth2/v1/userinfo' }
);

sub authorize_uri {
    my %params = @_;

    $params{response_type} //= 'code';
    if (ref($params{scope}) eq 'ARRAY') {
	$params{scope} = join( ' ', @{$params{scope}} );
    }	
    
    srand(time ^ ($$ + ($$ << 15)));
    my $sha1 = Digest::SHA->new(512)->add(
	$$, "Auth for login", Time::HiRes::time(), rand() * 10000
    )->hexdigest;
    $params{state} = substr($sha1, 4, 16);

    my $uri = URI->new(Sphere::HTTP::API::Google::OAuth2->auth_uri);
    $uri->query_form(\%params);

    $uri->as_string;
}

sub get_userinfo {
    my ( $self, $code, $state ) = @_;

    my $token = $self->get_token($code);
    my $params = {
	access_token => $token->{access_token},
    };

    my $uri = URI->new($self->userinfo_uri);
    $uri->query_form($params);
    
    my $response = $self->request(
	method => 'GET',
	url => $uri->as_string
    );

    decode_json( $response );
}

sub get_token {
    my ( $self, $code ) = @_;
    
    unless ( $code ) {
	Carp::confess("No auth code provided. An auth code must be requested before generating a token.");
    }

    my $params = {
	grant_type    => 'authorization_code',
	code          => $code,
	client_id     => $self->client_id,
	client_secret => $self->client_secret,
	redirect_uri  => $self->redirect_uri,
    };

    my $response = $self->request(
	method  => 'POST',
	url     => $self->token_uri,
	headers => ['Content-Type', 'application/x-www-form-urlencoded'],
	content => $params,
    );

    decode_json( $response );
}

1;
