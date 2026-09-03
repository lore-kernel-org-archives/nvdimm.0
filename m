Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEEF74B2CCE
	for <nvdimm@lists.linux.dev>; Thu,  3 Sep 2026 21:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788471277; cv=none; b=sc3/ajj7hfId/8JrwiTxq+KuZfdQ1MPcEYt8mJG2ljrYsQEd5H5gEHaVb4o4FIuMMaH4oJYZHojfmYHnmdD5uEpciHY8FxZNVBrwV1CyeeWZ1ufqZZ3Igbu0jzJo3hYrC44GSY/w0VujvjjGHBHERCNZ6JRXeZf4aDOV8wc7Ybo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788471277; c=relaxed/simple;
	bh=HzZSseehhvTcxKcIIXhrWBF1VYJIZphOiOExHWKaPpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IcDaD61CTgzliANRclkP2GUR2k0jWR/pOwjif1SFfBESFUnQ88Whvcy1l/KFYiq5BV76f7M6g7bdwJL9hyEqENYJzPIfbvhxwuTKjIwXZ1sQmPDsHnsI7j0WftqSgA+DDD9yk7ahleNpCcL0i4XgZkOgscXloY6DGnDUCvemQ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Fa+I83db; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Fa+I83db"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1788471276; x=1820007276;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HzZSseehhvTcxKcIIXhrWBF1VYJIZphOiOExHWKaPpw=;
  b=Fa+I83dbiYs/cfASQ8X/ItVI4w4zOGo7+LHazhXUjHn5BpCEBr8tQMl9
   qc14TCRCSPt9AmYmvet01kI3kcP2lY8CjLsZZXpKQW9223W13HWHapuWs
   1Z54Xuxo1UVbagjK7zBqYnxblJMz6D89Pz3R6zV8yrtI3Aq+YiDHxUlW3
   cfhQJLjt1n38lhmvuRDJKHyHuLiQpIryZ/TSybmwGY87F1gnxy4Atq1oQ
   V4ED18FtUgRgAXscpQESw8vH2eBXtnx3bgnqvYtL25EudBppzzw9fA86Z
   qtREh5VY919R7SwTsoQ1nZnHkxOv9/m4nsW8nWqxgVSG3vqQd/CCwM7Y5
   w==;
X-CSE-ConnectionGUID: 7RgtqM1cTLemti7boalTRQ==
X-CSE-MsgGUID: HKQQq2F4T1WbFdzN+aGUCg==
X-IronPort-AV: E=McAfee;i="6800,10657,11895"; a="76523235"
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="76523235"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:34:35 -0700
X-CSE-ConnectionGUID: TcJpliWrR4WBW2vFIqBYZA==
X-CSE-MsgGUID: 1JwpkV7nQkysprpG3Y8a+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.25,260,1779174000"; 
   d="scan'208";a="263657946"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.10])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2026 14:34:34 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v2 1/3] cxl/region: round default region size within root decoder extent
Date: Thu,  3 Sep 2026 14:34:16 -0700
Message-ID: <ac53ec453608b6cc2c42648c9441c50ac94cd4b8.1788469004.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <cover.1788469004.git.alison.schofield@intel.com>
References: <cover.1788469004.git.alison.schofield@intel.com>
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

