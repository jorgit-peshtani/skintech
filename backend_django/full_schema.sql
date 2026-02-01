-- DJANGO FULL SCHEMA EXPORT FOR NEON (PostgreSQL)
-- Generated automatically. Run this to create all tables.

BEGIN;

-- Migration: contenttypes 0001_initial
BEGIN;
--
-- Create model ContentType
--
CREATE TABLE "django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(100) NOT NULL, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);
--
-- Alter unique_together for contenttype (1 constraint(s))
--
CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");
COMMIT;


-- Migration: auth 0001_initial
BEGIN;
--
-- Create model Permission
--
CREATE TABLE "auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(50) NOT NULL, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL);
--
-- Create model Group
--
CREATE TABLE "auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(80) NOT NULL UNIQUE);
CREATE TABLE "auth_group_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model User
--
CREATE TABLE "auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "password" varchar(128) NOT NULL, "last_login" datetime NOT NULL, "is_superuser" bool NOT NULL, "username" varchar(30) NOT NULL UNIQUE, "first_name" varchar(30) NOT NULL, "last_name" varchar(30) NOT NULL, "email" varchar(75) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL);
CREATE TABLE "auth_user_groups" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "group_id" integer NOT NULL REFERENCES "auth_group" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE "auth_user_user_permissions" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "permission_id" integer NOT NULL REFERENCES "auth_permission" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");
CREATE UNIQUE INDEX "auth_group_permissions_group_id_permission_id_0cd325b0_uniq" ON "auth_group_permissions" ("group_id", "permission_id");
CREATE INDEX "auth_group_permissions_group_id_b120cbf9" ON "auth_group_permissions" ("group_id");
CREATE INDEX "auth_group_permissions_permission_id_84c5c92e" ON "auth_group_permissions" ("permission_id");
CREATE UNIQUE INDEX "auth_user_groups_user_id_group_id_94350c0c_uniq" ON "auth_user_groups" ("user_id", "group_id");
CREATE INDEX "auth_user_groups_user_id_6a12ed8b" ON "auth_user_groups" ("user_id");
CREATE INDEX "auth_user_groups_group_id_97559544" ON "auth_user_groups" ("group_id");
CREATE UNIQUE INDEX "auth_user_user_permissions_user_id_permission_id_14a6b632_uniq" ON "auth_user_user_permissions" ("user_id", "permission_id");
CREATE INDEX "auth_user_user_permissions_user_id_a95ead1b" ON "auth_user_user_permissions" ("user_id");
CREATE INDEX "auth_user_user_permissions_permission_id_1fbb5f2c" ON "auth_user_user_permissions" ("permission_id");
COMMIT;


-- Migration: address 0001_initial
BEGIN;
--
-- Create model Country
--
CREATE TABLE "address_country" ("iso_3166_1_a2" varchar(2) NOT NULL PRIMARY KEY, "iso_3166_1_a3" varchar(3) NOT NULL, "iso_3166_1_numeric" varchar(3) NOT NULL, "printable_name" varchar(128) NOT NULL, "name" varchar(128) NOT NULL, "display_order" smallint unsigned NOT NULL CHECK ("display_order" >= 0), "is_shipping_country" bool NOT NULL);
--
-- Create model UserAddress
--
CREATE TABLE "address_useraddress" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(64) NOT NULL, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "line1" varchar(255) NOT NULL, "line2" varchar(255) NOT NULL, "line3" varchar(255) NOT NULL, "line4" varchar(255) NOT NULL, "state" varchar(255) NOT NULL, "postcode" varchar(64) NOT NULL, "search_text" text NOT NULL, "phone_number" varchar(128) NOT NULL, "notes" text NOT NULL, "is_default_for_shipping" bool NOT NULL, "is_default_for_billing" bool NOT NULL, "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "hash" varchar(255) NOT NULL, "date_created" datetime NOT NULL, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Alter unique_together for useraddress (1 constraint(s))
--
CREATE UNIQUE INDEX "address_useraddress_user_id_hash_9d1738c7_uniq" ON "address_useraddress" ("user_id", "hash");
CREATE INDEX "address_country_display_order_dc88cde8" ON "address_country" ("display_order");
CREATE INDEX "address_country_is_shipping_country_f7b6c461" ON "address_country" ("is_shipping_country");
CREATE INDEX "address_useraddress_hash_e0a6b290" ON "address_useraddress" ("hash");
CREATE INDEX "address_useraddress_country_id_fa26a249" ON "address_useraddress" ("country_id");
CREATE INDEX "address_useraddress_user_id_6edf0244" ON "address_useraddress" ("user_id");
COMMIT;


-- Migration: address 0002_auto_20150927_1547
BEGIN;
--
-- Rename field num_orders on useraddress to num_orders_as_shipping_address
--
ALTER TABLE "address_useraddress" RENAME COLUMN "num_orders" TO "num_orders_as_shipping_address";
--
-- Add field num_orders_as_billing_address to useraddress
--
CREATE TABLE "new__address_useraddress" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(64) NOT NULL, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "line1" varchar(255) NOT NULL, "line2" varchar(255) NOT NULL, "line3" varchar(255) NOT NULL, "line4" varchar(255) NOT NULL, "state" varchar(255) NOT NULL, "postcode" varchar(64) NOT NULL, "search_text" text NOT NULL, "phone_number" varchar(128) NOT NULL, "notes" text NOT NULL, "is_default_for_shipping" bool NOT NULL, "is_default_for_billing" bool NOT NULL, "hash" varchar(255) NOT NULL, "date_created" datetime NOT NULL, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "num_orders_as_shipping_address" integer unsigned NOT NULL CHECK ("num_orders_as_shipping_address" >= 0), "num_orders_as_billing_address" integer unsigned NOT NULL CHECK ("num_orders_as_billing_address" >= 0));
INSERT INTO "new__address_useraddress" ("id", "title", "first_name", "last_name", "line1", "line2", "line3", "line4", "state", "postcode", "search_text", "phone_number", "notes", "is_default_for_shipping", "is_default_for_billing", "hash", "date_created", "country_id", "user_id", "num_orders_as_shipping_address", "num_orders_as_billing_address") SELECT "id", "title", "first_name", "last_name", "line1", "line2", "line3", "line4", "state", "postcode", "search_text", "phone_number", "notes", "is_default_for_shipping", "is_default_for_billing", "hash", "date_created", "country_id", "user_id", "num_orders_as_shipping_address", 0 FROM "address_useraddress";
DROP TABLE "address_useraddress";
ALTER TABLE "new__address_useraddress" RENAME TO "address_useraddress";
CREATE UNIQUE INDEX "address_useraddress_user_id_hash_9d1738c7_uniq" ON "address_useraddress" ("user_id", "hash");
CREATE INDEX "address_useraddress_hash_e0a6b290" ON "address_useraddress" ("hash");
CREATE INDEX "address_useraddress_country_id_fa26a249" ON "address_useraddress" ("country_id");
CREATE INDEX "address_useraddress_user_id_6edf0244" ON "address_useraddress" ("user_id");
COMMIT;


-- Migration: address 0003_auto_20150927_1551
BEGIN;
--
-- Change Meta options on useraddress
--
-- (no-op)
--
-- Alter field num_orders_as_billing_address on useraddress
--
-- (no-op)
--
-- Alter field num_orders_as_shipping_address on useraddress
--
-- (no-op)
COMMIT;


-- Migration: address 0004_auto_20170226_1122
BEGIN;
--
-- Alter field num_orders_as_billing_address on useraddress
--
-- (no-op)
--
-- Alter field num_orders_as_shipping_address on useraddress
--
-- (no-op)
COMMIT;


-- Migration: address 0005_regenerate_user_address_hashes
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: address 0006_auto_20181115_1953
BEGIN;
--
-- Alter field printable_name on country
--
CREATE TABLE "new__address_country" ("printable_name" varchar(128) NOT NULL, "iso_3166_1_a2" varchar(2) NOT NULL PRIMARY KEY, "iso_3166_1_a3" varchar(3) NOT NULL, "iso_3166_1_numeric" varchar(3) NOT NULL, "name" varchar(128) NOT NULL, "display_order" smallint unsigned NOT NULL CHECK ("display_order" >= 0), "is_shipping_country" bool NOT NULL);
INSERT INTO "new__address_country" ("iso_3166_1_a2", "iso_3166_1_a3", "iso_3166_1_numeric", "name", "display_order", "is_shipping_country", "printable_name") SELECT "iso_3166_1_a2", "iso_3166_1_a3", "iso_3166_1_numeric", "name", "display_order", "is_shipping_country", "printable_name" FROM "address_country";
DROP TABLE "address_country";
ALTER TABLE "new__address_country" RENAME TO "address_country";
CREATE INDEX "address_country_printable_name_450b016c" ON "address_country" ("printable_name");
CREATE INDEX "address_country_display_order_dc88cde8" ON "address_country" ("display_order");
CREATE INDEX "address_country_is_shipping_country_f7b6c461" ON "address_country" ("is_shipping_country");
COMMIT;


-- Migration: admin 0001_initial
BEGIN;
--
-- Create model LogEntry
--
CREATE TABLE "django_admin_log" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "action_time" datetime NOT NULL, "object_id" text NULL, "object_repr" varchar(200) NOT NULL, "action_flag" smallint unsigned NOT NULL CHECK ("action_flag" >= 0), "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");
CREATE INDEX "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");
COMMIT;


-- Migration: admin 0002_logentry_remove_auto_add
BEGIN;
--
-- Alter field action_time on logentry
--
CREATE TABLE "new__django_admin_log" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "action_time" datetime NOT NULL, "object_id" text NULL, "object_repr" varchar(200) NOT NULL, "action_flag" smallint unsigned NOT NULL CHECK ("action_flag" >= 0), "change_message" text NOT NULL, "content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__django_admin_log" ("id", "object_id", "object_repr", "action_flag", "change_message", "content_type_id", "user_id", "action_time") SELECT "id", "object_id", "object_repr", "action_flag", "change_message", "content_type_id", "user_id", "action_time" FROM "django_admin_log";
DROP TABLE "django_admin_log";
ALTER TABLE "new__django_admin_log" RENAME TO "django_admin_log";
CREATE INDEX "django_admin_log_content_type_id_c4bce8eb" ON "django_admin_log" ("content_type_id");
CREATE INDEX "django_admin_log_user_id_c564eba6" ON "django_admin_log" ("user_id");
COMMIT;


-- Migration: admin 0003_logentry_add_action_flag_choices
BEGIN;
--
-- Alter field action_flag on logentry
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0001_initial
BEGIN;
--
-- Create model AttributeOption
--
CREATE TABLE "catalogue_attributeoption" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "option" varchar(255) NOT NULL);
--
-- Create model AttributeOptionGroup
--
CREATE TABLE "catalogue_attributeoptiongroup" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL);
--
-- Create model Category
--
CREATE TABLE "catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL, "full_name" varchar(255) NOT NULL);
--
-- Create model Option
--
CREATE TABLE "catalogue_option" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "type" varchar(128) NOT NULL);
--
-- Create model Product
--
CREATE TABLE "catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL);
--
-- Create model ProductAttribute
--
CREATE TABLE "catalogue_productattribute" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL, "type" varchar(20) NOT NULL, "required" bool NOT NULL, "option_group_id" bigint NULL REFERENCES "catalogue_attributeoptiongroup" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ProductAttributeValue
--
CREATE TABLE "catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_text" text NULL, "value_integer" integer NULL, "value_boolean" bool NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ProductCategory
--
CREATE TABLE "catalogue_productcategory" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "category_id" bigint NOT NULL REFERENCES "catalogue_category" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ProductClass
--
CREATE TABLE "catalogue_productclass" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "slug" varchar(128) NOT NULL UNIQUE, "requires_shipping" bool NOT NULL, "track_stock" bool NOT NULL);
CREATE TABLE "catalogue_productclass_options" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "productclass_id" bigint NOT NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "option_id" bigint NOT NULL REFERENCES "catalogue_option" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ProductImage
--
CREATE TABLE "catalogue_productimage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "original" varchar(255) NOT NULL, "caption" varchar(200) NOT NULL, "display_order" integer unsigned NOT NULL CHECK ("display_order" >= 0), "date_created" datetime NOT NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ProductRecommendation
--
CREATE TABLE "catalogue_productrecommendation" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "ranking" smallint unsigned NOT NULL CHECK ("ranking" >= 0), "primary_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "recommendation_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Alter unique_together for productrecommendation (1 constraint(s))
--
CREATE UNIQUE INDEX "catalogue_productrecommendation_primary_id_recommendation_id_da1fdf43_uniq" ON "catalogue_productrecommendation" ("primary_id", "recommendation_id");
--
-- Alter unique_together for productimage (1 constraint(s))
--
CREATE UNIQUE INDEX "catalogue_productimage_product_id_display_order_2df78171_uniq" ON "catalogue_productimage" ("product_id", "display_order");
--
-- Alter unique_together for productcategory (1 constraint(s))
--
CREATE UNIQUE INDEX "catalogue_productcategory_product_id_category_id_8f0dbfe2_uniq" ON "catalogue_productcategory" ("product_id", "category_id");
--
-- Alter unique_together for productattributevalue (1 constraint(s))
--
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
--
-- Add field product_class to productattribute
--
ALTER TABLE "catalogue_productattribute" ADD COLUMN "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field attributes to product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable" FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
CREATE INDEX "catalogue_category_full_name_7682bdd5" ON "catalogue_category" ("full_name");
CREATE INDEX "catalogue_productattribute_code_9ffea293" ON "catalogue_productattribute" ("code");
CREATE INDEX "catalogue_productattribute_option_group_id_6b422dc2" ON "catalogue_productattribute" ("option_group_id");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productcategory_category_id_176db535" ON "catalogue_productcategory" ("category_id");
CREATE INDEX "catalogue_productcategory_product_id_846a4061" ON "catalogue_productcategory" ("product_id");
CREATE UNIQUE INDEX "catalogue_productclass_options_productclass_id_option_id_2266c635_uniq" ON "catalogue_productclass_options" ("productclass_id", "option_id");
CREATE INDEX "catalogue_productclass_options_productclass_id_732df4c8" ON "catalogue_productclass_options" ("productclass_id");
CREATE INDEX "catalogue_productclass_options_option_id_b099542c" ON "catalogue_productclass_options" ("option_id");
CREATE INDEX "catalogue_productimage_product_id_49474fe8" ON "catalogue_productimage" ("product_id");
CREATE INDEX "catalogue_productrecommendation_primary_id_6e51a55c" ON "catalogue_productrecommendation" ("primary_id");
CREATE INDEX "catalogue_productrecommendation_recommendation_id_daf8ae95" ON "catalogue_productrecommendation" ("recommendation_id");
CREATE INDEX "catalogue_productattribute_product_class_id_7af808ec" ON "catalogue_productattribute" ("product_class_id");
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
--
-- Add field categories to product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable" FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
--
-- Add field parent to product
--
ALTER TABLE "catalogue_product" ADD COLUMN "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field product_class to product
--
ALTER TABLE "catalogue_product" ADD COLUMN "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field product_options to product
--
CREATE TABLE "catalogue_product_product_options" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "option_id" bigint NOT NULL REFERENCES "catalogue_option" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Add field recommended_products to product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id" FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE UNIQUE INDEX "catalogue_product_product_options_product_id_option_id_9b3abb31_uniq" ON "catalogue_product_product_options" ("product_id", "option_id");
CREATE INDEX "catalogue_product_product_options_product_id_ad2b46bd" ON "catalogue_product_product_options" ("product_id");
CREATE INDEX "catalogue_product_product_options_option_id_ff470e13" ON "catalogue_product_product_options" ("option_id");
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
--
-- Add field group to attributeoption
--
CREATE TABLE "new__catalogue_attributeoption" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "option" varchar(255) NOT NULL, "group_id" bigint NOT NULL REFERENCES "catalogue_attributeoptiongroup" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_attributeoption" ("id", "option", "group_id") SELECT "id", "option", NULL FROM "catalogue_attributeoption";
DROP TABLE "catalogue_attributeoption";
ALTER TABLE "new__catalogue_attributeoption" RENAME TO "catalogue_attributeoption";
CREATE INDEX "catalogue_attributeoption_group_id_3d4a5e24" ON "catalogue_attributeoption" ("group_id");
COMMIT;


-- Migration: analytics 0001_initial
BEGIN;
--
-- Create model ProductRecord
--
CREATE TABLE "analytics_productrecord" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "num_views" integer unsigned NOT NULL CHECK ("num_views" >= 0), "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_purchases" integer unsigned NOT NULL CHECK ("num_purchases" >= 0), "score" real NOT NULL);
--
-- Create model UserProductView
--
CREATE TABLE "analytics_userproductview" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL);
--
-- Create model UserRecord
--
CREATE TABLE "analytics_userrecord" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "num_product_views" integer unsigned NOT NULL CHECK ("num_product_views" >= 0), "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "num_order_lines" integer unsigned NOT NULL CHECK ("num_order_lines" >= 0), "num_order_items" integer unsigned NOT NULL CHECK ("num_order_items" >= 0), "total_spent" decimal NOT NULL, "date_last_order" datetime NULL, "user_id" integer NOT NULL UNIQUE REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model UserSearch
--
CREATE TABLE "analytics_usersearch" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "query" varchar(255) NOT NULL, "date_created" datetime NOT NULL, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "analytics_productrecord_num_purchases_405301a0" ON "analytics_productrecord" ("num_purchases");
CREATE INDEX "analytics_userrecord_num_orders_b352ffd1" ON "analytics_userrecord" ("num_orders");
CREATE INDEX "analytics_userrecord_num_order_lines_97cc087f" ON "analytics_userrecord" ("num_order_lines");
CREATE INDEX "analytics_userrecord_num_order_items_fb2a8304" ON "analytics_userrecord" ("num_order_items");
CREATE INDEX "analytics_usersearch_query_ad36478b" ON "analytics_usersearch" ("query");
CREATE INDEX "analytics_usersearch_user_id_1775992d" ON "analytics_usersearch" ("user_id");
COMMIT;


-- Migration: analytics 0002_auto_20140827_1705
BEGIN;
--
-- Add field product to userproductview
--
CREATE TABLE "new__analytics_userproductview" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__analytics_userproductview" ("id", "date_created", "product_id") SELECT "id", "date_created", NULL FROM "analytics_userproductview";
DROP TABLE "analytics_userproductview";
ALTER TABLE "new__analytics_userproductview" RENAME TO "analytics_userproductview";
CREATE INDEX "analytics_userproductview_product_id_a55b87ad" ON "analytics_userproductview" ("product_id");
--
-- Add field user to userproductview
--
CREATE TABLE "new__analytics_userproductview" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__analytics_userproductview" ("id", "date_created", "product_id", "user_id") SELECT "id", "date_created", "product_id", NULL FROM "analytics_userproductview";
DROP TABLE "analytics_userproductview";
ALTER TABLE "new__analytics_userproductview" RENAME TO "analytics_userproductview";
CREATE INDEX "analytics_userproductview_product_id_a55b87ad" ON "analytics_userproductview" ("product_id");
CREATE INDEX "analytics_userproductview_user_id_5e49a8b1" ON "analytics_userproductview" ("user_id");
--
-- Add field product to productrecord
--
CREATE TABLE "new__analytics_productrecord" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "num_views" integer unsigned NOT NULL CHECK ("num_views" >= 0), "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_purchases" integer unsigned NOT NULL CHECK ("num_purchases" >= 0), "score" real NOT NULL, "product_id" bigint NOT NULL UNIQUE REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__analytics_productrecord" ("id", "num_views", "num_basket_additions", "num_purchases", "score", "product_id") SELECT "id", "num_views", "num_basket_additions", "num_purchases", "score", NULL FROM "analytics_productrecord";
DROP TABLE "analytics_productrecord";
ALTER TABLE "new__analytics_productrecord" RENAME TO "analytics_productrecord";
CREATE INDEX "analytics_productrecord_num_purchases_405301a0" ON "analytics_productrecord" ("num_purchases");
COMMIT;


-- Migration: analytics 0003_auto_20200801_0817
BEGIN;
--
-- Change Meta options on userproductview
--
-- (no-op)
--
-- Change Meta options on usersearch
--
-- (no-op)
COMMIT;


-- Migration: contenttypes 0002_remove_content_type_name
BEGIN;
--
-- Change Meta options on contenttype
--
-- (no-op)
--
-- Alter field name on contenttype
--
CREATE TABLE "new__django_content_type" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(100) NULL, "app_label" varchar(100) NOT NULL, "model" varchar(100) NOT NULL);
INSERT INTO "new__django_content_type" ("id", "app_label", "model", "name") SELECT "id", "app_label", "model", "name" FROM "django_content_type";
DROP TABLE "django_content_type";
ALTER TABLE "new__django_content_type" RENAME TO "django_content_type";
CREATE UNIQUE INDEX "django_content_type_app_label_model_76bd3d3b_uniq" ON "django_content_type" ("app_label", "model");
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
--
-- Remove field name from contenttype
--
ALTER TABLE "django_content_type" DROP COLUMN "name";
COMMIT;


-- Migration: auth 0002_alter_permission_name_max_length
BEGIN;
--
-- Alter field name on permission
--
CREATE TABLE "new__auth_permission" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL, "content_type_id" integer NOT NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "codename" varchar(100) NOT NULL);
INSERT INTO "new__auth_permission" ("id", "content_type_id", "codename", "name") SELECT "id", "content_type_id", "codename", "name" FROM "auth_permission";
DROP TABLE "auth_permission";
ALTER TABLE "new__auth_permission" RENAME TO "auth_permission";
CREATE UNIQUE INDEX "auth_permission_content_type_id_codename_01ab375a_uniq" ON "auth_permission" ("content_type_id", "codename");
CREATE INDEX "auth_permission_content_type_id_2f476e4b" ON "auth_permission" ("content_type_id");
COMMIT;


