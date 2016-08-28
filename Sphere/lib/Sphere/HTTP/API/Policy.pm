package Sphere::HTTP::API::Policy;

use strict;
use warnings;

use Moose;
use MooseX::ClassAttribute;

use utf8;
use Time::Piece;
use JSON;
use Carp;
use URI;

class_has service_uri => (
    is => 'ro',
    default => sub { return 'http://62.133.163.218:4305/ServiceModelSamples/service/setdate' }
);

with 'Sphere::HTTP::UserAgent';

sub new {
    my ( $caller, $time ) = @_;
    
    my $class = ref($caller) || $caller;
    $time //= sprintf("%d000", localtime->epoch);
    bless { millisecond => $time }, $class;
}

sub is_valid {
    my ( $self, $num ) = @_;
    
    my $result = 0;
    if ($num) {
	if (length($num) == 9) {
	    $result = $self->check_temp_certif_num($num);
	} elsif (length($num) == 16) {
	    $result = $self->check_pol_num($num);
	}
    }
    return $result;
}

sub set_time {
    my ( $self, $time ) = @_;
    
    $self->{millisecond} = $time;
}

sub check_temp_certif_num {
    my ( $self, $temp_certif_num ) = @_;
    
    return $self->check(exchange_type => 'TempCertif', pol_number => '', temp_certif => $temp_certif_num);
}

sub check_pol_num {
    my ( $self, $pol_num ) = @_;
    
    return $self->check(exchange_type => 'PolNum', pol_number => $pol_num, temp_certif => '');
}

sub check {
    my ( $self, %arg ) = @_;
    
    my ( $exchange_type, $pol_number, $temp_certif, $time ) = ( $arg{exchange_type}, $arg{pol_number}, $arg{temp_certif}, $self->{millisecond} );
    my $result = 0;
    
my $params = {
	ExchangeType => $exchange_type,
	PolNumber    => $pol_number,
	TempCertif   => $temp_certif,
	'_'          => $time,
    };
    my $uri = URI->new($self->service_uri);
    $uri->query_form($params);

    my $response = $self->request(
	method => 'GET',
	url => $uri->as_string
    );
    my $text = from_json($response, { utf8  => 1 })->{ProtocolText};

    if (index(lc $text, lc ' действительный') != -1 or index(lc $text, lc 'текущий этап изготовления') != -1) {
	$result = 1;
    }

    $result;
}

sub _request {
    my ( $self, %req ) = @_;

    my $response = $self->api_useragent->request(%req);
    # check the outcome
    unless ( $response->is_success() ) {
	Carp::confess("Request to $req{url} failed, response was:\n" . $response->as_string());
    }

    $response->decoded_content();
}

1;
