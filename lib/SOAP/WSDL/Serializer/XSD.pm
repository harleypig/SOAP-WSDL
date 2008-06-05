#!/usr/bin/perl -w
package SOAP::WSDL::Serializer::XSD;
use strict;
use warnings;
use Class::Std::Fast::Storable;
use Scalar::Util qw(blessed);

use version; our $VERSION = qv('2.00.03');

use SOAP::WSDL::Factory::Serializer;

my $SOAP_NS = 'http://schemas.xmlsoap.org/soap/envelope/';
my $XML_INSTANCE_NS = 'http://www.w3.org/2001/XMLSchema-instance';

sub serialize {
    my ($self, $args_of_ref) = @_;

    my $opt = $args_of_ref->{ options };

    if (not $opt->{ namespace }->{ $SOAP_NS })
    {
        $opt->{ namespace }->{ $SOAP_NS } = 'SOAP-ENV';
    }

    if (not $opt->{ namespace }->{ $XML_INSTANCE_NS })
    {
        $opt->{ namespace }->{ $XML_INSTANCE_NS } = 'xsi';
    }

    my $soap_prefix = $opt->{ namespace }->{ $SOAP_NS };

    # envelope start with namespaces
    my $xml = "<$soap_prefix\:Envelope ";

    while (my ($uri, $prefix) = each %{ $opt->{ namespace } })
    {
        $xml .= "xmlns:$prefix=\"$uri\" ";
    }
    #
    # add namespace for user-supplied prefix if needed
    $xml .= "xmlns:$opt->{prefix}=\"" . $args_of_ref->{ body }->get_xmlns() . "\" "
        if $opt->{prefix};

    # TODO insert encoding
    $xml.='>';
    $xml .= $self->serialize_header($args_of_ref->{ method }, $args_of_ref->{ header }, $opt);
    $xml .= $self->serialize_body($args_of_ref->{ method }, $args_of_ref->{ body }, $opt);
    $xml .= '</' . $soap_prefix .':Envelope>';
    return $xml;
}

sub serialize_header {
    my ($self, $name, $data, $opt) = @_;

    # header is optional. Leave out if there's no header data
    return q{} if not $data;
    return join ( q{},
        "<$opt->{ namespace }->{ $SOAP_NS }\:Header>",
        blessed $data ? $data->serialize_qualified : (),
        "</$opt->{ namespace }->{ $SOAP_NS }\:Header>",
    );
}

sub serialize_body {
    my ($self, $name, $data, $opt) = @_;
    $data->__set_name("$opt->{prefix}:$name") if $opt->{prefix};

    # Body is NOT optional. Serialize to empty body
    # if we have no data.
    return join ( q{},
        "<$opt->{ namespace }->{ $SOAP_NS }\:Body>",
        defined $data
            ? ref $data eq 'ARRAY'
                ? join q{}, map { blessed $_ ? $_->serialize_qualified() : () } @{ $data }
                : blessed $data
                    ? $opt->{prefix}
                        ? $data->serialize()
                        : $data->serialize_qualified()
                    : ()
            : (),
        "</$opt->{ namespace }->{ $SOAP_NS }\:Body>",
    );
}

__END__

=pod

=head1 NAME

SOAP:WSDL::Serializer::XSD - Serializer for SOAP::WSDL::XSD::Typelib:: objects

=head1 DESCRIPTION

This is the default serializer for SOAP::WSDL::Client and Interface classes
generated by SOAP::WSDL

It may be used as a template for creating custom serializers.

See L<SOAP::WSDL::Factory::Serializer|SOAP::WSDL::Factory::Serializer> for
details on that.

=head1 METHODS

=head2 serialize

Creates a SOAP envelope based on the body and header arguments passed.

Sets SOAP namespaces.

=head2 serialize_body

Serializes a message body to XML

=head2 serialize_header

Serializes a message header to XML

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007 Martin Kutter. All rights reserved.

This file is part of SOAP-WSDL. You may distribute/modify it under
the same terms as perl itself

=head1 AUTHOR

Martin Kutter E<lt>martin.kutter fen-net.deE<gt>

=head1 REPOSITORY INFORMATION

 $Rev: 677 $
 $LastChangedBy: kutterma $
 $Id: XSD.pm 677 2008-05-18 20:17:56Z kutterma $
 $HeadURL: http://soap-wsdl.svn.sourceforge.net/svnroot/soap-wsdl/SOAP-WSDL/trunk/lib/SOAP/WSDL/Serializer/XSD.pm $

=cut