-- Migration: auth 0003_alter_user_email_max_length
BEGIN;
--
-- Alter field email on user
--
CREATE TABLE "new__auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "email" varchar(254) NOT NULL, "password" varchar(128) NOT NULL, "last_login" datetime NOT NULL, "is_superuser" bool NOT NULL, "username" varchar(30) NOT NULL UNIQUE, "first_name" varchar(30) NOT NULL, "last_name" varchar(30) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL);
INSERT INTO "new__auth_user" ("id", "password", "last_login", "is_superuser", "username", "first_name", "last_name", "is_staff", "is_active", "date_joined", "email") SELECT "id", "password", "last_login", "is_superuser", "username", "first_name", "last_name", "is_staff", "is_active", "date_joined", "email" FROM "auth_user";
DROP TABLE "auth_user";
ALTER TABLE "new__auth_user" RENAME TO "auth_user";
COMMIT;


-- Migration: auth 0004_alter_user_username_opts
BEGIN;
--
-- Alter field username on user
--
-- (no-op)
COMMIT;


-- Migration: auth 0005_alter_user_last_login_null
BEGIN;
--
-- Alter field last_login on user
--
CREATE TABLE "new__auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "last_login" datetime NULL, "password" varchar(128) NOT NULL, "is_superuser" bool NOT NULL, "username" varchar(30) NOT NULL UNIQUE, "first_name" varchar(30) NOT NULL, "last_name" varchar(30) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL);
INSERT INTO "new__auth_user" ("id", "password", "is_superuser", "username", "first_name", "last_name", "email", "is_staff", "is_active", "date_joined", "last_login") SELECT "id", "password", "is_superuser", "username", "first_name", "last_name", "email", "is_staff", "is_active", "date_joined", "last_login" FROM "auth_user";
DROP TABLE "auth_user";
ALTER TABLE "new__auth_user" RENAME TO "auth_user";
COMMIT;


-- Migration: auth 0007_alter_validators_add_error_messages
BEGIN;
--
-- Alter field username on user
--
-- (no-op)
COMMIT;


-- Migration: auth 0008_alter_user_username_max_length
BEGIN;
--
-- Alter field username on user
--
CREATE TABLE "new__auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "username" varchar(150) NOT NULL UNIQUE, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "first_name" varchar(30) NOT NULL, "last_name" varchar(30) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL);
INSERT INTO "new__auth_user" ("id", "password", "last_login", "is_superuser", "first_name", "last_name", "email", "is_staff", "is_active", "date_joined", "username") SELECT "id", "password", "last_login", "is_superuser", "first_name", "last_name", "email", "is_staff", "is_active", "date_joined", "username" FROM "auth_user";
DROP TABLE "auth_user";
ALTER TABLE "new__auth_user" RENAME TO "auth_user";
COMMIT;


-- Migration: auth 0009_alter_user_last_name_max_length
BEGIN;
--
-- Alter field last_name on user
--
CREATE TABLE "new__auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "last_name" varchar(150) NOT NULL, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "username" varchar(150) NOT NULL UNIQUE, "first_name" varchar(30) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL);
INSERT INTO "new__auth_user" ("id", "password", "last_login", "is_superuser", "username", "first_name", "email", "is_staff", "is_active", "date_joined", "last_name") SELECT "id", "password", "last_login", "is_superuser", "username", "first_name", "email", "is_staff", "is_active", "date_joined", "last_name" FROM "auth_user";
DROP TABLE "auth_user";
ALTER TABLE "new__auth_user" RENAME TO "auth_user";
COMMIT;


-- Migration: auth 0010_alter_group_name_max_length
BEGIN;
--
-- Alter field name on group
--
CREATE TABLE "new__auth_group" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(150) NOT NULL UNIQUE);
INSERT INTO "new__auth_group" ("id", "name") SELECT "id", "name" FROM "auth_group";
DROP TABLE "auth_group";
ALTER TABLE "new__auth_group" RENAME TO "auth_group";
COMMIT;


-- Migration: auth 0011_update_proxy_permissions
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: auth 0012_alter_user_first_name_max_length
BEGIN;
--
-- Alter field first_name on user
--
CREATE TABLE "new__auth_user" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "first_name" varchar(150) NOT NULL, "password" varchar(128) NOT NULL, "last_login" datetime NULL, "is_superuser" bool NOT NULL, "username" varchar(150) NOT NULL UNIQUE, "last_name" varchar(150) NOT NULL, "email" varchar(254) NOT NULL, "is_staff" bool NOT NULL, "is_active" bool NOT NULL, "date_joined" datetime NOT NULL);
INSERT INTO "new__auth_user" ("id", "password", "last_login", "is_superuser", "username", "last_name", "email", "is_staff", "is_active", "date_joined", "first_name") SELECT "id", "password", "last_login", "is_superuser", "username", "last_name", "email", "is_staff", "is_active", "date_joined", "first_name" FROM "auth_user";
DROP TABLE "auth_user";
ALTER TABLE "new__auth_user" RENAME TO "auth_user";
COMMIT;


-- Migration: sites 0001_initial
BEGIN;
--
-- Create model Site
--
CREATE TABLE "django_site" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "domain" varchar(100) NOT NULL, "name" varchar(50) NOT NULL);
COMMIT;


-- Migration: partner 0001_initial
BEGIN;
--
-- Create model Partner
--
CREATE TABLE "partner_partner" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(128) NOT NULL UNIQUE, "name" varchar(128) NOT NULL);
CREATE TABLE "partner_partner_users" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "partner_id" bigint NOT NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model PartnerAddress
--
CREATE TABLE "partner_partneraddress" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(64) NOT NULL, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "line1" varchar(255) NOT NULL, "line2" varchar(255) NOT NULL, "line3" varchar(255) NOT NULL, "line4" varchar(255) NOT NULL, "state" varchar(255) NOT NULL, "postcode" varchar(64) NOT NULL, "search_text" text NOT NULL, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED, "partner_id" bigint NOT NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model StockAlert
--
CREATE TABLE "partner_stockalert" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "threshold" integer unsigned NOT NULL CHECK ("threshold" >= 0), "status" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "date_closed" datetime NULL);
--
-- Create model StockRecord
--
CREATE TABLE "partner_stockrecord" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "partner_sku" varchar(128) NOT NULL, "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_retail" decimal NULL, "cost_price" decimal NULL, "num_in_stock" integer unsigned NULL CHECK ("num_in_stock" >= 0), "num_allocated" integer NULL, "low_stock_threshold" integer unsigned NULL CHECK ("low_stock_threshold" >= 0), "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "partner_id" bigint NOT NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Alter unique_together for stockrecord (1 constraint(s))
--
CREATE UNIQUE INDEX "partner_stockrecord_partner_id_partner_sku_8441e010_uniq" ON "partner_stockrecord" ("partner_id", "partner_sku");
--
-- Add field stockrecord to stockalert
--
CREATE TABLE "new__partner_stockalert" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "threshold" integer unsigned NOT NULL CHECK ("threshold" >= 0), "status" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "date_closed" datetime NULL, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__partner_stockalert" ("id", "threshold", "status", "date_created", "date_closed", "stockrecord_id") SELECT "id", "threshold", "status", "date_created", "date_closed", NULL FROM "partner_stockalert";
DROP TABLE "partner_stockalert";
ALTER TABLE "new__partner_stockalert" RENAME TO "partner_stockalert";
CREATE UNIQUE INDEX "partner_partner_users_partner_id_user_id_9e5c0517_uniq" ON "partner_partner_users" ("partner_id", "user_id");
CREATE INDEX "partner_partner_users_partner_id_1883dfd9" ON "partner_partner_users" ("partner_id");
CREATE INDEX "partner_partner_users_user_id_d75d6e40" ON "partner_partner_users" ("user_id");
CREATE INDEX "partner_partneraddress_country_id_02c4f979" ON "partner_partneraddress" ("country_id");
CREATE INDEX "partner_partneraddress_partner_id_59551b0a" ON "partner_partneraddress" ("partner_id");
CREATE INDEX "partner_stockrecord_date_updated_e6ae5f14" ON "partner_stockrecord" ("date_updated");
CREATE INDEX "partner_stockrecord_partner_id_4155a586" ON "partner_stockrecord" ("partner_id");
CREATE INDEX "partner_stockrecord_product_id_62fd9e45" ON "partner_stockrecord" ("product_id");
CREATE INDEX "partner_stockalert_stockrecord_id_68ad503a" ON "partner_stockalert" ("stockrecord_id");
COMMIT;


-- Migration: customer 0001_initial
BEGIN;
--
-- Create model CommunicationEventType
--
CREATE TABLE "customer_communicationeventtype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(128) NOT NULL UNIQUE, "name" varchar(255) NOT NULL, "category" varchar(255) NOT NULL, "email_subject_template" varchar(255) NULL, "email_body_template" text NULL, "email_body_html_template" text NULL, "sms_template" varchar(170) NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL);
--
-- Create model Email
--
CREATE TABLE "customer_email" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "subject" text NOT NULL, "body_text" text NOT NULL, "body_html" text NOT NULL, "date_sent" datetime NOT NULL, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model Notification
--
CREATE TABLE "customer_notification" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "subject" varchar(255) NOT NULL, "body" text NOT NULL, "category" varchar(255) NOT NULL, "location" varchar(32) NOT NULL, "date_sent" datetime NOT NULL, "date_read" datetime NULL, "recipient_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "sender_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ProductAlert
--
CREATE TABLE "customer_productalert" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "email" varchar(75) NOT NULL, "key" varchar(128) NOT NULL, "status" varchar(20) NOT NULL, "date_created" datetime NOT NULL, "date_confirmed" datetime NULL, "date_cancelled" datetime NULL, "date_closed" datetime NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "customer_email_user_id_a69ad588" ON "customer_email" ("user_id");
CREATE INDEX "customer_notification_recipient_id_d99de5c8" ON "customer_notification" ("recipient_id");
CREATE INDEX "customer_notification_sender_id_affa1632" ON "customer_notification" ("sender_id");
CREATE INDEX "customer_productalert_email_e5f35f45" ON "customer_productalert" ("email");
CREATE INDEX "customer_productalert_key_a26f3bdc" ON "customer_productalert" ("key");
CREATE INDEX "customer_productalert_product_id_7e529a41" ON "customer_productalert" ("product_id");
CREATE INDEX "customer_productalert_user_id_677ad6d6" ON "customer_productalert" ("user_id");
COMMIT;


-- Migration: basket 0001_initial
BEGIN;
--
-- Create model Basket
--
CREATE TABLE "basket_basket" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "status" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "date_merged" datetime NULL, "date_submitted" datetime NULL);
--
-- Create model Line
--
CREATE TABLE "basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL);
--
-- Create model LineAttribute
--
CREATE TABLE "basket_lineattribute" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value" varchar(255) NOT NULL, "line_id" bigint NOT NULL REFERENCES "basket_line" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_lineattribute_line_id_c41e0cdf" ON "basket_lineattribute" ("line_id");
COMMIT;


-- Migration: basket 0002_auto_20140827_1705
BEGIN;
--
-- Add field option to lineattribute
--
CREATE TABLE "new__basket_lineattribute" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "option_id" bigint NOT NULL REFERENCES "catalogue_option" ("id") DEFERRABLE INITIALLY DEFERRED, "value" varchar(255) NOT NULL, "line_id" bigint NOT NULL REFERENCES "basket_line" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_lineattribute" ("id", "value", "line_id", "option_id") SELECT "id", "value", "line_id", NULL FROM "basket_lineattribute";
DROP TABLE "basket_lineattribute";
ALTER TABLE "new__basket_lineattribute" RENAME TO "basket_lineattribute";
CREATE INDEX "basket_lineattribute_option_id_9387a3f7" ON "basket_lineattribute" ("option_id");
CREATE INDEX "basket_lineattribute_line_id_c41e0cdf" ON "basket_lineattribute" ("line_id");
--
-- Add field basket to line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id") SELECT "id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", NULL FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
--
-- Add field product to line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id") SELECT "id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", NULL FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
CREATE INDEX "basket_line_product_id_303d743e" ON "basket_line" ("product_id");
--
-- Add field stockrecord to line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id") SELECT "id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", NULL FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
CREATE INDEX "basket_line_product_id_303d743e" ON "basket_line" ("product_id");
CREATE INDEX "basket_line_stockrecord_id_7039d8a4" ON "basket_line" ("stockrecord_id");
--
-- Alter unique_together for line (1 constraint(s))
--
CREATE UNIQUE INDEX "basket_line_basket_id_line_reference_8977e974_uniq" ON "basket_line" ("basket_id", "line_reference");
--
-- Add field owner to basket
--
ALTER TABLE "basket_basket" ADD COLUMN "owner_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "basket_basket_owner_id_3a018de5" ON "basket_basket" ("owner_id");
COMMIT;


-- Migration: order 0001_initial
BEGIN;
--
-- Create model BillingAddress
--
CREATE TABLE "order_billingaddress" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(64) NOT NULL, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "line1" varchar(255) NOT NULL, "line2" varchar(255) NOT NULL, "line3" varchar(255) NOT NULL, "line4" varchar(255) NOT NULL, "state" varchar(255) NOT NULL, "postcode" varchar(64) NOT NULL, "search_text" text NOT NULL, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model CommunicationEvent
--
CREATE TABLE "order_communicationevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "customer_communicationeventtype" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model Line
--
CREATE TABLE "order_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "partner_name" varchar(128) NOT NULL, "partner_sku" varchar(128) NOT NULL, "partner_line_reference" varchar(128) NOT NULL, "partner_line_notes" text NOT NULL, "title" varchar(255) NOT NULL, "upc" varchar(128) NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "line_price_incl_tax" decimal NOT NULL, "line_price_excl_tax" decimal NOT NULL, "line_price_before_discounts_incl_tax" decimal NOT NULL, "line_price_before_discounts_excl_tax" decimal NOT NULL, "unit_cost_price" decimal NULL, "unit_price_incl_tax" decimal NULL, "unit_price_excl_tax" decimal NULL, "unit_retail_price" decimal NULL, "status" varchar(255) NOT NULL, "est_dispatch_date" date NULL);
--
-- Create model LineAttribute
--
CREATE TABLE "order_lineattribute" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "type" varchar(128) NOT NULL, "value" varchar(255) NOT NULL, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED, "option_id" bigint NULL REFERENCES "catalogue_option" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model LinePrice
--
CREATE TABLE "order_lineprice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_incl_tax" decimal NOT NULL, "price_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model Order
--
CREATE TABLE "order_order" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "number" varchar(128) NOT NULL UNIQUE, "currency" varchar(12) NOT NULL, "total_incl_tax" decimal NOT NULL, "total_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "shipping_method" varchar(128) NOT NULL, "shipping_code" varchar(128) NOT NULL, "status" varchar(100) NOT NULL, "guest_email" varchar(75) NOT NULL, "date_placed" datetime NOT NULL, "basket_id" bigint NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "billing_address_id" bigint NULL REFERENCES "order_billingaddress" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model OrderDiscount
--
CREATE TABLE "order_orderdiscount" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "category" varchar(64) NOT NULL, "offer_id" integer unsigned NULL CHECK ("offer_id" >= 0), "offer_name" varchar(128) NOT NULL, "voucher_id" integer unsigned NULL CHECK ("voucher_id" >= 0), "voucher_code" varchar(128) NOT NULL, "frequency" integer unsigned NULL CHECK ("frequency" >= 0), "amount" decimal NOT NULL, "message" text NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model OrderNote
--
CREATE TABLE "order_ordernote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "note_type" varchar(128) NOT NULL, "message" text NOT NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model PaymentEvent
--
CREATE TABLE "order_paymentevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "date_created" datetime NOT NULL);
--
-- Create model PaymentEventQuantity
--
CREATE TABLE "order_paymenteventquantity" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "event_id" bigint NOT NULL REFERENCES "order_paymentevent" ("id") DEFERRABLE INITIALLY DEFERRED, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model PaymentEventType
--
CREATE TABLE "order_paymenteventtype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL UNIQUE, "code" varchar(128) NOT NULL UNIQUE);
--
-- Create model ShippingAddress
--
CREATE TABLE "order_shippingaddress" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "title" varchar(64) NOT NULL, "first_name" varchar(255) NOT NULL, "last_name" varchar(255) NOT NULL, "line1" varchar(255) NOT NULL, "line2" varchar(255) NOT NULL, "line3" varchar(255) NOT NULL, "line4" varchar(255) NOT NULL, "state" varchar(255) NOT NULL, "postcode" varchar(64) NOT NULL, "search_text" text NOT NULL, "phone_number" varchar(128) NOT NULL, "notes" text NOT NULL, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ShippingEvent
--
CREATE TABLE "order_shippingevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "notes" text NOT NULL, "date_created" datetime NOT NULL);
--
-- Create model ShippingEventQuantity
--
CREATE TABLE "order_shippingeventquantity" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "event_id" bigint NOT NULL REFERENCES "order_shippingevent" ("id") DEFERRABLE INITIALLY DEFERRED, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model ShippingEventType
--
CREATE TABLE "order_shippingeventtype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL UNIQUE, "code" varchar(128) NOT NULL UNIQUE);
--
-- Alter unique_together for shippingeventquantity (1 constraint(s))
--
CREATE UNIQUE INDEX "order_shippingeventquantity_event_id_line_id_91687107_uniq" ON "order_shippingeventquantity" ("event_id", "line_id");
--
-- Add field event_type to shippingevent
--
CREATE TABLE "new__order_shippingevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "notes" text NOT NULL, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_shippingeventtype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_shippingevent" ("id", "notes", "date_created", "event_type_id") SELECT "id", "notes", "date_created", NULL FROM "order_shippingevent";
DROP TABLE "order_shippingevent";
ALTER TABLE "new__order_shippingevent" RENAME TO "order_shippingevent";
CREATE INDEX "order_billingaddress_country_id_17f57dca" ON "order_billingaddress" ("country_id");
CREATE INDEX "order_communicationevent_event_type_id_4bc9ee29" ON "order_communicationevent" ("event_type_id");
CREATE INDEX "order_lineattribute_line_id_adf6dd87" ON "order_lineattribute" ("line_id");
CREATE INDEX "order_lineattribute_option_id_b54d597c" ON "order_lineattribute" ("option_id");
CREATE INDEX "order_lineprice_line_id_2de52446" ON "order_lineprice" ("line_id");
CREATE INDEX "order_order_date_placed_506a9365" ON "order_order" ("date_placed");
CREATE INDEX "order_order_basket_id_8b0acbb2" ON "order_order" ("basket_id");
CREATE INDEX "order_order_billing_address_id_8fe537cf" ON "order_order" ("billing_address_id");
CREATE INDEX "order_orderdiscount_offer_name_706d6119" ON "order_orderdiscount" ("offer_name");
CREATE INDEX "order_orderdiscount_voucher_code_6ee4f360" ON "order_orderdiscount" ("voucher_code");
CREATE INDEX "order_orderdiscount_order_id_bc91e123" ON "order_orderdiscount" ("order_id");
CREATE INDEX "order_ordernote_order_id_7d97583d" ON "order_ordernote" ("order_id");
CREATE INDEX "order_ordernote_user_id_48d7a672" ON "order_ordernote" ("user_id");
CREATE INDEX "order_paymenteventquantity_event_id_a540165a" ON "order_paymenteventquantity" ("event_id");
CREATE INDEX "order_paymenteventquantity_line_id_df44b021" ON "order_paymenteventquantity" ("line_id");
CREATE INDEX "order_shippingaddress_country_id_29abf9a0" ON "order_shippingaddress" ("country_id");
CREATE INDEX "order_shippingeventquantity_event_id_1c7fb9c7" ON "order_shippingeventquantity" ("event_id");
CREATE INDEX "order_shippingeventquantity_line_id_3b089ee0" ON "order_shippingeventquantity" ("line_id");
CREATE INDEX "order_shippingevent_event_type_id_9f1efb20" ON "order_shippingevent" ("event_type_id");
--
-- Add field lines to shippingevent
--
CREATE TABLE "new__order_shippingevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "notes" text NOT NULL, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_shippingeventtype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_shippingevent" ("id", "notes", "date_created", "event_type_id") SELECT "id", "notes", "date_created", "event_type_id" FROM "order_shippingevent";
DROP TABLE "order_shippingevent";
ALTER TABLE "new__order_shippingevent" RENAME TO "order_shippingevent";
CREATE INDEX "order_shippingevent_event_type_id_9f1efb20" ON "order_shippingevent" ("event_type_id");
--
-- Add field order to shippingevent
--
CREATE TABLE "new__order_shippingevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "notes" text NOT NULL, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_shippingeventtype" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_shippingevent" ("id", "notes", "date_created", "event_type_id", "order_id") SELECT "id", "notes", "date_created", "event_type_id", NULL FROM "order_shippingevent";
DROP TABLE "order_shippingevent";
ALTER TABLE "new__order_shippingevent" RENAME TO "order_shippingevent";
CREATE INDEX "order_shippingevent_event_type_id_9f1efb20" ON "order_shippingevent" ("event_type_id");
CREATE INDEX "order_shippingevent_order_id_8c031fb6" ON "order_shippingevent" ("order_id");
--
-- Alter unique_together for paymenteventquantity (1 constraint(s))
--
CREATE UNIQUE INDEX "order_paymenteventquantity_event_id_line_id_765c5209_uniq" ON "order_paymenteventquantity" ("event_id", "line_id");
--
-- Add field event_type to paymentevent
--
CREATE TABLE "new__order_paymentevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_paymenteventtype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_paymentevent" ("id", "amount", "reference", "date_created", "event_type_id") SELECT "id", "amount", "reference", "date_created", NULL FROM "order_paymentevent";
DROP TABLE "order_paymentevent";
ALTER TABLE "new__order_paymentevent" RENAME TO "order_paymentevent";
CREATE INDEX "order_paymentevent_event_type_id_568c7161" ON "order_paymentevent" ("event_type_id");
--
-- Add field lines to paymentevent
--
CREATE TABLE "new__order_paymentevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_paymenteventtype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_paymentevent" ("id", "amount", "reference", "date_created", "event_type_id") SELECT "id", "amount", "reference", "date_created", "event_type_id" FROM "order_paymentevent";
DROP TABLE "order_paymentevent";
ALTER TABLE "new__order_paymentevent" RENAME TO "order_paymentevent";
CREATE INDEX "order_paymentevent_event_type_id_568c7161" ON "order_paymentevent" ("event_type_id");
--
-- Add field order to paymentevent
--
CREATE TABLE "new__order_paymentevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_paymenteventtype" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_paymentevent" ("id", "amount", "reference", "date_created", "event_type_id", "order_id") SELECT "id", "amount", "reference", "date_created", "event_type_id", NULL FROM "order_paymentevent";
DROP TABLE "order_paymentevent";
ALTER TABLE "new__order_paymentevent" RENAME TO "order_paymentevent";
CREATE INDEX "order_paymentevent_event_type_id_568c7161" ON "order_paymentevent" ("event_type_id");
CREATE INDEX "order_paymentevent_order_id_395b3e82" ON "order_paymentevent" ("order_id");
--
-- Add field shipping_event to paymentevent
--
ALTER TABLE "order_paymentevent" ADD COLUMN "shipping_event_id" bigint NULL REFERENCES "order_shippingevent" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field shipping_address to order
--
ALTER TABLE "order_order" ADD COLUMN "shipping_address_id" bigint NULL REFERENCES "order_shippingaddress" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field site to order
--
ALTER TABLE "order_order" ADD COLUMN "site_id" integer NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field user to order
--
ALTER TABLE "order_order" ADD COLUMN "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field order to lineprice
--
CREATE TABLE "new__order_lineprice" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_incl_tax" decimal NOT NULL, "price_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_lineprice" ("id", "quantity", "price_incl_tax", "price_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "line_id", "order_id") SELECT "id", "quantity", "price_incl_tax", "price_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "line_id", NULL FROM "order_lineprice";
DROP TABLE "order_lineprice";
ALTER TABLE "new__order_lineprice" RENAME TO "order_lineprice";
CREATE INDEX "order_paymentevent_shipping_event_id_213dcfb8" ON "order_paymentevent" ("shipping_event_id");
CREATE INDEX "order_order_shipping_address_id_57e64931" ON "order_order" ("shipping_address_id");
CREATE INDEX "order_order_site_id_e27f3526" ON "order_order" ("site_id");
CREATE INDEX "order_order_user_id_7cf9bc2b" ON "order_order" ("user_id");
CREATE INDEX "order_lineprice_line_id_2de52446" ON "order_lineprice" ("line_id");
CREATE INDEX "order_lineprice_order_id_66792e56" ON "order_lineprice" ("order_id");
--
-- Add field order to line
--
CREATE TABLE "new__order_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "partner_name" varchar(128) NOT NULL, "partner_sku" varchar(128) NOT NULL, "partner_line_reference" varchar(128) NOT NULL, "partner_line_notes" text NOT NULL, "title" varchar(255) NOT NULL, "upc" varchar(128) NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "line_price_incl_tax" decimal NOT NULL, "line_price_excl_tax" decimal NOT NULL, "line_price_before_discounts_incl_tax" decimal NOT NULL, "line_price_before_discounts_excl_tax" decimal NOT NULL, "unit_cost_price" decimal NULL, "unit_price_incl_tax" decimal NULL, "unit_price_excl_tax" decimal NULL, "unit_retail_price" decimal NULL, "status" varchar(255) NOT NULL, "est_dispatch_date" date NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_line" ("id", "partner_name", "partner_sku", "partner_line_reference", "partner_line_notes", "title", "upc", "quantity", "line_price_incl_tax", "line_price_excl_tax", "line_price_before_discounts_incl_tax", "line_price_before_discounts_excl_tax", "unit_cost_price", "unit_price_incl_tax", "unit_price_excl_tax", "unit_retail_price", "status", "est_dispatch_date", "order_id") SELECT "id", "partner_name", "partner_sku", "partner_line_reference", "partner_line_notes", "title", "upc", "quantity", "line_price_incl_tax", "line_price_excl_tax", "line_price_before_discounts_incl_tax", "line_price_before_discounts_excl_tax", "unit_cost_price", "unit_price_incl_tax", "unit_price_excl_tax", "unit_retail_price", "status", "est_dispatch_date", NULL FROM "order_line";
DROP TABLE "order_line";
ALTER TABLE "new__order_line" RENAME TO "order_line";
CREATE INDEX "order_line_order_id_b9148391" ON "order_line" ("order_id");
--
-- Add field partner to line
--
ALTER TABLE "order_line" ADD COLUMN "partner_id" bigint NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field product to line
--
ALTER TABLE "order_line" ADD COLUMN "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field stockrecord to line
--
ALTER TABLE "order_line" ADD COLUMN "stockrecord_id" bigint NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field order to communicationevent
--
CREATE TABLE "new__order_communicationevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "customer_communicationeventtype" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_communicationevent" ("id", "date_created", "event_type_id", "order_id") SELECT "id", "date_created", "event_type_id", NULL FROM "order_communicationevent";
DROP TABLE "order_communicationevent";
ALTER TABLE "new__order_communicationevent" RENAME TO "order_communicationevent";
CREATE INDEX "order_line_partner_id_258a2fb9" ON "order_line" ("partner_id");
CREATE INDEX "order_line_product_id_e620902d" ON "order_line" ("product_id");
CREATE INDEX "order_line_stockrecord_id_1d65aff5" ON "order_line" ("stockrecord_id");
CREATE INDEX "order_communicationevent_event_type_id_4bc9ee29" ON "order_communicationevent" ("event_type_id");
CREATE INDEX "order_communicationevent_order_id_94e784ac" ON "order_communicationevent" ("order_id");
COMMIT;


