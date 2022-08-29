Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388426100
	for <nvdimm@lists.linux.dev>; Mon, 29 Aug 2022 23:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661816523; x=1693352523;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zETNzIlWgWJnq6zD3rw2Rep/FF/MNXsxnk/+JMc/YRc=;
  b=SJ4S+rEVCLvokn8jSMJiWXcD0tmVW/aGDIrG7t6VK3Yk7zNGuFAcmp1X
   l2Ffyj8R1vqcDACH6NrP/Qtgq6BytMnueu4pdWo9GkKvX/fF2lDEU4Goj
   epTGyf4yssui5ZGhT7f19+AM8BGHIcusHyuSC5hIQA+pYny7DToyE6yKK
   D5jujv3wgM/aqBe06fJkT3szgYyEvwiX7Yz+8OGDx0FgpuZT6Z86m3j8L
   RKA35ByV1keKgRCE0VRHtODN11dbs8lTh+rwiZaVa+wKaoCuw0u7RUbtX
   8hUjsnF8aPC16/9dk3QQS1iGq812BBmUet/+bZvgH1tGZyCAHOIm3Jlrl
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10454"; a="358989948"
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="358989948"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:42:01 -0700
X-IronPort-AV: E=Sophos;i="5.93,273,1654585200"; 
   d="scan'208";a="588358119"
Received: from kmora1-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.213.169.48])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2022 16:42:01 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	corsepiu@fedoraproject.org,
	<linux-cxl@vger.kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/2] scripts: update release scripts for meson
Date: Mon, 29 Aug 2022 17:41:57 -0600
Message-Id: <20220829234157.101085-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829234157.101085-1-vishal.l.verma@intel.com>
References: <20220829234157.101085-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=4925; h=from:subject; bh=zETNzIlWgWJnq6zD3rw2Rep/FF/MNXsxnk/+JMc/YRc=; b=owGbwMvMwCXGf25diOft7jLG02pJDMm8fkflXxpkLxSbUuGldGGCS9KUmVcjRRViH+YE1Tbvkvz/ ODmgo5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABNZy8zIMOXO1yv+FVXd3dN4C22W2d klPb+WFL2P8+KbGw2p969mrWZkmBnwle3axTQ56aMXJGqC3kqx2fyIPW1cHe41O2nLTPFeXgA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Update scripts/prepare-release and scripts/do_abidiff to use meson, and
change the expected branch name from 'master' to 'main'.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 scripts/do_abidiff         | 14 ++++++--------
 scripts/prepare-release.sh | 24 ++++++++++++------------
 2 files changed, 18 insertions(+), 20 deletions(-)

diff --git a/scripts/do_abidiff b/scripts/do_abidiff
index ec3e344..cb60e23 100755
--- a/scripts/do_abidiff
+++ b/scripts/do_abidiff
@@ -17,13 +17,11 @@ build_rpm()
 	local version=""
 
 	# prepare ndctl tree
-	rm -rf results_ndctl
+	rm -rf results_ndctl build
 	git checkout -b rel_${ref} $ref
-	./autogen.sh
-	./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64
-	make clean
-	make rhel/ndctl.spec
-	cp rhel/ndctl.spec .
+	meson setup build
+	meson compile -C build rhel/ndctl.spec
+	cp build/rhel/ndctl.spec .
 
 	# build and copy RPMs
 	version="$(./git-version)"
@@ -46,8 +44,8 @@ build_rpm()
 do_diff()
 {
 	local pkg="$1"
-	local old_base="$(find . -regex "./release/rel_${old}/${pkg}-[0-9]+.*" | head -1)"
-	local new_base="$(find . -regex "./release/rel_${new}/${pkg}-[0-9]+.*" | head -1)"
+	local old_base="$(find . -regex "./release/rel_${old}/${pkg}[-cli]*-[0-9]+.*" | head -1)"
+	local new_base="$(find . -regex "./release/rel_${new}/${pkg}[-cli]*-[0-9]+.*" | head -1)"
 	local old_dev="$(find . -regex "./release/rel_${old}/${pkg}-devel-[0-9]+.*" | head -1)"
 	local new_dev="$(find . -regex "./release/rel_${new}/${pkg}-devel-[0-9]+.*" | head -1)"
 	local old_lib="$(find . -regex "./release/rel_${old}/${pkg}-libs-[0-9]+.*" | head -1)"
diff --git a/scripts/prepare-release.sh b/scripts/prepare-release.sh
index 8901b50..c8f54dc 100755
--- a/scripts/prepare-release.sh
+++ b/scripts/prepare-release.sh
@@ -6,7 +6,7 @@
 
 # Notes:
 #  - Checkout to the appropriate branch beforehand
-#     master - for major release
+#     main - for major release
 #     ndctl-xx.y - for fixup release
 #    This is important for generating the shortlog
 #  - Add a temporary commit that updates the libtool versions as needed.
@@ -50,9 +50,9 @@ check_branch()
 			err "expected an ndctl-xx.y branch for fixup release"
 		fi
 	else
-		# major release, expect master branch
-		if ! grep -Eq "^master$" <<< "$cur"; then
-			err "expected master branch for a major release"
+		# major release, expect main branch
+		if ! grep -Eq "^main$" <<< "$cur"; then
+			err "expected main branch for a major release"
 		fi
 	fi
 	if ! git diff-index --quiet HEAD --; then
@@ -99,7 +99,7 @@ gen_lists()
 	c_count=$(git log --pretty=format:"%s" "$range" | wc -l)
 }
 
-# Check libtool versions in Makefile.am.in
+# Check libtool versions in meson.build
 # $1: lib name (currently libndctl, libdaxctl, or libcxl)
 check_libtool_vers()
 {
@@ -107,13 +107,13 @@ check_libtool_vers()
 	local lib_u="${lib^^}"
 	local libdir="${lib##lib}/lib/"
 	local symfile="${libdir}/${lib}.sym"
-	local last_cur=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
-	local last_rev=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
-	local last_age=$(git show $last_ref:Makefile.am.in | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
+	local last_cur=$(git show $last_ref:meson.build | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
+	local last_rev=$(git show $last_ref:meson.build | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
+	local last_age=$(git show $last_ref:meson.build | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
 	local last_soname=$((last_cur - last_age))
-	local next_cur=$(git show HEAD:Makefile.am.in | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
-	local next_rev=$(git show HEAD:Makefile.am.in | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
-	local next_age=$(git show HEAD:Makefile.am.in | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
+	local next_cur=$(git show HEAD:meson.build | grep -E "^${lib_u}_CURRENT" | cut -d'=' -f2)
+	local next_rev=$(git show HEAD:meson.build | grep -E "^${lib_u}_REVISION" | cut -d'=' -f2)
+	local next_age=$(git show HEAD:meson.build | grep -E "^${lib_u}_AGE" | cut -d'=' -f2)
 	local next_soname=$((next_cur - next_age))
 	local soname_diff=$((next_soname - last_soname))
 
@@ -195,6 +195,6 @@ sed -i -e "s/DEF_VER=[0-9]\+.*/DEF_VER=${next_ref#v}/" git-version
 echo "Ready to release ndctl-$next_ref with $c_count new commits."
 echo "Add git-version to the top commit to get the updated version."
 echo "Use release/commits and release/shortlog to compose the release message"
-echo "The release commit typically contains the Makefile.am.in libtool version"
+echo "The release commit typically contains the meson.build libtool version"
 echo "update, and the git-version update."
 echo "Finally, ensure the release commit as well as the tag are PGP signed."
-- 
2.37.2

