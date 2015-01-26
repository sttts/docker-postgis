#!/bin/sh
POSTGRES="gosu postgres postgres"

$POSTGRES --single -E <<EOSQL
CREATE DATABASE template_postgis
UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template_postgis'
EOSQL

POSTGIS_CONFIG=/usr/share/postgresql/$PG_MAJOR/contrib/postgis-$POSTGIS_MAJOR
PG_ROUTING_CONFIG=/usr/share/postgresql/$PG_MAJOR/contrib/pgrouting-2.0

# PostGIS Core
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/postgis.sql
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/spatial_ref_sys.sql
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/postgis_comments.sql

# Raster support
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/rtpostgis.sql
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/raster_comments.sql

# Topology support
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/topology.sql
$POSTGRES --single template_postgis -j < $POSTGIS_CONFIG/topology_comments.sql

# pgRouting support
$POSTGRES --single template_postgis -j < $PG_ROUTING_CONFIG/pgrouting.sql
