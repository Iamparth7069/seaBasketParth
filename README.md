# seabasket

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Prerequisites

| Dependency | Version    |
| ---------- | ---------- |
| **Flutter** | `v3.27.3` |

### Command to build apk
To make build for a particular environment just replace the `<flavor>` with an appropriate env name
`flutter build apk --flavor <flavor> -t lib/<flavor>/main_<flavor>.dart`

### Command to start build_runner
`dart pub run build_runner watch --delete-conflicting-outputs`
