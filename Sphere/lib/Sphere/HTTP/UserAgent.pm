package Sphere::HTTP::UserAgent;

use Moose::Role;

use Furl;
use Carp;

has api_useragent => (
    is      => 'rw',
    isa     => 'Furl',
    lazy    => 1,
    default => sub {
	my $self = shift;
	my $ua = Furl->new(
	    agent => 'Sphere'
	);
	$ua;
    }
);

sub request {
    my ( $self, %req ) = @_;

    my $response = $self->api_useragent->request(%req);
    unless ( $response->is_success() ) {
	Carp::confess("Request to $req{url} failed, response was:\n" . $response->as_string());
    }

    $response->decoded_content();
}

1;

__END__