-- Migration: offer 0001_initial
BEGIN;
--
-- Create model Benefit
--
CREATE TABLE "offer_benefit" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "type" varchar(128) NOT NULL, "value" decimal NULL, "max_affected_items" integer unsigned NULL CHECK ("max_affected_items" >= 0), "proxy_class" varchar(255) NULL UNIQUE);
--
-- Create model Condition
--
CREATE TABLE "offer_condition" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "type" varchar(128) NOT NULL, "value" decimal NULL, "proxy_class" varchar(255) NULL UNIQUE);
--
-- Create model ConditionalOffer
--
CREATE TABLE "offer_conditionaloffer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL UNIQUE, "slug" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "offer_type" varchar(128) NOT NULL, "status" varchar(64) NOT NULL, "priority" integer NOT NULL, "start_datetime" datetime NULL, "end_datetime" datetime NULL, "max_global_applications" integer unsigned NULL CHECK ("max_global_applications" >= 0), "max_user_applications" integer unsigned NULL CHECK ("max_user_applications" >= 0), "max_basket_applications" integer unsigned NULL CHECK ("max_basket_applications" >= 0), "max_discount" decimal NULL, "total_discount" decimal NOT NULL, "num_applications" integer unsigned NOT NULL CHECK ("num_applications" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "redirect_url" varchar(200) NOT NULL, "date_created" datetime NOT NULL, "benefit_id" bigint NOT NULL REFERENCES "offer_benefit" ("id") DEFERRABLE INITIALLY DEFERRED, "condition_id" bigint NOT NULL REFERENCES "offer_condition" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model Range
--
CREATE TABLE "offer_range" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL UNIQUE, "slug" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "is_public" bool NOT NULL, "includes_all_products" bool NOT NULL, "proxy_class" varchar(255) NULL UNIQUE, "date_created" datetime NOT NULL);
CREATE TABLE "offer_range_classes" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "productclass_id" bigint NOT NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE "offer_range_excluded_products" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE TABLE "offer_range_included_categories" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "category_id" bigint NOT NULL REFERENCES "catalogue_category" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model RangeProduct
--
CREATE TABLE "offer_rangeproduct" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "display_order" integer NOT NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model RangeProductFileUpload
--
CREATE TABLE "offer_rangeproductfileupload" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "filepath" varchar(255) NOT NULL, "size" integer unsigned NOT NULL CHECK ("size" >= 0), "date_uploaded" datetime NOT NULL, "status" varchar(32) NOT NULL, "error_message" varchar(255) NOT NULL, "date_processed" datetime NULL, "num_new_skus" integer unsigned NULL CHECK ("num_new_skus" >= 0), "num_unknown_skus" integer unsigned NULL CHECK ("num_unknown_skus" >= 0), "num_duplicate_skus" integer unsigned NULL CHECK ("num_duplicate_skus" >= 0), "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "uploaded_by_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Alter unique_together for rangeproduct (1 constraint(s))
--
CREATE UNIQUE INDEX "offer_rangeproduct_range_id_product_id_c46b1be8_uniq" ON "offer_rangeproduct" ("range_id", "product_id");
--
-- Add field included_products to range
--
CREATE TABLE "new__offer_range" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL UNIQUE, "slug" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "is_public" bool NOT NULL, "includes_all_products" bool NOT NULL, "proxy_class" varchar(255) NULL UNIQUE, "date_created" datetime NOT NULL);
INSERT INTO "new__offer_range" ("id", "name", "slug", "description", "is_public", "includes_all_products", "proxy_class", "date_created") SELECT "id", "name", "slug", "description", "is_public", "includes_all_products", "proxy_class", "date_created" FROM "offer_range";
DROP TABLE "offer_range";
ALTER TABLE "new__offer_range" RENAME TO "offer_range";
CREATE INDEX "offer_conditionaloffer_benefit_id_f43f68b5" ON "offer_conditionaloffer" ("benefit_id");
CREATE INDEX "offer_conditionaloffer_condition_id_e6baa945" ON "offer_conditionaloffer" ("condition_id");
CREATE UNIQUE INDEX "offer_range_classes_range_id_productclass_id_28eeefae_uniq" ON "offer_range_classes" ("range_id", "productclass_id");
CREATE INDEX "offer_range_classes_range_id_7d3e573e" ON "offer_range_classes" ("range_id");
CREATE INDEX "offer_range_classes_productclass_id_6f6de46d" ON "offer_range_classes" ("productclass_id");
CREATE UNIQUE INDEX "offer_range_excluded_products_range_id_product_id_eb1cfe87_uniq" ON "offer_range_excluded_products" ("range_id", "product_id");
CREATE INDEX "offer_range_excluded_products_range_id_cce4a032" ON "offer_range_excluded_products" ("range_id");
CREATE INDEX "offer_range_excluded_products_product_id_78c49bfc" ON "offer_range_excluded_products" ("product_id");
CREATE UNIQUE INDEX "offer_range_included_categories_range_id_category_id_a661d336_uniq" ON "offer_range_included_categories" ("range_id", "category_id");
CREATE INDEX "offer_range_included_categories_range_id_1b616138" ON "offer_range_included_categories" ("range_id");
CREATE INDEX "offer_range_included_categories_category_id_c61569a5" ON "offer_range_included_categories" ("category_id");
CREATE INDEX "offer_rangeproduct_product_id_723b3ea3" ON "offer_rangeproduct" ("product_id");
CREATE INDEX "offer_rangeproduct_range_id_ee358495" ON "offer_rangeproduct" ("range_id");
CREATE INDEX "offer_rangeproductfileupload_range_id_c055ebf8" ON "offer_rangeproductfileupload" ("range_id");
CREATE INDEX "offer_rangeproductfileupload_uploaded_by_id_c01a3250" ON "offer_rangeproductfileupload" ("uploaded_by_id");
--
-- Add field range to condition
--
ALTER TABLE "offer_condition" ADD COLUMN "range_id" bigint NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field range to benefit
--
ALTER TABLE "offer_benefit" ADD COLUMN "range_id" bigint NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Create proxy model AbsoluteDiscountBenefit
--
-- (no-op)
--
-- Create proxy model CountCondition
--
-- (no-op)
--
-- Create proxy model CoverageCondition
--
-- (no-op)
--
-- Create proxy model FixedPriceBenefit
--
-- (no-op)
--
-- Create proxy model MultibuyDiscountBenefit
--
-- (no-op)
--
-- Create proxy model PercentageDiscountBenefit
--
-- (no-op)
--
-- Create proxy model ShippingBenefit
--
-- (no-op)
--
-- Create proxy model ShippingAbsoluteDiscountBenefit
--
-- (no-op)
--
-- Create proxy model ShippingFixedPriceBenefit
--
-- (no-op)
--
-- Create proxy model ShippingPercentageDiscountBenefit
--
-- (no-op)
--
-- Create proxy model ValueCondition
--
-- (no-op)
CREATE INDEX "offer_condition_range_id_b023a2aa" ON "offer_condition" ("range_id");
CREATE INDEX "offer_benefit_range_id_ab19c5ab" ON "offer_benefit" ("range_id");
COMMIT;


-- Migration: voucher 0001_initial
BEGIN;
--
-- Create model Voucher
--
CREATE TABLE "voucher_voucher" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "usage" varchar(128) NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "total_discount" decimal NOT NULL, "date_created" date NOT NULL);
CREATE TABLE "voucher_voucher_offers" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "voucher_id" bigint NOT NULL REFERENCES "voucher_voucher" ("id") DEFERRABLE INITIALLY DEFERRED, "conditionaloffer_id" bigint NOT NULL REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model VoucherApplication
--
CREATE TABLE "voucher_voucherapplication" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" date NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "voucher_id" bigint NOT NULL REFERENCES "voucher_voucher" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "voucher_voucher_offers_voucher_id_conditionaloffer_id_01628a7f_uniq" ON "voucher_voucher_offers" ("voucher_id", "conditionaloffer_id");
CREATE INDEX "voucher_voucher_offers_voucher_id_7f9c575d" ON "voucher_voucher_offers" ("voucher_id");
CREATE INDEX "voucher_voucher_offers_conditionaloffer_id_f9682bfb" ON "voucher_voucher_offers" ("conditionaloffer_id");
CREATE INDEX "voucher_voucherapplication_order_id_30248a05" ON "voucher_voucherapplication" ("order_id");
CREATE INDEX "voucher_voucherapplication_user_id_df53a393" ON "voucher_voucherapplication" ("user_id");
CREATE INDEX "voucher_voucherapplication_voucher_id_5204edb7" ON "voucher_voucherapplication" ("voucher_id");
COMMIT;


-- Migration: basket 0003_basket_vouchers
BEGIN;
--
-- Add field vouchers to basket
--
CREATE TABLE "basket_basket_vouchers" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "voucher_id" bigint NOT NULL REFERENCES "voucher_voucher" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "basket_basket_vouchers_basket_id_voucher_id_0731eee2_uniq" ON "basket_basket_vouchers" ("basket_id", "voucher_id");
CREATE INDEX "basket_basket_vouchers_basket_id_f857c2f8" ON "basket_basket_vouchers" ("basket_id");
CREATE INDEX "basket_basket_vouchers_voucher_id_c2b66981" ON "basket_basket_vouchers" ("voucher_id");
COMMIT;


-- Migration: basket 0004_auto_20141007_2032
BEGIN;
--
-- Alter field price_currency on line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "price_currency" varchar(12) NOT NULL, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "line_reference", "quantity", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id", "price_currency") SELECT "id", "line_reference", "quantity", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id", "price_currency" FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE UNIQUE INDEX "basket_line_basket_id_line_reference_8977e974_uniq" ON "basket_line" ("basket_id", "line_reference");
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
CREATE INDEX "basket_line_product_id_303d743e" ON "basket_line" ("product_id");
CREATE INDEX "basket_line_stockrecord_id_7039d8a4" ON "basket_line" ("stockrecord_id");
COMMIT;


-- Migration: basket 0005_auto_20150604_1450
BEGIN;
--
-- Alter field vouchers on basket
--
CREATE TABLE "new__basket_basket_vouchers" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "voucher_id" bigint NOT NULL REFERENCES "voucher_voucher" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_basket_vouchers" ("id", "voucher_id", "basket_id") SELECT "id", "voucher_id", "basket_id" FROM "basket_basket_vouchers";
DROP TABLE "basket_basket_vouchers";
ALTER TABLE "new__basket_basket_vouchers" RENAME TO "basket_basket_vouchers";
CREATE UNIQUE INDEX "basket_basket_vouchers_basket_id_voucher_id_0731eee2_uniq" ON "basket_basket_vouchers" ("basket_id", "voucher_id");
CREATE INDEX "basket_basket_vouchers_basket_id_f857c2f8" ON "basket_basket_vouchers" ("basket_id");
CREATE INDEX "basket_basket_vouchers_voucher_id_c2b66981" ON "basket_basket_vouchers" ("voucher_id");
COMMIT;


-- Migration: basket 0006_auto_20160111_1108
BEGIN;
--
-- Change Meta options on line
--
-- (no-op)
COMMIT;


-- Migration: basket 0007_slugfield_noop
BEGIN;
--
-- Alter field line_reference on line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id", "line_reference") SELECT "id", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id", "line_reference" FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE UNIQUE INDEX "basket_line_basket_id_line_reference_8977e974_uniq" ON "basket_line" ("basket_id", "line_reference");
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
CREATE INDEX "basket_line_product_id_303d743e" ON "basket_line" ("product_id");
CREATE INDEX "basket_line_stockrecord_id_7039d8a4" ON "basket_line" ("stockrecord_id");
COMMIT;


-- Migration: basket 0008_auto_20181115_1953
BEGIN;
--
-- Alter field date_created on line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "basket_id", "product_id", "stockrecord_id", "date_created") SELECT "id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "basket_id", "product_id", "stockrecord_id", "date_created" FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE UNIQUE INDEX "basket_line_basket_id_line_reference_8977e974_uniq" ON "basket_line" ("basket_id", "line_reference");
CREATE INDEX "basket_line_date_created_eb0dfb1b" ON "basket_line" ("date_created");
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
CREATE INDEX "basket_line_product_id_303d743e" ON "basket_line" ("product_id");
CREATE INDEX "basket_line_stockrecord_id_7039d8a4" ON "basket_line" ("stockrecord_id");
COMMIT;


-- Migration: basket 0009_line_date_updated
BEGIN;
--
-- Add field date_updated to line
--
CREATE TABLE "new__basket_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_updated" datetime NOT NULL, "line_reference" varchar(128) NOT NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "price_currency" varchar(12) NOT NULL, "price_excl_tax" decimal NULL, "price_incl_tax" decimal NULL, "date_created" datetime NOT NULL, "basket_id" bigint NOT NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_line" ("id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id", "date_updated") SELECT "id", "line_reference", "quantity", "price_currency", "price_excl_tax", "price_incl_tax", "date_created", "basket_id", "product_id", "stockrecord_id", '2026-01-31 22:25:39.260286' FROM "basket_line";
DROP TABLE "basket_line";
ALTER TABLE "new__basket_line" RENAME TO "basket_line";
CREATE UNIQUE INDEX "basket_line_basket_id_line_reference_8977e974_uniq" ON "basket_line" ("basket_id", "line_reference");
CREATE INDEX "basket_line_date_updated_a74d069d" ON "basket_line" ("date_updated");
CREATE INDEX "basket_line_line_reference_08e91113" ON "basket_line" ("line_reference");
CREATE INDEX "basket_line_date_created_eb0dfb1b" ON "basket_line" ("date_created");
CREATE INDEX "basket_line_basket_id_b615c905" ON "basket_line" ("basket_id");
CREATE INDEX "basket_line_product_id_303d743e" ON "basket_line" ("product_id");
CREATE INDEX "basket_line_stockrecord_id_7039d8a4" ON "basket_line" ("stockrecord_id");
COMMIT;


-- Migration: basket 0010_convert_to_valid_json
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: basket 0011_json_basket_option
BEGIN;
--
-- Alter field value on lineattribute
--
CREATE TABLE "new__basket_lineattribute" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value" text NOT NULL CHECK ((JSON_VALID("value") OR "value" IS NULL)), "line_id" bigint NOT NULL REFERENCES "basket_line" ("id") DEFERRABLE INITIALLY DEFERRED, "option_id" bigint NOT NULL REFERENCES "catalogue_option" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__basket_lineattribute" ("id", "line_id", "option_id", "value") SELECT "id", "line_id", "option_id", "value" FROM "basket_lineattribute";
DROP TABLE "basket_lineattribute";
ALTER TABLE "new__basket_lineattribute" RENAME TO "basket_lineattribute";
CREATE INDEX "basket_lineattribute_line_id_c41e0cdf" ON "basket_lineattribute" ("line_id");
CREATE INDEX "basket_lineattribute_option_id_9387a3f7" ON "basket_lineattribute" ("option_id");
COMMIT;


-- Migration: basket 0012_line_code
BEGIN;
--
-- Add field tax_code to line
--
ALTER TABLE "basket_line" ADD COLUMN "tax_code" varchar(64) NULL;
COMMIT;


-- Migration: catalogue 0002_auto_20150217_1221
BEGIN;
--
-- Change Meta options on category
--
-- (no-op)
--
-- Remove field full_name from category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug" FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
COMMIT;


