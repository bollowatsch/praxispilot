CREATE TABLE IF NOT EXISTS public.user_preferences (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_profile_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE UNIQUE NOT NULL,

    -- UI preferences
    theme_mode VARCHAR(20) DEFAULT 'system', -- 'light', 'dark', 'system'
    high_contrast BOOLEAN DEFAULT false,
    reduce_animations BOOLEAN DEFAULT false,

    -- language & region
    language VARCHAR(10) DEFAULT 'de',
    locale VARCHAR(10) DEFAULT 'de_AT',
    date_format VARCHAR(20) DEFAULT 'DD.MM.YYYY',
    time_format VARCHAR(10) DEFAULT '24h',
    timezone VARCHAR(50) DEFAULT 'Europe/Vienna',

    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);