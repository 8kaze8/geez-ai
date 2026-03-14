-- ============================================================
-- 001_extensions.sql
-- PostgreSQL extensions and shared utility functions.
--
-- Must run first — all other migrations depend on the
-- update_updated_at_column() trigger function defined here.
-- Extensions: pgvector (embeddings), pg_trgm (text search),
-- moddatetime (auto updated_at via trigger).
-- ============================================================


-- ========================
-- Extensions
-- ========================

-- Vector similarity search (1536-dim embeddings)
CREATE EXTENSION IF NOT EXISTS vector
  WITH SCHEMA extensions;

-- Trigram text similarity (ILIKE-free full-text search)
CREATE EXTENSION IF NOT EXISTS pg_trgm
  WITH SCHEMA extensions;

-- Auto-update timestamptz columns via trigger
CREATE EXTENSION IF NOT EXISTS moddatetime
  WITH SCHEMA extensions;


-- ========================
-- Shared utility functions
-- ========================

-- Generic updated_at trigger function.
-- Used by every table that has an updated_at column.
-- Naming convention: trg_{table}_set_updated_at
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$;

COMMENT ON FUNCTION public.update_updated_at_column() IS
  'Sets updated_at = now() on every UPDATE. Attach with a BEFORE UPDATE trigger.';