-- Migration: catalogue 0003_data_migration_slugs
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: catalogue 0004_auto_20150217_1710
BEGIN;
--
-- Alter field slug on category
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0005_auto_20150604_1450
BEGIN;
--
-- Alter field product_class on product
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0006_auto_20150807_1725
BEGIN;
--
-- Alter field code on productattribute
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0007_auto_20151207_1440
BEGIN;
--
-- Alter unique_together for attributeoption (1 constraint(s))
--
CREATE UNIQUE INDEX "catalogue_attributeoption_group_id_option_7a8f6c11_uniq" ON "catalogue_attributeoption" ("group_id", "option");
COMMIT;


-- Migration: catalogue 0008_auto_20160304_1652
BEGIN;
--
-- Alter field code on productattribute
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0009_slugfield_noop
BEGIN;
--
-- Alter field slug on category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "slug" varchar(255) NOT NULL, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug" FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
COMMIT;


-- Migration: catalogue 0010_auto_20170420_0439
BEGIN;
--
-- Add field value_multi_option to productattributevalue
--
CREATE TABLE "catalogue_productattributevalue_value_multi_option" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "productattributevalue_id" bigint NOT NULL REFERENCES "catalogue_productattributevalue" ("id") DEFERRABLE INITIALLY DEFERRED, "attributeoption_id" bigint NOT NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Alter field option_group on productattribute
--
-- (no-op)
--
-- Alter field type on productattribute
--
-- (no-op)
CREATE UNIQUE INDEX "catalogue_productattributevalue_value_multi_option_productattributevalue_id_attributeoption_id_a1760824_uniq" ON "catalogue_productattributevalue_value_multi_option" ("productattributevalue_id", "attributeoption_id");
CREATE INDEX "catalogue_productattributevalue_value_multi_option_productattributevalue_id_9c7c031e" ON "catalogue_productattributevalue_value_multi_option" ("productattributevalue_id");
CREATE INDEX "catalogue_productattributevalue_value_multi_option_attributeoption_id_962b600b" ON "catalogue_productattributevalue_value_multi_option" ("attributeoption_id");
COMMIT;


-- ERROR generating for catalogue 0011_auto_20170422_1355: Found wrong number (0) of constraints for catalogue_productimage(product_id, display_order)
-- Migration: catalogue 0012_auto_20170609_1902
BEGIN;
--
-- Add field value_datetime to productattributevalue
--
ALTER TABLE "catalogue_productattributevalue" ADD COLUMN "value_datetime" datetime NULL;
--
-- Alter field type on productattribute
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0013_auto_20170821_1548
BEGIN;
--
-- Alter field option_group on productattribute
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0014_auto_20181115_1953
BEGIN;
--
-- Alter field date_created on product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_updated", "is_discountable", "parent_id", "product_class_id", "date_created") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_updated", "is_discountable", "parent_id", "product_class_id", "date_created" FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_date_created_d66f485a" ON "catalogue_product" ("date_created");
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
--
-- Alter field display_order on productimage
--
CREATE TABLE "new__catalogue_productimage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "original" varchar(255) NOT NULL, "caption" varchar(200) NOT NULL, "date_created" datetime NOT NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "display_order" integer unsigned NOT NULL CHECK ("display_order" >= 0));
INSERT INTO "new__catalogue_productimage" ("id", "original", "caption", "date_created", "product_id", "display_order") SELECT "id", "original", "caption", "date_created", "product_id", "display_order" FROM "catalogue_productimage";
DROP TABLE "catalogue_productimage";
ALTER TABLE "new__catalogue_productimage" RENAME TO "catalogue_productimage";
CREATE INDEX "catalogue_productimage_product_id_49474fe8" ON "catalogue_productimage" ("product_id");
CREATE INDEX "catalogue_productimage_display_order_9fa741ac" ON "catalogue_productimage" ("display_order");
--
-- Alter field ranking on productrecommendation
--
CREATE TABLE "new__catalogue_productrecommendation" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "primary_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "recommendation_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "ranking" smallint unsigned NOT NULL CHECK ("ranking" >= 0));
INSERT INTO "new__catalogue_productrecommendation" ("id", "primary_id", "recommendation_id", "ranking") SELECT "id", "primary_id", "recommendation_id", "ranking" FROM "catalogue_productrecommendation";
DROP TABLE "catalogue_productrecommendation";
ALTER TABLE "new__catalogue_productrecommendation" RENAME TO "catalogue_productrecommendation";
CREATE UNIQUE INDEX "catalogue_productrecommendation_primary_id_recommendation_id_da1fdf43_uniq" ON "catalogue_productrecommendation" ("primary_id", "recommendation_id");
CREATE INDEX "catalogue_productrecommendation_primary_id_6e51a55c" ON "catalogue_productrecommendation" ("primary_id");
CREATE INDEX "catalogue_productrecommendation_recommendation_id_daf8ae95" ON "catalogue_productrecommendation" ("recommendation_id");
CREATE INDEX "catalogue_productrecommendation_ranking_e7a0f7fd" ON "catalogue_productrecommendation" ("ranking");
COMMIT;


-- Migration: catalogue 0015_product_is_public
BEGIN;
--
-- Add field is_public to product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "is_public" bool NOT NULL, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", 1 FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_created_d66f485a" ON "catalogue_product" ("date_created");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
COMMIT;


-- Migration: catalogue 0016_auto_20190327_0757
BEGIN;
--
-- Alter field value_boolean on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_boolean" bool NULL, "value_text" text NULL, "value_integer" integer NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_boolean") SELECT "id", "value_text", "value_integer", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_boolean" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
--
-- Alter field value_date on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_text" text NULL, "value_integer" integer NULL, "value_boolean" bool NULL, "value_float" real NULL, "value_richtext" text NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL, "value_date" date NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_date") SELECT "id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_date" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
--
-- Alter field value_datetime on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_text" text NULL, "value_integer" integer NULL, "value_boolean" bool NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime") SELECT "id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_datetime_b474ac38" ON "catalogue_productattributevalue" ("value_datetime");
--
-- Alter field value_float on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_text" text NULL, "value_integer" integer NULL, "value_boolean" bool NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL, "value_float" real NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_boolean", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_float") SELECT "id", "value_text", "value_integer", "value_boolean", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_float" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_datetime_b474ac38" ON "catalogue_productattributevalue" ("value_datetime");
CREATE INDEX "catalogue_productattributevalue_value_float_5ef8d3db" ON "catalogue_productattributevalue" ("value_float");
--
-- Alter field value_integer on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_text" text NULL, "value_boolean" bool NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL, "value_integer" integer NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_boolean", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_integer") SELECT "id", "value_text", "value_boolean", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_integer" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_value_float_5ef8d3db" ON "catalogue_productattributevalue" ("value_float");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_datetime_b474ac38" ON "catalogue_productattributevalue" ("value_datetime");
CREATE INDEX "catalogue_productattributevalue_value_integer_55fbb7d6" ON "catalogue_productattributevalue" ("value_integer");
COMMIT;


-- Migration: catalogue 0017_auto_20190816_0938
BEGIN;
--
-- Alter field value_file on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_file" varchar(255) NULL, "value_text" text NULL, "value_integer" integer NULL, "value_boolean" bool NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_date", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_file") SELECT "id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_date", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_file" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_integer_55fbb7d6" ON "catalogue_productattributevalue" ("value_integer");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_value_float_5ef8d3db" ON "catalogue_productattributevalue" ("value_float");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_datetime_b474ac38" ON "catalogue_productattributevalue" ("value_datetime");
--
-- Alter field value_image on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_text" text NULL, "value_integer" integer NULL, "value_boolean" bool NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL, "value_image" varchar(255) NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_date", "value_file", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_image") SELECT "id", "value_text", "value_integer", "value_boolean", "value_float", "value_richtext", "value_date", "value_file", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_image" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_integer_55fbb7d6" ON "catalogue_productattributevalue" ("value_integer");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_value_float_5ef8d3db" ON "catalogue_productattributevalue" ("value_float");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_datetime_b474ac38" ON "catalogue_productattributevalue" ("value_datetime");
--
-- Alter field original on productimage
--
CREATE TABLE "new__catalogue_productimage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "caption" varchar(200) NOT NULL, "display_order" integer unsigned NOT NULL CHECK ("display_order" >= 0), "date_created" datetime NOT NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "original" varchar(255) NOT NULL);
INSERT INTO "new__catalogue_productimage" ("id", "caption", "display_order", "date_created", "product_id", "original") SELECT "id", "caption", "display_order", "date_created", "product_id", "original" FROM "catalogue_productimage";
DROP TABLE "catalogue_productimage";
ALTER TABLE "new__catalogue_productimage" RENAME TO "catalogue_productimage";
CREATE INDEX "catalogue_productimage_display_order_9fa741ac" ON "catalogue_productimage" ("display_order");
CREATE INDEX "catalogue_productimage_product_id_49474fe8" ON "catalogue_productimage" ("product_id");
COMMIT;


-- Migration: catalogue 0018_auto_20191220_0920
BEGIN;
--
-- Add field ancestors_are_public to category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "ancestors_are_public" bool NOT NULL, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug", 1 FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_ancestors_are_public_d088d0db" ON "catalogue_category" ("ancestors_are_public");
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
--
-- Add field is_public to category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL, "ancestors_are_public" bool NOT NULL, "is_public" bool NOT NULL);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", 1 FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
CREATE INDEX "catalogue_category_ancestors_are_public_d088d0db" ON "catalogue_category" ("ancestors_are_public");
CREATE INDEX "catalogue_category_is_public_ab0536be" ON "catalogue_category" ("is_public");
--
-- Alter field is_public on product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "is_public" bool NOT NULL, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public" FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_created_d66f485a" ON "catalogue_product" ("date_created");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_is_public_1cf798c5" ON "catalogue_product" ("is_public");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
COMMIT;


-- Migration: catalogue 0019_option_required
BEGIN;
--
-- Add field required to option
--
CREATE TABLE "new__catalogue_option" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "required" bool NOT NULL, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "type" varchar(128) NOT NULL);
INSERT INTO "new__catalogue_option" ("id", "name", "code", "type", "required") SELECT "id", "name", "code", "type", 0 FROM "catalogue_option";
DROP TABLE "catalogue_option";
ALTER TABLE "new__catalogue_option" RENAME TO "catalogue_option";
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
--
-- Alter field type on option
--
CREATE TABLE "new__catalogue_option" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "required" bool NOT NULL, "type" varchar(255) NOT NULL);
INSERT INTO "new__catalogue_option" ("id", "name", "code", "required", "type") SELECT "id", "name", "code", "required", "type" FROM "catalogue_option";
DROP TABLE "catalogue_option";
ALTER TABLE "new__catalogue_option" RENAME TO "catalogue_option";
COMMIT;


-- Migration: catalogue 0020_auto_20200801_0817
BEGIN;
--
-- Change Meta options on option
--
-- (no-op)
--
-- Alter field name on option
--
CREATE TABLE "new__catalogue_option" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "type" varchar(255) NOT NULL, "required" bool NOT NULL);
INSERT INTO "new__catalogue_option" ("id", "code", "type", "required", "name") SELECT "id", "code", "type", "required", "name" FROM "catalogue_option";
DROP TABLE "catalogue_option";
ALTER TABLE "new__catalogue_option" RENAME TO "catalogue_option";
CREATE INDEX "catalogue_option_name_7b84926d" ON "catalogue_option" ("name");
--
-- Alter field required on option
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0021_auto_20201005_0844
BEGIN;
--
-- Add field meta_description to category
--
ALTER TABLE "catalogue_category" ADD COLUMN "meta_description" text NULL;
--
-- Add field meta_title to category
--
ALTER TABLE "catalogue_category" ADD COLUMN "meta_title" varchar(255) NULL;
--
-- Add field meta_description to product
--
ALTER TABLE "catalogue_product" ADD COLUMN "meta_description" text NULL;
--
-- Add field meta_title to product
--
ALTER TABLE "catalogue_product" ADD COLUMN "meta_title" varchar(255) NULL;
COMMIT;


-- Migration: catalogue 0022_auto_20210210_0539
BEGIN;
--
-- Alter field value_boolean on productattributevalue
--
CREATE TABLE "new__catalogue_productattributevalue" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value_boolean" bool NULL, "value_text" text NULL, "value_integer" integer NULL, "value_float" real NULL, "value_richtext" text NULL, "value_date" date NULL, "value_file" varchar(255) NULL, "value_image" varchar(255) NULL, "entity_object_id" integer unsigned NULL CHECK ("entity_object_id" >= 0), "attribute_id" bigint NOT NULL REFERENCES "catalogue_productattribute" ("id") DEFERRABLE INITIALLY DEFERRED, "entity_content_type_id" integer NULL REFERENCES "django_content_type" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "value_option_id" bigint NULL REFERENCES "catalogue_attributeoption" ("id") DEFERRABLE INITIALLY DEFERRED, "value_datetime" datetime NULL);
INSERT INTO "new__catalogue_productattributevalue" ("id", "value_text", "value_integer", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_boolean") SELECT "id", "value_text", "value_integer", "value_float", "value_richtext", "value_date", "value_file", "value_image", "entity_object_id", "attribute_id", "entity_content_type_id", "product_id", "value_option_id", "value_datetime", "value_boolean" FROM "catalogue_productattributevalue";
DROP TABLE "catalogue_productattributevalue";
ALTER TABLE "new__catalogue_productattributevalue" RENAME TO "catalogue_productattributevalue";
CREATE UNIQUE INDEX "catalogue_productattributevalue_attribute_id_product_id_1e8e7112_uniq" ON "catalogue_productattributevalue" ("attribute_id", "product_id");
CREATE INDEX "catalogue_productattributevalue_value_boolean_c5b0d66a" ON "catalogue_productattributevalue" ("value_boolean");
CREATE INDEX "catalogue_productattributevalue_value_integer_55fbb7d6" ON "catalogue_productattributevalue" ("value_integer");
CREATE INDEX "catalogue_productattributevalue_value_float_5ef8d3db" ON "catalogue_productattributevalue" ("value_float");
CREATE INDEX "catalogue_productattributevalue_value_date_d18775c1" ON "catalogue_productattributevalue" ("value_date");
CREATE INDEX "catalogue_productattributevalue_attribute_id_0287c1e7" ON "catalogue_productattributevalue" ("attribute_id");
CREATE INDEX "catalogue_productattributevalue_entity_content_type_id_f7186ab5" ON "catalogue_productattributevalue" ("entity_content_type_id");
CREATE INDEX "catalogue_productattributevalue_product_id_a03cd90e" ON "catalogue_productattributevalue" ("product_id");
CREATE INDEX "catalogue_productattributevalue_value_option_id_21026066" ON "catalogue_productattributevalue" ("value_option_id");
CREATE INDEX "catalogue_productattributevalue_value_datetime_b474ac38" ON "catalogue_productattributevalue" ("value_datetime");
COMMIT;


-- Migration: catalogue 0023_auto_20210824_1414
BEGIN;
--
-- Alter field slug on product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "slug" varchar(255) NOT NULL, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "is_public" bool NOT NULL, "meta_description" text NULL, "meta_title" varchar(255) NULL, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public", "meta_description", "meta_title", "slug") SELECT "id", "structure", "upc", "title", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public", "meta_description", "meta_title", "slug" FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_created_d66f485a" ON "catalogue_product" ("date_created");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_is_public_1cf798c5" ON "catalogue_product" ("is_public");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
COMMIT;


-- Migration: catalogue 0024_remove_duplicate_attributes
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: catalogue 0025_attribute_code_uniquetogether_constraint
BEGIN;
--
-- Alter unique_together for productattribute (1 constraint(s))
--
CREATE UNIQUE INDEX "catalogue_productattribute_code_product_class_id_82f69012_uniq" ON "catalogue_productattribute" ("code", "product_class_id");
COMMIT;


-- Migration: catalogue 0026_predefined_product_options
BEGIN;
--
-- Change Meta options on option
--
-- (no-op)
--
-- Add field help_text to option
--
ALTER TABLE "catalogue_option" ADD COLUMN "help_text" varchar(255) NULL;
--
-- Add field option_group to option
--
ALTER TABLE "catalogue_option" ADD COLUMN "option_group_id" bigint NULL REFERENCES "catalogue_attributeoptiongroup" ("id") DEFERRABLE INITIALLY DEFERRED;
--
-- Add field order to option
--
ALTER TABLE "catalogue_option" ADD COLUMN "order" integer NULL;
--
-- Alter field type on option
--
-- (no-op)
CREATE INDEX "catalogue_option_option_group_id_2fd86269" ON "catalogue_option" ("option_group_id");
CREATE INDEX "catalogue_option_order_d4ee348f" ON "catalogue_option" ("order");
COMMIT;


-- Migration: catalogue 0027_attributeoption_code_attributeoptiongroup_code_and_more
BEGIN;
--
-- Add field code to attributeoption
--
CREATE TABLE "new__catalogue_attributeoption" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(255) NULL UNIQUE, "option" varchar(255) NOT NULL, "group_id" bigint NOT NULL REFERENCES "catalogue_attributeoptiongroup" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_attributeoption" ("id", "option", "group_id", "code") SELECT "id", "option", "group_id", NULL FROM "catalogue_attributeoption";
DROP TABLE "catalogue_attributeoption";
ALTER TABLE "new__catalogue_attributeoption" RENAME TO "catalogue_attributeoption";
CREATE UNIQUE INDEX "catalogue_attributeoption_group_id_option_7a8f6c11_uniq" ON "catalogue_attributeoption" ("group_id", "option");
CREATE INDEX "catalogue_attributeoption_group_id_3d4a5e24" ON "catalogue_attributeoption" ("group_id");
--
-- Add field code to attributeoptiongroup
--
CREATE TABLE "new__catalogue_attributeoptiongroup" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(255) NULL UNIQUE);
INSERT INTO "new__catalogue_attributeoptiongroup" ("id", "name", "code") SELECT "id", "name", NULL FROM "catalogue_attributeoptiongroup";
DROP TABLE "catalogue_attributeoptiongroup";
ALTER TABLE "new__catalogue_attributeoptiongroup" RENAME TO "catalogue_attributeoptiongroup";
--
-- Add field code to category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL, "ancestors_are_public" bool NOT NULL, "is_public" bool NOT NULL, "meta_description" text NULL, "meta_title" varchar(255) NULL, "code" varchar(255) NULL UNIQUE);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public", "meta_description", "meta_title", "code") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public", "meta_description", "meta_title", NULL FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
CREATE INDEX "catalogue_category_ancestors_are_public_d088d0db" ON "catalogue_category" ("ancestors_are_public");
CREATE INDEX "catalogue_category_is_public_ab0536be" ON "catalogue_category" ("is_public");
--
-- Add field code to productimage
--
CREATE TABLE "new__catalogue_productimage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "original" varchar(255) NOT NULL, "caption" varchar(200) NOT NULL, "display_order" integer unsigned NOT NULL CHECK ("display_order" >= 0), "date_created" datetime NOT NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "code" varchar(255) NULL UNIQUE);
INSERT INTO "new__catalogue_productimage" ("id", "original", "caption", "display_order", "date_created", "product_id", "code") SELECT "id", "original", "caption", "display_order", "date_created", "product_id", NULL FROM "catalogue_productimage";
DROP TABLE "catalogue_productimage";
ALTER TABLE "new__catalogue_productimage" RENAME TO "catalogue_productimage";
CREATE INDEX "catalogue_productimage_display_order_9fa741ac" ON "catalogue_productimage" ("display_order");
CREATE INDEX "catalogue_productimage_product_id_49474fe8" ON "catalogue_productimage" ("product_id");
COMMIT;


-- Migration: catalogue 0028_product_priority
BEGIN;
--
-- Add field priority to product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "priority" smallint NOT NULL, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "is_public" bool NOT NULL, "meta_description" text NULL, "meta_title" varchar(255) NULL, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public", "meta_description", "meta_title", "priority") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public", "meta_description", "meta_title", 0 FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_priority_983a8f56" ON "catalogue_product" ("priority");
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_created_d66f485a" ON "catalogue_product" ("date_created");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_is_public_1cf798c5" ON "catalogue_product" ("is_public");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
COMMIT;


-- Migration: catalogue 0029_product_code
BEGIN;
--
-- Add field code to product
--
CREATE TABLE "new__catalogue_product" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(255) NULL UNIQUE, "structure" varchar(10) NOT NULL, "upc" varchar(64) NULL UNIQUE, "title" varchar(255) NOT NULL, "slug" varchar(255) NOT NULL, "description" text NOT NULL, "rating" real NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "is_discountable" bool NOT NULL, "product_class_id" bigint NULL REFERENCES "catalogue_productclass" ("id") DEFERRABLE INITIALLY DEFERRED, "is_public" bool NOT NULL, "meta_description" text NULL, "meta_title" varchar(255) NULL, "priority" smallint NOT NULL, "parent_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__catalogue_product" ("id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public", "meta_description", "meta_title", "priority", "code") SELECT "id", "structure", "upc", "title", "slug", "description", "rating", "date_created", "date_updated", "is_discountable", "parent_id", "product_class_id", "is_public", "meta_description", "meta_title", "priority", NULL FROM "catalogue_product";
DROP TABLE "catalogue_product";
ALTER TABLE "new__catalogue_product" RENAME TO "catalogue_product";
CREATE INDEX "catalogue_product_slug_c8e2e2b9" ON "catalogue_product" ("slug");
CREATE INDEX "catalogue_product_date_created_d66f485a" ON "catalogue_product" ("date_created");
CREATE INDEX "catalogue_product_date_updated_d3a1785d" ON "catalogue_product" ("date_updated");
CREATE INDEX "catalogue_product_product_class_id_0c6c5b54" ON "catalogue_product" ("product_class_id");
CREATE INDEX "catalogue_product_is_public_1cf798c5" ON "catalogue_product" ("is_public");
CREATE INDEX "catalogue_product_priority_983a8f56" ON "catalogue_product" ("priority");
CREATE INDEX "catalogue_product_parent_id_9bfd2382" ON "catalogue_product" ("parent_id");
COMMIT;


