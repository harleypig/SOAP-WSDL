package SOAP::WSDL::XSD::Typelib::Attribute;
use strict;
use warnings;

use base qw(SOAP::WSDL::XSD::Typelib::Element);

our $VERSION = 3.004;

sub start_tag {
    # my ($self, $opt, $value) = @_;
    return q{} if (@_ < 3);
    my $ns = $_[0]->get_xmlns();
    if ($ns eq 'http://www.w3.org/XML/1998/namespace') {
        return qq{ xml:$_[1]->{ name }="};
    }
    return qq{ $_[1]->{ name }="};
}

sub end_tag {
    return q{"};
}

1;