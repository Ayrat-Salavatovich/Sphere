package Sphere::View::JSON;

use Moose;
use namespace::autoclean;
use JSON::MaybeXS();

extends 'Catalyst::View::JSON';

has 'encoder' => (
    isa => 'Object',
    lazy => 1,
    is => 'ro',
    default => sub {
	return JSON::MaybeXS
	    ->new
	    ->utf8
	    ->pretty(1)
	    ->indent(1)
	    ->allow_nonref(1)
	    ->allow_blessed(1)
	    ->convert_blessed(1)
    }
);

sub process {
    my ( $self, $c ) = @_;

    # Remove collection
    delete $c->stash->{collection} if $c->stash->{collection};

    $c->res->header('Pragma' => 'no-cache');
    $c->res->header('Cache-Control' => 'no-store, no-cache, must-revalidate, post-check=0, pre-check=0');
    $self->SUPER::process( $c, @_ );
    if ( $c->stash->{content_transfer} ) {
	$c->response->headers->header('Content-Type' => $c->stash->{content_transfer} );
    } else {
	$c->res->header('Content-type'  => 'application/json; charset=utf-8');
    }
}

sub encode_json
{
    my ( $self, $c, $data ) = @_;

    return $self->encoder->encode( $data );
}

=head1 NAME

Sphere::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<Sphere>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