-- Migration: catalogue 0030_auto_20250217_1247
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL


-- Migration: catalogue 0031_productcategoryhierarchy
BEGIN;
--
-- Create model ProductCategoryHierarchy
--
-- (no-op)
COMMIT;


-- Migration: catalogue 0032_category_exclude_from_menu_category_long_description
BEGIN;
--
-- Add field exclude_from_menu to category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "exclude_from_menu" bool NOT NULL, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL, "ancestors_are_public" bool NOT NULL, "is_public" bool NOT NULL, "meta_description" text NULL, "meta_title" varchar(255) NULL, "code" varchar(255) NULL UNIQUE);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public", "meta_description", "meta_title", "code", "exclude_from_menu") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public", "meta_description", "meta_title", "code", 0 FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_exclude_from_menu_898e8583" ON "catalogue_category" ("exclude_from_menu");
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
CREATE INDEX "catalogue_category_ancestors_are_public_d088d0db" ON "catalogue_category" ("ancestors_are_public");
CREATE INDEX "catalogue_category_is_public_ab0536be" ON "catalogue_category" ("is_public");
--
-- Add field long_description to category
--
CREATE TABLE "new__catalogue_category" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "path" varchar(255) NOT NULL UNIQUE, "depth" integer unsigned NOT NULL CHECK ("depth" >= 0), "numchild" integer unsigned NOT NULL CHECK ("numchild" >= 0), "name" varchar(255) NOT NULL, "description" text NOT NULL, "image" varchar(255) NULL, "slug" varchar(255) NOT NULL, "ancestors_are_public" bool NOT NULL, "is_public" bool NOT NULL, "meta_description" text NULL, "meta_title" varchar(255) NULL, "code" varchar(255) NULL UNIQUE, "exclude_from_menu" bool NOT NULL, "long_description" text NOT NULL);
INSERT INTO "new__catalogue_category" ("id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public", "meta_description", "meta_title", "code", "exclude_from_menu", "long_description") SELECT "id", "path", "depth", "numchild", "name", "description", "image", "slug", "ancestors_are_public", "is_public", "meta_description", "meta_title", "code", "exclude_from_menu", '' FROM "catalogue_category";
DROP TABLE "catalogue_category";
ALTER TABLE "new__catalogue_category" RENAME TO "catalogue_category";
CREATE INDEX "catalogue_category_name_1f342ac2" ON "catalogue_category" ("name");
CREATE INDEX "catalogue_category_slug_9635febd" ON "catalogue_category" ("slug");
CREATE INDEX "catalogue_category_ancestors_are_public_d088d0db" ON "catalogue_category" ("ancestors_are_public");
CREATE INDEX "catalogue_category_is_public_ab0536be" ON "catalogue_category" ("is_public");
CREATE INDEX "catalogue_category_exclude_from_menu_898e8583" ON "catalogue_category" ("exclude_from_menu");
COMMIT;


-- Migration: catalogue 0033_product_brand
BEGIN;
--
-- Add field brand to product
--
ALTER TABLE "catalogue_product" ADD COLUMN "brand" varchar(100) NULL;
COMMIT;


-- Migration: order 0002_auto_20141007_2032
BEGIN;
--
-- Alter field currency on order
--
CREATE TABLE "new__order_order" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "currency" varchar(12) NOT NULL, "number" varchar(128) NOT NULL UNIQUE, "total_incl_tax" decimal NOT NULL, "total_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "shipping_method" varchar(128) NOT NULL, "shipping_code" varchar(128) NOT NULL, "status" varchar(100) NOT NULL, "guest_email" varchar(75) NOT NULL, "date_placed" datetime NOT NULL, "basket_id" bigint NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "billing_address_id" bigint NULL REFERENCES "order_billingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_address_id" bigint NULL REFERENCES "order_shippingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "site_id" integer NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_order" ("id", "number", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "currency") SELECT "id", "number", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "currency" FROM "order_order";
DROP TABLE "order_order";
ALTER TABLE "new__order_order" RENAME TO "order_order";
CREATE INDEX "order_order_date_placed_506a9365" ON "order_order" ("date_placed");
CREATE INDEX "order_order_basket_id_8b0acbb2" ON "order_order" ("basket_id");
CREATE INDEX "order_order_billing_address_id_8fe537cf" ON "order_order" ("billing_address_id");
CREATE INDEX "order_order_shipping_address_id_57e64931" ON "order_order" ("shipping_address_id");
CREATE INDEX "order_order_site_id_e27f3526" ON "order_order" ("site_id");
CREATE INDEX "order_order_user_id_7cf9bc2b" ON "order_order" ("user_id");
COMMIT;


-- Migration: order 0003_auto_20150113_1629
BEGIN;
--
-- Alter field date_placed on order
--
CREATE TABLE "new__order_order" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_placed" datetime NOT NULL, "number" varchar(128) NOT NULL UNIQUE, "currency" varchar(12) NOT NULL, "total_incl_tax" decimal NOT NULL, "total_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "shipping_method" varchar(128) NOT NULL, "shipping_code" varchar(128) NOT NULL, "status" varchar(100) NOT NULL, "guest_email" varchar(75) NOT NULL, "basket_id" bigint NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "billing_address_id" bigint NULL REFERENCES "order_billingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_address_id" bigint NULL REFERENCES "order_shippingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "site_id" integer NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_order" ("id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "date_placed") SELECT "id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "date_placed" FROM "order_order";
DROP TABLE "order_order";
ALTER TABLE "new__order_order" RENAME TO "order_order";
CREATE INDEX "order_order_date_placed_506a9365" ON "order_order" ("date_placed");
CREATE INDEX "order_order_basket_id_8b0acbb2" ON "order_order" ("basket_id");
CREATE INDEX "order_order_billing_address_id_8fe537cf" ON "order_order" ("billing_address_id");
CREATE INDEX "order_order_shipping_address_id_57e64931" ON "order_order" ("shipping_address_id");
CREATE INDEX "order_order_site_id_e27f3526" ON "order_order" ("site_id");
CREATE INDEX "order_order_user_id_7cf9bc2b" ON "order_order" ("user_id");
COMMIT;


-- Migration: order 0004_auto_20160111_1108
BEGIN;
--
-- Change Meta options on line
--
-- (no-op)
COMMIT;


-- Migration: order 0005_update_email_length
BEGIN;
--
-- Alter field guest_email on order
--
CREATE TABLE "new__order_order" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "guest_email" varchar(254) NOT NULL, "number" varchar(128) NOT NULL UNIQUE, "currency" varchar(12) NOT NULL, "total_incl_tax" decimal NOT NULL, "total_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "shipping_method" varchar(128) NOT NULL, "shipping_code" varchar(128) NOT NULL, "status" varchar(100) NOT NULL, "date_placed" datetime NOT NULL, "basket_id" bigint NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "billing_address_id" bigint NULL REFERENCES "order_billingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_address_id" bigint NULL REFERENCES "order_shippingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "site_id" integer NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_order" ("id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "guest_email") SELECT "id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "guest_email" FROM "order_order";
DROP TABLE "order_order";
ALTER TABLE "new__order_order" RENAME TO "order_order";
CREATE INDEX "order_order_date_placed_506a9365" ON "order_order" ("date_placed");
CREATE INDEX "order_order_basket_id_8b0acbb2" ON "order_order" ("basket_id");
CREATE INDEX "order_order_billing_address_id_8fe537cf" ON "order_order" ("billing_address_id");
CREATE INDEX "order_order_shipping_address_id_57e64931" ON "order_order" ("shipping_address_id");
CREATE INDEX "order_order_site_id_e27f3526" ON "order_order" ("site_id");
CREATE INDEX "order_order_user_id_7cf9bc2b" ON "order_order" ("user_id");
COMMIT;


-- Migration: order 0006_orderstatuschange
BEGIN;
--
-- Create model OrderStatusChange
--
CREATE TABLE "order_orderstatuschange" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "old_status" varchar(100) NOT NULL, "new_status" varchar(100) NOT NULL, "date_created" datetime NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "order_orderstatuschange_order_id_43efdbe5" ON "order_orderstatuschange" ("order_id");
COMMIT;


-- Migration: order 0007_auto_20181115_1953
BEGIN;
--
-- Alter field date_created on communicationevent
--
CREATE TABLE "new__order_communicationevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "customer_communicationeventtype" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_communicationevent" ("id", "event_type_id", "order_id", "date_created") SELECT "id", "event_type_id", "order_id", "date_created" FROM "order_communicationevent";
DROP TABLE "order_communicationevent";
ALTER TABLE "new__order_communicationevent" RENAME TO "order_communicationevent";
CREATE INDEX "order_communicationevent_date_created_ce404d62" ON "order_communicationevent" ("date_created");
CREATE INDEX "order_communicationevent_event_type_id_4bc9ee29" ON "order_communicationevent" ("event_type_id");
CREATE INDEX "order_communicationevent_order_id_94e784ac" ON "order_communicationevent" ("order_id");
--
-- Alter field date_created on orderstatuschange
--
CREATE TABLE "new__order_orderstatuschange" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "old_status" varchar(100) NOT NULL, "new_status" varchar(100) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__order_orderstatuschange" ("id", "old_status", "new_status", "order_id", "date_created") SELECT "id", "old_status", "new_status", "order_id", "date_created" FROM "order_orderstatuschange";
DROP TABLE "order_orderstatuschange";
ALTER TABLE "new__order_orderstatuschange" RENAME TO "order_orderstatuschange";
CREATE INDEX "order_orderstatuschange_order_id_43efdbe5" ON "order_orderstatuschange" ("order_id");
CREATE INDEX "order_orderstatuschange_date_created_a5107b93" ON "order_orderstatuschange" ("date_created");
--
-- Alter field date_created on paymentevent
--
CREATE TABLE "new__order_paymentevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_paymenteventtype" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_event_id" bigint NULL REFERENCES "order_shippingevent" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__order_paymentevent" ("id", "amount", "reference", "event_type_id", "order_id", "shipping_event_id", "date_created") SELECT "id", "amount", "reference", "event_type_id", "order_id", "shipping_event_id", "date_created" FROM "order_paymentevent";
DROP TABLE "order_paymentevent";
ALTER TABLE "new__order_paymentevent" RENAME TO "order_paymentevent";
CREATE INDEX "order_paymentevent_event_type_id_568c7161" ON "order_paymentevent" ("event_type_id");
CREATE INDEX "order_paymentevent_order_id_395b3e82" ON "order_paymentevent" ("order_id");
CREATE INDEX "order_paymentevent_shipping_event_id_213dcfb8" ON "order_paymentevent" ("shipping_event_id");
CREATE INDEX "order_paymentevent_date_created_05d8c079" ON "order_paymentevent" ("date_created");
--
-- Alter field date_created on shippingevent
--
CREATE TABLE "new__order_shippingevent" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "notes" text NOT NULL, "event_type_id" bigint NOT NULL REFERENCES "order_shippingeventtype" ("id") DEFERRABLE INITIALLY DEFERRED, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__order_shippingevent" ("id", "notes", "event_type_id", "order_id", "date_created") SELECT "id", "notes", "event_type_id", "order_id", "date_created" FROM "order_shippingevent";
DROP TABLE "order_shippingevent";
ALTER TABLE "new__order_shippingevent" RENAME TO "order_shippingevent";
CREATE INDEX "order_shippingevent_event_type_id_9f1efb20" ON "order_shippingevent" ("event_type_id");
CREATE INDEX "order_shippingevent_order_id_8c031fb6" ON "order_shippingevent" ("order_id");
CREATE INDEX "order_shippingevent_date_created_74c4a6fa" ON "order_shippingevent" ("date_created");
COMMIT;


-- Migration: customer 0002_auto_20150807_1725
BEGIN;
--
-- Alter field code on communicationeventtype
--
-- (no-op)
COMMIT;


-- Migration: customer 0003_update_email_length
BEGIN;
--
-- Alter field email on productalert
--
CREATE TABLE "new__customer_productalert" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "email" varchar(254) NOT NULL, "key" varchar(128) NOT NULL, "status" varchar(20) NOT NULL, "date_created" datetime NOT NULL, "date_confirmed" datetime NULL, "date_cancelled" datetime NULL, "date_closed" datetime NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__customer_productalert" ("id", "key", "status", "date_created", "date_confirmed", "date_cancelled", "date_closed", "product_id", "user_id", "email") SELECT "id", "key", "status", "date_created", "date_confirmed", "date_cancelled", "date_closed", "product_id", "user_id", "email" FROM "customer_productalert";
DROP TABLE "customer_productalert";
ALTER TABLE "new__customer_productalert" RENAME TO "customer_productalert";
CREATE INDEX "customer_productalert_email_e5f35f45" ON "customer_productalert" ("email");
CREATE INDEX "customer_productalert_key_a26f3bdc" ON "customer_productalert" ("key");
CREATE INDEX "customer_productalert_product_id_7e529a41" ON "customer_productalert" ("product_id");
CREATE INDEX "customer_productalert_user_id_677ad6d6" ON "customer_productalert" ("user_id");
COMMIT;


-- Migration: customer 0004_email_save
BEGIN;
--
-- Add field email to email
--
ALTER TABLE "customer_email" ADD COLUMN "email" varchar(254) NULL;
--
-- Alter field user on email
--
CREATE TABLE "new__customer_email" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "subject" text NOT NULL, "body_text" text NOT NULL, "body_html" text NOT NULL, "date_sent" datetime NOT NULL, "email" varchar(254) NULL, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__customer_email" ("id", "subject", "body_text", "body_html", "date_sent", "email", "user_id") SELECT "id", "subject", "body_text", "body_html", "date_sent", "email", "user_id" FROM "customer_email";
DROP TABLE "customer_email";
ALTER TABLE "new__customer_email" RENAME TO "customer_email";
CREATE INDEX "customer_email_user_id_a69ad588" ON "customer_email" ("user_id");
COMMIT;


-- Migration: customer 0005_auto_20181115_1953
BEGIN;
--
-- Alter field date_sent on notification
--
CREATE TABLE "new__customer_notification" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_sent" datetime NOT NULL, "subject" varchar(255) NOT NULL, "body" text NOT NULL, "category" varchar(255) NOT NULL, "location" varchar(32) NOT NULL, "date_read" datetime NULL, "recipient_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "sender_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__customer_notification" ("id", "subject", "body", "category", "location", "date_read", "recipient_id", "sender_id", "date_sent") SELECT "id", "subject", "body", "category", "location", "date_read", "recipient_id", "sender_id", "date_sent" FROM "customer_notification";
DROP TABLE "customer_notification";
ALTER TABLE "new__customer_notification" RENAME TO "customer_notification";
CREATE INDEX "customer_notification_date_sent_9b6baeda" ON "customer_notification" ("date_sent");
CREATE INDEX "customer_notification_recipient_id_d99de5c8" ON "customer_notification" ("recipient_id");
CREATE INDEX "customer_notification_sender_id_affa1632" ON "customer_notification" ("sender_id");
COMMIT;


-- Migration: communication 0001_initial
BEGIN;
--
-- Custom state/database change combination
--
-- (no-op)
COMMIT;


-- Migration: order 0008_auto_20190301_1035
BEGIN;
--
-- Alter field event_type on communicationevent
--
-- (no-op)
COMMIT;


-- Migration: communication 0002_reset_table_names
--
-- Rename table for communicationeventtype to (default)
--
ALTER TABLE "customer_communicationeventtype" RENAME TO "communication_communicationeventtype";
--
-- Rename table for email to (default)
--
ALTER TABLE "customer_email" RENAME TO "communication_email";
--
-- Rename table for notification to (default)
--
ALTER TABLE "customer_notification" RENAME TO "communication_notification";


-- Migration: communication 0003_remove_notification_category_make_code_uppercase
BEGIN;
--
-- Remove field category from notification
--
ALTER TABLE "communication_notification" DROP COLUMN "category";
--
-- Alter field code on communicationeventtype
--
-- (no-op)
COMMIT;


-- Migration: communication 0004_auto_20200801_0817
BEGIN;
--
-- Change Meta options on communicationeventtype
--
-- (no-op)
--
-- Change Meta options on email
--
-- (no-op)
--
-- Alter field name on communicationeventtype
--
CREATE TABLE "new__communication_communicationeventtype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "category" varchar(255) NOT NULL, "email_subject_template" varchar(255) NULL, "email_body_template" text NULL, "email_body_html_template" text NULL, "sms_template" varchar(170) NULL, "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL);
INSERT INTO "new__communication_communicationeventtype" ("id", "code", "category", "email_subject_template", "email_body_template", "email_body_html_template", "sms_template", "date_created", "date_updated", "name") SELECT "id", "code", "category", "email_subject_template", "email_body_template", "email_body_html_template", "sms_template", "date_created", "date_updated", "name" FROM "communication_communicationeventtype";
DROP TABLE "communication_communicationeventtype";
ALTER TABLE "new__communication_communicationeventtype" RENAME TO "communication_communicationeventtype";
CREATE INDEX "communication_communicationeventtype_name_45761eb9" ON "communication_communicationeventtype" ("name");
COMMIT;


-- Migration: reviews 0001_initial
BEGIN;
--
-- Create model ProductReview
--
CREATE TABLE "reviews_productreview" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "score" smallint NOT NULL, "title" varchar(255) NOT NULL, "body" text NOT NULL, "name" varchar(255) NOT NULL, "email" varchar(75) NOT NULL, "homepage" varchar(200) NOT NULL, "status" smallint NOT NULL, "total_votes" integer NOT NULL, "delta_votes" integer NOT NULL, "date_created" datetime NOT NULL, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model Vote
--
CREATE TABLE "reviews_vote" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "delta" smallint NOT NULL, "date_created" datetime NOT NULL, "review_id" bigint NOT NULL REFERENCES "reviews_productreview" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Alter unique_together for vote (1 constraint(s))
--
CREATE UNIQUE INDEX "reviews_vote_user_id_review_id_bb858939_uniq" ON "reviews_vote" ("user_id", "review_id");
--
-- Alter unique_together for productreview (1 constraint(s))
--
CREATE UNIQUE INDEX "reviews_productreview_product_id_user_id_c4fdc4cd_uniq" ON "reviews_productreview" ("product_id", "user_id");
CREATE INDEX "reviews_productreview_delta_votes_bd8ffc87" ON "reviews_productreview" ("delta_votes");
CREATE INDEX "reviews_productreview_product_id_52e52a32" ON "reviews_productreview" ("product_id");
CREATE INDEX "reviews_productreview_user_id_8acb5ddd" ON "reviews_productreview" ("user_id");
CREATE INDEX "reviews_vote_review_id_371b2d8d" ON "reviews_vote" ("review_id");
CREATE INDEX "reviews_vote_user_id_5fb87b53" ON "reviews_vote" ("user_id");
COMMIT;


-- Migration: flatpages 0001_initial
BEGIN;
--
-- Create model FlatPage
--
CREATE TABLE "django_flatpage" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "url" varchar(100) NOT NULL, "title" varchar(200) NOT NULL, "content" text NOT NULL, "enable_comments" bool NOT NULL, "template_name" varchar(70) NOT NULL, "registration_required" bool NOT NULL);
CREATE TABLE "django_flatpage_sites" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "flatpage_id" integer NOT NULL REFERENCES "django_flatpage" ("id") DEFERRABLE INITIALLY DEFERRED, "site_id" integer NOT NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "django_flatpage_url_41612362" ON "django_flatpage" ("url");
CREATE UNIQUE INDEX "django_flatpage_sites_flatpage_id_site_id_0d29d9d1_uniq" ON "django_flatpage_sites" ("flatpage_id", "site_id");
CREATE INDEX "django_flatpage_sites_flatpage_id_078bbc8b" ON "django_flatpage_sites" ("flatpage_id");
CREATE INDEX "django_flatpage_sites_site_id_bfd8ea84" ON "django_flatpage_sites" ("site_id");
COMMIT;


-- Migration: customer 0006_auto_20190430_1736
BEGIN;
--
-- Custom state/database change combination
--
-- (no-op)
COMMIT;


-- Migration: customer 0007_auto_20200801_0817
BEGIN;
--
-- Change Meta options on productalert
--
-- (no-op)
--
-- Alter field date_created on productalert
--
CREATE TABLE "new__customer_productalert" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "email" varchar(254) NOT NULL, "key" varchar(128) NOT NULL, "status" varchar(20) NOT NULL, "date_confirmed" datetime NULL, "date_cancelled" datetime NULL, "date_closed" datetime NULL, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__customer_productalert" ("id", "email", "key", "status", "date_confirmed", "date_cancelled", "date_closed", "product_id", "user_id", "date_created") SELECT "id", "email", "key", "status", "date_confirmed", "date_cancelled", "date_closed", "product_id", "user_id", "date_created" FROM "customer_productalert";
DROP TABLE "customer_productalert";
ALTER TABLE "new__customer_productalert" RENAME TO "customer_productalert";
CREATE INDEX "customer_productalert_date_created_00622b1c" ON "customer_productalert" ("date_created");
CREATE INDEX "customer_productalert_email_e5f35f45" ON "customer_productalert" ("email");
CREATE INDEX "customer_productalert_key_a26f3bdc" ON "customer_productalert" ("key");
CREATE INDEX "customer_productalert_product_id_7e529a41" ON "customer_productalert" ("product_id");
CREATE INDEX "customer_productalert_user_id_677ad6d6" ON "customer_productalert" ("user_id");
COMMIT;


