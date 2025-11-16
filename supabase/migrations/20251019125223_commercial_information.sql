CREATE TABLE IF NOT EXISTS public.user_practice_information (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_profile_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE UNIQUE NOT NULL,

    practice_name VARCHAR(255),
    practice_type VARCHAR(50),
    street VARCHAR(255),
    house_number VARCHAR(20),
    postal_code VARCHAR(20),
    city VARCHAR(100),
    state VARCHAR(100),
    country CHAR(2),
    phone VARCHAR(50),
    email VARCHAR(255),
    website VARCHAR(255),

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
    );