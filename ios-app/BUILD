load("@build_bazel_rules_apple//apple:ios.bzl", "ios_application")
load("@build_bazel_rules_swift//swift:swift.bzl", "swift_library")

swift_library(
    name = "Sources",
    srcs = glob([
        "**/*.swift",
    ]),
    data = glob([
        "**/*.storyboard",
    ]),
)

ios_application(
    name = "ios-app",
    bundle_id = "com.vinid.ios-app",
    families = [
        "iphone",
    ],
    infoplists = [":Info.plist"],
    minimum_os_version = "11.0",
    visibility = ["//visibility:public"],
    deps = [":Sources"],
)