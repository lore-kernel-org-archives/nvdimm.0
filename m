Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE1987EF
	for <nvdimm@lists.linux.dev>; Fri, 13 Jan 2023 17:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673630306; x=1705166306;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=czDPd7cRgkAhGvDLUHzw8TzbNVK7GhsXxCrOpxgVpjI=;
  b=V+WwUQ5eKWW9+Igs7DFLdEF/GCnRO1q10dJQOTIt7wnK+aQ1iOYe2sgJ
   delzJBfglDGWxF5SIDKaY9JvW/LeCYfbH4zE75i3t6DmtLhlAgIEnHNgN
   Rtg3T+rST5DjJa4AFBANSJ8HLY3pHxC60OQWOdowMuP+9kkemcodqNAkY
   bYQiVoVDVG/G8yb7/ZIGBUjYUZbAQcLwF5Ul+C76z4BLTrmqJjIF4uUD9
   oKKplEW1EOteXkxFWPC1zZ1xkz994u7Wc7kenYdo6D8Uc9uGSHQNR/x0w
   IBURbf3KJ0Wdch/QQSTu0F+DlFKAaHxfs+GU2hNcARWEOHUuw6jFhUQE0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="326103486"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="326103486"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 09:16:29 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10589"; a="903626543"
X-IronPort-AV: E=Sophos;i="5.97,214,1669104000"; 
   d="scan'208";a="903626543"
Received: from ajlopez1-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.14.206])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 09:16:28 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 13 Jan 2023 10:16:21 -0700
Subject: [PATCH ndctl] test/cxl-xor-region.sh: skip instead of fail for
 missing cxl_test
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230112-vv-xor-test-skip-v1-1-92ddc619ba6c@intel.com>
X-B4-Tracking: v=1; b=H4sIAOWRwWMC/x2NywqEMAwAf0Vy3kBbH4f9lWUP1UYNQiyJFEH89
 617HIZhLjBSJoN3c4FSYeNdKvhXA9MaZSHkVBmCC63zPmApeO6KB9mBtnHGNlI398kNPXVQszE
 a4ahRpvUJM0liWR6TlWY+/7PP975/c/kp23wAAAA=
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12-dev-78c63
X-Developer-Signature: v=1; a=openpgp-sha256; l=1120;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=czDPd7cRgkAhGvDLUHzw8TzbNVK7GhsXxCrOpxgVpjI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMkHJ76RuuEQ9WqrclDckoMnd8/ZlPxp6pUX8yZ7Lwyu2qPy
 53zht45SFgYxLgZZMUWWv3s+Mh6T257PE5jgCDOHlQlkCAMXpwBMxHY9w//EA6nqJwRNpjD1+F7/M6
 tzV3Zi7g9m0dz51rWmZxZ0CXoxMryqWa7+NjOs9rbVjFq52d9u98vq5NVOjZnRKxuWdDBIgR8A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Fix cxl-xor-region.sh to correctly skip if cxl_test is unavailable by
returning the special code '77' if the modprobe fails.

Link: https://github.com/pmem/ndctl/issues/229
Fixes: 05486f8bf154 ("cxl/test: add cxl_xor_region test")
Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/cxl-xor-region.sh | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/test/cxl-xor-region.sh b/test/cxl-xor-region.sh
index 5c2108c..1962327 100644
--- a/test/cxl-xor-region.sh
+++ b/test/cxl-xor-region.sh
@@ -4,7 +4,7 @@
 
 . $(dirname $0)/common
 
-rc=1
+rc=77
 
 set -ex
 
@@ -15,6 +15,7 @@ check_prereq "jq"
 modprobe -r cxl_test
 modprobe cxl_test interleave_arithmetic=1
 udevadm settle
+rc=1
 
 # THEORY OF OPERATION: Create x1,2,3,4 regions to exercise the XOR math
 # option of the CXL driver. As with other cxl_test tests, changes to the

---
base-commit: b73e4e0390aae822bc91b8bf72430e6f0e84d668
change-id: 20230112-vv-xor-test-skip-3ae4f5d065e4

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

