# Binary Analysis Workflow Examples

This document provides examples and use cases for the Binary Analysis Workflow.

## Example Use Cases

### 1. Analyzing an Android Application Release

**Scenario**: You have a ZIP file containing an Android APK and want to analyze its structure and code.

**Inputs**:
```
zip_url: https://example.com/releases/my-app-v1.0.zip
analysis_name: my-app-v1.0-security-audit
```

**Expected Results**:
- Decompiled APK structure with apktool
- Decompiled Java source code with jadx
- Analysis of any native libraries (.so files) found in the APK
- Extracted strings and embedded files

### 2. Analyzing a JAR Library

**Scenario**: Analyze a Java library distributed as a JAR file.

**Inputs**:
```
zip_url: https://example.com/libs/library-bundle.zip
analysis_name: java-library-analysis
```

**Expected Results**:
- Decompiled Java classes
- String analysis
- Any embedded resources

### 3. Firmware Analysis

**Scenario**: Analyze firmware binaries for embedded devices.

**Inputs**:
```
zip_url: https://example.com/firmware/device-firmware-v2.0.zip
analysis_name: firmware-v2.0-analysis
```

**Expected Results**:
- Binwalk extraction of firmware components
- String analysis for hardcoded credentials or paths
- ELF binary analysis of executables
- File system extraction

### 4. Security Audit of Third-Party Binaries

**Scenario**: Perform security analysis on third-party binaries before deployment.

**Inputs**:
```
zip_url: https://example.com/vendor/binary-package.zip
analysis_name: vendor-security-audit
```

**Expected Results**:
- Complete binary analysis
- Symbol table examination
- String analysis for sensitive data
- Embedded file extraction

## Workflow Trigger Methods

### Manual Trigger via GitHub UI

1. Navigate to repository **Actions** tab
2. Select **Binary Analysis Workflow**
3. Click **Run workflow** button
4. Fill in the inputs
5. Click **Run workflow**

### Trigger via GitHub CLI

```bash
gh workflow run binary-analysis.yml \
  -f zip_url="https://example.com/files/archive.zip" \
  -f analysis_name="my-analysis"
```

### Trigger via API

```bash
curl -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  https://api.github.com/repos/OWNER/REPO/actions/workflows/binary-analysis.yml/dispatches \
  -d '{"ref":"main","inputs":{"zip_url":"https://example.com/files/archive.zip","analysis_name":"my-analysis"}}'
```

## Understanding the Results

### Apktool Output

Located in `analysis-results/apktool/`:
- **Decoded APK structure**: Contains AndroidManifest.xml, resources, smali code
- **apktool.log**: Decompilation log showing any errors or warnings
- **structure.txt**: Directory tree of the decoded APK

**What to look for**:
- Permissions in AndroidManifest.xml
- Resource files (images, strings, layouts)
- Smali bytecode for analysis

### Jadx Output

Located in `analysis-results/jadx/`:
- **Decompiled Java source**: Human-readable Java code
- **jadx.log**: Decompilation log
- **summary.txt**: Statistics on decompiled files

**What to look for**:
- Application logic and algorithms
- API endpoints and network calls
- Hardcoded secrets or credentials
- Code quality and security issues

### Readelf Output

Located in `analysis-results/readelf/`:
- **ELF header information**: Architecture, entry point, type
- **Program headers**: Memory layout
- **Section headers**: Code and data sections
- **Symbol table**: Exported and imported functions
- **Dynamic section**: Shared library dependencies

**What to look for**:
- Binary architecture and platform
- Security features (NX, PIE, RELRO)
- Imported/exported functions
- Library dependencies

### Binwalk Output

Located in `analysis-results/binwalk/`:
- **binwalk.txt**: Detected file signatures and embedded files
- **extraction.log**: Extraction results
- **[file]-extracted/**: Extracted embedded files

**What to look for**:
- Embedded file systems
- Compressed data
- Cryptographic signatures
- Hidden or embedded files

### Strings Output

Located in `analysis-results/strings/`:
- **strings.txt**: All printable strings found
- **strings-offset.txt**: Strings with their hexadecimal offsets

**What to look for**:
- URLs and API endpoints
- Hardcoded credentials or keys
- Debug messages
- File paths
- User messages and error strings

## Tips for Effective Analysis

### 1. Start with the Analysis Report

Always begin by reading `ANALYSIS_REPORT.md` to get an overview of:
- What files were found
- What tools successfully analyzed them
- Any errors or failures

### 2. Follow a Systematic Approach

1. **File Discovery**: Check what files were found
2. **High-Level Analysis**: Review apktool/jadx output for APKs/JARs
3. **Binary Analysis**: Examine readelf output for native libraries
4. **Deep Inspection**: Use binwalk and strings for detailed analysis
5. **Cross-Reference**: Correlate findings across different tools

### 3. Security-Focused Analysis

For security audits, pay special attention to:
- **Strings**: Look for API keys, passwords, tokens
- **Permissions**: Check AndroidManifest.xml for excessive permissions
- **Network**: Search for HTTP (non-HTTPS) endpoints
- **Dependencies**: Review linked libraries for known vulnerabilities
- **Obfuscation**: Check if code is obfuscated or packed

### 4. Handling Large Results

- Results are compressed in the artifact
- Large extracted files (>10MB) are excluded from artifacts
- Focus on logs and summaries first before diving into full source code
- Use text search tools to find specific patterns across results

## Troubleshooting

### Workflow Fails to Download ZIP

- Verify the URL is publicly accessible
- Check if authentication is required (not supported)
- Ensure the file is actually a ZIP file

### Analysis Tools Fail

- Check tool-specific logs in the analysis results
- Some files may be corrupted or use unsupported formats
- The workflow continues even if individual tools fail

### Artifact Too Large

- Default retention is 90 days
- Large files (>10MB) are automatically excluded
- Consider analyzing smaller batches
- Focus on specific file types if needed

### No Files Found for Analysis

- Verify the ZIP contains binary files
- Check file extensions match expected patterns (.apk, .jar, .so)
- Review `file-types.txt` for actual file types detected

## Advanced Usage

### Modifying the Workflow

To customize the analysis for specific needs:

1. **Add New Tools**: Add installation and analysis steps for additional tools
2. **Filter Files**: Modify the discovery step to focus on specific files
3. **Adjust Tool Parameters**: Change tool flags for different analysis depth
4. **Custom Reports**: Modify the report generation step for custom formats

### Integrating with CI/CD

The workflow can be integrated into CI/CD pipelines:

```yaml
- name: Trigger Binary Analysis
  uses: actions/github-script@v7
  with:
    script: |
      await github.rest.actions.createWorkflowDispatch({
        owner: context.repo.owner,
        repo: 'it-tools',
        workflow_id: 'binary-analysis.yml',
        ref: 'main',
        inputs: {
          zip_url: '${{ env.BUILD_ARTIFACT_URL }}',
          analysis_name: 'build-${{ github.run_number }}'
        }
      })
```

## Best Practices

1. **Name Your Analyses**: Use descriptive names for easy identification
2. **Document Context**: Keep notes about what you're analyzing and why
3. **Version Control**: Save analysis reports in version control for comparison
4. **Automate**: Trigger analysis automatically on new releases
5. **Review Regularly**: Periodically re-analyze to detect changes
6. **Secure URLs**: Use secure HTTPS URLs for downloads
7. **Retention**: Download important results before the 90-day retention expires
