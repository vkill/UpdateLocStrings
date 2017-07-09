UpdateLocStrings
==========

Command line tool that creates `*.strings` files with localizable strings for iOS/macOS projects. It wraps `xcrun extractLocStrings` tool from Xcode and add additional option for merge files with previous version.

### Installation

Download zip archive from releases tab and run `install-updatelocstrings.sh` script.

### Usage

`updateLocStrings` support all options for `extractLocStrings` tool. In additional, it support option `-m` for merge new generated strings files with previous version. In this case, in new generated `*.strings` files all values for keys will be replaced with previous values.
This allow you to makeaddition of localizable string very simple to existing files. Also it help you to remove unused strings from `*.strings` files.

```Bash
updateLocStrings -m -o /path/to/folder file1.m file2.swift
```

## License

UpdateLocStrings is available under the MIT license. See the `LICENSE` file for more info.