# Functional Requirements

## Patient Management

| ID     | User Story | Acceptance Criteria | Priority |
|--------|------------|---------------------|----------|
| FR-01  | As a psychotherapist, I want to register and log into the system so that I can access my practice data | Given that I provide valid email and password, when I register and log in, then I can access the main dashboard | Must |
| FR-02  | As a psychotherapist, I want to add new patients with comprehensive information so that I can keep detailed records | Given that I'm logged in, when I add a patient with personal details, emergency contacts, and insurance info, then they appear in my patient list with complete profile | Must |
| FR-03  | As a psychotherapist, I want to view a list of my patients with filtering options so that I can navigate efficiently | Given that I'm logged in, when I go to the patients page, then I see all my patients with options to filter by status, last session, etc. | Must |
| FR-04  | As a psychotherapist, I want to edit patient information so that I can keep records current | Given that I'm viewing a patient profile, when I edit and save changes, then the updated information is stored with change tracking | Should |
| FR-05  | As a psychotherapist, I want to search for patients by multiple criteria so that I can quickly find specific records | Given that I have multiple patients, when I search by name, insurance number, or other criteria, then matching results are displayed instantly | Could |

---

## Session Notes Management

| ID     | User Story | Acceptance Criteria | Priority |
|--------|------------|---------------------|----------|
| FR-06  | As a psychotherapist, I want to create new session notes for patients so that I can document our meetings professionally | Given that I select a patient, when I create a session note with date, duration, session type, and detailed content, then it's stored and linked to that patient with automatic timestamp | Must |
| FR-07  | As a psychotherapist, I want to view all session notes for a patient in chronological order so that I can track treatment progress over time | Given that I select a patient, when I view their session history, then I see all notes sorted by date (newest first) with session details and quick preview | Must |
| FR-08  | As a psychotherapist, I want to edit existing session notes so that I can correct errors or add additional information | Given that I'm viewing a session note, when I edit and save changes, then the updated content is stored with edit timestamp and change tracking | Must |
| FR-09  | As a psychotherapist, I want to use structured session note templates so that I maintain consistent documentation standards | Given that I'm creating a session note, when I select a template (SOAP, DAP, etc.), then the note structure is pre-filled with appropriate sections and prompts | Could |
| FR-10  | As a psychotherapist, I want to mark session notes as draft or final so that I can work on documentation over time | Given that I'm writing a session note, when I save it as draft, then I can return later to complete it before marking as final | Should |
| FR-11  | As a psychotherapist, I want to add treatment goals and track progress in session notes so that I can monitor therapeutic outcomes | Given that I'm documenting a session, when I reference treatment goals, then I can update progress status and link goals to specific interventions | Could |

---

# Quality of Service (Non-Functional Requirements)

| ID     | Requirement | Priority |
|--------|-------------|----------|
| NFR-01 | User passwords must be hashed using bcrypt or similar secure hashing algorithm before storage | Must |
| NFR-02 | The system must work on modern web browsers (Chrome 90+, Firefox 85+, Safari 14+, Edge 90+) | Must |
| NFR-03 | User interfaces must be responsive and functional on screen sizes from 320px (mobile) to 1920px (desktop) | Must |
| NFR-04 | Common operations (login, view patients, create notes) must complete within 5 seconds on standard internet connection | Must |
| NFR-05 | All forms must validate user input and show appropriate error messages for better user experience | Must |
| NFR-06 | The system should provide basic data persistence with SQLite or PostgreSQL database | Should |
| NFR-07 | The system should work offline for viewing existing data with clear offline indicators | Should |
