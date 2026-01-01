# it-tools

## Binary Analysis Workflow

This repository contains a GitHub Actions workflow for automated analysis of binary files including Android APK files, JAR files, shared objects (.so), and other binaries.

### Features

- **Automatic ZIP Download & Extraction**: Downloads and extracts ZIP archives containing binaries
- **Recursive File Discovery**: Automatically finds all APK, JAR, SO, and binary files within the extracted archive
- **Multi-Tool Analysis**:
  - **apktool**: Decompiles Android APK files
  - **jadx**: Decompiles APK and JAR files to Java source code
  - **readelf**: Analyzes ELF binary format (shared objects and executables)
  - **binwalk**: Analyzes and extracts embedded files from binaries
  - **strings**: Extracts readable strings from binary files
- **Comprehensive Reporting**: Generates detailed analysis reports
- **Artifact Storage**: Uploads all analysis results to GitHub Actions artifacts
- **Analysis Repository**: Creates a git repository structure with all results

### Usage

#### Running the Workflow

1. Go to the **Actions** tab in this repository
2. Select **Binary Analysis Workflow** from the workflow list
3. Click **Run workflow**
4. Provide the required inputs:
   - **zip_url**: URL to the ZIP file containing binaries to analyze
   - **analysis_name** (optional): Custom name for this analysis run (default: "binary-analysis")

#### Example Inputs

```
zip_url: https://example.com/files/app-release.zip
analysis_name: app-release-v1.0-analysis
```

### Workflow Steps

1. **Setup**: Installs all required analysis tools (apktool, jadx, readelf, binwalk)
2. **Download**: Downloads the specified ZIP file
3. **Extract**: Extracts all contents of the ZIP file
4. **Discover**: Recursively searches for all analyzable files:
   - *.apk files
   - *.jar files
   - *.so files
   - Binary/executable files
5. **Analyze**:
   - APK files are decompiled with apktool and jadx
   - JAR files are decompiled with jadx
   - SO files are analyzed with readelf
   - All binaries are analyzed with binwalk
   - Strings are extracted from all binaries
6. **Report**: Generates a comprehensive markdown report
7. **Upload**: Uploads all results to GitHub Actions artifacts

### Output Structure

The analysis produces the following output structure:

```
final-artifacts/
├── analysis-results/
│   ├── apktool/              # Apktool decompiled APK files
│   │   ├── [app-name]/       # Decompiled APK contents
│   │   ├── [app-name]-apktool.log
│   │   ├── [app-name]-structure.txt
│   │   └── summary.txt
│   ├── jadx/                 # Jadx decompiled source code
│   │   ├── [app-name]/       # Decompiled Java source
│   │   ├── [app-name]-jadx.log
│   │   └── summary.txt
│   ├── readelf/              # ELF binary analysis
│   │   ├── [file]-readelf.txt
│   │   └── summary.txt
│   ├── binwalk/              # Binwalk analysis and extraction
│   │   ├── [file]-binwalk.txt
│   │   ├── [file]-extraction.log
│   │   ├── [file]-extracted/
│   │   └── summary.txt
│   ├── strings/              # Extracted strings
│   │   ├── [file]-strings.txt
│   │   ├── [file]-strings-offset.txt
│   │   └── summary.txt
│   ├── ANALYSIS_REPORT.md    # Complete analysis report
│   ├── apk-files.txt         # List of APK files found
│   ├── jar-files.txt         # List of JAR files found
│   ├── so-files.txt          # List of SO files found
│   ├── binary-files.txt      # List of binary files found
│   └── file-types.txt        # File type analysis
├── extracted-contents/       # Original extracted files (< 10MB)
└── manifest.txt              # Complete file listing

```

### Downloading Results

1. After the workflow completes, go to the workflow run page
2. Scroll to the **Artifacts** section at the bottom
3. Download the artifact named `[analysis_name]-results`
4. Extract the ZIP file to view all analysis results

### Analysis Report

The workflow generates a comprehensive `ANALYSIS_REPORT.md` that includes:

- Analysis metadata (date, workflow run, source URL)
- Summary of files discovered
- Results from each analysis tool
- Complete file listings

### Requirements

- A publicly accessible URL to a ZIP file containing binaries
- The ZIP file can contain APK, JAR, SO files or other binaries
- Files are analyzed recursively (nested directories are supported)

### Tool Versions

- apktool: 2.9.3
- jadx: 1.5.0
- readelf: Latest from binutils
- binwalk: Latest from Ubuntu repositories

### Notes

- The workflow runs on Ubuntu latest
- Analysis artifacts are retained for 90 days
- Large files (> 10MB) are excluded from the artifact upload to prevent excessive storage usage
- All analysis steps use `continue-on-error: true` to ensure partial results even if some tools fail
- The workflow creates a git repository structure in the results for easy versioning and sharing