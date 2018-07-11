Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6DB8C2096FADE
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 14:24:04 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] contrib/do_abidiff: make the build more robust
Date: Wed, 11 Jul 2018 15:23:57 -0600
Message-Id: <20180711212357.4281-1-vishal.l.verma@intel.com>
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

Use the mock config to determine the release to build for, as that will
result in a build version for the running system. If the build were to
fail, ensure we catch that, and if the build artifacts are missing,
error out on that.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 contrib/do_abidiff | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/contrib/do_abidiff b/contrib/do_abidiff
index a520c3c..0bd7a16 100755
--- a/contrib/do_abidiff
+++ b/contrib/do_abidiff
@@ -27,8 +27,10 @@ build_rpm()
 
 	# build and copy RPMs
 	version="$(./git-version)"
+	release="f$(basename $(readlink -f /etc/mock/default.cfg) | cut -d- -f2)"
 	git archive  --format=tar --prefix="ndctl-${version}/" HEAD | gzip > ndctl-${version}.tar.gz
-	fedpkg --release master --module-name ndctl mockbuild
+	fedpkg --release $release --module-name ndctl mockbuild
+	[ "$?" -eq 0 ] || err "error building $ref"
 	mkdir -p release/rel_${ref}/
 	cp results_ndctl/*/*/*.x86_64.rpm release/rel_${ref}/
 
@@ -52,6 +54,8 @@ do_diff()
 	local new_lib="$(find . -regex "./release/rel_${new}/${pkg}-libs-[0-9]+.*" | head -1)"
 
 	[ -n "$pkg" ] || err "specify a package for diff (ndctl, daxctl)"
+	[ -n "$old_base" ] || err "$pkg: old_base empty, possible build failure"
+	[ -n "$new_base" ] || err "$pkg: new_base empty, possible build failure"
 
 	abipkgdiff --dso-only --no-added-syms --harmless --drop-private-types \
 		--devel1 "$old_dev" --devel2 "$new_dev" \
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
