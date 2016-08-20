package Sphere::HTTP::UserAgent;

use Moose::Role;
use LWP::UserAgent;

has api_useragent => (
    is      => 'rw',
    isa     => 'LWP::UserAgent',
    lazy    => 1,
    default => sub {
	my $self = shift;
	my $ua = LWP::UserAgent->new();
	$ua->agent('Sphere');
	$ua;
    }
    );

1;

__END__
