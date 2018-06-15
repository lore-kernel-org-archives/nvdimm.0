Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4091B210F75C7
 for <linux-nvdimm@lists.01.org>; Fri, 15 Jun 2018 01:14:57 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, contrib: Add helper scripts for new release
Date: Fri, 15 Jun 2018 02:14:46 -0600
Message-Id: <20180615081446.6624-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Add a couple of helper scripts to codify the release process.
First is do_abidiff: This builds RPMs for two different versions of
ndctl (specified as a git revision range, for example vXX.Y..HEAD). It
then uses abipkgdiff to determine whether the commits in that range
(collectively) introduced any compatibility breaking ABI changes.
Changing or removing a publicly exported function is considered a
breakage, where as adding new functions is acceptable.

Second is prepare-release.sh: Its primary purpose is to codify the
libtool version update. It does a variety of sanity checks to ensure we
didn't involuntarily bump the soname, or update the libtool version in
an unexpected way.

prepare-release.sh also calls do_abidiff to perform an abi check between
the last bug-fix update and the new version about to be released.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/do_abidiff         |  73 ++++++++++++++
 contrib/prepare-release.sh | 201 +++++++++++++++++++++++++++++++++++++
 2 files changed, 274 insertions(+)
 create mode 100755 contrib/do_abidiff
 create mode 100755 contrib/prepare-release.sh

