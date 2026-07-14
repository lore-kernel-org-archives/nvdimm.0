Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D2D32B108
	for <nvdimm@lists.linux.dev>; Tue, 14 Jul 2026 22:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784067369; cv=none; b=M7QowLK5okfWqHzBILfin0GzSEEUPHZggxRWbGPWlB5gXjQ6t73Tm6iZMXj0WGWzpIeqPfTfXbIGhOUiUP5lDFSmetVeOndIf9JwPbzqZFQL8PHS3h9NIDK6Islvc151bv9HkCTp90TtK9P6j/0Hfbs1MII48bbxui/FHlhCsvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784067369; c=relaxed/simple;
	bh=E9fHS2dVnb0N2KGkmVROvjmfkzCh020+yjK93xbpsZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9kTdSXy9HhbkUlIIOPIXFE/olpjmXaiVgqOvwHHngquRFvC8f/JXIfKkNia0tCJfD3Sm3IUd4Fi615HecXr4gfB4ujzXwKByfmju1hJsYsmddhhKZnRmaLvhlijAq+1IfTiVCzBgvNzs/5Z1gO8rSFICodpGWLKgt25CPjbQQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jKgX5Y3w; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jKgX5Y3w"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1784067366; x=1815603366;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=E9fHS2dVnb0N2KGkmVROvjmfkzCh020+yjK93xbpsZU=;
  b=jKgX5Y3wQrTYQKe94iIl4oAaKva43lDCNp70h73xFX0Ff6Y30RqEs0dW
   +4qowsyR/4L+zKXwWC7pSa72DoKL5Tg2grrVYU3PzegUw7i15ImtHAKeD
   Zy0/19a0EP4mZsIkS/GLD+hFAuyzMFQV+Ol3AT7VhZ5nk2pKxTgRZqpvF
   kgAWi6q0CtUAd7imvI33fkADVUQD3ojYaz8QfrrkhEfflkYzXmLowl2yT
   w+sy1lrtuXExJkhXJRXCWBwyLYgHUWHmn0c9N646WhbJBKK2HDClvlDbN
   7zz0SV8/JvAZCg6h2JYXN9BgFJ9LBNqgqThBrn26SKqygWbb1496b+TdB
   Q==;
X-CSE-ConnectionGUID: mdKNQs9zRxmsYuIwy2vwxg==
X-CSE-MsgGUID: IUTOADuCR+qScRoocFRUcw==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="88522715"
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="88522715"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 15:16:05 -0700
X-CSE-ConnectionGUID: iJQajfTOSmG5dTnIIdv+QA==
X-CSE-MsgGUID: BETzYn4sSfmXp07XIXdQtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,164,1779174000"; 
   d="scan'208";a="252598417"
Received: from aschende-mobl.amr.corp.intel.com (HELO [10.125.108.131]) ([10.125.108.131])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2026 15:16:05 -0700
Message-ID: <07ba26a3-3ed4-41d9-9205-1a0e16724983@intel.com>
Date: Tue, 14 Jul 2026 15:16:03 -0700
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [ndctl PATCH] contrib: add Fedora release scripts
To: Alison Schofield <alison.schofield@intel.com>, nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>
References: <20260707035709.1668810-1-alison.schofield@intel.com>
Content-Language: en-US
From: Dave Jiang <dave.jiang@intel.com>
In-Reply-To: <20260707035709.1668810-1-alison.schofield@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 7/6/26 8:57 PM, Alison Schofield wrote:
> Documentation and scripts used by ndctl maintainers to build and
> release Fedora packages have traditionally been maintained outside
> the ndctl git repository. Bring them into the tree under
> contrib/fedora/ so the release process is documented and
> discoverable, and the scripts are reviewed and versioned alongside
> the project they serve.
> 
> The scripts automate the Fedora package build and release process.
> They run from the upstream repository and operate on a local clone
> of the Fedora package repository (dist-git), configured via
> contrib/fedora/config.local.
> 
> The workflow is split into discrete, individually verifiable steps:
> 
>   01-prep_build            download release, compose the spec, upload
>                            sources to the lookaside cache
>   02-do_build_local_checks sanity-check the dist-git workspace
>   03-do_build_push         commit and push the spec to dist-git main
>   04-do_build_branches     scratch-build gate, then fire Koji builds
>                            for rawhide and the stable branches
>   05-do_submit_updates     verify builds completed, submit bodhi
>                            updates for the stable branches
>   06-cleanup               remove temporary files
> 
> Notable design choices:
> 
>  - Stable branches receive the release by copying the spec/sources
>    files from dist-git main rather than merging, since stable
>    branches can permanently diverge from main (e.g. after a Fedora
>    mass rebuild lands on them independently).
> 
>  - Builds are submitted with --nowait and run in parallel in Koji;
>    bodhi submission is a separate step (05) run after the builds are
>    verified green, providing a natural checkpoint.
> 
>  - Every script supports a --check mode that verifies configuration
>    and paths without performing any real work.
> 
>  - Local mock builds are dropped in favor of the Koji scratch build,
>    which uses the real Fedora build environment with no local setup.
> 
> The contrib/ directory is excluded from release tarballs via
> .gitattributes export-ignore, and config.local is git-ignored as it
> is machine-specific.
> 
> Originally-by: Vishal Verma <vishal.l.verma@intel.com>
> Assisted-by: Claude:Opus-4-8
> Signed-off-by: Alison Schofield <alison.schofield@intel.com>

LGTM

Reviewed-by: Dave Jiang <dave.jiang@intel.com>

