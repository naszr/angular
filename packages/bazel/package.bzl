# Copyright Google Inc. All Rights Reserved.
#
# Use of this source code is governed by an MIT-style license that can be
# found in the LICENSE file at https://angular.io/license

"""Package file which defines dependencies of Angular rules in skylark
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_angular_dependencies():
    """
    Fetch our transitive dependencies.

    If the user wants to get a different version of these, they can just fetch it
    from their WORKSPACE before calling this function, or not call this function at all.
    """

    #
    # Download Bazel toolchain dependencies as needed by build actions
    # Use a SHA to get fix for needing symlink_prefix during npm publishing
    _maybe(
        http_archive,
        name = "build_bazel_rules_nodejs",
        url = "https://github.com/bazelbuild/rules_nodejs/archive/0.16.5.zip",
        strip_prefix = "rules_nodejs-0.16.5",
    )

    _maybe(
        http_archive,
        name = "build_bazel_rules_typescript",
        url = "https://github.com/bazelbuild/rules_typescript/archive/0.22.1.zip",
        strip_prefix = "rules_typescript-0.22.1",
    )

    # Needed for Remote Execution
    _maybe(
        http_archive,
        name = "bazel_toolchains",
        sha256 = "ee854b5de299138c1f4a2edb5573d22b21d975acfc7aa938f36d30b49ef97498",
        strip_prefix = "bazel-toolchains-37419a124bdb9af2fec5b99a973d359b6b899b61",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/bazel-toolchains/archive/37419a124bdb9af2fec5b99a973d359b6b899b61.tar.gz",
            "https://github.com/bazelbuild/bazel-toolchains/archive/37419a124bdb9af2fec5b99a973d359b6b899b61.tar.gz",
        ],
    )

def rules_angular_dev_dependencies():
    """
    Fetch dependencies needed for local development, but not needed by users.

    These are in this file to keep version information in one place, and make the WORKSPACE
    shorter.
    """

    http_archive(
        name = "org_brotli",
        sha256 = "774b893a0700b0692a76e2e5b7e7610dbbe330ffbe3fe864b4b52ca718061d5a",
        strip_prefix = "brotli-1.0.5",
        url = "https://github.com/google/brotli/archive/v1.0.5.zip",
    )

    # The TypeScript rules transitively fetch a version of "rules_webtesting", but the version
    # does not include 239b491e8251588bb46297b899d306ae7024858e which updates the "chromedriver"
    # version so that e2e tests are able to capture the browser console output. This is needed
    # for a few e2e tests, so we manually fetch a version that includes that required SHA.
    http_archive(
        name = "io_bazel_rules_webtesting",
        url = "https://github.com/bazelbuild/rules_webtesting/archive/1f430d5e1cae10efc953a6511147e21b3bc03a5d.zip",
        strip_prefix = "rules_webtesting-1f430d5e1cae10efc953a6511147e21b3bc03a5d",
    )

    #############################################
    # Dependencies for generating documentation #
    #############################################
    http_archive(
        name = "io_bazel_rules_sass",
        strip_prefix = "rules_sass-1.15.1",
        url = "https://github.com/bazelbuild/rules_sass/archive/1.15.1.zip",
    )

    http_archive(
        name = "io_bazel_skydoc",
        strip_prefix = "skydoc-a9550cb3ca3939cbabe3b589c57b6f531937fa99",
        # TODO: switch to upstream when https://github.com/bazelbuild/skydoc/pull/103 is merged
        url = "https://github.com/alexeagle/skydoc/archive/a9550cb3ca3939cbabe3b589c57b6f531937fa99.zip",
    )

def _maybe(repo_rule, name, **kwargs):
    if name not in native.existing_rules():
        repo_rule(name = name, **kwargs)