-- Migration: customer 0008_assign_permissions_to_staff
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: offer 0002_auto_20151210_1053
BEGIN;
--
-- Alter field proxy_class on benefit
--
CREATE TABLE "new__offer_benefit" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "proxy_class" varchar(255) NULL, "type" varchar(128) NOT NULL, "value" decimal NULL, "max_affected_items" integer unsigned NULL CHECK ("max_affected_items" >= 0), "range_id" bigint NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__offer_benefit" ("id", "type", "value", "max_affected_items", "range_id", "proxy_class") SELECT "id", "type", "value", "max_affected_items", "range_id", "proxy_class" FROM "offer_benefit";
DROP TABLE "offer_benefit";
ALTER TABLE "new__offer_benefit" RENAME TO "offer_benefit";
CREATE INDEX "offer_benefit_range_id_ab19c5ab" ON "offer_benefit" ("range_id");
COMMIT;


-- Migration: offer 0003_auto_20161120_1707
BEGIN;
--
-- Alter field proxy_class on condition
--
CREATE TABLE "new__offer_condition" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "proxy_class" varchar(255) NULL, "type" varchar(128) NOT NULL, "value" decimal NULL, "range_id" bigint NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__offer_condition" ("id", "type", "value", "range_id", "proxy_class") SELECT "id", "type", "value", "range_id", "proxy_class" FROM "offer_condition";
DROP TABLE "offer_condition";
ALTER TABLE "new__offer_condition" RENAME TO "offer_condition";
CREATE INDEX "offer_condition_range_id_b023a2aa" ON "offer_condition" ("range_id");
COMMIT;


-- Migration: offer 0004_auto_20170415_1518
BEGIN;
--
-- Change Meta options on conditionaloffer
--
-- (no-op)
COMMIT;


-- Migration: offer 0005_auto_20170423_1217
BEGIN;
--
-- Alter field benefit on conditionaloffer
--
-- (no-op)
--
-- Alter field condition on conditionaloffer
--
-- (no-op)
COMMIT;


-- Migration: offer 0006_auto_20170504_0616
BEGIN;
--
-- Alter field end_datetime on conditionaloffer
--
-- (no-op)
--
-- Alter field start_datetime on conditionaloffer
--
-- (no-op)
COMMIT;


-- Migration: offer 0007_conditionaloffer_exclusive
BEGIN;
--
-- Add field exclusive to conditionaloffer
--
CREATE TABLE "new__offer_conditionaloffer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "exclusive" bool NOT NULL, "name" varchar(128) NOT NULL UNIQUE, "slug" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "offer_type" varchar(128) NOT NULL, "status" varchar(64) NOT NULL, "priority" integer NOT NULL, "start_datetime" datetime NULL, "end_datetime" datetime NULL, "max_global_applications" integer unsigned NULL CHECK ("max_global_applications" >= 0), "max_user_applications" integer unsigned NULL CHECK ("max_user_applications" >= 0), "max_basket_applications" integer unsigned NULL CHECK ("max_basket_applications" >= 0), "max_discount" decimal NULL, "total_discount" decimal NOT NULL, "num_applications" integer unsigned NOT NULL CHECK ("num_applications" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "redirect_url" varchar(200) NOT NULL, "date_created" datetime NOT NULL, "benefit_id" bigint NOT NULL REFERENCES "offer_benefit" ("id") DEFERRABLE INITIALLY DEFERRED, "condition_id" bigint NOT NULL REFERENCES "offer_condition" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__offer_conditionaloffer" ("id", "name", "slug", "description", "offer_type", "status", "priority", "start_datetime", "end_datetime", "max_global_applications", "max_user_applications", "max_basket_applications", "max_discount", "total_discount", "num_applications", "num_orders", "redirect_url", "date_created", "benefit_id", "condition_id", "exclusive") SELECT "id", "name", "slug", "description", "offer_type", "status", "priority", "start_datetime", "end_datetime", "max_global_applications", "max_user_applications", "max_basket_applications", "max_discount", "total_discount", "num_applications", "num_orders", "redirect_url", "date_created", "benefit_id", "condition_id", 1 FROM "offer_conditionaloffer";
DROP TABLE "offer_conditionaloffer";
ALTER TABLE "new__offer_conditionaloffer" RENAME TO "offer_conditionaloffer";
CREATE INDEX "offer_conditionaloffer_benefit_id_f43f68b5" ON "offer_conditionaloffer" ("benefit_id");
CREATE INDEX "offer_conditionaloffer_condition_id_e6baa945" ON "offer_conditionaloffer" ("condition_id");
COMMIT;


-- Migration: offer 0008_auto_20181115_1953
BEGIN;
--
-- Alter field priority on conditionaloffer
--
CREATE TABLE "new__offer_conditionaloffer" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "priority" integer NOT NULL, "name" varchar(128) NOT NULL UNIQUE, "slug" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "offer_type" varchar(128) NOT NULL, "status" varchar(64) NOT NULL, "start_datetime" datetime NULL, "end_datetime" datetime NULL, "max_global_applications" integer unsigned NULL CHECK ("max_global_applications" >= 0), "max_user_applications" integer unsigned NULL CHECK ("max_user_applications" >= 0), "max_basket_applications" integer unsigned NULL CHECK ("max_basket_applications" >= 0), "max_discount" decimal NULL, "total_discount" decimal NOT NULL, "num_applications" integer unsigned NOT NULL CHECK ("num_applications" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "redirect_url" varchar(200) NOT NULL, "date_created" datetime NOT NULL, "benefit_id" bigint NOT NULL REFERENCES "offer_benefit" ("id") DEFERRABLE INITIALLY DEFERRED, "condition_id" bigint NOT NULL REFERENCES "offer_condition" ("id") DEFERRABLE INITIALLY DEFERRED, "exclusive" bool NOT NULL);
INSERT INTO "new__offer_conditionaloffer" ("id", "name", "slug", "description", "offer_type", "status", "start_datetime", "end_datetime", "max_global_applications", "max_user_applications", "max_basket_applications", "max_discount", "total_discount", "num_applications", "num_orders", "redirect_url", "date_created", "benefit_id", "condition_id", "exclusive", "priority") SELECT "id", "name", "slug", "description", "offer_type", "status", "start_datetime", "end_datetime", "max_global_applications", "max_user_applications", "max_basket_applications", "max_discount", "total_discount", "num_applications", "num_orders", "redirect_url", "date_created", "benefit_id", "condition_id", "exclusive", "priority" FROM "offer_conditionaloffer";
DROP TABLE "offer_conditionaloffer";
ALTER TABLE "new__offer_conditionaloffer" RENAME TO "offer_conditionaloffer";
CREATE INDEX "offer_conditionaloffer_priority_4c2fc582" ON "offer_conditionaloffer" ("priority");
CREATE INDEX "offer_conditionaloffer_benefit_id_f43f68b5" ON "offer_conditionaloffer" ("benefit_id");
CREATE INDEX "offer_conditionaloffer_condition_id_e6baa945" ON "offer_conditionaloffer" ("condition_id");
--
-- Alter field date_uploaded on rangeproductfileupload
--
CREATE TABLE "new__offer_rangeproductfileupload" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "filepath" varchar(255) NOT NULL, "size" integer unsigned NOT NULL CHECK ("size" >= 0), "status" varchar(32) NOT NULL, "error_message" varchar(255) NOT NULL, "date_processed" datetime NULL, "num_new_skus" integer unsigned NULL CHECK ("num_new_skus" >= 0), "num_unknown_skus" integer unsigned NULL CHECK ("num_unknown_skus" >= 0), "num_duplicate_skus" integer unsigned NULL CHECK ("num_duplicate_skus" >= 0), "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "uploaded_by_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "date_uploaded" datetime NOT NULL);
INSERT INTO "new__offer_rangeproductfileupload" ("id", "filepath", "size", "status", "error_message", "date_processed", "num_new_skus", "num_unknown_skus", "num_duplicate_skus", "range_id", "uploaded_by_id", "date_uploaded") SELECT "id", "filepath", "size", "status", "error_message", "date_processed", "num_new_skus", "num_unknown_skus", "num_duplicate_skus", "range_id", "uploaded_by_id", "date_uploaded" FROM "offer_rangeproductfileupload";
DROP TABLE "offer_rangeproductfileupload";
ALTER TABLE "new__offer_rangeproductfileupload" RENAME TO "offer_rangeproductfileupload";
CREATE INDEX "offer_rangeproductfileupload_range_id_c055ebf8" ON "offer_rangeproductfileupload" ("range_id");
CREATE INDEX "offer_rangeproductfileupload_uploaded_by_id_c01a3250" ON "offer_rangeproductfileupload" ("uploaded_by_id");
CREATE INDEX "offer_rangeproductfileupload_date_uploaded_f0a4f9ae" ON "offer_rangeproductfileupload" ("date_uploaded");
COMMIT;


-- Migration: offer 0009_auto_20200801_0817
BEGIN;
--
-- Change Meta options on range
--
-- (no-op)
COMMIT;


-- Migration: offer 0010_conditionaloffer_combinations
BEGIN;
--
-- Add field combinations to conditionaloffer
--
CREATE TABLE "offer_conditionaloffer_combinations" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "from_conditionaloffer_id" bigint NOT NULL REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED, "to_conditionaloffer_id" bigint NOT NULL REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "offer_conditionaloffer_combinations_from_conditionaloffer_id_to_conditionaloffer_id_2e3e9ffe_uniq" ON "offer_conditionaloffer_combinations" ("from_conditionaloffer_id", "to_conditionaloffer_id");
CREATE INDEX "offer_conditionaloffer_combinations_from_conditionaloffer_id_85c3bd9f" ON "offer_conditionaloffer_combinations" ("from_conditionaloffer_id");
CREATE INDEX "offer_conditionaloffer_combinations_to_conditionaloffer_id_ae993478" ON "offer_conditionaloffer_combinations" ("to_conditionaloffer_id");
COMMIT;


-- Migration: offer 0011_rangeproductfileupload_included
BEGIN;
--
-- Add field upload_type to rangeproductfileupload
--
CREATE TABLE "new__offer_rangeproductfileupload" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "upload_type" varchar(8) NOT NULL, "filepath" varchar(255) NOT NULL, "size" integer unsigned NOT NULL CHECK ("size" >= 0), "date_uploaded" datetime NOT NULL, "status" varchar(32) NOT NULL, "error_message" varchar(255) NOT NULL, "date_processed" datetime NULL, "num_new_skus" integer unsigned NULL CHECK ("num_new_skus" >= 0), "num_unknown_skus" integer unsigned NULL CHECK ("num_unknown_skus" >= 0), "num_duplicate_skus" integer unsigned NULL CHECK ("num_duplicate_skus" >= 0), "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "uploaded_by_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__offer_rangeproductfileupload" ("id", "filepath", "size", "date_uploaded", "status", "error_message", "date_processed", "num_new_skus", "num_unknown_skus", "num_duplicate_skus", "range_id", "uploaded_by_id", "upload_type") SELECT "id", "filepath", "size", "date_uploaded", "status", "error_message", "date_processed", "num_new_skus", "num_unknown_skus", "num_duplicate_skus", "range_id", "uploaded_by_id", 'included' FROM "offer_rangeproductfileupload";
DROP TABLE "offer_rangeproductfileupload";
ALTER TABLE "new__offer_rangeproductfileupload" RENAME TO "offer_rangeproductfileupload";
CREATE INDEX "offer_rangeproductfileupload_date_uploaded_f0a4f9ae" ON "offer_rangeproductfileupload" ("date_uploaded");
CREATE INDEX "offer_rangeproductfileupload_range_id_c055ebf8" ON "offer_rangeproductfileupload" ("range_id");
CREATE INDEX "offer_rangeproductfileupload_uploaded_by_id_c01a3250" ON "offer_rangeproductfileupload" ("uploaded_by_id");
COMMIT;


-- Migration: offer 0012_fixedunitdiscountbenefit_alter_benefit_type
BEGIN;
--
-- Create proxy model FixedUnitDiscountBenefit
--
-- (no-op)
--
-- Alter field type on benefit
--
-- (no-op)
COMMIT;


-- Migration: offer 0013_range_excluded_categories
BEGIN;
--
-- Add field excluded_categories to range
--
CREATE TABLE "offer_range_excluded_categories" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "range_id" bigint NOT NULL REFERENCES "offer_range" ("id") DEFERRABLE INITIALLY DEFERRED, "category_id" bigint NOT NULL REFERENCES "catalogue_category" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE UNIQUE INDEX "offer_range_excluded_categories_range_id_category_id_2f84ef27_uniq" ON "offer_range_excluded_categories" ("range_id", "category_id");
CREATE INDEX "offer_range_excluded_categories_range_id_6346945d" ON "offer_range_excluded_categories" ("range_id");
CREATE INDEX "offer_range_excluded_categories_category_id_c16fd4f7" ON "offer_range_excluded_categories" ("category_id");
COMMIT;


-- Migration: order 0009_surcharge
BEGIN;
--
-- Create model Surcharge
--
CREATE TABLE "order_surcharge" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL, "incl_tax" decimal NOT NULL, "excl_tax" decimal NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "order_surcharge_order_id_5c0a94f5" ON "order_surcharge" ("order_id");
COMMIT;


-- Migration: order 0010_auto_20200724_0909
BEGIN;
--
-- Remove field est_dispatch_date from line
--
ALTER TABLE "order_line" DROP COLUMN "est_dispatch_date";
--
-- Remove field unit_cost_price from line
--
ALTER TABLE "order_line" DROP COLUMN "unit_cost_price";
--
-- Remove field unit_retail_price from line
--
ALTER TABLE "order_line" DROP COLUMN "unit_retail_price";
COMMIT;


-- Migration: order 0011_auto_20200801_0817
BEGIN;
--
-- Change Meta options on orderdiscount
--
-- (no-op)
--
-- Change Meta options on ordernote
--
-- (no-op)
COMMIT;


-- Migration: order 0012_convert_to_valid_json
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: order 0013_json_option_value
BEGIN;
--
-- Alter field value on lineattribute
--
CREATE TABLE "new__order_lineattribute" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "value" text NOT NULL CHECK ((JSON_VALID("value") OR "value" IS NULL)), "type" varchar(128) NOT NULL, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED, "option_id" bigint NULL REFERENCES "catalogue_option" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__order_lineattribute" ("id", "type", "line_id", "option_id", "value") SELECT "id", "type", "line_id", "option_id", "value" FROM "order_lineattribute";
DROP TABLE "order_lineattribute";
ALTER TABLE "new__order_lineattribute" RENAME TO "order_lineattribute";
CREATE INDEX "order_lineattribute_line_id_adf6dd87" ON "order_lineattribute" ("line_id");
CREATE INDEX "order_lineattribute_option_id_b54d597c" ON "order_lineattribute" ("option_id");
COMMIT;


-- Migration: order 0014_tax_code
BEGIN;
--
-- Add field tax_code to line
--
ALTER TABLE "order_line" ADD COLUMN "tax_code" varchar(64) NULL;
--
-- Add field tax_code to lineprice
--
ALTER TABLE "order_lineprice" ADD COLUMN "tax_code" varchar(64) NULL;
--
-- Add field shipping_tax_code to order
--
ALTER TABLE "order_order" ADD COLUMN "shipping_tax_code" varchar(64) NULL;
--
-- Add field tax_code to surcharge
--
ALTER TABLE "order_surcharge" ADD COLUMN "tax_code" varchar(64) NULL;
COMMIT;


-- Migration: order 0015_orderlinediscount
BEGIN;
--
-- Create model OrderLineDiscount
--
CREATE TABLE "order_orderlinediscount" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "is_incl_tax" bool NOT NULL, "amount" decimal NOT NULL, "line_id" bigint NOT NULL REFERENCES "order_line" ("id") DEFERRABLE INITIALLY DEFERRED, "order_discount_id" bigint NOT NULL REFERENCES "order_orderdiscount" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "order_orderlinediscount_line_id_88fbcd4a" ON "order_orderlinediscount" ("line_id");
CREATE INDEX "order_orderlinediscount_order_discount_id_b9dfa715" ON "order_orderlinediscount" ("order_discount_id");
COMMIT;


-- Migration: order 0016_line_allocation_cancelled_line_num_allocated
BEGIN;
--
-- Add field allocation_cancelled to line
--
CREATE TABLE "new__order_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "allocation_cancelled" bool NOT NULL, "partner_name" varchar(128) NOT NULL, "partner_sku" varchar(128) NOT NULL, "partner_line_reference" varchar(128) NOT NULL, "partner_line_notes" text NOT NULL, "title" varchar(255) NOT NULL, "upc" varchar(128) NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "line_price_incl_tax" decimal NOT NULL, "line_price_excl_tax" decimal NOT NULL, "line_price_before_discounts_incl_tax" decimal NOT NULL, "line_price_before_discounts_excl_tax" decimal NOT NULL, "unit_price_incl_tax" decimal NULL, "unit_price_excl_tax" decimal NULL, "status" varchar(255) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "partner_id" bigint NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED, "tax_code" varchar(64) NULL);
INSERT INTO "new__order_line" ("id", "partner_name", "partner_sku", "partner_line_reference", "partner_line_notes", "title", "upc", "quantity", "line_price_incl_tax", "line_price_excl_tax", "line_price_before_discounts_incl_tax", "line_price_before_discounts_excl_tax", "unit_price_incl_tax", "unit_price_excl_tax", "status", "order_id", "partner_id", "product_id", "stockrecord_id", "tax_code", "allocation_cancelled") SELECT "id", "partner_name", "partner_sku", "partner_line_reference", "partner_line_notes", "title", "upc", "quantity", "line_price_incl_tax", "line_price_excl_tax", "line_price_before_discounts_incl_tax", "line_price_before_discounts_excl_tax", "unit_price_incl_tax", "unit_price_excl_tax", "status", "order_id", "partner_id", "product_id", "stockrecord_id", "tax_code", 0 FROM "order_line";
DROP TABLE "order_line";
ALTER TABLE "new__order_line" RENAME TO "order_line";
CREATE INDEX "order_line_order_id_b9148391" ON "order_line" ("order_id");
CREATE INDEX "order_line_partner_id_258a2fb9" ON "order_line" ("partner_id");
CREATE INDEX "order_line_product_id_e620902d" ON "order_line" ("product_id");
CREATE INDEX "order_line_stockrecord_id_1d65aff5" ON "order_line" ("stockrecord_id");
--
-- Add field num_allocated to line
--
ALTER TABLE "order_line" ADD COLUMN "num_allocated" integer unsigned NULL CHECK ("num_allocated" >= 0);
COMMIT;


-- Migration: order 0017_set_num_allocated_to_quantity
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: order 0018_alter_line_num_allocated
BEGIN;
--
-- Alter field num_allocated on line
--
CREATE TABLE "new__order_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "num_allocated" integer unsigned NOT NULL CHECK ("num_allocated" >= 0), "partner_name" varchar(128) NOT NULL, "partner_sku" varchar(128) NOT NULL, "partner_line_reference" varchar(128) NOT NULL, "partner_line_notes" text NOT NULL, "title" varchar(255) NOT NULL, "upc" varchar(128) NULL, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "line_price_incl_tax" decimal NOT NULL, "line_price_excl_tax" decimal NOT NULL, "line_price_before_discounts_incl_tax" decimal NOT NULL, "line_price_before_discounts_excl_tax" decimal NOT NULL, "unit_price_incl_tax" decimal NULL, "unit_price_excl_tax" decimal NULL, "status" varchar(255) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "partner_id" bigint NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "stockrecord_id" bigint NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED, "tax_code" varchar(64) NULL, "allocation_cancelled" bool NOT NULL);
INSERT INTO "new__order_line" ("id", "partner_name", "partner_sku", "partner_line_reference", "partner_line_notes", "title", "upc", "quantity", "line_price_incl_tax", "line_price_excl_tax", "line_price_before_discounts_incl_tax", "line_price_before_discounts_excl_tax", "unit_price_incl_tax", "unit_price_excl_tax", "status", "order_id", "partner_id", "product_id", "stockrecord_id", "tax_code", "allocation_cancelled", "num_allocated") SELECT "id", "partner_name", "partner_sku", "partner_line_reference", "partner_line_notes", "title", "upc", "quantity", "line_price_incl_tax", "line_price_excl_tax", "line_price_before_discounts_incl_tax", "line_price_before_discounts_excl_tax", "unit_price_incl_tax", "unit_price_excl_tax", "status", "order_id", "partner_id", "product_id", "stockrecord_id", "tax_code", "allocation_cancelled", coalesce("num_allocated", NULL) FROM "order_line";
DROP TABLE "order_line";
ALTER TABLE "new__order_line" RENAME TO "order_line";
CREATE INDEX "order_line_order_id_b9148391" ON "order_line" ("order_id");
CREATE INDEX "order_line_partner_id_258a2fb9" ON "order_line" ("partner_id");
CREATE INDEX "order_line_product_id_e620902d" ON "order_line" ("product_id");
CREATE INDEX "order_line_stockrecord_id_1d65aff5" ON "order_line" ("stockrecord_id");
COMMIT;


