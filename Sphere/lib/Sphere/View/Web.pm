package Sphere::View::Web;

use Moose;
use namespace::autoclean;

extends 'Catalyst::View::TT';

__PACKAGE__->config(
    TEMPLATE_EXTENSION => '.tt',
    CATALYST_VAR       => 'Catalyst',
    TIMER              => 0,
    ENCODING           => 'utf-8',
    PRE_PROCESS        => 'config/main.tt',
    WRAPPER            => 'site/wrapper.tt', # Add a wrapper template
    ERROR              => 'error.tt',
    render_die         => 1,
);

=head1 NAME

Sphere::View::Web - TT View for Sphere

=head1 DESCRIPTION

TT View for Sphere.

=head1 SEE ALSO

L<Sphere>

=head1 AUTHOR

A clever guy

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
