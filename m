Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBF923A1
	for <nvdimm@lists.linux.dev>; Wed, 22 Nov 2023 02:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LviSfuLT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700621876; x=1732157876;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=V/hPdxx4+FPFMl4D2SHJgoI/pplpCvVod2LAgTQbFZM=;
  b=LviSfuLTiZe/Ef7w8tOUgVigDAvqG+g0hIwyy/jvBMZ7gCtvRTrJnucc
   xp9ZHbMtzOyo0uAsBMhhlTYI/CNaZ9+q6xvD29dyLEY0g2irhpG+z93Y+
   zg5bc0UN9ApeFMlXSGsDU1tcRIXw1uj6SsKCj3lsybKGr3dKjZIfRJZMN
   U850ZAeXKHYHOR/k7izUbuxvXNe+GjvncqktcDx+I5Rt20zcnQs3lf0Zz
   MWX1SdQybdywCSa6GHO7786qEDzODWLzxfWspUIdOe6rlBcueEakOWmwp
   BRd9yaB/TEOzflGLYnDbgUDaZrRjaZsh/4NdOnqXh9G9ubl9niFIpi/41
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="394806592"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="394806592"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 18:57:55 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10901"; a="1098247105"
X-IronPort-AV: E=Sophos;i="6.04,217,1695711600"; 
   d="scan'208";a="1098247105"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.90.75])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2023 18:57:54 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: replace a bad root decoder usage in cxl-xor-region.sh
Date: Tue, 21 Nov 2023 18:57:53 -0800
Message-Id: <20231122025753.1209527-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The 4-way XOR region as defined in this test uses a root decoder that
is created using an improperly defined CFMWS. The problem with the
CFMWS is that Host Bridges repeat in the target list like this:
{ 0, 1, 0, 1 }.

Stop using that root decoder and create a 4-way XOR region using an
x2 root decoder that supports XOR arithmetic.

The test passes prior to this patch but there is an interleave check [1]
introduced in the CXL region driver that will expose the bad interleave
this test creates via dev_dbg() messages like this:

[ ] cxl_core:cxl_region_attach:1808: cxl decoder17.0: Test cxl_calc_interleave_pos(): fail test_pos:4 cxled->pos:2
[ ] cxl_core:cxl_region_attach:1808: cxl decoder18.0: Test cxl_calc_interleave_pos(): fail test_pos:5 cxled->pos:3

Note that the CFMWS's are defined in the kernel cxl-test module, so a
kernel patch removing the bad CFMWS will also need to be merged, but
that cleanup can follow this patch. Also note that the bad CFMWS is not
used in the default cxl-test environment. It is only visible when the
cxl-test module is loaded using the param interleave_arithmetic=1. It is
a special config that provides the XOR math CFMWS's for this test.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=a3e00c964fb943934af916f48f0dd43b5110c866

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

Vishal - I'm hoping you will merge this in ndctl v79 even though the
exposure with the kernel doesn't happen until kernel 6.7. This way
users of cxl-test are not learning to ignore the interleave calc
warnings.

Also, hopefully I have not introduced any new shell issues, but
I know this unit test has existing warnings. Can we do a shell
cleanup in a follow-on patchset across the CXL tests?
(and not last minute for your ndctl release)


 test/cxl-xor-region.sh | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index 1962327bd00a..117e7a4bba61 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -68,10 +68,10 @@ setup_x2()
 
 setup_x4()
 {
-        # find x4 decoder
+        # find an x2 decoder
         decoder=$($CXL list -b cxl_test -D -d root | jq -r ".[] |
           select(.pmem_capable == true) |
-          select(.nr_targets == 4) |
+          select(.nr_targets == 2) |
           .decoder")
 
         # Find a memdev for each host-bridge interleave position
@@ -79,14 +79,10 @@ setup_x4()
             .targets | .[] | select(.position == 0) | .target")
         port_dev1=$($CXL list -T -d $decoder | jq -r ".[] |
             .targets | .[] | select(.position == 1) | .target")
-        port_dev2=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 2) | .target")
-        port_dev3=$($CXL list -T -d $decoder | jq -r ".[] |
-            .targets | .[] | select(.position == 3) | .target")
         mem0=$($CXL list -M -p $port_dev0 | jq -r ".[0].memdev")
-        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
-        mem2=$($CXL list -M -p $port_dev2 | jq -r ".[2].memdev")
-        mem3=$($CXL list -M -p $port_dev3 | jq -r ".[3].memdev")
+        mem1=$($CXL list -M -p $port_dev1 | jq -r ".[0].memdev")
+        mem2=$($CXL list -M -p $port_dev0 | jq -r ".[1].memdev")
+        mem3=$($CXL list -M -p $port_dev1 | jq -r ".[1].memdev")
         memdevs="$mem0 $mem1 $mem2 $mem3"
 }
 

base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
-- 
2.37.3

