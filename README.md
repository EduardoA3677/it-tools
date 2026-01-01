# it-tools

## Binary Analysis Workflow

This repository contains a GitHub Actions workflow for automated analysis of binary files including Android APK files, JAR files, shared objects (.so), and other binaries.

### Features

- **Automatic ZIP Download & Extraction**: Downloads and extracts ZIP archives containing binaries
- **Recursive File Discovery**: Automatically finds all APK, JAR, SO, and binary files within the extracted archive
- **Multi-Tool Analysis**:
  - **apktool**: Decompiles Android APK files to readable resources and smali bytecode
  - **jadx**: Decompiles APK and JAR files to Java source code
  - **dex2jar**: Converts Android DEX files to JAR format
  - **APKiD**: Identifies packers, obfuscators, and compilers in APK files
  - **androguard**: Android application analysis and reverse engineering
  - **readelf**: Analyzes ELF binary format (shared objects and executables)
  - **objdump**: Displays object file information and disassembly
  - **nm**: Lists symbol tables from object files
  - **ldd**: Shows shared library dependencies
  - **binwalk**: Analyzes and extracts embedded files from binaries
  - **radare2**: Advanced binary analysis and reverse engineering framework
  - **strings**: Extracts readable strings from binary files
  - **hexdump**: Creates hexadecimal dumps of binary files
  - **file**: Detailed file type identification with MIME types
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

1. **Setup**: Installs all required analysis tools (apktool, jadx, dex2jar, APKiD, androguard, readelf, objdump, nm, ldd, binwalk, radare2, and more)
2. **Download**: Downloads the specified ZIP file
3. **Extract**: Extracts all contents of the ZIP file
4. **Discover**: Recursively searches for all analyzable files:
   - *.apk files
   - *.jar files
   - *.so files
   - Binary/executable files
5. **Analyze**:
   - APK files are analyzed with apktool, jadx, dex2jar, APKiD, and androguard
   - JAR files are decompiled with jadx
   - SO files are analyzed with readelf, objdump, nm, and ldd
   - All binaries are analyzed with binwalk, radare2, objdump, and nm
   - Strings are extracted from all binaries
   - Hexdumps are created for binary inspection
   - Detailed file type identification is performed
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
│   ├── dex2jar/              # DEX to JAR conversion
│   │   ├── [app-name].jar
│   │   ├── [app-name]-dex2jar.log
│   │   ├── [app-name]-contents.txt
│   │   └── summary.txt
│   ├── apkid/                # APK identification
│   │   ├── [app-name]-apkid.txt
│   │   └── summary.txt
│   ├── androguard/           # Androguard analysis
│   │   ├── [app-name]-androguard.txt
│   │   └── summary.txt
│   ├── readelf/              # ELF binary analysis
│   │   ├── [file]-readelf.txt
│   │   └── summary.txt
│   ├── objdump/              # Object dump analysis
│   │   ├── [file]-objdump.txt
│   │   └── summary.txt
│   ├── nm/                   # Symbol analysis
│   │   ├── [file]-all-symbols.txt
│   │   ├── [file]-dynamic-symbols.txt
│   │   ├── [file]-demangled-symbols.txt
│   │   └── summary.txt
│   ├── ldd/                  # Library dependencies
│   │   ├── [file]-deps.txt
│   │   └── summary.txt
│   ├── radare2/              # Radare2 analysis
│   │   ├── [file]-r2.txt
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
│   ├── hexdump/              # Hexadecimal dumps
│   │   ├── [file]-hexdump.txt
│   │   └── summary.txt
│   ├── file-analysis/        # File type identification
│   │   ├── [file]-detailed.txt
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

- **apktool**: 2.9.3
- **jadx**: 1.5.0
- **dex2jar**: 2.1
- **APKiD**: Latest from pip
- **androguard**: Latest from Ubuntu repositories
- **readelf**: Latest from binutils
- **objdump**: Latest from binutils
- **nm**: Latest from binutils
- **ldd**: Latest from Ubuntu repositories
- **binwalk**: Latest from Ubuntu repositories
- **radare2**: Latest from Ubuntu repositories
- **Ghidra**: 11.0.1 (optional, headless mode)
- **Python tools**: pefile, pyelftools, capstone, r2pipe, yara-python

### Notes

- The workflow runs on Ubuntu latest
- Analysis artifacts are retained for 90 days
- Large files (> 10MB) are excluded from the artifact upload to prevent excessive storage usage
- All analysis steps use `continue-on-error: true` to ensure partial results even if some tools fail
- Some tools (radare2, hexdump) process only a limited number of files to avoid timeouts
- The workflow creates a git repository structure in the results for easy versioning and sharing