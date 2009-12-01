package WWW::Mechanize::Plack;

use strict;
use warnings;

use base 'WWW::Mechanize';
use Plack::Test;

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->plack_hook(@_);
    return $self;
}

sub plack_hook {
    my $self = shift;
    my %args = (
        uri => "http://localhost:8888/",
        @_
    );

    die "No handler provided"
        unless $args{handler};

    my $cb;

    test_psgi
        app => $handler,
        client => sub {$cb = shift};

    my $for = URI->new( $args{uri} );
    $self->add_handler(
        request_send => $cb,
        m_scheme => $for->scheme,
        m_host => $for->host,
        m_port => $for->port,
        m_path_prefix => $for->path,
    );
}

#package
#    HTTP::Headers::Fast;
#sub content_is_text { 1; }
#sub content_type_charset { "utf-8" }

1;
