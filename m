Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D9133FFA
	for <nvdimm@lists.linux.dev>; Wed, 15 Jun 2022 22:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655333300; x=1686869300;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Tdv5b4Bp16qerqfxpTdHw00vLaLugS2dKqAgB14VwCA=;
  b=RW5y4DzyI6ZUi22DWAGU9QrCQLrqbVdhtQg4INJoYkWR0//3qdUPZ3zK
   UaF1Rs7/ikyRgNh93tmFSrfDTKJlaIkjqdIz3qj7s5SadC6jvOhjSnAwD
   Swr5L3OsjId5UXNS+GBBdXhcHSWpT2sNBvauftk158tu6DGbImChjLePW
   oUBXFGdPlrlmxGWSXHT0EQrfzAADyGegdPQ7HhVira6iynvAcEypH2ugp
   TYicWrhe+sdSV2cNs+wMFy4UpK45hM9vi1KwfeOf6yI3PBxPdXh5RVTo/
   uYMLimjoM0wpmwPo9xvRtW2+M7FPf/cMglN2JXX+Q53JhNySSznebxalP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10379"; a="280150969"
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="280150969"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:17 -0700
X-IronPort-AV: E=Sophos;i="5.91,302,1647327600"; 
   d="scan'208";a="911896796"
Received: from rshirckx-mobl.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.81.6])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2022 15:48:16 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v2 5/5] scripts: update release helper scripts for meson and cxl
Date: Wed, 15 Jun 2022 16:48:13 -0600
Message-Id: <20220615224813.523053-6-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220615224813.523053-1-vishal.l.verma@intel.com>
References: <20220615224813.523053-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2254; h=from:subject; bh=Tdv5b4Bp16qerqfxpTdHw00vLaLugS2dKqAgB14VwCA=; b=owGbwMvMwCXGf25diOft7jLG02pJDEmrEtfaSk9/LL+ji62m+XvViWLP15ffu9v6zVtfsTpx733t GSrTO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjARhjKG//H9KnUSWyQ+81jmXXgZvi F+Rrzi/swn9zesTZ6ixmYkxMfwhzvx5Jv3PyJ4dpVcX/n+E//+NGNpjVXbbd6nnQp14bu+mx0A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The prepare-release.sh and do_abidiff scripts perform sanity checking
for library versioning and also guard against accidental ABI breakage
by comparing the current release with the previous using 'abipkgdiff'
from libabigail. Teach the scripts about libcxl, so that it too can
participate in the above checks.

Additionally, move the checks over to the new meson regime. This does
break any checking for the older autotools based build, but that should
be okay.

Link: https://lore.kernel.org/r/20220106050940.743232-4-vishal.l.verma@intel.com
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 scripts/do_abidiff         | 3 ++-
 scripts/prepare-release.sh | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/scripts/do_abidiff b/scripts/do_abidiff
index e8c3a65..ec3e344 100755
--- a/scripts/do_abidiff
+++ b/scripts/do_abidiff
@@ -53,7 +53,7 @@ do_diff()
 	local old_lib="$(find . -regex "./release/rel_${old}/${pkg}-libs-[0-9]+.*" | head -1)"
 	local new_lib="$(find . -regex "./release/rel_${new}/${pkg}-libs-[0-9]+.*" | head -1)"
 
-	[ -n "$pkg" ] || err "specify a package for diff (ndctl, daxctl)"
+	[ -n "$pkg" ] || err "specify a package for diff (ndctl, daxctl, cxl)"
 	[ -n "$old_base" ] || err "$pkg: old_base empty, possible build failure"
 	[ -n "$new_base" ] || err "$pkg: new_base empty, possible build failure"
 
@@ -75,3 +75,4 @@ build_rpm $old > release/buildlog_$old 2>&1
 build_rpm $new > release/buildlog_$new 2>&1
 do_diff ndctl
 do_diff daxctl
+do_diff cxl
diff --git a/scripts/prepare-release.sh b/scripts/prepare-release.sh
index 97ab964..8901b50 100755
--- a/scripts/prepare-release.sh
+++ b/scripts/prepare-release.sh
@@ -100,7 +100,7 @@ gen_lists()
 }
 
 # Check libtool versions in Makefile.am.in
-# $1: lib name (currently libndctl or libdaxctl)
+# $1: lib name (currently libndctl, libdaxctl, or libcxl)
 check_libtool_vers()
 {
 	local lib="$1"
@@ -181,6 +181,7 @@ next_fix=$(next_fix "$last_fix")
 
 check_libtool_vers "libndctl"
 check_libtool_vers "libdaxctl"
+check_libtool_vers "libcxl"
 
 # HEAD~1 because HEAD would be the release commit
 gen_lists ${last_ref}..HEAD~1
-- 
2.36.1

