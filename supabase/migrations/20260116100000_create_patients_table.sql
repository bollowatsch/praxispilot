-- Create patients table
CREATE TABLE IF NOT EXISTS public.patients (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_profile_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE NOT NULL,

    -- Personal information
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    address TEXT,

    -- Insurance information (free-form text)
    insurance_info TEXT,

    -- Emergency contact (single contact, inline)
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(50),
    emergency_contact_relationship VARCHAR(100),

    -- Status (active or archived)
    status VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active', 'archived')),

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    archived_at TIMESTAMPTZ,

    -- Constraints
    CONSTRAINT patient_name_not_empty CHECK (
        length(trim(first_name)) > 0 AND length(trim(last_name)) > 0
    )
);

-- Create indexes for performance
CREATE INDEX idx_patients_user_profile ON public.patients(user_profile_id);
CREATE INDEX idx_patients_status ON public.patients(status);
CREATE INDEX idx_patients_name ON public.patients(last_name, first_name);
CREATE INDEX idx_patients_dob ON public.patients(date_of_birth);
CREATE INDEX idx_patients_created_at ON public.patients(created_at DESC);

-- Create full-text search index for patient search
CREATE INDEX idx_patients_search ON public.patients
USING gin(to_tsvector('german', first_name || ' ' || last_name || ' ' || COALESCE(email, '')));

-- Enable Row Level Security
ALTER TABLE public.patients ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only see their own patients
CREATE POLICY patients_isolation_policy ON public.patients
    FOR ALL
    USING (user_profile_id = (
        SELECT id FROM public.user_profiles
        WHERE user_id = auth.uid()
    ));

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_patients_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER patients_updated_at_trigger
    BEFORE UPDATE ON public.patients
    FOR EACH ROW
    EXECUTE FUNCTION update_patients_updated_at();

-- Create trigger to set archived_at when status changes to archived
CREATE OR REPLACE FUNCTION set_patients_archived_at()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.status = 'archived' AND OLD.status != 'archived' THEN
        NEW.archived_at = NOW();
    ELSIF NEW.status = 'active' AND OLD.status = 'archived' THEN
        NEW.archived_at = NULL;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER patients_archived_at_trigger
    BEFORE UPDATE OF status ON public.patients
    FOR EACH ROW
    EXECUTE FUNCTION set_patients_archived_at();

-- Create table for tracking patient field changes (for auditing)
CREATE TABLE IF NOT EXISTS public.patient_change_log (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    patient_id UUID REFERENCES public.patients(id) ON DELETE CASCADE NOT NULL,
    field_name VARCHAR(100) NOT NULL,
    old_value TEXT,
    new_value TEXT,
    changed_by UUID REFERENCES auth.users(id) NOT NULL,
    changed_at TIMESTAMPTZ DEFAULT NOW() NOT NULL
);

CREATE INDEX idx_patient_change_log_patient ON public.patient_change_log(patient_id);
CREATE INDEX idx_patient_change_log_changed_at ON public.patient_change_log(changed_at DESC);

-- Enable RLS for change log
ALTER TABLE public.patient_change_log ENABLE ROW LEVEL SECURITY;

-- Policy: Users can only see change logs for their own patients
CREATE POLICY patient_change_log_isolation_policy ON public.patient_change_log
    FOR ALL
    USING (patient_id IN (
        SELECT id FROM public.patients
        WHERE user_profile_id = (
            SELECT id FROM public.user_profiles
            WHERE user_id = auth.uid()
        )
    ));