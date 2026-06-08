CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  role TEXT CHECK (role IN ('owner','sitter','admin')) DEFAULT 'owner',
  created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE pets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES users(id),
  name TEXT,
  type TEXT,
  created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_id UUID REFERENCES users(id),
  sitter_id UUID REFERENCES users(id),
  pet_id UUID REFERENCES pets(id),
  start_time TIMESTAMP,
  end_time TIMESTAMP,
  status TEXT DEFAULT 'pending'
);

CREATE TABLE payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID REFERENCES bookings(id),
  amount NUMERIC,
  status TEXT DEFAULT 'held',
  created_at TIMESTAMP DEFAULT now()
);

CREATE TABLE reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  booking_id UUID REFERENCES bookings(id),
  rating INT,
  comment TEXT
);