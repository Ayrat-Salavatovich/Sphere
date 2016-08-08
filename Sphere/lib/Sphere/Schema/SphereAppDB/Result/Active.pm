use utf8;
package Sphere::Schema::SphereAppDB::Result::Active;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Active

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

=head1 TABLE: C<actives>

=cut

__PACKAGE__->table("actives");

=head1 ACCESSORS

=head2 pk

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'actives_pk_seq'

=head2 event_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 time

  data_type: 'timestamp'
  default_value: current_timestamp
  is_nullable: 1
  original: {default_value => \"now()"}

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 table_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "pk",
  {
    data_type         => "integer",
    is_auto_increment => 1,
    is_nullable       => 0,
    sequence          => "actives_pk_seq",
  },
  "event_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "time",
  {
    data_type     => "timestamp",
    default_value => \"current_timestamp",
    is_nullable   => 1,
    original      => { default_value => \"now()" },
  },
  "description",
  { data_type => "text", is_nullable => 1 },
  "table_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");

=head1 RELATIONS

=head2 event_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Event>

=cut

__PACKAGE__->belongs_to(
  "event_fk",
  "Sphere::Schema::SphereAppDB::Result::Event",
  { pk => "event_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 table_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Table>

=cut

__PACKAGE__->belongs_to(
  "table_fk",
  "Sphere::Schema::SphereAppDB::Result::Table",
  { pk => "table_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-08 15:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZPKkYAGBD7VPcpE9FuMLAA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