diff --git a/contrib/do_abidiff b/contrib/do_abidiff
new file mode 100755
index 0000000..9adc93a
--- /dev/null
+++ b/contrib/do_abidiff
@@ -0,0 +1,73 @@
+#!/bin/bash -e
+
+# WARNING: This will wipe ~/rpmbuild
+
+range="$*"
+old="${range%%..*}"
+new="${range##*..}"
+
+err()
+{
+	echo "$1"
+	exit 1
+}
+
+build_rpm()
+{
+	local cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
+	local ref="$1"
+
+	# setup rpmbuild env
+	rpmdev-wipetree && rpmdev-setuptree
+
+	# prepare ndctl tree
+	git checkout -b rel_${ref} $ref
+	./autogen.sh
+	./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64
+	make clean
+	make rhel/ndctl.spec
+	mkdir -p ~/git/
+	[ -d ~/git/ndctl/ ] && err "~/git/ndctl already exists, please remove it" || true
+	cp -r $(readlink -f .) ~/git/
+
+	# build and copy RPMs
+	./rpmbuild.sh
+	mkdir -p release/rel_${ref}/
+	cp ~/rpmbuild/RPMS/x86_64/*.rpm release/rel_${ref}/
+
+	# restore ndctl branch
+	git checkout $cur
+	git branch -D rel_${ref}
+	rm -rf ~/git/ndctl
+}
+
+do_diff()
+{
+	local pkg="$1"
+	local old_base="$(find . -regex "./release/rel_${old}/${pkg}-[0-9]+.*" | head -1)"
+	local new_base="$(find . -regex "./release/rel_${new}/${pkg}-[0-9]+.*" | head -1)"
+	local old_dev="$(find . -regex "./release/rel_${old}/${pkg}-devel-[0-9]+.*" | head -1)"
+	local new_dev="$(find . -regex "./release/rel_${new}/${pkg}-devel-[0-9]+.*" | head -1)"
+	local old_lib="$(find . -regex "./release/rel_${old}/${pkg}-libs-[0-9]+.*" | head -1)"
+	local new_lib="$(find . -regex "./release/rel_${new}/${pkg}-libs-[0-9]+.*" | head -1)"
+
+	[ -n "$pkg" ] || err "specify a package for diff (ndctl, daxctl)"
+
+	abipkgdiff --dso-only --no-added-syms --harmless --drop-private-types \
+		--devel1 "$old_dev" --devel2 "$new_dev" \
+		"$old_base" "$new_base"
+	abipkgdiff  --no-added-syms --harmless --drop-private-types \
+		--devel1 "$old_dev" --devel2 "$new_dev" \
+		"$old_lib" "$new_lib"
+}
+
+[ -e "COPYING" ] || err "Run from the top level of an ndctl tree"
+if ! command -v "abipkgdiff" >/dev/null; then
+	err "missing abipkgdiff. Please install libabigail"
+fi
+rm -rf release/rel*
+
+build_rpm $old > /dev/null 2>&1
+build_rpm $new > /dev/null 2>&1
+do_diff ndctl
+do_diff daxctl
diff --git a/contrib/prepare-release.sh b/contrib/prepare-release.sh
new file mode 100755
index 0000000..2941124
--- /dev/null
+++ b/contrib/prepare-release.sh
@@ -0,0 +1,201 @@
+#!/bin/bash -e
+
+# Arguments:
+#  fix - fixup release instead of a full release
+#  ignore_rev - ignore the check for _REVISION in libtool versioning checks
+
+# Notes:
+#  - Checkout to the appropriate branch beforehand
+#     master - for major release
+#     ndctl-xx.y - for fixup release
+#    This is important for generating the shortlog
+#  - Add a temporary commit that updates the libtool versions as needed.
+#    This will later become the release commit. Use --amend to add in the
+#    git-version update and the message body.
+
+# WARNING: This will wipe ~/rpmbuild
+
+# Pre-reqs:
+#  - libabigail  (for abipkgdiff)
+#  - rpmdevtools (for rpmdev-setuptree etc)
+
+# TODO
+#  - auto generate a release commit/tag message template
+#  - determine the most recent kernel release and add it to the above
+#  - perform documentation update for pmem.io/ndctl
+#    (this needs the ndctl update to be pushed first..)
+
+cleanup()
+{
+	rm -rf release
+	mkdir release/
+}
+
+err()
+{
+	echo "$1"
+	exit 1
+}
+
+parse_args()
+{
+	local args="$*"
+	grep -q "fix" <<< "$args" && rel_fix="1" || rel_fix=""
+	grep -q "ignore_rev" <<< "$args" && ignore_rev="1" || ignore_rev=""
+}
+
+check_branch()
+{
+	local cur=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
+	if [ -n "$rel_fix" ]; then
+		# fixup release, expect ndctl-xx.y branch
+		if ! grep -Eq "^ndctl.[0-9]+\.y$" <<< "$cur"; then
+			err "expected an ndctl-xx.y branch for fixup release"
+		fi
+	else
+		# major release, expect master branch
+		if ! grep -Eq "^master$" <<< "$cur"; then
+			err "expected master branch for a major release"
+		fi
+	fi
+	if ! git diff-index --quiet HEAD --; then
+		err "$cur has uncommitted/unstaged changes"
+	fi
+}
+
+last_maj()
+{
+	git tag  | sort -V | grep -E "v[0-9]+$" | tail -1
+}
+
+last_fix()
+{
+	local base="$1"
+	git tag  | sort -V | grep -E "$base\.?[0-9]*$" | tail -1
+}
+
+next_maj()
+{
+	local last="$1"
+	local num=${last#v}
+
+	newnum="$((num + 1))"
+	echo "v$newnum"
+}
+
+next_fix()
+{
+	local last="$1"
+	local num=${last##*.}
+	local base=${last%%.*}
+
+	newnum=$((num + 1))
+	echo "$base.$newnum"
+}
+
+gen_lists()
+{
+	local range="$1"
+
+	git shortlog "$range" > release/shortlog
+	git log --pretty=format:"%s" "$range" > release/commits
+	c_count=$(git log --pretty=format:"%s" "$range" | wc -l)
+}
+
+# Check libtool versions in Makefile.am.in
+# $1: lib name (currently libndctl or libdaxctl)
+check_libtool_vers()
+{
+	local lib="$1"
+	local lib_u="${lib^^}"
+	local libdir="${lib##lib}"
+	local symfile="${libdir}/lib/${lib}.sym"
+	local last_cur=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
+	local last_rev=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
+	local last_age=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
+	local last_soname=$((last_cur - last_age))
+	local next_cur=$(git show HEAD:Makefile.am.in | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
+	local next_rev=$(git show HEAD:Makefile.am.in | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
+	local next_age=$(git show HEAD:Makefile.am.in | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
+	local next_soname=$((next_cur - next_age))
+	local soname_diff=$((next_soname - last_soname))
+
+	# generally libtool versions either reset to zero or increase only by one
+	# _CURRENT monotonically increases (by one)
+	if [ "$((next_cur - last_cur))" -gt 1 ]; then
+		err "${lib_u}_CURRENT can increase at most by 1"
+	fi
+	if [ "$next_rev" -ne 0 ]; then
+		if [ "$((next_rev - last_rev))" -gt 1 ]; then
+			err "${lib_u}_REVISION can increase at most by 1"
+		fi
+	fi
+	if [ "$next_age" -ne 0 ]; then
+		if [ "$((next_age - last_age))" -gt 1 ]; then
+			err "${lib_u}_AGE can increase at most by 1"
+		fi
+	fi
+
+	# test for soname change
+	if [ "$soname_diff" -ne 0 ]; then
+		err "${lib}: expected soname to stay unchanged"
+	fi
+
+	# tests based on whether symfile changed
+	# compatibility breaking changes are left for libabigail to detect
+	test -s "$symfile" || err "$symfile: not found"
+	if [ -n "$(git diff --name-only $last_ref..HEAD $symfile)" ]; then
+		# symfile has changed, cur and age should increase
+		if [ "$((next_cur - last_cur))" -ne 1 ]; then
+			err "based on $symfile, ${lib_u}_CURRENT should've increased by 1"
+		fi
+		if [ "$((next_age - last_age))" -ne 1 ]; then
+			err "based on $symfile, ${lib_u}_AGE should've increased by 1"
+		fi
+	else
+		# no changes to symfile, revision should've increased if source changed
+		if [ -n "$ignore_rev" ]; then
+			: # skip
+		elif [ -n "$(git diff --name-only $last_ref..HEAD $libdir/)" ]; then
+			if [ "$((next_rev - last_rev))" -ne 1 ]; then
+				err "based on $symfile, ${lib_u}_REVISION should've increased by 1"
+			fi
+		fi
+	fi
+}
+
+
+# main
+cleanup
+parse_args "$*"
+check_branch
+[ -e "COPYING" ] || err "Run from the top level of an ndctl tree"
+
+last_maj=$(last_maj)
+test -n "$last_maj" || err "Unable to determine last release"
+
+last_fix=$(last_fix $last_maj)
+test -n "$last_fix" || err "Unable to determine last fixup tag for $last_maj"
+
+next_maj=$(next_maj "$last_maj")
+next_fix=$(next_fix "$last_fix")
+[ -n "$rel_fix" ] && last_ref="$last_fix" || last_ref="$last_maj"
+[ -n "$rel_fix" ] && next_ref="$next_fix" || next_ref="$next_maj"
+
+check_libtool_vers "libndctl"
+check_libtool_vers "libdaxctl"
+
+gen_lists ${last_ref}..HEAD
+
+# For ABI diff purposes, use the latest fixes tag
+contrib/do_abidiff ${last_fix}..HEAD
+
+# once everything passes, update the git-version
+sed -i -e "s/DEF_VER=[0-9]\+.*/DEF_VER=${next_ref#v}/" git-version
+
+echo "Ready to release ndctl-$next_ref with $c_count new commits."
+echo "Add git-version to the top commit to get the updated version."
+echo "Use release/commits and release/shortlog to compose the release message"
+echo "The release commit typically contains the Makefile.am.in libtool version"
+echo "update, and the git-version update."
+echo "Finally, ensure the release commit as well as the tag are PGP signed."
-- 
2.17.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
