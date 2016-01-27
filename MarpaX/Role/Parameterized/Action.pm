use strict;
use warnings FATAL => 'all';

package MarpaX::Role::Parameterized::Action;

# ABSTRACT: Dynamic action value on top of a Marpa grammar

# VERSION

# AUTHORITY

use MooX::Role::Parameterized;
use Type::Params qw/compile/;
use Types::Standard -all;

#
# Role parameters validation
#
our $check_params = compile(
    slurpy
    Dict[
        '-extends' => Maybe[ArrayRef[Str]],
        '-roles'   => Maybe[ArrayRef[Str]],
        '-bnf'     => Str,
        '-rules'   => HashRef[Str],
    ]
    );

role {
  my $params = shift;
  #
  # Sanity checks on params
  #
  my ($hash_ref) = HashRef->($params);
  my ($PARAMS)   = $check_params->(%{$hash_ref});
  #
  # Extensions are applied at the very beginning
  #
  extends(@{$PARAMS->{'-extends'}}) if $PARAMS->{'-extends'};
  #
  # Roles are applied at the very end
  #
  with(@{$PARAMS->{'-roles'}}) if $PARAMS->{'-roles'};
};

1;
