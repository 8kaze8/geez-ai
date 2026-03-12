-- ============================================================
-- 006_pgvector.sql
-- pgvector Extension + Place Embeddings
-- ============================================================

-- pgvector extension
CREATE EXTENSION IF NOT EXISTS vector;

-- Mekan embeddings cache
CREATE TABLE place_embeddings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  place_id TEXT UNIQUE NOT NULL,
  place_name TEXT NOT NULL,
  city TEXT NOT NULL,
  category TEXT,
  description TEXT,
  embedding vector(1536),                   -- OpenAI / Claude embedding boyutu
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Benzer mekan arama icin ivfflat index (cosine similarity)
-- NOT: Bu index en az 100 satir veri oldugunda optimal calisir.
-- Bos tabloda olusturulursa sorun olmaz, Postgres veri geldikce kullanir.
CREATE INDEX idx_place_embeddings_vector
  ON place_embeddings
  USING ivfflat (embedding vector_cosine_ops)
  WITH (lists = 100);
