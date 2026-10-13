Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C0135C6B9
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 04:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791864884; cv=none; b=TS+aZIfFellQJUsKlbjCiPpm1b0Lv8gyvqCieZEnKw5C19/F+IkhfcK5IJ9PcbHLv/55ynv383B/0ymmsgnq+5/FqpNYTWaiS4MtzQCIbc+bqQjx1DY6/8M1yWcmhii7D0n1IiiQLk14ltvAG2o+LNv25fKrvTX1wkLjLujhPBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791864884; c=relaxed/simple;
	bh=HzZSseehhvTcxKcIIXhrWBF1VYJIZphOiOExHWKaPpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2UT0d99l9iPmxfHXoRPJeswXDjwKuaRAJBb4s/e/lTpAsTd9mKlWNWmtr3ZKPsx4zHsj8xrGXx/Ivyk3X0nnSAy3bwMIBnhAulZhStNjIraFMgw4z/NpVnhYSk2ogjTWuXMuMI0KD8blXpHVUMxNlvF6RuoGxnuuMbLSIhUhuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aAHXTRSM; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aAHXTRSM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791864883; x=1823400883;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HzZSseehhvTcxKcIIXhrWBF1VYJIZphOiOExHWKaPpw=;
  b=aAHXTRSMviU2gF3ZA3+6yc/L9Ih3P9FXvEMXJW1vB89hO2puplx2Lglm
   2tV2/syPJGHvDc+QwKQvp5tlUB2nbCrOyNhPSLbRL7DF2l76Bu1dhCkiq
   hVCJQERx+21Hk7xqOfu4LxE3otU4uLVVem4Sv0y2AEk75QWZNurQVy/px
   dKqyEm9RT6xRw0NN7/t5MUMfd2psAcUAKAzl7FsarAdLGUXYY2xTA7gEe
   zUgH/j8gfkSBwOPtyW5Ph4Vzm6ji6aAyUnbCXkqRN8V47LfbY3FFjOl3j
   3CkZavayEKPUb8m7MJfapQofXWguJe9UNLYLyET44TV9SO5lXKESKPvdY
   Q==;
X-CSE-ConnectionGUID: VzlDFrUCTB2YZmpbXsCI6w==
X-CSE-MsgGUID: 43g+cOINROKXaejCP9Y0Lw==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="468514"
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="468514"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 21:14:43 -0700
X-CSE-ConnectionGUID: 5UZ9QdIMRTaS8m4WtLnQFg==
X-CSE-MsgGUID: DAFJ9AtETsGKE4q4r8epdg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="1388987"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.102])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 21:14:42 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v3 1/3] cxl/region: round default region size within root decoder extent
Date: Mon, 12 Oct 2026 21:14:33 -0700
Message-ID: <ac53ec453608b6cc2c42648c9441c50ac94cd4b8.1791863817.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1791863817.git.alison.schofield@intel.com>
References: <cover.1791863817.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The kernel requires a region size to be a multiple of SZ_256M * ways. The
cxl-cli command, cxl create-region, accepts an explicit size with -s, or
derives the size using ALIGN_DOWN(). The derived size is not always valid.

The calculation can fail in two ways:

1) When the region interleave ways has a factor of three, SZ_256M * ways is
not a power of two, so ALIGN_DOWN() is not valid for the calculation. The
result depends on the root decoder extent and can appear correct by chance.
For example, a 6-way region with a 3G extent produces the expected 3G size,
while a 12-way region with the same extent is trimmed to 1G.

2) At 16 ways, SZ_256M * ways overflows the int used for the multiplication
and evaluates to zero, so the trim returns zero.

Compute the product in u64 to avoid the overflow and round down by division
so that the derived size is a multiple of SZ_256M * ways. Return -ENOSPC
when the root decoder window is smaller than SZ_256M * ways.

This was found while adding 12-way region test coverage.

Fixes: 2904504721a6 ("cxl/region: Trim region size by max available extent")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/region.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index 85d4d9bb54f2..9d727216b9b8 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -682,8 +682,18 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 		return -ENOSPC;
 	}
 
-	if (size > max_extent)
-		size = ALIGN_DOWN(max_extent, SZ_256M * p->ways);
+	if (size > max_extent) {
+		u64 min_size = (u64)SZ_256M * p->ways;
+
+		size = (max_extent / min_size) * min_size;
+		if (!size) {
+			log_err(&rl,
+				"%s: max available space (%#lx) is less than the minimum %d-way region size (%#lx)\n",
+				cxl_decoder_get_devname(p->root_decoder),
+				max_extent, p->ways, min_size);
+			return -ENOSPC;
+		}
+	}
 
 	if (p->mode == CXL_DECODER_MODE_PMEM) {
 		region = cxl_decoder_create_pmem_region(p->root_decoder);
-- 
2.37.3

