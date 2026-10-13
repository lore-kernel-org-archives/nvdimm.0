Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDFF471CE4
	for <nvdimm@lists.linux.dev>; Tue, 13 Oct 2026 04:14:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791864885; cv=none; b=DZu8iYEVuO0Jp9BOypDOkam/Vhoz9QfgN1paZpvW/cxbUm1LLgWc2ghY8IAaw+sqIuc3HSNnJoiyhckVHJobRlyxUMAKJP9YLOsTcUN8U+RLX1pyCkHZXrf3C3QURxf15g1H+1sT2ehNA6xw7Uy9pcalSzlHHn6g8QuA6myPEUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791864885; c=relaxed/simple;
	bh=B6SjVNzlgfbwB80GU565XXQ42vj3P9FJcjq+so+U8Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A8AmLv3YraQmPFj4KePUrm8p3mCyLKrH3ffTZiIqE5fouTm1ao1BIZ4LaIsCSDX0PpihdU7yeFY/r0YOssxHgdvQZm3m7lu7/wslLon1kd/CIASqqxdxfQxgJxC1qEiEpfIvjqvu9H9ZYo1oVMwN82rfBvHklyGMmKVhVoABl3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aRq+kS7K; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aRq+kS7K"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1791864884; x=1823400884;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=B6SjVNzlgfbwB80GU565XXQ42vj3P9FJcjq+so+U8Ao=;
  b=aRq+kS7KOqo1ucLBYShwPqUFzBybbi3eaPtiSFZqYaSTA/lwAqJNvCPa
   tmzhBUkqmdd3CtHBDPbDp4kkTWM5X9Cf+Vmawxh2zY9z7FkvWiN9Ljc3G
   iH4YIwnLTzP8UcvkLP/HmKiL9L/dIb85OuL/CXmZA4bHKCjLUBsJPdNIl
   CahbL7UTdChDhEDeu73CyQstiOHCpcT39ye41D0izCXny+QQsiRnWr6ae
   f2XGHmhdGlybyNg0020MyUCFMNPN3kEwkNbBJS9ooRULLHsZ64Q0RgCAo
   kdw2Zli8q6vIh75L1FPhMAAV/IGbGogkvrTqsKs8x8fkkYNz5MUtELqdt
   w==;
X-CSE-ConnectionGUID: I5FsXHWMSCKZiD4FLKO1kg==
X-CSE-MsgGUID: DQ9uI7A+S0+lUe6GFIL6oA==
X-IronPort-AV: E=McAfee;i="6800,10657,11933"; a="468515"
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="468515"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 21:14:44 -0700
X-CSE-ConnectionGUID: K31+J5WvRlen92nll1aIpw==
X-CSE-MsgGUID: s0kmRJl6QbmR73oeUQLlGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,155,1787036400"; 
   d="scan'208";a="1388990"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.102])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2026 21:14:43 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH v3 2/3] cxl/region: allow region granularity finer than the root
Date: Mon, 12 Oct 2026 21:14:34 -0700
Message-ID: <263b128ca78071b0484533813ed7d75b9b81c294.1791863817.git.alison.schofield@intel.com>
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

cxl_region_determine_granularity() rejects any user-supplied granularity
that does not exactly match the root decoder's granularity, making it
impossible to create a region with a granularity finer than the root from
userspace even when the kernel driver accepts it.

Relax the check to allow region_gran <= root_gran. This function only needs
to reject what it can determine on its own is always wrong - a region
granularity greater than the root decoder's. The kernel does the rest of
the validation.

Reject a granularity that is not a power of two, or is below 256, since the
previous exact-match test that screened those out implicitly is now gone.

Update the cxl-create-region man page to document the new behavior.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-create-region.txt | 21 ++++++++++++++++-----
 cxl/region.c                            | 25 +++++++++++++++++++------
 2 files changed, 35 insertions(+), 11 deletions(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index b244af60b8a6..131fb069fd53 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -93,11 +93,22 @@ include::bus-option.txt[]
 
 -g::
 --granularity=::
-	The interleave granularity for the new region. Must match the selected
-	root decoder's (if provided) granularity. If the root decoder is
-	interleaved across more than one host-bridge then this value must match
-	that granularity. Otherwise, for non-interleaved decode windows, any
-	granularity can be specified as long as all devices support that setting.
+	The interleave granularity for the new region. A granularity coarser
+	than the root decoder's is never legal. If the root decoder is
+	interleaved across more than one host bridge, then for a given number
+	of ways at most two granularities are legal:
+
+	  * "root_ways * root_granularity / ways", which creates a region
+	    finer than the root. The root interleaves at its own coarser
+	    granularity and the levels below it, host bridges and switches,
+	    refine monotonically toward the region granularity.
+	  * The root decoder granularity itself, which repeats the root
+	    interleave pattern across a wider region. This is available only
+	    when the root decoder ways are a power of two.
+
+	The two coincide when the region ways equal the root decoder ways. For
+	non-interleaved root decoders, any granularity can be specified as
+	long as all devices support that setting.
 
 -d::
 --decoder=::
diff --git a/cxl/region.c b/cxl/region.c
index 9d727216b9b8..69421771ad10 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -620,6 +620,18 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
 	if (!p->granularity)
 		return granularity;
 
+	/*
+	 * The CXL specification defines interleave granularities of 256 through
+	 * 16K in powers of two. Reject anything else here, rather than leave the
+	 * user with a bare EINVAL from the kernel.
+	 */
+	if (p->granularity < 256 || !is_power_of_2(p->granularity)) {
+		log_err(&rl,
+			"%s: granularity (%d) must be a power of 2, 256 or greater\n",
+			devname, p->granularity);
+		return -EINVAL;
+	}
+
 	ways = cxl_decoder_get_interleave_ways(p->root_decoder);
 	if (ways == 0 || ways == -1) {
 		log_err(&rl, "%s: unable to determine root decoder ways\n",
@@ -632,15 +644,16 @@ static int cxl_region_determine_granularity(struct cxl_region *region,
 		return p->granularity;
 
 	/*
-	 * For ways > 1, only allow the same granularity as the selected
-	 * root decoder
+	 * For ways > 1, allow any region granularity up to and including the
+	 * root decoder granularity. The kernel validates a finer region
+	 * granularity, and a coarser one is always invalid.
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
 
-- 
2.37.3

