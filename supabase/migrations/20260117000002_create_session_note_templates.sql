-- Create session_note_templates table
CREATE TABLE IF NOT EXISTS public.session_note_templates (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_profile_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,

    -- Template metadata
    name VARCHAR(100) NOT NULL,
    description TEXT,

    -- Template content (structured as JSON for flexibility)
    content_template TEXT NOT NULL,

    -- Template settings
    is_system_template BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,

    -- Timestamps
    created_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT NOW() NOT NULL,

    -- Constraints
    CONSTRAINT unique_user_template_name UNIQUE (user_profile_id, name),
    CONSTRAINT system_template_no_user CHECK (
        (is_system_template = TRUE AND user_profile_id IS NULL) OR
        (is_system_template = FALSE AND user_profile_id IS NOT NULL)
    )
);

-- Create indexes for performance
CREATE INDEX idx_session_note_templates_user_profile ON public.session_note_templates(user_profile_id);
CREATE INDEX idx_session_note_templates_system ON public.session_note_templates(is_system_template) WHERE is_system_template = TRUE;
CREATE INDEX idx_session_note_templates_active ON public.session_note_templates(is_active) WHERE is_active = TRUE;

-- Enable Row Level Security
ALTER TABLE public.session_note_templates ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can see system templates and their own templates
CREATE POLICY session_note_templates_select_policy ON public.session_note_templates
    FOR SELECT
    USING (
        is_system_template = TRUE OR
        user_profile_id = (
            SELECT id FROM public.user_profiles
            WHERE user_id = auth.uid()
        )
    );

-- Create policy: Users can only modify their own templates (not system templates)
CREATE POLICY session_note_templates_modify_policy ON public.session_note_templates
    FOR ALL
    USING (
        is_system_template = FALSE AND
        user_profile_id = (
            SELECT id FROM public.user_profiles
            WHERE user_id = auth.uid()
        )
    );

-- Create trigger to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_session_note_templates_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER session_note_templates_updated_at_trigger
    BEFORE UPDATE ON public.session_note_templates
    FOR EACH ROW
    EXECUTE FUNCTION update_session_note_templates_updated_at();

-- Insert system templates (SOAP and DAP)
INSERT INTO public.session_note_templates (name, description, content_template, is_system_template)
VALUES
(
    'SOAP',
    'Subjective, Objective, Assessment, Plan - Standard clinical documentation format',
    E'SUBJECTIVE (Subjektiv)\n────────────────────\nPatient''s complaints, symptoms, and feelings:\n\n\n\nOBJECTIVE (Objektiv)\n────────────────────\nObservable findings, mental status, behavior:\n\n\n\nASSESSMENT (Beurteilung)\n────────────────────\nClinical impression, diagnosis, progress:\n\n\n\nPLAN (Plan)\n────────────────────\nTreatment plan, homework, next steps:\n',
    TRUE
),
(
    'DAP',
    'Data, Assessment, Plan - Streamlined progress note format',
    E'DATA (Daten)\n────────────────────\nPatient presentation, observations, reported information:\n\n\n\nASSESSMENT (Beurteilung)\n────────────────────\nClinical evaluation, progress toward goals:\n\n\n\nPLAN (Plan)\n────────────────────\nInterventions, homework, next session focus:\n',
    TRUE
),
(
    'Standard-Protokoll',
    'Blank template for free-form documentation',
    E'',
    TRUE
);
