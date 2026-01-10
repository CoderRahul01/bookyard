-- 1. Create Enums
DO $$ BEGIN
    CREATE TYPE user_role AS ENUM ('parent', 'kid');
    CREATE TYPE intent_type AS ENUM ('giveaway', 'sell', 'share');
    CREATE TYPE reservation_status AS ENUM ('pending', 'active', 'completed', 'cancelled');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- 2. Create Categories table
CREATE TABLE IF NOT EXISTS category (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 3. Create Profiles table (linked to Auth)
CREATE TABLE IF NOT EXISTS profile (
    id UUID PRIMARY KEY REFERENCES auth.users ON DELETE CASCADE,
    username TEXT UNIQUE,
    full_name TEXT,
    avatar_url TEXT,
    role user_role DEFAULT 'parent',
    parent_id UUID REFERENCES profile(id) ON DELETE SET NULL,
    credits INTEGER DEFAULT 0,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 4. Create Books table
CREATE TABLE IF NOT EXISTS book (
    id SERIAL PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    description TEXT,
    isbn TEXT,
    published_year INTEGER,
    pages INTEGER,
    price DECIMAL(12,2),
    stock_count INTEGER DEFAULT 1,
    intent intent_type DEFAULT 'share',
    is_active BOOLEAN DEFAULT TRUE,
    owner_id UUID REFERENCES profile(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES category(id) ON DELETE SET NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 5. Create Reservations table
CREATE TABLE IF NOT EXISTS reservation (
    id SERIAL PRIMARY KEY,
    book_id INTEGER REFERENCES book(id) ON DELETE CASCADE,
    borrower_id UUID REFERENCES profile(id) ON DELETE CASCADE,
    status reservation_status DEFAULT 'pending',
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    credits_used INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 6. Create Credits History
CREATE TABLE IF NOT EXISTS creditshistory (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES profile(id) ON DELETE CASCADE,
    amount INTEGER NOT NULL,
    type TEXT NOT NULL,
    description TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 7. Create Feed Items
CREATE TABLE IF NOT EXISTS feeditem (
    id SERIAL PRIMARY KEY,
    user_id UUID REFERENCES profile(id) ON DELETE CASCADE,
    action_type TEXT NOT NULL,
    content TEXT NOT NULL,
    metadata JSONB DEFAULT '{}',
    is_public BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- 8. Enable Realtime
BEGIN;
  DROP PUBLICATION IF EXISTS supabase_realtime;
  CREATE PUBLICATION supabase_realtime FOR TABLE book, reservation, feeditem, category;
COMMIT;

-- 9. Performance Optimization: Indexes
CREATE INDEX IF NOT EXISTS idx_book_title ON book USING GIN (to_tsvector('english', title));
CREATE INDEX IF NOT EXISTS idx_book_author ON book USING GIN (to_tsvector('english', author));
CREATE INDEX IF NOT EXISTS idx_book_category ON book(category_id);
CREATE INDEX IF NOT EXISTS idx_reservation_book ON reservation(book_id);

-- 10. Row Level Security (RLS)
ALTER TABLE book ENABLE ROW LEVEL SECURITY;
ALTER TABLE profile ENABLE ROW LEVEL SECURITY;
ALTER TABLE reservation ENABLE ROW LEVEL SECURITY;

-- Public read access for books
CREATE POLICY "Public Read Access" ON book FOR SELECT USING (is_active = TRUE);

-- Authenticated users control own books
CREATE POLICY "Users Control Own Books" ON book 
    FOR ALL 
    TO authenticated 
    USING (auth.uid() = owner_id)
    WITH CHECK (auth.uid() = owner_id);
