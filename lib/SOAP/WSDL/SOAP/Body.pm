package SOAP::WSDL::SOAP::Body;
use strict;
use warnings;
use base qw(SOAP::WSDL::Base);
use Class::Std::Fast::Storable;

our $VERSION = 3.004;

my %use_of              :ATTR(:name<use>            :default<q{}>);
my %namespace_of        :ATTR(:name<namespace>      :default<q{}>);
my %encodingStyle_of    :ATTR(:name<encodingStyle>  :default<q{}>);
my %parts_of            :ATTR(:name<parts>          :default<q{}>);

1;