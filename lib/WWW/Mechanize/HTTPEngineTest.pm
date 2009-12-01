package WWW::Mechanize::HTTPEngineTest;

use strict;
use warnings;

use base 'WWW::Mechanize';
use HTTP::Engine;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->http_engine_hook(@_);
    return $self;
}

sub http_engine_hook {
    my $self = shift;
    my %args = (
        uri => "http://localhost:8888/",
        @_
    );

    die "No handler provided"
        unless $args{handler};

    my $engine = HTTP::Engine->new(
        interface => {
            module => 'Test',
            request_handler => $args{handler},
        },
    );

    my $for = URI->new( $args{uri} );
    $self->add_handler(
        request_send => sub {
            $engine->run( $_[0], env => \%ENV );
        },
        m_scheme => $for->scheme,
        m_host => $for->host,
        m_port => $for->port,
        m_path_prefix => $for->path,
    );
}

package
    HTTP::Headers::Fast;

sub content_is_text { 1; }
sub content_type_charset { "utf-8" }

1;
