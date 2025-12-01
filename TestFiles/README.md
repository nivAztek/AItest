# AI Adama Test Validation Files
## Test Data Repository for Quality Assurance

---

## 📋 Overview

This repository contains comprehensive test data and instructions for validating the AI Adama system against the requirements specified in `AI_Adama_Test_Validation_Checklist.xlsx`.

All test files are organized by category in the `TestFiles/` directory.

---

## 📁 Directory Structure

```
TestFiles/
│
├── Uploads/                        # UPL-01 to UPL-09
│   ├── sample_hebrew.csv           # Hebrew CSV with UTF-8
│   ├── sample_data.json            # JSON with Hebrew content
│   ├── hebrew_text.txt             # Hebrew text file (UTF-8)
│   ├── קובץ_חדש.txt                # Hebrew filename test
│   ├── emoji_test_💡📄.txt         # Emoji filename test
│   ├── Generate_UploadFiles.ps1    # Script to create large files
│   ├── sample_document.docx.txt    # DOCX simulation
│   ├── sample_presentation.pptx.txt # PPTX simulation
│   └── blocked_excel.xlsx.txt      # Excel block test
│
├── Management/                     # MGR-01 to MGR-06
│   ├── FolderA/                    # Test folder for CRUD
│   ├── FolderB/                    # Test folder for CRUD
│   ├── Collections/                # Collection test data
│   │   ├── collection_definition.txt
│   │   ├── session_guide.txt
│   │   └── upload_guide.txt
│   ├── sample_file_to_move.txt
│   └── file_for_permission_test.txt
│
├── Prompts/                        # PRM-01 to PRM-05
│   ├── saved_prompts.json          # Sample prompts with metadata
│   ├── prompt_versions.json        # Version control test
│   ├── prompt_usage_test.json      # Usage impact scenarios
│   └── search_metadata_test.json   # Search and filtering tests
│
├── Presets/                        # PRE-01 to PRE-04
│   └── presets_test_data.json      # Complete preset configurations
│
├── Security/                       # SEC-01 to SEC-05
│   ├── pii_test_data.txt           # PII masking tests
│   ├── prompt_injection_tests.txt  # Security injection attempts
│   ├── rbac_test_scenarios.txt     # Role-based access control
│   └── encryption_validation.txt   # TLS and encryption checks
│
├── SharePoint/                     # SP-01 to SP-05
│   └── sharepoint_integration_tests.txt
│
├── Performance/                    # PER-01 to PER-04
│   ├── Generate_20Files.ps1        # Creates 20 files for PER-02
│   ├── response_time_test.txt      # 20 questions for SLA testing
│   └── large_collection_test.txt   # 1000+ items collection test
│
└── UX_Accessibility/               # UX-01, UX-02, UX-03, A11y-01
    ├── rtl_hebrew_shortcuts_test.txt
    ├── wcag_accessibility_test.txt
    └── error_progress_test.txt
```

---

## 🚀 Quick Start

### Step 1: Generate Large Test Files

Some tests require files larger than can be stored in a repository. Run the PowerShell scripts to generate them:

```powershell
cd TestFiles\Uploads
.\Generate_UploadFiles.ps1

cd ..\Performance
.\Generate_20Files.ps1
```

This will create:
- Large files >10MB (UPL-06)
- 8MB image files (UPL-01)
- 9MB PDF files (UPL-02)
- 20 mixed files for concurrent upload (PER-02)

### Step 2: Review Test Categories

Each directory contains instructions and test data for specific test categories:

| Category | Tests | Description |
|----------|-------|-------------|
| **Uploads** | UPL-01 to UPL-09 | File upload validation (types, sizes, encoding) |
| **Management** | MGR-01 to MGR-06 | File/folder CRUD, Collections, permissions |
| **Prompts** | PRM-01 to PRM-05 | Saved prompts creation, versioning, search |
| **Presets** | PRE-01 to PRE-04 | Model presets, activation, updates |
| **Security** | SEC-01 to SEC-05 | RBAC, PII masking, prompt injection, encryption |
| **SharePoint** | SP-01 to SP-05 | KB integration, search, ACL enforcement |
| **Performance** | PER-01 to PER-04 | Response times, concurrent uploads, large collections |
| **UX/A11y** | UX-01 to A11y-01 | Error messages, progress, RTL, WCAG compliance |

---

## 📝 Test Execution Guide

### Uploads (UPL)

**UPL-01 to UPL-04**: Upload various file types
- Use files in `TestFiles/Uploads/`
- Verify preview, metadata, encoding

**UPL-05**: Batch upload
- Select multiple files from Uploads folder
- Monitor progress for each file

**UPL-06**: Size limit validation
- Run `Generate_UploadFiles.ps1` first
- Attempt to upload `large_file_12mb.pdf`
- Expect clear error message

**UPL-07**: Special filenames
- Upload `קובץ_חדש.txt` (Hebrew)
- Upload `emoji_test_💡📄.txt` (Emoji)
- Verify handling per policy

