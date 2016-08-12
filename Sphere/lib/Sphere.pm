package Sphere;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application.
#
# Note that ORDERING IS IMPORTANT here as plugins are initialized in order,
# therefore you almost certainly want to keep ConfigLoader at the head of the
# list if you're using it.
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
    Params::Profile
/;

extends 'Catalyst';

our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in sphere.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'Sphere',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    enable_catalyst_header => 1, # Send X-Catalyst header
    using_frontend_proxy => 1, # Set the right headers for nginx
);

# Set the location for TT files
__PACKAGE__->config(
    'View::Web' => {
	INCLUDE_PATH => [
	    __PACKAGE__->path_to( 'root', 'templates', 'lib' ),
            __PACKAGE__->path_to( 'root', 'templates', 'src' ),
	],
    },
);

# Start the application
__PACKAGE__->setup();

=encoding utf8

=head1 NAME

Sphere - Catalyst based application

=head1 SYNOPSIS

    script/sphere_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Sphere::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Catalyst developer

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