-- Migration: order 0019_order_analytics_tracked
BEGIN;
--
-- Add field analytics_tracked to order
--
CREATE TABLE "new__order_order" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "analytics_tracked" bool NOT NULL, "number" varchar(128) NOT NULL UNIQUE, "currency" varchar(12) NOT NULL, "total_incl_tax" decimal NOT NULL, "total_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "shipping_method" varchar(128) NOT NULL, "shipping_code" varchar(128) NOT NULL, "status" varchar(100) NOT NULL, "guest_email" varchar(254) NOT NULL, "date_placed" datetime NOT NULL, "basket_id" bigint NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "billing_address_id" bigint NULL REFERENCES "order_billingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_address_id" bigint NULL REFERENCES "order_shippingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "site_id" integer NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_tax_code" varchar(64) NULL);
INSERT INTO "new__order_order" ("id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "shipping_tax_code", "analytics_tracked") SELECT "id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "shipping_tax_code", 1 FROM "order_order";
DROP TABLE "order_order";
ALTER TABLE "new__order_order" RENAME TO "order_order";
CREATE INDEX "order_order_date_placed_506a9365" ON "order_order" ("date_placed");
CREATE INDEX "order_order_basket_id_8b0acbb2" ON "order_order" ("basket_id");
CREATE INDEX "order_order_billing_address_id_8fe537cf" ON "order_order" ("billing_address_id");
CREATE INDEX "order_order_shipping_address_id_57e64931" ON "order_order" ("shipping_address_id");
CREATE INDEX "order_order_site_id_e27f3526" ON "order_order" ("site_id");
CREATE INDEX "order_order_user_id_7cf9bc2b" ON "order_order" ("user_id");
COMMIT;


-- Migration: order 0020_alter_order_analytics_tracked
BEGIN;
--
-- Alter field analytics_tracked on order
--
CREATE TABLE "new__order_order" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "analytics_tracked" bool NOT NULL, "number" varchar(128) NOT NULL UNIQUE, "currency" varchar(12) NOT NULL, "total_incl_tax" decimal NOT NULL, "total_excl_tax" decimal NOT NULL, "shipping_incl_tax" decimal NOT NULL, "shipping_excl_tax" decimal NOT NULL, "shipping_method" varchar(128) NOT NULL, "shipping_code" varchar(128) NOT NULL, "status" varchar(100) NOT NULL, "guest_email" varchar(254) NOT NULL, "date_placed" datetime NOT NULL, "basket_id" bigint NULL REFERENCES "basket_basket" ("id") DEFERRABLE INITIALLY DEFERRED, "billing_address_id" bigint NULL REFERENCES "order_billingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_address_id" bigint NULL REFERENCES "order_shippingaddress" ("id") DEFERRABLE INITIALLY DEFERRED, "site_id" integer NULL REFERENCES "django_site" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "shipping_tax_code" varchar(64) NULL);
INSERT INTO "new__order_order" ("id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "shipping_tax_code", "analytics_tracked") SELECT "id", "number", "currency", "total_incl_tax", "total_excl_tax", "shipping_incl_tax", "shipping_excl_tax", "shipping_method", "shipping_code", "status", "guest_email", "date_placed", "basket_id", "billing_address_id", "shipping_address_id", "site_id", "user_id", "shipping_tax_code", "analytics_tracked" FROM "order_order";
DROP TABLE "order_order";
ALTER TABLE "new__order_order" RENAME TO "order_order";
CREATE INDEX "order_order_date_placed_506a9365" ON "order_order" ("date_placed");
CREATE INDEX "order_order_basket_id_8b0acbb2" ON "order_order" ("basket_id");
CREATE INDEX "order_order_billing_address_id_8fe537cf" ON "order_order" ("billing_address_id");
CREATE INDEX "order_order_shipping_address_id_57e64931" ON "order_order" ("shipping_address_id");
CREATE INDEX "order_order_site_id_e27f3526" ON "order_order" ("site_id");
CREATE INDEX "order_order_user_id_7cf9bc2b" ON "order_order" ("user_id");
COMMIT;


-- Migration: oscarapi 0001_initial
BEGIN;
--
-- Create model ApiKey
--
CREATE TABLE "oscarapi_apikey" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "key" varchar(255) NOT NULL UNIQUE);
COMMIT;


-- Migration: partner 0002_auto_20141007_2032
BEGIN;
--
-- Alter field price_currency on stockrecord
--
CREATE TABLE "new__partner_stockrecord" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "price_currency" varchar(12) NOT NULL, "partner_sku" varchar(128) NOT NULL, "price_excl_tax" decimal NULL, "price_retail" decimal NULL, "cost_price" decimal NULL, "num_in_stock" integer unsigned NULL CHECK ("num_in_stock" >= 0), "num_allocated" integer NULL, "low_stock_threshold" integer unsigned NULL CHECK ("low_stock_threshold" >= 0), "date_created" datetime NOT NULL, "date_updated" datetime NOT NULL, "partner_id" bigint NOT NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED, "product_id" bigint NOT NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__partner_stockrecord" ("id", "partner_sku", "price_excl_tax", "price_retail", "cost_price", "num_in_stock", "num_allocated", "low_stock_threshold", "date_created", "date_updated", "partner_id", "product_id", "price_currency") SELECT "id", "partner_sku", "price_excl_tax", "price_retail", "cost_price", "num_in_stock", "num_allocated", "low_stock_threshold", "date_created", "date_updated", "partner_id", "product_id", "price_currency" FROM "partner_stockrecord";
DROP TABLE "partner_stockrecord";
ALTER TABLE "new__partner_stockrecord" RENAME TO "partner_stockrecord";
CREATE UNIQUE INDEX "partner_stockrecord_partner_id_partner_sku_8441e010_uniq" ON "partner_stockrecord" ("partner_id", "partner_sku");
CREATE INDEX "partner_stockrecord_date_updated_e6ae5f14" ON "partner_stockrecord" ("date_updated");
CREATE INDEX "partner_stockrecord_partner_id_4155a586" ON "partner_stockrecord" ("partner_id");
CREATE INDEX "partner_stockrecord_product_id_62fd9e45" ON "partner_stockrecord" ("product_id");
COMMIT;


-- Migration: partner 0003_auto_20150604_1450
BEGIN;
--
-- Alter field users on partner
--
CREATE TABLE "new__partner_partner_users" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "partner_id" bigint NOT NULL REFERENCES "partner_partner" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__partner_partner_users" ("id", "user_id", "partner_id") SELECT "id", "user_id", "partner_id" FROM "partner_partner_users";
DROP TABLE "partner_partner_users";
ALTER TABLE "new__partner_partner_users" RENAME TO "partner_partner_users";
CREATE UNIQUE INDEX "partner_partner_users_partner_id_user_id_9e5c0517_uniq" ON "partner_partner_users" ("partner_id", "user_id");
CREATE INDEX "partner_partner_users_partner_id_1883dfd9" ON "partner_partner_users" ("partner_id");
CREATE INDEX "partner_partner_users_user_id_d75d6e40" ON "partner_partner_users" ("user_id");
COMMIT;


-- Migration: partner 0004_auto_20160107_1755
BEGIN;
--
-- Change Meta options on partner
--
-- (no-op)
COMMIT;


-- Migration: partner 0005_auto_20181115_1953
BEGIN;
--
-- Alter field name on partner
--
CREATE TABLE "new__partner_partner" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE);
INSERT INTO "new__partner_partner" ("id", "code", "name") SELECT "id", "code", "name" FROM "partner_partner";
DROP TABLE "partner_partner";
ALTER TABLE "new__partner_partner" RENAME TO "partner_partner";
CREATE INDEX "partner_partner_name_caa0c2ee" ON "partner_partner" ("name");
--
-- Alter field date_created on stockalert
--
CREATE TABLE "new__partner_stockalert" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "threshold" integer unsigned NOT NULL CHECK ("threshold" >= 0), "status" varchar(128) NOT NULL, "date_closed" datetime NULL, "stockrecord_id" bigint NOT NULL REFERENCES "partner_stockrecord" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__partner_stockalert" ("id", "threshold", "status", "date_closed", "stockrecord_id", "date_created") SELECT "id", "threshold", "status", "date_closed", "stockrecord_id", "date_created" FROM "partner_stockalert";
DROP TABLE "partner_stockalert";
ALTER TABLE "new__partner_stockalert" RENAME TO "partner_stockalert";
CREATE INDEX "partner_stockalert_stockrecord_id_68ad503a" ON "partner_stockalert" ("stockrecord_id");
CREATE INDEX "partner_stockalert_date_created_832cf043" ON "partner_stockalert" ("date_created");
COMMIT;


-- Migration: partner 0006_auto_20200724_0909
BEGIN;
--
-- Remove field cost_price from stockrecord
--
ALTER TABLE "partner_stockrecord" DROP COLUMN "cost_price";
--
-- Remove field price_retail from stockrecord
--
ALTER TABLE "partner_stockrecord" DROP COLUMN "price_retail";
--
-- Alter field price_excl_tax on stockrecord
--
-- (no-op)
--
-- Rename field price_excl_tax on stockrecord to price
--
ALTER TABLE "partner_stockrecord" RENAME COLUMN "price_excl_tax" TO "price";
COMMIT;


-- Migration: payment 0001_initial
BEGIN;
--
-- Create model Bankcard
--
CREATE TABLE "payment_bankcard" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "card_type" varchar(128) NOT NULL, "name" varchar(255) NOT NULL, "number" varchar(32) NOT NULL, "expiry_date" date NOT NULL, "partner_reference" varchar(255) NOT NULL, "user_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model Source
--
CREATE TABLE "payment_source" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "currency" varchar(12) NOT NULL, "amount_allocated" decimal NOT NULL, "amount_debited" decimal NOT NULL, "amount_refunded" decimal NOT NULL, "reference" varchar(128) NOT NULL, "label" varchar(128) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model SourceType
--
CREATE TABLE "payment_sourcetype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE);
--
-- Create model Transaction
--
CREATE TABLE "payment_transaction" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "txn_type" varchar(128) NOT NULL, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "status" varchar(128) NOT NULL, "date_created" datetime NOT NULL, "source_id" bigint NOT NULL REFERENCES "payment_source" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Add field source_type to source
--
CREATE TABLE "new__payment_source" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "currency" varchar(12) NOT NULL, "amount_allocated" decimal NOT NULL, "amount_debited" decimal NOT NULL, "amount_refunded" decimal NOT NULL, "reference" varchar(128) NOT NULL, "label" varchar(128) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "source_type_id" bigint NOT NULL REFERENCES "payment_sourcetype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__payment_source" ("id", "currency", "amount_allocated", "amount_debited", "amount_refunded", "reference", "label", "order_id", "source_type_id") SELECT "id", "currency", "amount_allocated", "amount_debited", "amount_refunded", "reference", "label", "order_id", NULL FROM "payment_source";
DROP TABLE "payment_source";
ALTER TABLE "new__payment_source" RENAME TO "payment_source";
CREATE INDEX "payment_bankcard_user_id_08e1d04c" ON "payment_bankcard" ("user_id");
CREATE INDEX "payment_transaction_source_id_c5ac31e8" ON "payment_transaction" ("source_id");
CREATE INDEX "payment_source_order_id_6b7f2215" ON "payment_source" ("order_id");
CREATE INDEX "payment_source_source_type_id_700828fe" ON "payment_source" ("source_type_id");
COMMIT;


-- Migration: payment 0002_auto_20141007_2032
BEGIN;
--
-- Alter field currency on source
--
CREATE TABLE "new__payment_source" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "currency" varchar(12) NOT NULL, "amount_allocated" decimal NOT NULL, "amount_debited" decimal NOT NULL, "amount_refunded" decimal NOT NULL, "reference" varchar(128) NOT NULL, "label" varchar(128) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "source_type_id" bigint NOT NULL REFERENCES "payment_sourcetype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__payment_source" ("id", "amount_allocated", "amount_debited", "amount_refunded", "reference", "label", "order_id", "source_type_id", "currency") SELECT "id", "amount_allocated", "amount_debited", "amount_refunded", "reference", "label", "order_id", "source_type_id", "currency" FROM "payment_source";
DROP TABLE "payment_source";
ALTER TABLE "new__payment_source" RENAME TO "payment_source";
CREATE INDEX "payment_source_order_id_6b7f2215" ON "payment_source" ("order_id");
CREATE INDEX "payment_source_source_type_id_700828fe" ON "payment_source" ("source_type_id");
COMMIT;


-- Migration: payment 0003_auto_20160323_1520
BEGIN;
--
-- Alter field reference on source
--
CREATE TABLE "new__payment_source" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "reference" varchar(255) NOT NULL, "currency" varchar(12) NOT NULL, "amount_allocated" decimal NOT NULL, "amount_debited" decimal NOT NULL, "amount_refunded" decimal NOT NULL, "label" varchar(128) NOT NULL, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "source_type_id" bigint NOT NULL REFERENCES "payment_sourcetype" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__payment_source" ("id", "currency", "amount_allocated", "amount_debited", "amount_refunded", "label", "order_id", "source_type_id", "reference") SELECT "id", "currency", "amount_allocated", "amount_debited", "amount_refunded", "label", "order_id", "source_type_id", "reference" FROM "payment_source";
DROP TABLE "payment_source";
ALTER TABLE "new__payment_source" RENAME TO "payment_source";
CREATE INDEX "payment_source_order_id_6b7f2215" ON "payment_source" ("order_id");
CREATE INDEX "payment_source_source_type_id_700828fe" ON "payment_source" ("source_type_id");
COMMIT;


-- Migration: payment 0004_auto_20181115_1953
BEGIN;
--
-- Alter field date_created on transaction
--
CREATE TABLE "new__payment_transaction" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "txn_type" varchar(128) NOT NULL, "amount" decimal NOT NULL, "reference" varchar(128) NOT NULL, "status" varchar(128) NOT NULL, "source_id" bigint NOT NULL REFERENCES "payment_source" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__payment_transaction" ("id", "txn_type", "amount", "reference", "status", "source_id", "date_created") SELECT "id", "txn_type", "amount", "reference", "status", "source_id", "date_created" FROM "payment_transaction";
DROP TABLE "payment_transaction";
ALTER TABLE "new__payment_transaction" RENAME TO "payment_transaction";
CREATE INDEX "payment_transaction_date_created_f887f6bc" ON "payment_transaction" ("date_created");
CREATE INDEX "payment_transaction_source_id_c5ac31e8" ON "payment_transaction" ("source_id");
COMMIT;


-- Migration: payment 0005_auto_20200801_0817
BEGIN;
--
-- Change Meta options on source
--
-- (no-op)
--
-- Change Meta options on sourcetype
--
-- (no-op)
--
-- Alter field name on sourcetype
--
CREATE TABLE "new__payment_sourcetype" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE);
INSERT INTO "new__payment_sourcetype" ("id", "code", "name") SELECT "id", "code", "name" FROM "payment_sourcetype";
DROP TABLE "payment_sourcetype";
ALTER TABLE "new__payment_sourcetype" RENAME TO "payment_sourcetype";
CREATE INDEX "payment_sourcetype_name_a980e862" ON "payment_sourcetype" ("name");
COMMIT;


-- Migration: reviews 0002_update_email_length
BEGIN;
--
-- Alter field email on productreview
--
CREATE TABLE "new__reviews_productreview" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "email" varchar(254) NOT NULL, "score" smallint NOT NULL, "title" varchar(255) NOT NULL, "body" text NOT NULL, "name" varchar(255) NOT NULL, "homepage" varchar(200) NOT NULL, "status" smallint NOT NULL, "total_votes" integer NOT NULL, "delta_votes" integer NOT NULL, "date_created" datetime NOT NULL, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__reviews_productreview" ("id", "score", "title", "body", "name", "homepage", "status", "total_votes", "delta_votes", "date_created", "product_id", "user_id", "email") SELECT "id", "score", "title", "body", "name", "homepage", "status", "total_votes", "delta_votes", "date_created", "product_id", "user_id", "email" FROM "reviews_productreview";
DROP TABLE "reviews_productreview";
ALTER TABLE "new__reviews_productreview" RENAME TO "reviews_productreview";
CREATE UNIQUE INDEX "reviews_productreview_product_id_user_id_c4fdc4cd_uniq" ON "reviews_productreview" ("product_id", "user_id");
CREATE INDEX "reviews_productreview_delta_votes_bd8ffc87" ON "reviews_productreview" ("delta_votes");
CREATE INDEX "reviews_productreview_product_id_52e52a32" ON "reviews_productreview" ("product_id");
CREATE INDEX "reviews_productreview_user_id_8acb5ddd" ON "reviews_productreview" ("user_id");
COMMIT;


-- Migration: reviews 0003_auto_20160802_1358
BEGIN;
--
-- Alter field status on productreview
--
CREATE TABLE "new__reviews_productreview" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "status" smallint NOT NULL, "score" smallint NOT NULL, "title" varchar(255) NOT NULL, "body" text NOT NULL, "name" varchar(255) NOT NULL, "email" varchar(254) NOT NULL, "homepage" varchar(200) NOT NULL, "total_votes" integer NOT NULL, "delta_votes" integer NOT NULL, "date_created" datetime NOT NULL, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__reviews_productreview" ("id", "score", "title", "body", "name", "email", "homepage", "total_votes", "delta_votes", "date_created", "product_id", "user_id", "status") SELECT "id", "score", "title", "body", "name", "email", "homepage", "total_votes", "delta_votes", "date_created", "product_id", "user_id", "status" FROM "reviews_productreview";
DROP TABLE "reviews_productreview";
ALTER TABLE "new__reviews_productreview" RENAME TO "reviews_productreview";
CREATE UNIQUE INDEX "reviews_productreview_product_id_user_id_c4fdc4cd_uniq" ON "reviews_productreview" ("product_id", "user_id");
CREATE INDEX "reviews_productreview_delta_votes_bd8ffc87" ON "reviews_productreview" ("delta_votes");
CREATE INDEX "reviews_productreview_product_id_52e52a32" ON "reviews_productreview" ("product_id");
CREATE INDEX "reviews_productreview_user_id_8acb5ddd" ON "reviews_productreview" ("user_id");
COMMIT;


-- Migration: reviews 0004_auto_20170429_0941
BEGIN;
--
-- Alter field product on productreview
--
-- (no-op)
COMMIT;


-- Migration: scanner 0001_initial
BEGIN;
--
-- Create model Ingredient
--
CREATE TABLE "scanner_ingredient" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL UNIQUE, "inci_name" varchar(255) NULL, "function" text NULL, "description" text NULL, "safety_rating" integer NOT NULL, "comedogenic_rating" integer NOT NULL, "is_allergen" bool NOT NULL, "is_irritant" bool NOT NULL, "pregnancy_safe" bool NOT NULL, "effects" text NOT NULL CHECK ((JSON_VALID("effects") OR "effects" IS NULL)), "created_at" datetime NOT NULL, "updated_at" datetime NOT NULL);
COMMIT;


-- Migration: scanner 0002_ingredient_description_sq
BEGIN;
--
-- Add field description_sq to ingredient
--
ALTER TABLE "scanner_ingredient" ADD COLUMN "description_sq" text NULL;
COMMIT;


-- Migration: sessions 0001_initial
BEGIN;
--
-- Create model Session
--
CREATE TABLE "django_session" ("session_key" varchar(40) NOT NULL PRIMARY KEY, "session_data" text NOT NULL, "expire_date" datetime NOT NULL);
CREATE INDEX "django_session_expire_date_a5c62663" ON "django_session" ("expire_date");
COMMIT;


-- Migration: shipping 0001_initial
BEGIN;
--
-- Create model OrderAndItemCharges
--
CREATE TABLE "shipping_orderanditemcharges" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(128) NOT NULL UNIQUE, "name" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "price_per_order" decimal NOT NULL, "price_per_item" decimal NOT NULL, "free_shipping_threshold" decimal NULL);
CREATE TABLE "shipping_orderanditemcharges_countries" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "orderanditemcharges_id" bigint NOT NULL REFERENCES "shipping_orderanditemcharges" ("id") DEFERRABLE INITIALLY DEFERRED, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model WeightBand
--
CREATE TABLE "shipping_weightband" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "upper_limit" decimal NOT NULL, "charge" decimal NOT NULL);
--
-- Create model WeightBased
--
CREATE TABLE "shipping_weightbased" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(128) NOT NULL UNIQUE, "name" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "default_weight" decimal NOT NULL);
CREATE TABLE "shipping_weightbased_countries" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "weightbased_id" bigint NOT NULL REFERENCES "shipping_weightbased" ("id") DEFERRABLE INITIALLY DEFERRED, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED);
--
-- Add field method to weightband
--
CREATE TABLE "new__shipping_weightband" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "upper_limit" decimal NOT NULL, "charge" decimal NOT NULL, "method_id" bigint NOT NULL REFERENCES "shipping_weightbased" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__shipping_weightband" ("id", "upper_limit", "charge", "method_id") SELECT "id", "upper_limit", "charge", NULL FROM "shipping_weightband";
DROP TABLE "shipping_weightband";
ALTER TABLE "new__shipping_weightband" RENAME TO "shipping_weightband";
CREATE UNIQUE INDEX "shipping_orderanditemcharges_countries_orderanditemcharges_id_country_id_9f0c9c8f_uniq" ON "shipping_orderanditemcharges_countries" ("orderanditemcharges_id", "country_id");
CREATE INDEX "shipping_orderanditemcharges_countries_orderanditemcharges_id_bf5bfee9" ON "shipping_orderanditemcharges_countries" ("orderanditemcharges_id");
CREATE INDEX "shipping_orderanditemcharges_countries_country_id_30387f2e" ON "shipping_orderanditemcharges_countries" ("country_id");
CREATE UNIQUE INDEX "shipping_weightbased_countries_weightbased_id_country_id_de8c5e42_uniq" ON "shipping_weightbased_countries" ("weightbased_id", "country_id");
CREATE INDEX "shipping_weightbased_countries_weightbased_id_93e3132f" ON "shipping_weightbased_countries" ("weightbased_id");
CREATE INDEX "shipping_weightbased_countries_country_id_06117384" ON "shipping_weightbased_countries" ("country_id");
CREATE INDEX "shipping_weightband_method_id_b699a1ba" ON "shipping_weightband" ("method_id");
COMMIT;


