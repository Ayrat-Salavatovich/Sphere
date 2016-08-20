package Sphere::HTTP::API::Policy;

use strict;
use warnings;

use Time::Piece;
use JSON;
use Moose;

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
    my $response = $self->api_useragent->get("http://62.133.163.218:4305/ServiceModelSamples/service/setdate?ExchangeType=$exchange_type&PolNumber=$pol_number&TempCertif=$temp_certif&_=$time");
    # check the outcome
    if ($response->is_success) {
	my $text = from_json($response->decoded_content, { utf8  => 1 })->{ProtocolText};

	if (index(lc $text, lc ' действительный') != -1 or index(lc $text, lc 'текущий этап изготовления') != -1) {
	    $result = 1;
	}
    }	
    $result;
}

1;