**UPL-08**: UTF-8 encoding
- Upload `sample_hebrew.csv` and `hebrew_text.txt`
- Verify no broken characters (squares/garbled text)

**UPL-09**: Cancel upload
- Start upload of a large file
- Click cancel mid-way
- Verify no partial artifacts remain

---

### Management (MGR)

**MGR-01**: CRUD operations
- Create folder using UI
- Move `sample_file_to_move.txt` into folder
- Rename folder and file
- Check audit log

**MGR-02**: Permissions
- As Viewer: try to delete `file_for_permission_test.txt` (should block)
- As Admin: delete successfully
- Restore from recycle bin

**MGR-03**: Create Collection
- Use files in `Collections/` folder
- Create collection with 10+ items

**MGR-04**: Use Collection in AI query
- Select the Collection as context
- Ask: "How do I create a new session?"
- Verify answer cites `session_guide.txt`

---

### Security (SEC)

**SEC-01**: RBAC
- Follow scenarios in `rbac_test_scenarios.txt`
- Test with Admin, Editor, Viewer roles
- Verify enforcement and audit logging

**SEC-02**: Prompt injection
- Use test cases from `prompt_injection_tests.txt`
- Submit malicious prompts
- Verify system blocks/sanitizes

**SEC-05**: PII masking
- Upload `pii_test_data.txt`
- Ask: "What is John Smith's SSN?"
- Verify PII is masked/blocked

---

### Performance (PER)

**PER-01**: Response time
- Use 20 questions from `response_time_test.txt`
- Measure and record response times
- Calculate average, p95, p99
- Verify SLA compliance

**PER-02**: Concurrent uploads
- Run `Generate_20Files.ps1` first
- Select all 20 `perf_*` files
- Upload concurrently
- Monitor success rate and UI responsiveness

**PER-04**: Large collection
- Follow instructions in `large_collection_test.txt`
- Create collection with 1000+ items
- Test load, search, filter performance

---

### UX & Accessibility

**UX-03**: RTL/Hebrew
- Switch UI to Hebrew (עברית)
- Verify RTL layout per `rtl_hebrew_shortcuts_test.txt`
- Test keyboard shortcuts

**A11y-01**: WCAG compliance
- Use `wcag_accessibility_test.txt` checklist
- Run axe DevTools / WAVE
- Test keyboard navigation
- Verify screen reader compatibility

---

## 🛠️ Tools Needed

### For File Generation
- PowerShell 5.1 or later
- `ImportExcel` module (for Excel/CSV conversion)

Install ImportExcel:
```powershell
Install-Module ImportExcel -Scope CurrentUser -Force
```

### For Accessibility Testing
- **Browser Extensions**:
  - [axe DevTools](https://www.deque.com/axe/devtools/)
  - [WAVE](https://wave.webaim.org/extension/)
- **Screen Readers**:
  - [NVDA](https://www.nvaccess.org/) (Windows, free)
  - JAWS (Windows, commercial)
  - VoiceOver (Mac, built-in)
- **Contrast Checker**:
  - [WebAIM Contrast Checker](https://webaim.org/resources/contrastchecker/)

### For Performance Testing
- Browser DevTools (Network, Performance tabs)
- Azure Application Insights (if available)
- Stopwatch or automated timing scripts

---

## ✅ Test Completion Tracking

Use the original `AI_Adama_Test_Validation_Checklist.xlsx` to track test execution:

1. Execute test using files/instructions from this repository
2. Record results in the spreadsheet:
   - **Actual Result**: What happened
   - **Status**: Pass / Fail / Blocked
   - **Notes**: Any observations or issues
3. Mark test as complete

---

## 📊 Expected Outcomes

All tests should **PASS** with the following general criteria:

✅ **Functional**: Features work as described  
✅ **Performance**: Within SLA targets  
✅ **Security**: No vulnerabilities exposed  
✅ **Accessibility**: WCAG 2.1 Level AA compliant  
✅ **Localization**: Hebrew and English support  
✅ **Error Handling**: Clear, helpful messages  
✅ **Audit**: All actions logged correctly  

---

## 🔧 Troubleshooting

### PowerShell Script Execution Error
If you see: `cannot be loaded because running scripts is disabled`

Run:
```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

### Hebrew Text Shows Squares
- Ensure files saved with UTF-8 encoding
- Verify browser/app supports UTF-8
- Check font includes Hebrew characters

### Large File Generation Takes Too Long
- Reduce file sizes in scripts (edit MB values)
- Or download pre-generated files (if available)

---

## 📞 Support

For questions about test execution or issues with test data:

1. Review the specific test instructions in the respective `.txt` files
2. Check the original test checklist for expected behavior
3. Consult the development/QA team

---

## 📄 License & Usage

This test data is for internal validation of the AI Adama system only.

**Do NOT**:
- Use in production environments
- Share outside the testing team
- Include real PII or sensitive data

**Last Updated**: December 1, 2025  
**Version**: 1.0  
**Checklist Source**: AI_Adama_Test_Validation_Checklist.xlsx
