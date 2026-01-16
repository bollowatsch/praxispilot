# PraxisPilot Requirements Specification

## Product Scope

This document defines the requirements for the PraxisPilot application. PraxisPilot is a cross-platform, web-based patient management and session notes application for psychotherapists. The software is designed as a complete business solution that will be developed in multiple phases, starting with a university MVP project that demonstrates core patient record management functionality and evolving into a full-featured management platform later on.

**Primary Market:** Austria (German-speaking)

---

## Functional Requirements

### Patient Management

| ID     | User Story | Acceptance Criteria | Priority |
|--------|------------|---------------------|----------|
| FR-01  | As a psychotherapist, I want to register and log into the system so that I can access my practice data | Given that I provide valid email and password, when I register and log in, then I can access the main dashboard | Must |
| FR-02  | As a psychotherapist, I want to add new patients with comprehensive information so that I can keep detailed records | Given that I'm logged in, when I add a patient with personal details, emergency contact, and insurance info, then they appear in my patient list with complete profile | Must |
| FR-03  | As a psychotherapist, I want to view a list of my patients with filtering options so that I can navigate efficiently | Given that I'm logged in, when I go to the patients page, then I see all my patients with options to filter by status, last session, firstname, and lastname | Must |
| FR-04  | As a psychotherapist, I want to edit patient information so that I can keep records current | Given that I'm viewing a patient profile, when I edit and save changes, then the updated information is stored with field-level change tracking | Should |
| FR-05  | As a psychotherapist, I want to search for patients by multiple criteria so that I can quickly find specific records | Given that I have multiple patients, when I search by name, insurance number, or other criteria, then matching results are displayed instantly (active patients by default, toggle to include archived) | Could |

#### Patient Management Implementation Details

| Aspect | Decision |
|--------|----------|
| Data isolation | Strict - each therapist sees only their own patients, no sharing |
| Patient status | Binary only: active or archived |
| Deletion behavior | Soft delete with 10-year retention after patient's last interaction, then hard delete |
| Emergency contacts | Single contact per patient |
| Insurance validation | Free-form text, no format validation |
| Duplicate detection | Warning shown if potential duplicate found (same name + DOB), but creation allowed |
| Change tracking | Field-level tracking stored in background for auditing (not visible in normal UI) |
| Profile layout | Split layout - patient info in sidebar, session notes list in main area |

---

### Session Notes Management

| ID     | User Story | Acceptance Criteria | Priority |
|--------|------------|---------------------|----------|
| FR-06  | As a psychotherapist, I want to create new session notes for patients so that I can document our meetings professionally | Given that I select a patient, when I create a session note with date, start time, duration, session type, and detailed content, then it's stored and linked to that patient with automatic timestamp | Must |
| FR-07  | As a psychotherapist, I want to view all session notes for a patient in chronological order so that I can track treatment progress over time | Given that I select a patient, when I view their session history, then I see all notes sorted by date (newest first) with metadata preview (date, duration, session type) | Must |
| FR-08  | As a psychotherapist, I want to edit existing session notes so that I can correct errors or add additional information | Given that I'm viewing a session note, when I edit and save changes, then the updated content is stored as a new version with edit timestamp | Must |
| FR-09  | As a psychotherapist, I want to use structured session note templates so that I maintain consistent documentation standards | Given that I'm creating a session note, when I select a template (SOAP, DAP, etc.), then the note structure is pre-filled with appropriate sections as guidance (all sections optional) | Could |
| FR-10  | As a psychotherapist, I want to mark session notes as draft or final so that I can work on documentation over time | Given that I'm writing a session note, when I save it as draft, then I can return later to complete it before marking as final. Finalized notes can be unlocked with a documented reason. | Should |
| FR-11  | As a psychotherapist, I want to add treatment goals and track progress in session notes so that I can monitor therapeutic outcomes | Given that I'm documenting a session, when I reference treatment goals, then I can update progress status (progress updates tied to session notes) | Could |

#### Session Notes Implementation Details

| Aspect | Decision |
|--------|----------|
| Version history | Full version history stored; single version view at a time (no side-by-side diff) |
| Finalized notes | Can be unlocked with documented reason; unlock reason visible on the note |
| Auto-save | No auto-save; manual save only |
| Unsaved changes | Warning dialog with Save/Discard/Cancel options when navigating away |
| Text formatting | Rich text editor (bold, italic, headings, tables, nested lists) |
| Paste behavior | Strip external formatting on paste |
| Templates | System templates only (SOAP, DAP, etc.); guidance only, all sections optional |
| Date default | Default to today, editable |
| Session types | System defaults + custom types per therapist |
| Duration input | Start time + session duration entered manually |
| Edit locking | None - last write wins |
| Previous session reference | Inline preview popup on hover/click |
| Mobile editing | Full-screen modal editor |

---

### Treatment Goals

| Aspect | Decision |
|--------|----------|
| Goal structure | Hybrid - text description + optional structured fields (target dates, progress percentage, status) |
| Progress updates | Tied to session notes (updated as part of session documentation) |

---

### Dashboard

| Aspect | Decision |
|--------|----------|
| Primary content | Recent activity (last edited notes) + quick actions (new patient, new note, search) |

---

## Quality of Service (Non-Functional Requirements)

| ID     | Requirement | Priority |
|--------|-------------|----------|
| NFR-01 | User passwords must be hashed using bcrypt or similar secure hashing algorithm before storage | Must |
| NFR-02 | The system must work on modern web browsers (Chrome 90+, Firefox 85+, Safari 14+, Edge 90+) | Must |
| NFR-03 | User interfaces must be responsive and functional on screen sizes from 320px (mobile) to 1920px (desktop) | Must |
| NFR-04 | Common operations (login, view patients, create notes) must complete within 5 seconds on standard internet connection (applies post-initial-load) | Must |
| NFR-05 | All forms must validate user input and show appropriate error messages for better user experience | Must |
| NFR-06 | The system should provide data persistence with PostgreSQL database (via Supabase) | Should |
| NFR-07 | The system should work offline for viewing existing data and creating draft notes (synced when online) with clear offline indicators | Should |

---

## Authentication & Security

| Aspect | Decision |
|--------|----------|
| Password reset | Email-based reset links + admin manual reset for locked accounts |
| Session timeout | Configurable auto-logout (user sets duration in settings) |
| Data isolation | Strict per-therapist isolation; no cross-therapist data access |

---

## Localization & Settings

| Aspect | Decision |
|--------|----------|
| Default language | German (Austria is primary market) |
| Supported languages | German, English |
| Language selection | Default German, changeable in settings |
| Date/Time format | Derived from system locale automatically |

---

## Offline Support

| Aspect | Decision |
|--------|----------|
| Offline capability | View existing data + create draft notes locally |
| Sync behavior | Drafts sync when connection returns |
| Conflict resolution | Last write wins |

---

## Technical Constraints (MVP)

| Aspect | Decision |
|--------|----------|
| File attachments | Text only - no file attachments in MVP |
| Bulk operations | None - no bulk export or bulk actions in MVP |
| Keyboard shortcuts | None in MVP |
| Access logging | None - only track modifications, not views |