> ---
>  .gitattributes                          |   1 +
>  .gitignore                              |   1 +
>  contrib/fedora/01-prep_build            | 166 ++++++++++
>  contrib/fedora/02-do_build_local_checks | 112 +++++++
>  contrib/fedora/03-do_build_push         |  69 ++++
>  contrib/fedora/04-do_build_branches     | 232 ++++++++++++++
>  contrib/fedora/06-cleanup               |  38 +++
>  contrib/fedora/README.md                | 403 ++++++++++++++++++++++++
>  contrib/fedora/common.sh                |  82 +++++
>  contrib/fedora/config.local.example     |  12 +
>  10 files changed, 1116 insertions(+)
>  create mode 100644 .gitattributes
>  create mode 100755 contrib/fedora/01-prep_build
>  create mode 100755 contrib/fedora/02-do_build_local_checks
>  create mode 100755 contrib/fedora/03-do_build_push
>  create mode 100755 contrib/fedora/04-do_build_branches
>  create mode 100755 contrib/fedora/06-cleanup
>  create mode 100644 contrib/fedora/README.md
>  create mode 100644 contrib/fedora/common.sh
>  create mode 100644 contrib/fedora/config.local.example
> 
> diff --git a/.gitattributes b/.gitattributes
> new file mode 100644
> index 0000000..19d5126
> --- /dev/null
> +++ b/.gitattributes
> @@ -0,0 +1 @@
> +contrib/fedora export-ignore
> diff --git a/.gitignore b/.gitignore
> index eeb275f..94b77b2 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -6,3 +6,4 @@ sles/ndctl.spec
>  tags
>  cscope.*
>  scripts/docsurgeon_parser.sh
> +contrib/fedora/config.local
> diff --git a/contrib/fedora/01-prep_build b/contrib/fedora/01-prep_build
> new file mode 100755
> index 0000000..11e97fb
> --- /dev/null
> +++ b/contrib/fedora/01-prep_build
> @@ -0,0 +1,166 @@
> +#!/bin/bash -eEx
> +#
> +# 01-prep_build <version>
> +#
> +# PURPOSE: Download upstream sources, extract the spec file from the upstream
> +# meson build, and compose a new ndctl.spec by merging the new spec body with
> +# the existing %changelog section.  Also uploads the new sources to the Fedora
> +# lookaside cache via 'fedpkg new-sources'.
> +#
> +# RUN FROM: upstream ndctl repo root (any branch; the release is downloaded
> +# by tag from GitHub, so the local upstream branch does not matter).
> +# The dist-git clone must be on 'main' -- that is checked automatically.
> +#
> +# TESTABLE WITHOUT BUILDING: run with --check to verify setup only:
> +#   ./contrib/fedora/01-prep_build --check vNN
> +#
> +# AFTER THIS SCRIPT: Review ndctl.spec in the dist-git directory before
> +# proceeding.  The spec should show the new Version, a bumped Release, and a
> +# new %changelog entry.
> +# If something looks wrong, restore with:
> +#   cp $DISTGIT/ndctl.spec.orig $DISTGIT/ndctl.spec
> +#
> +# NEXT STEP: ./contrib/fedora/02-do_build_local_checks <version>
> +#
> +
> +# Source shared functions (config loading, branch checks, preflight)
> +SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> +# shellcheck source=common.sh
> +source "$SCRIPTS_DIR/common.sh"
> +
> +# --- Argument handling ---
> +check_only=false
> +if [[ "$1" == "--check" ]]; then
> +	check_only=true
> +	shift
> +fi
> +
> +ver="$1"
> +if [[ ! "$ver" ]]; then
> +	printf "Usage: %s [--check] <version>  e.g. vNN\n" "$0"
> +	printf "  --check: verify setup and paths without downloading or building anything\n"
> +	exit 1
> +fi
> +
> +srcfile="ndctl-${ver#v}.tar.gz"
> +srcdir="ndctl-${ver#v}"
> +
> +# --- Pre-flight checks ---
> +# These run even with --check, so you can test your setup at any time.
> +load_config
> +verify_upstream_repo
> +verify_distgit_branch "main"
> +preflight_check "$ver"
> +
> +if $check_only; then
> +	printf "Pre-flight checks passed (--check mode, stopping here).\n"
> +	exit 0
> +fi
> +
> +# --- Kerberos authentication ---
> +# Acquire a Kerberos ticket for Fedora if not already authenticated.
> +# Reads the Fedora username from ~/.fedora.upn if present.
> +if [[ -f ~/.fedora.upn ]]; then
> +	if ! klist | grep FEDORAPROJECT; then
> +		kinit "$(cat ~/.fedora.upn)@FEDORAPROJECT.ORG"
> +	fi
> +fi
> +
> +# --- Download upstream sources ---
> +# Downloads ndctl-<ver>.tar.gz from the GitHub release archive.
> +download_release()
> +{
> +	if ! wget "https://github.com/pmem/ndctl/archive/$ver.tar.gz" -O "$srcfile"; then
> +		printf "ERROR: failed to download sources for %s\n" "$ver"
> +		exit 1
> +	fi
> +	# Re-verify Kerberos before going further -- needed for fedpkg new-sources
> +	if ! klist | grep FEDORAPROJECT; then
> +		printf "ERROR: not authenticated with FEDORAPROJECT.org\n"
> +		printf "authenticate using 'kinit <user>@FEDORAPROJECT.ORG'\n"
> +		exit 1
> +	fi
> +}
> +
> +# --- Extract spec from upstream meson build ---
> +# ndctl ships its own spec under rhel/ndctl.spec, generated by meson.
> +# We extract it here and save it as ndctl.spec.src for use in compose_spec.
> +get_src_spec()
> +{
> +	tar xvf "$srcfile"
> +	pushd "$srcdir" || exit 1
> +	meson setup build
> +	meson compile -C build rhel/ndctl.spec
> +	# Save extracted spec alongside the tarball (in upstream repo dir, not dist-git)
> +	cp build/rhel/ndctl.spec "$SCRIPTS_DIR/../../ndctl.spec.src"
> +	popd || exit 1
> +	rm -rf "$srcdir"
> +}
> +
> +# --- Compose the Fedora spec ---
> +# Combines:
> +#   - spec body (everything above %changelog) from the upstream spec (ndctl.spec.src)
> +#   - %changelog section from the existing Fedora spec (ndctl.spec.orig)
> +# Bumps the Version and Release fields using rpmdev-bumpspec.
> +# All file operations happen inside DISTGIT.
> +compose_spec()
> +{
> +	local src_spec="$SCRIPTS_DIR/../../ndctl.spec.src"
> +	local orig="$DISTGIT/ndctl.spec.orig"
> +	local out="$DISTGIT/ndctl.spec"
> +
> +	# Save the current dist-git spec as .orig before touching anything
> +	if [ -f "$out" ]; then
> +		mv "$out" "$orig"
> +	else
> +		test -f "$orig"
> +	fi
> +	rm -f "$out"
> +	test -f "$src_spec"
> +
> +	# Bump version and add a %changelog entry in the .orig file
> +	rpmdev-bumpspec -c "release $ver" -n "${ver#v}" "$orig"
> +
> +	# Find the line where %changelog starts in each file
> +	local src_split
> +	src_split="$(grep -n "%changelog" "$src_spec" | cut -d':' -f1)"
> +	src_split="$((src_split - 1))"
> +	local orig_split
> +	orig_split="$(grep -n "%changelog" "$orig" | cut -d':' -f1)"
> +
> +	# Take the spec body from upstream, append our %changelog
> +	head -n +"$src_split" "$src_spec" > "$out"
> +	tail -n +"$orig_split" "$orig" >> "$out"
> +}
> +
> +# --- Main sequence ---
> +
> +download_release
> +get_src_spec
> +
> +# Make sure dist-git is up to date with origin/main before making changes
> +git -C "$DISTGIT" pull --ff-only
> +
> +compose_spec
> +
> +# Upload the new tarball to the Fedora lookaside cache.
> +# This also updates the 'sources' file and '.gitignore' in dist-git.
> +(cd "$DISTGIT" && fedpkg new-sources "$OLDPWD/$srcfile")
> +
> +cat <<- EOF
> +
> +	ndctl.spec has been composed in: $DISTGIT/ndctl.spec
> +
> +	ACTION REQUIRED: Review the spec and confirm it looks correct:
> +	  grep -E "^Version|^Release" $DISTGIT/ndctl.spec
> +	  Expected: Version: ${ver#v}  Release: 1%{?dist}
> +
> +	  Also check the top %changelog entry looks right:
> +	  head -30 $DISTGIT/ndctl.spec
> +
> +	If something looks wrong, restore the original:
> +	  cp $DISTGIT/ndctl.spec.orig $DISTGIT/ndctl.spec
> +
> +	If it looks good, proceed with:
> +	  ./contrib/fedora/02-do_build_local_checks $ver
> +EOF
> diff --git a/contrib/fedora/02-do_build_local_checks b/contrib/fedora/02-do_build_local_checks
> new file mode 100755
> index 0000000..54482fe
> --- /dev/null
> +++ b/contrib/fedora/02-do_build_local_checks
> @@ -0,0 +1,112 @@
> +#!/bin/bash -eEx
> +#
> +# 02-do_build_local_checks <version>
> +#
> +# PURPOSE: Sanity-check the dist-git workspace state before committing or
> +# pushing anything.  Verifies that ndctl.spec has been modified and that
> +# the sources and .gitignore files have been staged by 'fedpkg new-sources'.
> +#
> +# RUN FROM: upstream ndctl repo root
> +#
> +# TESTABLE WITHOUT BUILDING: run with --check to verify setup only:
> +#   ./contrib/fedora/02-do_build_local_checks --check vNN
> +#
> +# NOTE ON MOCK BUILDS: fedpkg mockbuild is intentionally skipped here.
> +# Mock requires local environment setup (mock group membership, Fedora build
> +# root configs) that is fragile and painful to maintain for a quarterly
> +# workflow.  Script 04 runs a scratch build in Koji instead, which uses
> +# Fedora's actual build infrastructure and is more reliable.  If the scratch
> +# build fails, nothing will have been pushed to any stable branch yet, so
> +# recovery is clean.  See README for details.
> +#
> +# If this script passes, the workspace is ready to commit and push.
> +# If it fails, something went wrong in script 01 -- do not proceed.
> +#
> +# NEXT STEP: ./contrib/fedora/03-do_build_push <version>
> +#
> +
> +SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> +# shellcheck source=common.sh
> +source "$SCRIPTS_DIR/common.sh"
> +
> +# --- Argument handling ---
> +check_only=false
> +if [[ "$1" == "--check" ]]; then
> +	check_only=true
> +	shift
> +fi
> +
> +ver="$1"
> +if [[ ! "$ver" ]]; then
> +	printf "Usage: %s [--check] <version>  e.g. vNN\n" "$0"
> +	printf "  --check: verify setup and paths without checking workspace state\n"
> +	exit 1
> +fi
> +
> +# --- Pre-flight checks ---
> +load_config
> +verify_upstream_repo
> +verify_distgit_branch "main"
> +preflight_check "$ver"
> +
> +if $check_only; then
> +	printf "Pre-flight checks passed (--check mode, stopping here).\n"
> +	exit 0
> +fi
> +
> +# --- Workspace state checks ---
> +# These verify that script 01 completed successfully and left dist-git in
> +# the expected state before we commit anything.
> +
> +trap "unwind" ERR
> +unwind()
> +{
> +	# If ndctl.spec was accidentally staged during a partial failure,
> +	# unstage it so the workspace is back to a clean state
> +	if git -C "$DISTGIT" ls-files --cached ndctl.spec | grep -q ndctl.spec; then
> +		git -C "$DISTGIT" reset HEAD ndctl.spec
> +	fi
> +}
> +
> +# check_cached: verify a file is staged in the dist-git index.
> +# sources and .gitignore are staged by 'fedpkg new-sources' in script 01.
> +check_cached()
> +{
> +	local file="$1"
> +	test -f "$DISTGIT/$file"
> +	if [[ "$(git -C "$DISTGIT" ls-files --cached "$file")" == "$file" ]]; then
> +		printf "  OK (staged):    %s\n" "$file"
> +		return
> +	else
> +		printf "ERROR: Expected '%s' to be staged in dist-git but it is not.\n" "$file"
> +		printf "Did 'fedpkg new-sources' run successfully in script 01?\n"
> +		exit 1
> +	fi
> +}
> +
> +# check_modified: verify a file has unstaged modifications in dist-git.
> +# ndctl.spec should be modified but not yet staged -- it gets staged in script 03.
> +check_modified()
> +{
> +	local file="$1"
> +	test -f "$DISTGIT/$file"
> +	if [[ "$(git -C "$DISTGIT" ls-files --modified "$file")" == "$file" ]]; then
> +		printf "  OK (modified):  %s\n" "$file"
> +		return
> +	else
> +		printf "ERROR: Expected '%s' to be modified in dist-git but it is not.\n" "$file"
> +		printf "Did script 01 run successfully and update the spec?\n"
> +		exit 1
> +	fi
> +}
> +
> +printf "Checking dist-git workspace state in: %s\n" "$DISTGIT"
> +check_modified "ndctl.spec"
> +check_cached "sources"
> +check_cached ".gitignore"
> +
> +# Uncomment to re-enable local build checks (see note above about mock):
> +# (cd "$DISTGIT" && fedpkg mockbuild)   # full mock build -- slow but thorough
> +# (cd "$DISTGIT" && fedpkg lint -i)     # RPM lint checks
> +
> +printf "\nAll checks passed. Proceed with:\n  ./contrib/fedora/03-do_build_push %s\n" "$ver"
> diff --git a/contrib/fedora/03-do_build_push b/contrib/fedora/03-do_build_push
> new file mode 100755
> index 0000000..d9df424
> --- /dev/null
> +++ b/contrib/fedora/03-do_build_push
> @@ -0,0 +1,69 @@
> +#!/bin/bash -eEx
> +#
> +# 03-do_build_push <version>
> +#
> +# PURPOSE: Commit the updated spec/sources in dist-git and push to the 'main'
> +# branch on Fedora dist-git.  This is the single push that makes the new
> +# version available for all stable branches to merge from.
> +#
> +# RUN FROM: upstream ndctl repo root
> +#
> +# TESTABLE WITHOUT BUILDING: run with --check to verify setup only:
> +#   ./contrib/fedora/03-do_build_push --check vNN
> +#
> +# IMPORTANT: This script pushes to dist-git 'main' only.  Script 04 handles
> +# merging and pushing to stable branches (f42, f43, f44).  Pushing to main
> +# first is critical -- script 04 copies the release files *from main*, so if
> +# this step is accidentally done on a stable branch, the other branches would
> +# get the old version.
> +# (Ask me how I know.  See README: "Script ran on the wrong branch".)
> +#
> +# NEXT STEP: ./contrib/fedora/04-do_build_branches <version>
> +#
> +
> +SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> +# shellcheck source=common.sh
> +source "$SCRIPTS_DIR/common.sh"
> +
> +# --- Argument handling ---
> +check_only=false
> +if [[ "$1" == "--check" ]]; then
> +	check_only=true
> +	shift
> +fi
> +
> +ver="$1"
> +if [[ ! "$ver" ]]; then
> +	printf "Usage: %s [--check] <version>  e.g. vNN\n" "$0"
> +	printf "  --check: verify setup and paths without committing or pushing anything\n"
> +	exit 1
> +fi
> +
> +# --- Pre-flight checks ---
> +load_config
> +verify_upstream_repo
> +verify_distgit_branch "main"
> +preflight_check "$ver"
> +
> +if $check_only; then
> +	printf "Pre-flight checks passed (--check mode, stopping here).\n"
> +	exit 0
> +fi
> +
> +# --- Commit and push to dist-git main ---
> +
> +# Stage the spec file. sources and .gitignore were already staged by
> +# 'fedpkg new-sources' in script 01.
> +git -C "$DISTGIT" add ndctl.spec
> +
> +# Commit using the top %changelog entry as the commit message.
> +(cd "$DISTGIT" && fedpkg commit --clog)
> +
> +# Push to origin/main only.
> +# Script 04 handles the stable branches.
> +(cd "$DISTGIT" && fedpkg push)
> +
> +printf "\nPushed to dist-git main. Proceed with:\n"
> +printf "  ./contrib/fedora/04-do_build_branches %s\n" "$ver"
> +printf "which fires the Koji builds, then (once they are green):\n"
> +printf "  ./contrib/fedora/05-do_submit_updates %s\n" "$ver"
> diff --git a/contrib/fedora/04-do_build_branches b/contrib/fedora/04-do_build_branches
> new file mode 100755
> index 0000000..46171f7
> --- /dev/null
> +++ b/contrib/fedora/04-do_build_branches
> @@ -0,0 +1,232 @@
> +#!/bin/bash -eEx
> +#
> +# 04-do_build_branches <version>
> +#
> +# PURPOSE: Run a scratch build as a gate, then fire off real Koji builds for
> +# main (rawhide) and each stable branch.  Builds run in parallel in Koji; this
> +# script does NOT wait for them.  Watch them at the printed URLs, and when all
> +# are green, run 05-do_submit_updates to submit the bodhi updates.
> +#
> +# RUN FROM: upstream ndctl repo root
> +#
> +# TESTABLE WITHOUT BUILDING: run with --check to verify setup only:
> +#   ./contrib/fedora/04-do_build_branches --check vNN
> +#
> +# USAGE:
> +#   ./contrib/fedora/04-do_build_branches vNN              # scratch gate + main + stable branches
> +#   br=f44 ./contrib/fedora/04-do_build_branches vNN       # one branch only (skips scratch + main)
> +#   num_stable=3 ./contrib/fedora/04-do_build_branches vNN # build 3 stable branches instead of 2
> +#
> +# ENVIRONMENT VARIABLES:
> +#   br          - if set, only build this one branch (skips scratch build and main)
> +#   num_stable  - number of stable branches to build, newest first (default: 2)
> +#                 Check https://endoflife.date/fedora for the current stable set;
> +#                 use 3 only during the transition window when a new Fedora is out
> +#                 but the oldest release has not yet gone EOL.
> +#
> +# HOW BRANCHES GET THE NEW VERSION:
> +#   For each stable branch, the release files (ndctl.spec, .gitignore, sources)
> +#   are copied directly from dist-git main and committed.  This deliberately
> +#   avoids 'git merge': stable branches can permanently diverge from main
> +#   (e.g. after a Fedora mass rebuild lands on them independently, or after a
> +#   past manual fix-up), which makes fast-forward merges impossible.  The file
> +#   copy works identically whether or not the branch has diverged, and is a
> +#   no-op if the branch already has the files (safe to re-run).
> +#
> +# IF THE SCRATCH BUILD FAILS:
> +#   Fix the spec in dist-git main, commit and push, then re-run from the top.
> +#   Nothing will have been pushed to any stable branch yet.
> +#
> +# IF A BRANCH BUILD FAILS:
> +#   Check the Koji task URL printed in the output for the build log.
> +#   Fix the issue, then retry just that branch: br=<branch> $0 <version>
> +#
> +# CHECK BUILD STATUS:
> +#   Koji:  https://koji.fedoraproject.org/koji/packageinfo?packageID=ndctl
> +#
> +# NEXT STEP (after all builds are green in Koji):
> +#   ./contrib/fedora/05-do_submit_updates <version>
> +#
> +
> +SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> +# shellcheck source=common.sh
> +source "$SCRIPTS_DIR/common.sh"
> +
> +# --- Argument handling ---
> +check_only=false
> +if [[ "$1" == "--check" ]]; then
> +	check_only=true
> +	shift
> +fi
> +
> +ver="$1"
> +: "${num_stable:=2}"   # how many stable branches to build (newest first)
> +: "${br:=""}"          # if set, build only this one branch
> +
> +if [[ ! "$ver" ]]; then
> +	printf "Usage: %s [--check] <version>  e.g. vNN\n" "$0"
> +	printf "  --check: verify setup and print branch list without building anything\n"
> +	exit 1
> +fi
> +
> +# --- Pre-flight checks ---
> +load_config
> +preflight_check "$ver"
> +
> +if $check_only; then
> +	printf "Stable branches that would be built (num_stable=%s):\n" "$num_stable"
> +	git -C "$DISTGIT" branch -r --list origin/f* | cut -d'/' -f2 | sort -Vr | head -"$num_stable"
> +	printf "Pre-flight checks passed (--check mode, stopping here).\n"
> +	exit 0
> +fi
> +
> +# Collect "branch: task URL" lines for the final summary
> +build_summary=()
> +
> +# --- fedpkg_build_wait ---
> +# Submit a build and poll Koji every 30 seconds until it completes.
> +# Used ONLY for the scratch build, which acts as a gate: it must pass before
> +# anything is pushed to stable branches.
> +# On failure: prints the Koji task URL and exits 1.
> +fedpkg_build_wait()
> +{
> +	# Poll up to 20 times (20 x 30s = 10 minutes) before giving up
> +	local timeout=20
> +
> +	(cd "$DISTGIT" && fedpkg build --nowait "$@") | tee /tmp/fedpkg-build-out
> +	taskid="$(grep -E "^Created task: [0-9]*" /tmp/fedpkg-build-out | cut -d':' -f2 | tr -d ' ')"
> +
> +	printf "Waiting for Koji task %s...\n" "$taskid"
> +	printf "  Task URL: https://koji.fedoraproject.org/koji/taskinfo?taskID=%s\n" "$taskid"
> +
> +	while true; do
> +		sleep 30
> +		koji taskinfo "$taskid" > /tmp/fedpkg-build-state || true
> +		if [ -f /tmp/fedpkg-build-state ]; then
> +			state="$(grep -E "^State: .*" /tmp/fedpkg-build-state | cut -d':' -f2 | tr -d ' ')"
> +			if [ -z "$state" ]; then
> +				timeout=$((timeout - 1))
> +				if ((timeout == 0)); then
> +					printf "ERROR: timed out waiting for Koji state after 10 minutes\n"
> +					printf "Check manually: https://koji.fedoraproject.org/koji/taskinfo?taskID=%s\n" "$taskid"
> +					exit 1
> +				fi
> +				continue
> +			fi
> +			case "$state" in
> +			closed)
> +				printf "Task %s completed successfully.\n" "$taskid"
> +				break
> +				;;
> +			open)
> +				continue
> +				;;
> +			failed)
> +				printf "ERROR: Koji task %s failed.\n" "$taskid"
> +				printf "Check: https://koji.fedoraproject.org/koji/taskinfo?taskID=%s\n" "$taskid"
> +				exit 1
> +				;;
> +			esac
> +		fi
> +	done
> +	rm -f /tmp/fedpkg-build-out /tmp/fedpkg-build-state
> +}
> +
> +# --- fedpkg_build_nowait ---
> +# Submit a build to Koji and return immediately.  Records the task URL in
> +# build_summary for the final printout.  Builds run in parallel in Koji.
> +fedpkg_build_nowait()
> +{
> +	local label="$1"
> +
> +	(cd "$DISTGIT" && fedpkg build --nowait) | tee /tmp/fedpkg-build-out
> +	taskid="$(grep -E "^Created task: [0-9]*" /tmp/fedpkg-build-out | cut -d':' -f2 | tr -d ' ')"
> +	build_summary+=("$label: https://koji.fedoraproject.org/koji/taskinfo?taskID=$taskid")
> +	rm -f /tmp/fedpkg-build-out
> +}
> +
> +# --- prepare_and_build_branch ---
> +# Switch dist-git to a branch, copy the release files from main, commit,
> +# push, and fire off the build (without waiting).
> +#
> +# The file copy replaces the old 'git merge main --ff-only' approach -- see
> +# "HOW BRANCHES GET THE NEW VERSION" in the header for why.
> +prepare_and_build_branch()
> +{
> +	local branch="$1"
> +	(cd "$DISTGIT" && fedpkg switch-branch "$branch")
> +
> +	# Copy the release files directly from main.  Works whether or not the
> +	# branch has diverged from main.
> +	git -C "$DISTGIT" checkout main -- ndctl.spec .gitignore sources
> +	git -C "$DISTGIT" add ndctl.spec .gitignore sources
> +
> +	# Commit only if the copy actually changed something.  Makes this
> +	# idempotent: safe to re-run on a branch that was already prepared.
> +	if git -C "$DISTGIT" diff --cached --quiet; then
> +		printf "  %s already has the release files; nothing to commit\n" "$branch"
> +	else
> +		git -C "$DISTGIT" commit -m "release $ver"
> +	fi
> +
> +	(cd "$DISTGIT" && fedpkg push)
> +	fedpkg_build_nowait "$branch"
> +}
> +
> +# print_summary: show all fired builds and the next step
> +print_summary()
> +{
> +	printf "\n=== Builds submitted (running in parallel in Koji) ===\n"
> +	local line
> +	for line in "${build_summary[@]}"; do
> +		printf "  %s\n" "$line"
> +	done
> +	printf "\nAll builds: https://koji.fedoraproject.org/koji/packageinfo?packageID=ndctl\n"
> +	printf "\nWhen all builds show green (state 'complete'), submit the bodhi updates:\n"
> +	printf "  ./contrib/fedora/05-do_submit_updates %s\n" "$ver"
> +}
> +
> +# --- Single branch mode ---
> +# If 'br' is set, prepare and build only that branch, then exit.
> +# Skips the scratch build and main.  Useful for retrying a failed branch.
> +if [[ $br ]]; then
> +	if ! git -C "$DISTGIT" branch -l "$br" | grep -q "$br"; then
> +		printf "ERROR: branch '%s' not found in dist-git\n" "$br"
> +		printf "Available branches:\n"
> +		git -C "$DISTGIT" branch -l
> +		exit 1
> +	fi
> +	prepare_and_build_branch "$br"
> +	(cd "$DISTGIT" && fedpkg switch-branch main)
> +	print_summary
> +	exit 0
> +fi
> +
> +# --- Normal full build mode ---
> +
> +# Step 1: scratch build on main -- the gate.
> +# Runs in Koji using Fedora's actual build infrastructure and WAITS for the
> +# result.  If this fails, the spec has a problem: fix it on main, push, and
> +# re-run.  Nothing has been pushed to any stable branch yet at this point.
> +printf "Step 1: scratch build to verify spec builds cleanly (this one waits)...\n"
> +(cd "$DISTGIT" && fedpkg switch-branch main)
> +fedpkg_build_wait --scratch
> +
> +# Step 2: fire the real build on main (becomes rawhide / next Fedora).
> +# No bodhi update needed for rawhide -- bodhi creates one automatically
> +# when the build completes.
> +printf "Step 2: submitting main (rawhide) build...\n"
> +fedpkg_build_nowait "main (rawhide)"
> +
> +# Step 3: prepare and fire builds for the stable branches, newest first.
> +printf "Step 3: submitting builds for %s stable branches...\n" "$num_stable"
> +git -C "$DISTGIT" branch -r --list origin/f* | cut -d'/' -f2 | sort -Vr | head -"$num_stable" > /tmp/fedpkg-branches
> +while read -r branch; do
> +	printf "  Preparing and building %s...\n" "$branch"
> +	prepare_and_build_branch "$branch"
> +done < /tmp/fedpkg-branches
> +rm -f /tmp/fedpkg-branches
> +
> +(cd "$DISTGIT" && fedpkg switch-branch main)
> +
> +print_summary
> diff --git a/contrib/fedora/06-cleanup b/contrib/fedora/06-cleanup
> new file mode 100755
> index 0000000..45c9721
> --- /dev/null
> +++ b/contrib/fedora/06-cleanup
> @@ -0,0 +1,38 @@
> +#!/bin/bash -eEx
> +#
> +# 06-cleanup
> +#
> +# PURPOSE: Remove temporary files generated during the build process.
> +# Safe to run at any time after script 01 has completed.
> +#
> +# RUN FROM: upstream ndctl repo root
> +#
> +# What gets removed:
> +#   ndctl.spec.src        - upstream spec extracted by script 01 (meson output)
> +#   $DISTGIT/ndctl.spec.orig  - backup of previous Fedora spec made by script 01
> +#   $DISTGIT/*.src.rpm    - any local source RPMs from mock builds
> +#   $DISTGIT/results_ndctl/   - mock build output directory
> +#   $DISTGIT/copr-out/    - COPR build output directory
> +#
> +# NOTE: ndctl.spec itself is NOT removed -- it is the live Fedora spec file
> +# tracked in dist-git.
> +#
> +
> +SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> +# shellcheck source=common.sh
> +source "$SCRIPTS_DIR/common.sh"
> +load_config
> +
> +# Upstream repo root (two levels up from contrib/fedora/)
> +UPSTREAM_ROOT="$(cd "$SCRIPTS_DIR/../.." && pwd)"
> +
> +# Remove temp spec files from upstream repo root
> +rm -f "$UPSTREAM_ROOT/ndctl.spec.src"
> +
> +# Remove temp files from dist-git
> +rm -f "$DISTGIT/ndctl.spec.orig"
> +rm -f "$DISTGIT"/*.src.rpm
> +rm -rf "$DISTGIT/results_ndctl"
> +rm -rf "$DISTGIT/copr-out"
> +
> +printf "Cleanup complete.\n"
> diff --git a/contrib/fedora/README.md b/contrib/fedora/README.md
> new file mode 100644
> index 0000000..62ea51e
> --- /dev/null
> +++ b/contrib/fedora/README.md
> @@ -0,0 +1,403 @@
> +# ndctl Fedora Package Build Scripts
> +
> +## Overview
> +
> +These scripts live in `contrib/fedora/` in the upstream ndctl repo and automate
> +the process of building and publishing a new ndctl release to Fedora.  They are
> +meant to be run in order, once per release (~quarterly), from your upstream ndctl
> +clone — not from the dist-git clone.
> +
> +The general flow is:
> +1. Download the new upstream sources and compose a new spec file
> +2. Sanity-check the dist-git workspace before pushing anything
> +3. Commit and push the spec/sources to dist-git `main`
> +4. Fire off Koji builds for main and each stable Fedora branch
> +5. After the builds are green, submit the bodhi updates
> +6. Clean up temporary files
> +
> +Scripts 04 and 05 are deliberately split: 04 submits the builds and exits
> +(Koji runs them in parallel), you watch them complete on the Koji web page,
> +and then 05 verifies they finished and submits the bodhi updates.  This gives
> +a natural human checkpoint instead of a script blocking for hours.
> +
> +---
> +
> +## One-Time Setup
> +
> +These scripts need to know where your local dist-git clone lives.  Copy the
> +example config and fill in your path:
> +
> +```bash
> +cp contrib/fedora/config.local.example contrib/fedora/config.local
> +# edit config.local and set DISTGIT to your dist-git clone path
> +```
> +
> +`config.local` is excluded from git and from release tarballs (see
> +`.gitattributes`).  It is specific to your machine and never committed.
> +
> +You can verify your setup at any time without doing any real work by running
> +any script with `--check`:
> +
> +```bash
> +./contrib/fedora/01-prep_build --check vNN
> +./contrib/fedora/04-do_build_branches --check vNN   # also prints branch list
> +./contrib/fedora/05-do_submit_updates --check vNN   # also prints the NVRs it would verify
> +```
> +
> +---
> +
> +## Two Repos, One Workflow
> +
> +These scripts operate across two separate git repos:
> +
> +| Repo | Purpose | Typical location |
> +|---|---|---|
> +| **upstream** (this repo) | ndctl source code; where scripts live | `~/src/ndctl` |
> +| **dist-git** | Fedora packaging repo (fedpkg clone) | `~/fedora-pkgs/ndctl` |
> +
> +**All scripts are run from the upstream repo root.**  They use `$DISTGIT` (from
> +`config.local`) to operate on the dist-git clone as needed.
> +
> +---
> +
> +## Branch Strategy
> +
> +Fedora dist-git uses separate branches per release:
> +
> +- `main` / `rawhide` — the next unreleased Fedora (e.g. fc45).  Builds here
> +  but no bodhi update — rawhide gets updates automatically.
> +- `f44`, `f43`, `f42` — current stable Fedora releases.  Builds here AND
> +  submit bodhi updates so the package reaches users.
> +- `f41` and older — EOL, do not build.
> +
> +**Scripts 01-03 always operate on dist-git `main`.**  Script 04 then fans out
> +to stable branches by **copying the release files (`ndctl.spec`, `.gitignore`,
> +`sources`) from `main`** and committing them on each branch.  This means the
> +new version must land on `main` first, before any stable branch builds are
> +attempted.
> +
> +The file copy is used instead of `git merge` on purpose: stable branches can
> +permanently diverge from main (a Fedora mass rebuild landing on a branch
> +independently, or a past manual fix-up), which makes fast-forward merges
> +impossible.  The file copy works identically whether or not a branch has
> +diverged, and is a no-op if the branch already has the files — safe to re-run.
> +
> +After script 03, the dist-git branch state should look like:
> +```
> +main  → vNN    ← just pushed (the new release)
> +f44   → vNN-1  ← script 04 will copy the files from main and build
> +f43   → vNN-1  ← script 04 will copy the files from main and build
> +
> +(fNN branch names and prior versions shown are examples; the set of stable
> +branches changes as Fedora releases roll forward)
> +```
> +
> +---
> +
> +## Prerequisites
> +
> +- `kinit <user>@FEDORAPROJECT.ORG` — Kerberos auth (script 01 handles this
> +  automatically if `~/.fedora.upn` contains your Fedora username)
> +- Tools installed: `fedpkg`, `koji`, `rpm-build`, `rpmdev-bumpspec`, `wget`,
> +  `meson`
> +- dist-git clone on `main` branch before starting
> +
> +---
> +
> +## Script Reference
> +
> +### 01-prep_build \<version\>
> +
> +**Purpose:** Download upstream sources, extract the spec from the upstream meson
> +build, and compose a new `ndctl.spec` in dist-git by merging the upstream spec
> +body with the existing `%changelog` section.  Also uploads the new tarball to
> +the Fedora lookaside cache.
> +
> +**Run from:** upstream repo root (any branch — the release tarball is
> +downloaded from GitHub by tag; your local upstream tree is not used).
> +The **dist-git** clone must be on `main`.
> +
> +**Test without building:**
> +```bash
> +./contrib/fedora/01-prep_build --check vNN
> +```
> +
> +**After this script:** Review the spec in dist-git before proceeding:
> +```bash
> +grep -E "^Version|^Release" $DISTGIT/ndctl.spec
> +head -30 $DISTGIT/ndctl.spec
> +```
> +If something looks wrong, restore the original:
> +```bash
> +cp $DISTGIT/ndctl.spec.orig $DISTGIT/ndctl.spec
> +```
> +
> +---
> +
> +### 02-do_build_local_checks \<version\>
> +
> +**Purpose:** Sanity-check that dist-git is in the right state before committing
> +anything — confirms `ndctl.spec` was modified and `sources`/`.gitignore` were
> +staged by `fedpkg new-sources`.
> +
> +**Run from:** upstream repo root
> +
> +**Test without building:**
> +```bash
> +./contrib/fedora/02-do_build_local_checks --check vNN
> +```
> +
> +If this script passes, dist-git is ready to commit and push.  If it fails,
> +something went wrong in script 01 — do not proceed.
> +
> +---
> +
> +### 03-do_build_push \<version\>
> +
> +**Purpose:** Commit the updated spec/sources in dist-git and push to `main`.
> +This is the single push that makes the new version available for all stable
> +branches to copy from.
> +
> +**Run from:** upstream repo root
> +
> +**Test without building:**
> +```bash
> +./contrib/fedora/03-do_build_push --check vNN
> +```
> +
> +**Important:** This pushes to dist-git `main` only.  Script 04 handles the
> +stable branches.  Pushing to `main` first is critical — script 04 copies the
> +release files *from main*, so if this push somehow lands on a stable branch
> +instead, the other branches won't get the new version.  See "Script ran on
> +wrong branch" in Common Problems.
> +
> +---
> +
> +### 04-do_build_branches \<version\>
> +
> +**Purpose:** Run a scratch build as a gate, then fire off real Koji builds for
> +main (rawhide) and each stable branch.  The builds run **in parallel** in Koji;
> +the script prints their URLs and exits without waiting.
> +
> +**Run from:** upstream repo root
> +
> +**Test without building (also prints branch list):**
> +```bash
> +./contrib/fedora/04-do_build_branches --check vNN
> +```
> +
> +**Normal usage:**
> +```bash
> +./contrib/fedora/04-do_build_branches vNN
> +```
> +
> +**Single branch (retry a failed branch; skips scratch and main):**
> +```bash
> +br=f44 ./contrib/fedora/04-do_build_branches vNN
> +```
> +
> +**Build more stable branches** (check https://endoflife.date/fedora for the
> +current stable set; 3 is only needed in the transition window when a new
> +Fedora is out but the oldest release hasn't gone EOL yet):
> +```bash
> +num_stable=3 ./contrib/fedora/04-do_build_branches vNN
> +```
> +
> +**What it does:**
> +1. Scratch build on `main` — the gate; this one WAITS for the result.
> +   Nothing is pushed to any stable branch until it passes.
> +2. Fires the real `main` (rawhide) build with `--nowait`
> +3. For each stable branch: copies `ndctl.spec`, `.gitignore`, `sources` from
> +   `main`, commits, pushes, and fires the build with `--nowait`
> +4. Prints all Koji task URLs and exits
> +
> +**Environment variables:**
> +
> +| Variable | Default | Purpose |
> +|---|---|---|
> +| `br` | (unset) | Build only this one branch |
> +| `num_stable` | `2` | How many stable branches to build |
> +
> +**After this script:** watch the builds at the printed Koji URLs.  When all
> +show green (state `complete`), run script 05.
> +
> +---
> +
> +### 05-do_submit_updates \<version\>
> +
> +**Purpose:** Verify the Koji builds completed, then submit the bodhi updates
> +for the stable branches.  Bodhi is Fedora's update gating system — submitting
> +moves the build into `updates-testing` where users can install and karma-test
> +it before it reaches the stable repo.  A Koji build alone does not reach users.
> +
> +**Run from:** upstream repo root
> +
> +**Test without submitting (shows the NVRs it would verify):**
> +```bash
> +./contrib/fedora/05-do_submit_updates --check vNN
> +```
> +
> +**Normal usage (after all builds are green):**
> +```bash
> +./contrib/fedora/05-do_submit_updates vNN
> +```
> +
> +**What it does:**
> +1. Checks every expected build (e.g. `ndctl-85-1.fc44`) is `COMPLETE` in Koji.
> +   If any is not ready, it lists them and exits without submitting anything —
> +   wait and re-run.
> +2. Submits a bodhi update for each stable branch.
> +   Rawhide/main is skipped — bodhi creates its update automatically.
> +
> +**Bodhi update type:** a version with a dot (e.g. `vNN.M`) is submitted as a
> +`bugfix`; otherwise `enhancement`.
> +
> +**Environment variables:**
> +
> +| Variable | Default | Purpose |
> +|---|---|---|
> +| `br` | (unset) | Submit for only this one branch |
> +| `num_stable` | `2` | How many stable branches (match what 04 used) |
> +| `bz` | (unset) | Bugzilla number to attach to the updates |
> +| `rel` | `1` | RPM Release number, if the build wasn't `-1` |
> +
> +---
> +
> +### 06-cleanup
> +
> +**Purpose:** Remove temporary files from both the upstream repo and dist-git.
> +
> +**What it removes:**
> +- `ndctl.spec.src` (upstream repo) — extracted upstream spec from script 01
> +- `$DISTGIT/ndctl.spec.orig` — backup of the previous Fedora spec
> +- `$DISTGIT/*.src.rpm` — local source RPMs from mock builds
> +- `$DISTGIT/results_ndctl/` — mock build output
> +- `$DISTGIT/copr-out/` — COPR build output
> +
> +`ndctl.spec` itself is NOT removed — it is the live Fedora spec tracked in
> +dist-git.
> +
> +---
> +
> +## Local vs Scratch Builds
> +
> +Script 02 has `fedpkg mockbuild` and `fedpkg lint` commented out.  Local mock
> +builds are fragile — they depend on your local environment, mock group
> +membership, and locally installed Fedora build root configs, all of which are a
> +pain to maintain for a quarterly workflow.
> +
> +Instead, script 04 runs a **scratch build** in Koji as its first step.  A
> +scratch build runs in Fedora's actual build infrastructure using the exact same
> +environment as a real build.  If it passes, the spec is good.  This is more
> +reliable than a local mock build and requires zero local setup.
> +
> +The scratch build is intentionally the first thing script 04 does.  If it
> +fails, nothing has been pushed to any stable branch yet, so recovery is clean.
> +
> +---
> +
> +## Checking Build and Update Status
> +
> +**Koji builds:**
> +```
> +https://koji.fedoraproject.org/koji/packageinfo?packageID=ndctl
> +```
> +
> +**Bodhi updates:**
> +```
> +https://bodhi.fedoraproject.org/updates/?packages=ndctl
> +```
> +
> +---
> +
> +## Common Problems
> +
> +### Scratch build failed
> +
> +The scratch build in script 04 runs before any stable branch work.  If it
> +fails, the script aborts and nothing has been pushed to any stable branch yet —
> +recovery is clean.
> +
> +Common causes that local checks won't catch:
> +- Missing or incorrect `BuildRequires` in the spec
> +- Upstream source tarball has a different directory layout than the spec expects
> +- A patch no longer applies cleanly against the new version
> +- A macro or path referenced in the spec no longer exists in the new sources
> +
> +To recover:
> +1. Check the Koji task URL printed in the output to see the build log
> +2. Fix `$DISTGIT/ndctl.spec`
> +3. Commit and push the fix:
> +   ```bash
> +   git -C $DISTGIT add ndctl.spec
> +   git -C $DISTGIT commit -m "fix spec for vNN"
> +   (cd $DISTGIT && fedpkg push)
> +   ```
> +4. Re-run script 04 from the top — it will run a new scratch build first
> +
> +---
> +
> +### "Build already exists" error in Koji
> +
> +Koji refuses to build an NVR that was already built.  The branch's spec is
> +still at the old version — usually meaning the release files never made it to
> +that branch.  Since script 04 copies the files from `main` itself, this
> +normally only happens if the push to `main` (script 03) landed somewhere else.
> +Check the branch and main:
> +```bash
> +git -C $DISTGIT log --oneline main | head -3     # should show "release vNN"
> +git -C $DISTGIT log --oneline <branch> | head -3
> +```
> +If `main` is missing the release commit, see "Script ran on the wrong branch"
> +below.  Once main is correct, retry the branch:
> +`br=<branch> ./contrib/fedora/04-do_build_branches vNN`
> +
> +---
> +
> +### A stable branch has diverged from `main`
> +
> +This happens when commits land on a branch independently of main — e.g. a
> +Fedora mass rebuild, or a past manual fix-up.  It is expected and harmless:
> +script 04 copies the release files from main rather than merging, precisely so
> +that diverged branches work the same as clean ones.  No action needed.
> +
> +---
> +
> +### Bodhi update not submitted for a branch
> +
> +Retry just that branch (script 05 verifies the build then submits):
> +```bash
> +br=<branch> ./contrib/fedora/05-do_submit_updates vNN
> +```
> +Or fully manually:
> +```bash
> +git -C $DISTGIT checkout <branch>
> +cd $DISTGIT && fedpkg update --request=testing --type=enhancement --notes=release-vNN
> +```
> +
> +---
> +
> +### An unexpected rawhide update appeared in bodhi
> +
> +Not a problem.  Bodhi automatically creates an update for rawhide when the
> +main build completes — nobody submits it, and script 05 deliberately skips
> +rawhide for this reason.
> +
> +---
> +
> +### Script ran on the wrong branch
> +
> +If scripts 01-03 ran while dist-git was on a stable branch (e.g. `f43`) instead
> +of `main`, the new version commit landed on that branch only.  `main` still has
> +the old version, and script 04 copies from `main`, so it would propagate the
> +old version.
> +
> +To fix: copy the files from the branch where the commit landed onto `main`:
> +```bash
> +git -C $DISTGIT checkout main
> +git -C $DISTGIT checkout f43 -- ndctl.spec .gitignore sources
> +git -C $DISTGIT add ndctl.spec .gitignore sources
> +git -C $DISTGIT commit -m "release vNN"
> +git -C $DISTGIT push
> +```
> +Then proceed normally with script 04.
> diff --git a/contrib/fedora/common.sh b/contrib/fedora/common.sh
> new file mode 100644
> index 0000000..6a4705e
> --- /dev/null
> +++ b/contrib/fedora/common.sh
> @@ -0,0 +1,82 @@
> +# contrib/fedora/common.sh
> +#
> +# Shared functions and setup sourced by all ndctl Fedora packaging scripts.
> +# Not meant to be run directly.
> +#
> +
> +# Locate the directory containing these scripts (contrib/fedora/ in the
> +# upstream clone), regardless of where the caller's working directory is.
> +SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
> +
> +# Load local config (DISTGIT path etc.)
> +# If config.local is missing, print a clear setup message and exit.
> +load_config()
> +{
> +	if [[ ! -f "$SCRIPTS_DIR/config.local" ]]; then
> +		printf "ERROR: missing %s/config.local\n" "$SCRIPTS_DIR"
> +		printf "One-time setup: copy the example and fill in your paths:\n"
> +		printf "  cp %s/config.local.example %s/config.local\n" "$SCRIPTS_DIR" "$SCRIPTS_DIR"
> +		exit 1
> +	fi
> +	# shellcheck source=config.local.example
> +	source "$SCRIPTS_DIR/config.local"
> +
> +	if [[ ! -d "$DISTGIT" ]]; then
> +		printf "ERROR: DISTGIT directory not found: %s\n" "$DISTGIT"
> +		printf "Check the DISTGIT path in %s/config.local\n" "$SCRIPTS_DIR"
> +		exit 1
> +	fi
> +}
> +
> +# verify_upstream_repo: confirm we are running from inside the upstream repo.
> +# All scripts run from the upstream clone (not the dist-git clone).
> +#
> +# NOTE: The upstream repo's *branch* does not matter -- script 01 downloads
> +# the release tarball by tag from GitHub and never reads the local upstream
> +# tree.  The branch that matters is dist-git being on 'main', which is
> +# checked separately by verify_distgit_branch.
> +verify_upstream_repo()
> +{
> +	local upstream_dir
> +	upstream_dir="$(git -C "$SCRIPTS_DIR" rev-parse --show-toplevel 2>/dev/null)"
> +
> +	# Make sure the caller's cwd is inside the upstream repo
> +	local cwd_toplevel
> +	cwd_toplevel="$(git rev-parse --show-toplevel 2>/dev/null)"
> +
> +	if [[ "$cwd_toplevel" != "$upstream_dir" ]]; then
> +		printf "ERROR: must run from inside the upstream ndctl repo\n"
> +		printf "  Expected: %s\n" "$upstream_dir"
> +		printf "  Got:      %s\n" "$cwd_toplevel"
> +		exit 1
> +	fi
> +}
> +
> +# verify_distgit_branch: confirm the dist-git clone is on the expected branch.
> +verify_distgit_branch()
> +{
> +	local expected_branch="$1"
> +	local current_branch
> +	current_branch="$(git -C "$DISTGIT" rev-parse --abbrev-ref HEAD)"
> +	if [[ "$current_branch" != "$expected_branch" ]]; then
> +		printf "ERROR: dist-git repo must be on '%s' branch, currently on '%s'\n" \
> +			"$expected_branch" "$current_branch"
> +		printf "Run: git -C %s checkout %s\n" "$DISTGIT" "$expected_branch"
> +		exit 1
> +	fi
> +}
> +
> +# preflight_check: run all pre-flight checks and print a summary.
> +# Call this with --check to test the setup without doing any real work.
> +# Each script calls this at the start.
> +preflight_check()
> +{
> +	local ver="$1"
> +	printf "=== Pre-flight checks ===\n"
> +	printf "  Scripts dir:  %s\n" "$SCRIPTS_DIR"
> +	printf "  Dist-git dir: %s\n" "$DISTGIT"
> +	printf "  Version:      %s\n" "$ver"
> +	printf "  Upstream branch: %s\n" "$(git rev-parse --abbrev-ref HEAD)"
> +	printf "  Dist-git branch: %s\n" "$(git -C "$DISTGIT" rev-parse --abbrev-ref HEAD)"
> +	printf "=========================\n"
> +}
> diff --git a/contrib/fedora/config.local.example b/contrib/fedora/config.local.example
> new file mode 100644
> index 0000000..0bb38da
> --- /dev/null
> +++ b/contrib/fedora/config.local.example
> @@ -0,0 +1,12 @@
> +# contrib/fedora/config.local
> +#
> +# Local machine configuration for the ndctl Fedora packaging scripts.
> +# This file is NOT committed to git (see .gitattributes).
> +#
> +# SETUP: Copy this file to config.local and fill in your paths.
> +#   cp config.local.example config.local
> +#
> +
> +# DISTGIT: path to your local clone of the Fedora dist-git repo
> +# This is the repo you cloned with 'fedpkg clone ndctl'
> +DISTGIT=~/fedora-pkgs/ndctl