-- Migration: shipping 0002_auto_20150604_1450
BEGIN;
--
-- Alter field countries on orderanditemcharges
--
CREATE TABLE "new__shipping_orderanditemcharges_countries" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "orderanditemcharges_id" bigint NOT NULL REFERENCES "shipping_orderanditemcharges" ("id") DEFERRABLE INITIALLY DEFERRED, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__shipping_orderanditemcharges_countries" ("id", "country_id", "orderanditemcharges_id") SELECT "id", "country_id", "orderanditemcharges_id" FROM "shipping_orderanditemcharges_countries";
DROP TABLE "shipping_orderanditemcharges_countries";
ALTER TABLE "new__shipping_orderanditemcharges_countries" RENAME TO "shipping_orderanditemcharges_countries";
CREATE UNIQUE INDEX "shipping_orderanditemcharges_countries_orderanditemcharges_id_country_id_9f0c9c8f_uniq" ON "shipping_orderanditemcharges_countries" ("orderanditemcharges_id", "country_id");
CREATE INDEX "shipping_orderanditemcharges_countries_orderanditemcharges_id_bf5bfee9" ON "shipping_orderanditemcharges_countries" ("orderanditemcharges_id");
CREATE INDEX "shipping_orderanditemcharges_countries_country_id_30387f2e" ON "shipping_orderanditemcharges_countries" ("country_id");
--
-- Alter field countries on weightbased
--
CREATE TABLE "new__shipping_weightbased_countries" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "weightbased_id" bigint NOT NULL REFERENCES "shipping_weightbased" ("id") DEFERRABLE INITIALLY DEFERRED, "country_id" varchar(2) NOT NULL REFERENCES "address_country" ("iso_3166_1_a2") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__shipping_weightbased_countries" ("id", "country_id", "weightbased_id") SELECT "id", "country_id", "weightbased_id" FROM "shipping_weightbased_countries";
DROP TABLE "shipping_weightbased_countries";
ALTER TABLE "new__shipping_weightbased_countries" RENAME TO "shipping_weightbased_countries";
CREATE UNIQUE INDEX "shipping_weightbased_countries_weightbased_id_country_id_de8c5e42_uniq" ON "shipping_weightbased_countries" ("weightbased_id", "country_id");
CREATE INDEX "shipping_weightbased_countries_weightbased_id_93e3132f" ON "shipping_weightbased_countries" ("weightbased_id");
CREATE INDEX "shipping_weightbased_countries_country_id_06117384" ON "shipping_weightbased_countries" ("country_id");
COMMIT;


-- Migration: shipping 0003_auto_20181115_1953
BEGIN;
--
-- Alter field name on orderanditemcharges
--
CREATE TABLE "new__shipping_orderanditemcharges" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL UNIQUE, "code" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "price_per_order" decimal NOT NULL, "price_per_item" decimal NOT NULL, "free_shipping_threshold" decimal NULL);
INSERT INTO "new__shipping_orderanditemcharges" ("id", "code", "description", "price_per_order", "price_per_item", "free_shipping_threshold", "name") SELECT "id", "code", "description", "price_per_order", "price_per_item", "free_shipping_threshold", "name" FROM "shipping_orderanditemcharges";
DROP TABLE "shipping_orderanditemcharges";
ALTER TABLE "new__shipping_orderanditemcharges" RENAME TO "shipping_orderanditemcharges";
--
-- Alter field upper_limit on weightband
--
CREATE TABLE "new__shipping_weightband" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "charge" decimal NOT NULL, "method_id" bigint NOT NULL REFERENCES "shipping_weightbased" ("id") DEFERRABLE INITIALLY DEFERRED, "upper_limit" decimal NOT NULL);
INSERT INTO "new__shipping_weightband" ("id", "charge", "method_id", "upper_limit") SELECT "id", "charge", "method_id", "upper_limit" FROM "shipping_weightband";
DROP TABLE "shipping_weightband";
ALTER TABLE "new__shipping_weightband" RENAME TO "shipping_weightband";
CREATE INDEX "shipping_weightband_method_id_b699a1ba" ON "shipping_weightband" ("method_id");
CREATE INDEX "shipping_weightband_upper_limit_9edc5097" ON "shipping_weightband" ("upper_limit");
--
-- Alter field name on weightbased
--
CREATE TABLE "new__shipping_weightbased" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "code" varchar(128) NOT NULL UNIQUE, "description" text NOT NULL, "default_weight" decimal NOT NULL, "name" varchar(128) NOT NULL UNIQUE);
INSERT INTO "new__shipping_weightbased" ("id", "code", "description", "default_weight", "name") SELECT "id", "code", "description", "default_weight", "name" FROM "shipping_weightbased";
DROP TABLE "shipping_weightbased";
ALTER TABLE "new__shipping_weightbased" RENAME TO "shipping_weightbased";
COMMIT;


-- Migration: sites 0002_alter_domain_unique
BEGIN;
--
-- Alter field domain on site
--
CREATE TABLE "new__django_site" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "domain" varchar(100) NOT NULL UNIQUE, "name" varchar(50) NOT NULL);
INSERT INTO "new__django_site" ("id", "name", "domain") SELECT "id", "name", "domain" FROM "django_site";
DROP TABLE "django_site";
ALTER TABLE "new__django_site" RENAME TO "django_site";
COMMIT;


-- Migration: thumbnail 0001_initial
BEGIN;
--
-- Create model KVStore
--
CREATE TABLE "thumbnail_kvstore" ("key" varchar(200) NOT NULL PRIMARY KEY, "value" text NOT NULL);
COMMIT;


-- Migration: voucher 0002_auto_20170418_2132
BEGIN;
--
-- Alter field date_created on voucher
--
CREATE TABLE "new__voucher_voucher" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "usage" varchar(128) NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "total_discount" decimal NOT NULL);
INSERT INTO "new__voucher_voucher" ("id", "name", "code", "usage", "start_datetime", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created") SELECT "id", "name", "code", "usage", "start_datetime", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created" FROM "voucher_voucher";
DROP TABLE "voucher_voucher";
ALTER TABLE "new__voucher_voucher" RENAME TO "voucher_voucher";
--
-- Alter field date_created on voucherapplication
--
CREATE TABLE "new__voucher_voucherapplication" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "voucher_id" bigint NOT NULL REFERENCES "voucher_voucher" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__voucher_voucherapplication" ("id", "order_id", "user_id", "voucher_id", "date_created") SELECT "id", "order_id", "user_id", "voucher_id", "date_created" FROM "voucher_voucherapplication";
DROP TABLE "voucher_voucherapplication";
ALTER TABLE "new__voucher_voucherapplication" RENAME TO "voucher_voucherapplication";
CREATE INDEX "voucher_voucherapplication_order_id_30248a05" ON "voucher_voucherapplication" ("order_id");
CREATE INDEX "voucher_voucherapplication_user_id_df53a393" ON "voucher_voucherapplication" ("user_id");
CREATE INDEX "voucher_voucherapplication_voucher_id_5204edb7" ON "voucher_voucherapplication" ("voucher_id");
COMMIT;


-- Migration: voucher 0003_auto_20171212_0411
BEGIN;
--
-- Alter field offers on voucher
--
-- (no-op)
COMMIT;


-- Migration: voucher 0004_auto_20180228_0940
BEGIN;
--
-- Create model VoucherSet
--
CREATE TABLE "voucher_voucherset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(100) NOT NULL, "count" integer NOT NULL, "code_length" integer NOT NULL, "description" text NOT NULL, "date_created" datetime NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "offer_id" bigint NULL UNIQUE REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Add field voucher_set to voucher
--
ALTER TABLE "voucher_voucher" ADD COLUMN "voucher_set_id" bigint NULL REFERENCES "voucher_voucherset" ("id") DEFERRABLE INITIALLY DEFERRED;
CREATE INDEX "voucher_voucher_voucher_set_id_17b96a54" ON "voucher_voucher" ("voucher_set_id");
COMMIT;


-- Migration: voucher 0005_auto_20180402_1425
BEGIN;
--
-- Alter field offer on voucherset
--
-- (no-op)
COMMIT;


-- Migration: voucher 0006_auto_20180413_0911
BEGIN;
--
-- Alter field count on voucherset
--
CREATE TABLE "new__voucher_voucherset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "count" integer unsigned NOT NULL CHECK ("count" >= 0), "name" varchar(100) NOT NULL, "code_length" integer NOT NULL, "description" text NOT NULL, "date_created" datetime NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "offer_id" bigint NULL UNIQUE REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__voucher_voucherset" ("id", "name", "code_length", "description", "date_created", "start_datetime", "end_datetime", "offer_id", "count") SELECT "id", "name", "code_length", "description", "date_created", "start_datetime", "end_datetime", "offer_id", "count" FROM "voucher_voucherset";
DROP TABLE "voucher_voucherset";
ALTER TABLE "new__voucher_voucherset" RENAME TO "voucher_voucherset";
COMMIT;


-- Migration: voucher 0007_auto_20181115_1953
BEGIN;
--
-- Alter field end_datetime on voucher
--
CREATE TABLE "new__voucher_voucher" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "end_datetime" datetime NOT NULL, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "usage" varchar(128) NOT NULL, "start_datetime" datetime NOT NULL, "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "total_discount" decimal NOT NULL, "date_created" datetime NOT NULL, "voucher_set_id" bigint NULL REFERENCES "voucher_voucherset" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__voucher_voucher" ("id", "name", "code", "usage", "start_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created", "voucher_set_id", "end_datetime") SELECT "id", "name", "code", "usage", "start_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created", "voucher_set_id", "end_datetime" FROM "voucher_voucher";
DROP TABLE "voucher_voucher";
ALTER TABLE "new__voucher_voucher" RENAME TO "voucher_voucher";
CREATE INDEX "voucher_voucher_end_datetime_db182297" ON "voucher_voucher" ("end_datetime");
CREATE INDEX "voucher_voucher_voucher_set_id_17b96a54" ON "voucher_voucher" ("voucher_set_id");
--
-- Alter field start_datetime on voucher
--
CREATE TABLE "new__voucher_voucher" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "usage" varchar(128) NOT NULL, "end_datetime" datetime NOT NULL, "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "total_discount" decimal NOT NULL, "date_created" datetime NOT NULL, "voucher_set_id" bigint NULL REFERENCES "voucher_voucherset" ("id") DEFERRABLE INITIALLY DEFERRED, "start_datetime" datetime NOT NULL);
INSERT INTO "new__voucher_voucher" ("id", "name", "code", "usage", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created", "voucher_set_id", "start_datetime") SELECT "id", "name", "code", "usage", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created", "voucher_set_id", "start_datetime" FROM "voucher_voucher";
DROP TABLE "voucher_voucher";
ALTER TABLE "new__voucher_voucher" RENAME TO "voucher_voucher";
CREATE INDEX "voucher_voucher_end_datetime_db182297" ON "voucher_voucher" ("end_datetime");
CREATE INDEX "voucher_voucher_voucher_set_id_17b96a54" ON "voucher_voucher" ("voucher_set_id");
CREATE INDEX "voucher_voucher_start_datetime_bfb7df84" ON "voucher_voucher" ("start_datetime");
COMMIT;


-- Migration: voucher 0008_auto_20200801_0817
BEGIN;
--
-- Change Meta options on voucher
--
-- (no-op)
--
-- Change Meta options on voucherapplication
--
-- (no-op)
--
-- Change Meta options on voucherset
--
-- (no-op)
--
-- Alter field date_created on voucher
--
CREATE TABLE "new__voucher_voucher" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "name" varchar(128) NOT NULL, "code" varchar(128) NOT NULL UNIQUE, "usage" varchar(128) NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "total_discount" decimal NOT NULL, "voucher_set_id" bigint NULL REFERENCES "voucher_voucherset" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__voucher_voucher" ("id", "name", "code", "usage", "start_datetime", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "voucher_set_id", "date_created") SELECT "id", "name", "code", "usage", "start_datetime", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "voucher_set_id", "date_created" FROM "voucher_voucher";
DROP TABLE "voucher_voucher";
ALTER TABLE "new__voucher_voucher" RENAME TO "voucher_voucher";
CREATE INDEX "voucher_voucher_date_created_f3081a03" ON "voucher_voucher" ("date_created");
CREATE INDEX "voucher_voucher_start_datetime_bfb7df84" ON "voucher_voucher" ("start_datetime");
CREATE INDEX "voucher_voucher_end_datetime_db182297" ON "voucher_voucher" ("end_datetime");
CREATE INDEX "voucher_voucher_voucher_set_id_17b96a54" ON "voucher_voucher" ("voucher_set_id");
--
-- Alter field date_created on voucherapplication
--
CREATE TABLE "new__voucher_voucherapplication" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "order_id" bigint NOT NULL REFERENCES "order_order" ("id") DEFERRABLE INITIALLY DEFERRED, "user_id" integer NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED, "voucher_id" bigint NOT NULL REFERENCES "voucher_voucher" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__voucher_voucherapplication" ("id", "order_id", "user_id", "voucher_id", "date_created") SELECT "id", "order_id", "user_id", "voucher_id", "date_created" FROM "voucher_voucherapplication";
DROP TABLE "voucher_voucherapplication";
ALTER TABLE "new__voucher_voucherapplication" RENAME TO "voucher_voucherapplication";
CREATE INDEX "voucher_voucherapplication_order_id_30248a05" ON "voucher_voucherapplication" ("order_id");
CREATE INDEX "voucher_voucherapplication_user_id_df53a393" ON "voucher_voucherapplication" ("user_id");
CREATE INDEX "voucher_voucherapplication_voucher_id_5204edb7" ON "voucher_voucherapplication" ("voucher_id");
CREATE INDEX "voucher_voucherapplication_date_created_2d9acdaf" ON "voucher_voucherapplication" ("date_created");
--
-- Alter field date_created on voucherset
--
CREATE TABLE "new__voucher_voucherset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(100) NOT NULL, "count" integer unsigned NOT NULL CHECK ("count" >= 0), "code_length" integer NOT NULL, "description" text NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "offer_id" bigint NULL UNIQUE REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED, "date_created" datetime NOT NULL);
INSERT INTO "new__voucher_voucherset" ("id", "name", "count", "code_length", "description", "start_datetime", "end_datetime", "offer_id", "date_created") SELECT "id", "name", "count", "code_length", "description", "start_datetime", "end_datetime", "offer_id", "date_created" FROM "voucher_voucherset";
DROP TABLE "voucher_voucherset";
ALTER TABLE "new__voucher_voucherset" RENAME TO "voucher_voucherset";
CREATE INDEX "voucher_voucherset_date_created_3dd68c8e" ON "voucher_voucherset" ("date_created");
COMMIT;


-- Migration: voucher 0009_make_voucher_names_unique
BEGIN;
--
-- Raw Python operation
--
-- THIS OPERATION CANNOT BE WRITTEN AS SQL
COMMIT;


-- Migration: voucher 0010_auto_20210224_0712
BEGIN;
--
-- Alter field name on voucher
--
CREATE TABLE "new__voucher_voucher" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(128) NOT NULL UNIQUE, "code" varchar(128) NOT NULL UNIQUE, "usage" varchar(128) NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "num_basket_additions" integer unsigned NOT NULL CHECK ("num_basket_additions" >= 0), "num_orders" integer unsigned NOT NULL CHECK ("num_orders" >= 0), "total_discount" decimal NOT NULL, "date_created" datetime NOT NULL, "voucher_set_id" bigint NULL REFERENCES "voucher_voucherset" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__voucher_voucher" ("id", "code", "usage", "start_datetime", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created", "voucher_set_id", "name") SELECT "id", "code", "usage", "start_datetime", "end_datetime", "num_basket_additions", "num_orders", "total_discount", "date_created", "voucher_set_id", "name" FROM "voucher_voucher";
DROP TABLE "voucher_voucher";
ALTER TABLE "new__voucher_voucher" RENAME TO "voucher_voucher";
CREATE INDEX "voucher_voucher_start_datetime_bfb7df84" ON "voucher_voucher" ("start_datetime");
CREATE INDEX "voucher_voucher_end_datetime_db182297" ON "voucher_voucher" ("end_datetime");
CREATE INDEX "voucher_voucher_date_created_f3081a03" ON "voucher_voucher" ("date_created");
CREATE INDEX "voucher_voucher_voucher_set_id_17b96a54" ON "voucher_voucher" ("voucher_set_id");
--
-- Alter field name on voucherset
--
CREATE TABLE "new__voucher_voucherset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "count" integer unsigned NOT NULL CHECK ("count" >= 0), "code_length" integer NOT NULL, "description" text NOT NULL, "date_created" datetime NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL, "offer_id" bigint NULL UNIQUE REFERENCES "offer_conditionaloffer" ("id") DEFERRABLE INITIALLY DEFERRED, "name" varchar(100) NOT NULL UNIQUE);
INSERT INTO "new__voucher_voucherset" ("id", "count", "code_length", "description", "date_created", "start_datetime", "end_datetime", "offer_id", "name") SELECT "id", "count", "code_length", "description", "date_created", "start_datetime", "end_datetime", "offer_id", "name" FROM "voucher_voucherset";
DROP TABLE "voucher_voucherset";
ALTER TABLE "new__voucher_voucherset" RENAME TO "voucher_voucherset";
CREATE INDEX "voucher_voucherset_date_created_3dd68c8e" ON "voucher_voucherset" ("date_created");
--
-- Remove field offer from voucherset
--
CREATE TABLE "new__voucher_voucherset" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(100) NOT NULL UNIQUE, "count" integer unsigned NOT NULL CHECK ("count" >= 0), "code_length" integer NOT NULL, "description" text NOT NULL, "date_created" datetime NOT NULL, "start_datetime" datetime NOT NULL, "end_datetime" datetime NOT NULL);
INSERT INTO "new__voucher_voucherset" ("id", "name", "count", "code_length", "description", "date_created", "start_datetime", "end_datetime") SELECT "id", "name", "count", "code_length", "description", "date_created", "start_datetime", "end_datetime" FROM "voucher_voucherset";
DROP TABLE "voucher_voucherset";
ALTER TABLE "new__voucher_voucherset" RENAME TO "voucher_voucherset";
CREATE INDEX "voucher_voucherset_date_created_3dd68c8e" ON "voucher_voucherset" ("date_created");
COMMIT;


-- Migration: wishlists 0001_initial
BEGIN;
--
-- Create model Line
--
CREATE TABLE "wishlists_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "title" varchar(255) NOT NULL, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Create model WishList
--
CREATE TABLE "wishlists_wishlist" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "name" varchar(255) NOT NULL, "key" varchar(6) NOT NULL UNIQUE, "visibility" varchar(20) NOT NULL, "date_created" datetime NOT NULL, "owner_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
--
-- Add field wishlist to line
--
CREATE TABLE "new__wishlists_line" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "quantity" integer unsigned NOT NULL CHECK ("quantity" >= 0), "title" varchar(255) NOT NULL, "product_id" bigint NULL REFERENCES "catalogue_product" ("id") DEFERRABLE INITIALLY DEFERRED, "wishlist_id" bigint NOT NULL REFERENCES "wishlists_wishlist" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__wishlists_line" ("id", "quantity", "title", "product_id", "wishlist_id") SELECT "id", "quantity", "title", "product_id", NULL FROM "wishlists_line";
DROP TABLE "wishlists_line";
ALTER TABLE "new__wishlists_line" RENAME TO "wishlists_line";
CREATE INDEX "wishlists_wishlist_owner_id_d5464c62" ON "wishlists_wishlist" ("owner_id");
CREATE INDEX "wishlists_line_product_id_9d6d9b37" ON "wishlists_line" ("product_id");
CREATE INDEX "wishlists_line_wishlist_id_4cffe302" ON "wishlists_line" ("wishlist_id");
--
-- Alter unique_together for line (1 constraint(s))
--
CREATE UNIQUE INDEX "wishlists_line_wishlist_id_product_id_78f04673_uniq" ON "wishlists_line" ("wishlist_id", "product_id");
COMMIT;


-- Migration: wishlists 0002_auto_20160111_1108
BEGIN;
--
-- Change Meta options on line
--
-- (no-op)
COMMIT;


-- Migration: wishlists 0003_auto_20181115_1953
BEGIN;
--
-- Alter field date_created on wishlist
--
CREATE TABLE "new__wishlists_wishlist" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "date_created" datetime NOT NULL, "name" varchar(255) NOT NULL, "key" varchar(6) NOT NULL UNIQUE, "visibility" varchar(20) NOT NULL, "owner_id" integer NOT NULL REFERENCES "auth_user" ("id") DEFERRABLE INITIALLY DEFERRED);
INSERT INTO "new__wishlists_wishlist" ("id", "name", "key", "visibility", "owner_id", "date_created") SELECT "id", "name", "key", "visibility", "owner_id", "date_created" FROM "wishlists_wishlist";
DROP TABLE "wishlists_wishlist";
ALTER TABLE "new__wishlists_wishlist" RENAME TO "wishlists_wishlist";
CREATE INDEX "wishlists_wishlist_date_created_c05d5e7f" ON "wishlists_wishlist" ("date_created");
CREATE INDEX "wishlists_wishlist_owner_id_d5464c62" ON "wishlists_wishlist" ("owner_id");
COMMIT;


-- Migration: wishlists 0004_auto_20220328_0939
BEGIN;
--
-- Create model WishListSharedEmail
--
CREATE TABLE "wishlists_wishlistsharedemail" ("id" integer NOT NULL PRIMARY KEY AUTOINCREMENT, "email" varchar(254) NOT NULL, "wishlist_id" bigint NOT NULL REFERENCES "wishlists_wishlist" ("id") DEFERRABLE INITIALLY DEFERRED);
CREATE INDEX "wishlists_wishlistsharedemail_wishlist_id_d7500842" ON "wishlists_wishlistsharedemail" ("wishlist_id");
COMMIT;


COMMIT;
