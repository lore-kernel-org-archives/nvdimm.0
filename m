Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35466768EA
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 00:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780100334; cv=none; b=OKbK03oFM9ILxTXRfExVM7Ils9AhqdYSDDXVkZ0q0UHP+grS8/rmTvfxxZAzHfCjHntgbpIBbcDsWqop7SQ0Rkb1PCux9ZC9RHYUPl60jWlX6UgLTBQnyZZGeC4aHq+MPBF6StLp5pQlRxAVrqVws+fA9LQQZw77e4syMB+0WJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780100334; c=relaxed/simple;
	bh=FPhENVVsjlEd4rb/o1Rx9e2nBpeObjdBYoY8RuBLRBs=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Jr22Ctm3qVxDN3iNALjQnrgwWSDUkH822rigalx+dTGeAyiOA+WRYs3rs5uo2FWROyvfzi1EmuchWZ3nKIazY22O/9g7os95MyMm2vdTEHqt7Qp7dYJmlO95Z79GK7rqV1b4qyv1FesbaU7N4Lm/X1vQPtmBqkonXS4RkaFi5Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=j7u0j3/3; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="j7u0j3/3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780100333; x=1811636333;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FPhENVVsjlEd4rb/o1Rx9e2nBpeObjdBYoY8RuBLRBs=;
  b=j7u0j3/3jjC0GeH8fNVMbaMlphLWOakfqMKz3vwsKze63DBIF9r4aQXS
   niVcNvG1Ot2uHSCi7OENupQU/EAWdweFT9+rHu55JaTL9+d07/7hfa6e1
   NqHmaRAlP/tOH6KSVOOHnqMXSbpPZdrxOghtiy/OLih2ZdvwDlWAuKPoH
   duc9ddI4WEjBX7rE2JuA28HFHiMPa7fpoQA0WcHgHpAneAWt7i6rdP1SE
   N3nb3ux3nwUXGq41ikCbg6wpwWEYxdNONgx5GDApqQkvw09GDNIR3QlFG
   3ebFMi05w6ZYix4BmPBRLcCLPqrtaqX9AHp2tP3E5o4CUBVMP3w9hb706
   A==;
X-CSE-ConnectionGUID: AKd7VBEXRdO8YtSXSGB2qA==
X-CSE-MsgGUID: dJ9qZWScTE2kNM9mBPw1HQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11801"; a="92339073"
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="92339073"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 17:18:53 -0700
X-CSE-ConnectionGUID: X9ha3j/WR6W25+q9nEwNGg==
X-CSE-MsgGUID: IBnTyILjTuKXEgmT7X4yeQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,176,1774335600"; 
   d="scan'208";a="247264552"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.221.60])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 May 2026 17:18:52 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH 1/2] cxl/region: allow mixed-granularity regions
Date: Fri, 29 May 2026 17:18:46 -0700
Message-ID: <fa5c109f08824180f58341ebd9055545a2ff3142.1780099216.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

cxl_region_determine_granularity() rejects any user-supplied granularity
that does not exactly match the root decoder's granularity, making it
impossible to create mixed-granularity regions from userspace even when
the kernel driver accepts them.

Relax the check to allow region_gran <= root_gran. The kernel validates
constraints at region-commit time so this function only needs to reject
the one arrangement it can determine is always wrong: a region
granularity greater than the root decoder's granularity.

Update the cxl-create-region man page to document the new behavior.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-create-region.txt | 13 ++++++++-----
 cxl/region.c                            | 13 +++++++------
 2 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index b244af60b8a6..d2ff47ec2a18 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -93,11 +93,14 @@ include::bus-option.txt[]
 
 -g::
 --granularity=::
-	The interleave granularity for the new region. Must match the selected
-	root decoder's (if provided) granularity. If the root decoder is
-	interleaved across more than one host-bridge then this value must match
-	that granularity. Otherwise, for non-interleaved decode windows, any
-	granularity can be specified as long as all devices support that setting.
+	The interleave granularity for the new region. If the root decoder is
+	interleaved across more than one host bridge, the region granularity
+	must be less than or equal to the root decoder granularity. A region
+	granularity less than root creates a mixed-granularity configuration
+	where the root interleaves at a coarser granularity and subordinate
+	switches interleave at the finer region granularity. For
+	non-interleaved root decoders, any granularity can be specified as
+	long as all devices support that setting.
 
 -d::
 --decoder=::
diff --git a/cxl/region.c b/cxl/region.c
index 85d4d9bb54f2..fbc7272b9a84 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -632,15 +632,16 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
 		return p->granularity;
 
 	/*
-	 * For ways > 1, only allow the same granularity as the selected
-	 * root decoder
+	 * For ways > 1, allow any region granularity up to and including the
+	 * root decoder granularity. A finer region granularity produces a
+	 * mixed-granularity configuration and a coarser one is always invalid.
 	 */
-	if (p->granularity == granularity)
-		return granularity;
+	if (p->granularity <= granularity)
+		return p->granularity;
 
 	log_err(&rl,
-		"%s: For an x%d root, only root decoder granularity (%d) permitted\n",
-		devname, ways, granularity);
+		"%s: region granularity (%d) cannot exceed root decoder granularity (%d)\n",
+		devname, p->granularity, granularity);
 	return -EINVAL;
 }
 

base-commit: bbd403a03fa2a1551c1a10bbf78f32027c718758
-- 
2.37.3

