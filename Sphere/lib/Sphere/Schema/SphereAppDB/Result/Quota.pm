use utf8;
package Sphere::Schema::SphereAppDB::Result::Quota;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Quota

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

=head1 TABLE: C<quotas>

=cut

__PACKAGE__->table("quotas");

=head1 ACCESSORS

=head2 pk

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'quotas_pk_seq'

=head2 quota_limit

  data_type: 'integer'
  is_nullable: 0

=head2 quota_value

  data_type: 'integer'
  is_nullable: 0

=head2 doctor_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

=head2 year

  data_type: 'integer'
  is_nullable: 0

=head2 month

  data_type: 'integer'
  is_nullable: 0

=head2 day

  data_type: 'integer'
  is_nullable: 0

=head2 status_fk

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
    sequence          => "quotas_pk_seq",
  },
  "quota_limit",
  { data_type => "integer", is_nullable => 0 },
  "quota_value",
  { data_type => "integer", is_nullable => 0 },
  "doctor_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "year",
  { data_type => "integer", is_nullable => 0 },
  "month",
  { data_type => "integer", is_nullable => 0 },
  "day",
  { data_type => "integer", is_nullable => 0 },
  "status_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");

=head1 RELATIONS

=head2 doctor_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Doctor>

=cut

__PACKAGE__->belongs_to(
  "doctor",
  "Sphere::Schema::SphereAppDB::Result::Doctor",
  { pk => "doctor_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 status_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Status>

=cut

__PACKAGE__->belongs_to(
  "status",
  "Sphere::Schema::SphereAppDB::Result::Status",
  { pk => "status_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-08 15:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:2atJjwSNpvYY+6Aw/Aqtzg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
