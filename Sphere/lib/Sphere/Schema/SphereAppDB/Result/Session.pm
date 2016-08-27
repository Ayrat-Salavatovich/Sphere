use utf8;
package Sphere::Schema::SphereAppDB::Result::Session;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Session

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<sessions>

=cut

__PACKAGE__->table("sessions");

=head1 ACCESSORS

=head2 pk

  data_type: 'char'
  is_nullable: 0
  size: 72

=head2 data

  data_type: 'text'
  is_nullable: 1

=head2 expires

  data_type: 'integer'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "pk",
  { data_type => "char", is_nullable => 0, size => 72 },
  "data",
  { data_type => "text", default_value => undef, is_nullable => 1, size => 65535 },
  "expires",
  { data_type => "integer", default_value => undef, is_nullable => 1, size => 11 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-27 11:12:30
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:uCCpyB3AyaTqvIKpm11ikw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
