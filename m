Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA0C2CAF
	for <nvdimm@lists.linux.dev>; Thu,  6 Jan 2022 05:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641445819; x=1672981819;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZkAhzl0Xl8wQCn0V5QtzzTRSh8WBwuYlWLZ2VvYZGsU=;
  b=bo2z2DPxdgiZQkENSNo6McnCpEG07l6taJ4gB1qXWKTv222c8TfkIPzI
   pFyRD30uS2W20b45/ltybOgZb/ysTjJqQZkr1kDww3TTIimRVos9He9+T
   m1sWUovCApE1PdJ1hERwx5cCOZhBsLh8kJBcWk3HT0SBAYiSrpiAayluD
   5VNnWkz+Ja0SU+xM6FM9ywpiJ1B0ZHu65TI+DTSkXLritQ4P4rqm4UHuc
   7uHIpLdR8ivwwzPn2LmGy1rQI/ox0RW4EqlS85rD46zs+AZw0bvXVJMtY
   6/ugaofEUXm97PAVBVT/4+OnMPoiG1GXlYTV9S8PIvQ2+/E2p2QUhlXfR
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="240138582"
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="240138582"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:51 -0800
X-IronPort-AV: E=Sophos;i="5.88,266,1635231600"; 
   d="scan'208";a="689272632"
Received: from asamymu-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.136.30])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 21:09:51 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/3] scripts: teach release helper scripts about cxl and libcxl
Date: Wed,  5 Jan 2022 22:09:40 -0700
Message-Id: <20220106050940.743232-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220106050940.743232-1-vishal.l.verma@intel.com>
References: <20220106050940.743232-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2016; h=from:subject; bh=ZkAhzl0Xl8wQCn0V5QtzzTRSh8WBwuYlWLZ2VvYZGsU=; b=owGbwMvMwCXGf25diOft7jLG02pJDInXKqcwKi4sZJRlXK/QUZY16/u7yW/7Pr1XMvgw7fdBrUMm 0Y0PO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRG/YM//QrfZxvHJAxP568Ztuy7Z MzD51t8riQFly+qOXXs8Uf6pYyMpzcJ2E2f9U/Gf4oJzOlnZvluS+snTy9ujHCR9f+27qNZiwA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The prepare-release.sh and do_abidiff scripts perform sanity checking
for library versioning and also guard against accidental ABI breakage
by comparing the current release with the previous using 'abipkgdiff'
from libabigail. Teach the scripts about libcxl, so that it too can
participate in the above checks.

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
2.33.1

