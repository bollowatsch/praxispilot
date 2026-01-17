-- Create session_notes table
CREATE TABLE IF NOT EXISTS public.session_notes (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_profile_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE NOT NULL,
    patient_id UUID REFERENCES public.patients(id) ON DELETE CASCADE NOT NULL,

    -- Session metadata
    session_date DATE NOT NULL,
    session_start_time TIME NOT NULL,
    session_duration_minutes INTEGER NOT NULL CHECK (session_duration_minutes > 0),
    session_type VARCHAR(50) NOT NULL DEFAULT 'individual',

    -- Content
    content TEXT,

    -- Status management
    status VARCHAR(20) DEFAULT 'draft' CHECK (status IN ('draft', 'finalized')),
    finalized_at TIMESTAMPTZ,

    -- Unlock tracking (for finalized notes)
    unlock_reason TEXT,
    unlocked_at TIMESTAMPTZ,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    archived_at TIMESTAMPTZ
);

-- Create indexes for performance
CREATE INDEX idx_session_notes_patient ON public.session_notes(patient_id);
CREATE INDEX idx_session_notes_user_profile ON public.session_notes(user_profile_id);
CREATE INDEX idx_session_notes_session_date ON public.session_notes(session_date DESC);
CREATE INDEX idx_session_notes_created_at ON public.session_notes(created_at DESC);
CREATE INDEX idx_session_notes_status ON public.session_notes(status);

-- Enable Row Level Security
ALTER TABLE public.session_notes ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only see session notes for their own patients
CREATE POLICY session_notes_isolation_policy ON public.session_notes
    FOR ALL
    USING (patient_id IN (
        SELECT id FROM public.patients
        WHERE user_profile_id = (
            SELECT id FROM public.user_profiles
            WHERE user_id = auth.uid()
        )
    ));

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_session_notes_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER session_notes_updated_at_trigger
    BEFORE UPDATE ON public.session_notes
    FOR EACH ROW
    EXECUTE FUNCTION update_session_notes_updated_at();

-- Create trigger to set finalized_at when status changes to 'finalized'
CREATE OR REPLACE FUNCTION set_session_notes_finalized_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'finalized' AND (OLD.status IS NULL OR OLD.status != 'finalized') THEN
        NEW.finalized_at = NOW();
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER session_notes_finalized_at_trigger
    BEFORE UPDATE OF status ON public.session_notes
    FOR EACH ROW
    EXECUTE FUNCTION set_session_notes_finalized_at();
