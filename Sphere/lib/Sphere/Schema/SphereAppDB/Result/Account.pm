use utf8;
package Sphere::Schema::SphereAppDB::Result::Account;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Sphere::Schema::SphereAppDB::Result::Account

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

=head1 TABLE: C<accounts>

=cut

__PACKAGE__->table("accounts");

=head1 ACCESSORS

=head2 pk

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0
  sequence: 'accounts_pk_seq'

=head2 email

  data_type: 'text'
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 role_fk

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=head2 description

  data_type: 'text'
  is_nullable: 1

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
    sequence          => "accounts_pk_seq",
  },
  "email",
  { data_type => "text", is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
  "role_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
  "description",
  { data_type => "text", is_nullable => 1 },
  "status_fk",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</pk>

=back

=cut

__PACKAGE__->set_primary_key("pk");

=head1 UNIQUE CONSTRAINTS

=head2 C<accounts_email_key>

=over 4

=item * L</email>

=back

=cut

__PACKAGE__->add_unique_constraint("accounts_email_key", ["email"]);

=head2 C<accounts_name_key>

=over 4

=item * L</name>

=back

=cut

__PACKAGE__->add_unique_constraint("accounts_name_key", ["name"]);

=head1 RELATIONS

=head2 patients

Type: has_many

Related object: L<Sphere::Schema::SphereAppDB::Result::Patient>

=cut

__PACKAGE__->has_many(
  "patients",
  "Sphere::Schema::SphereAppDB::Result::Patient",
  { "foreign.account_fk" => "self.pk" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 role_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Role>

=cut

__PACKAGE__->belongs_to(
  "role_fk",
  "Sphere::Schema::SphereAppDB::Result::Role",
  { pk => "role_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);

=head2 status_fk

Type: belongs_to

Related object: L<Sphere::Schema::SphereAppDB::Result::Status>

=cut

__PACKAGE__->belongs_to(
  "status_fk",
  "Sphere::Schema::SphereAppDB::Result::Status",
  { pk => "status_fk" },
  { is_deferrable => 0, on_delete => "NO ACTION", on_update => "NO ACTION" },
);


# Created by DBIx::Class::Schema::Loader v0.07045 @ 2016-08-08 15:12:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:bf0iZ4XCJSPW4AVsCutlIA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
