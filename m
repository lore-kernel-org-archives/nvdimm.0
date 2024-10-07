Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA3B51DE8B1
	for <nvdimm@lists.linux.dev>; Mon,  7 Oct 2024 23:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728343035; cv=none; b=JplPN0sokR2khQuM/CPauCMOG58RwFzUy9h80FdjhqCNYXXaQHwbXrudjXOSe1H8efE/eTwmtuYytqYQC/wTa7sBziFl2yI4D+bBE+VO6onY1HrdsojDNl08OSLiMx2KJNIhZvzWa2WDIy01ffS8WoUxgyiwdzrE8Hno5XcNads=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728343035; c=relaxed/simple;
	bh=7Aziv7pKJRTmg8ztGr51uqBKOZLkS3Ovx05kHI1NfI8=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=VWbStPoVnCZJ4ZIPwZmpbXV7d4NHPACrLvdfynRHGNeEBInWktA3qJi5vO7H0gOInlkDh/oZ04jpD16sXlk0hlvKalmZZyhJVAueJWxjEZsp9w9/fVyD7+7IHl9HkUEKAfrFCCkHbUoGObh1d23XQCui3YGbg4XLjymdstwSsRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=czjCQj1G; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="czjCQj1G"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728343034; x=1759879034;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=7Aziv7pKJRTmg8ztGr51uqBKOZLkS3Ovx05kHI1NfI8=;
  b=czjCQj1GOJbmfr0RMhg6yDVezvZbuHNngxSoC4uMFOtxKJtjpnEMZxQz
   Pmd+tEdjXNK4kooOxREUSBnJekXOR302esA7FKzwCSQmxrOn7ethWLuqZ
   xJ/z/dIScF7XwRNAcC+m1QKdjPS4G7TFkC2zDuyboJIk44fhy8kPPibCe
   MmZybkQUaPvwtcdE5B2WpV4uf5JbA9SCTlal7eMo8i4YjP5SXDw7/sqBq
   u02MJ165PgFNICd2FCgQLl8M6CsB15npHV666xBbY/fMzAjzgPaVt5uNB
   R2JKXgpavARpH4+KV7Lxrzj3ZWPieC51qNU8lTFOGdyzke2cW7QB1J4QF
   g==;
X-CSE-ConnectionGUID: MWn96dl/Ro+Ti77v0I1+QQ==
X-CSE-MsgGUID: 41cBsLX0TZaCWab1cMmFtg==
X-IronPort-AV: E=McAfee;i="6700,10204,11218"; a="26972655"
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="26972655"
Received: from fmviesa010.fm.intel.com ([10.60.135.150])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:13 -0700
X-CSE-ConnectionGUID: gFddk6zdTf6EusCUOxhxzg==
X-CSE-MsgGUID: mH1R8XMDRxSCUiUSk9ogqA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,185,1725346800"; 
   d="scan'208";a="76001797"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.110.112])
  by fmviesa010-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Oct 2024 16:17:11 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 07 Oct 2024 18:16:26 -0500
Subject: [PATCH v4 20/28] cxl/core: Return endpoint decoder information
 from region search
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241007-dcd-type2-upstream-v4-20-c261ee6eeded@intel.com>
References: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
In-Reply-To: <20241007-dcd-type2-upstream-v4-0-c261ee6eeded@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-btrfs@vger.kernel.org, linux-cxl@vger.kernel.org, 
 linux-doc@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-37811
X-Developer-Signature: v=1; a=ed25519-sha256; t=1728342968; l=4183;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=7Aziv7pKJRTmg8ztGr51uqBKOZLkS3Ovx05kHI1NfI8=;
 b=SYNH12WQME42J8YnWeQicXrhArlCiFX55UMTAAJi173NdrqSnWdS/6CTkv14avXanX0Md/Ocu
 Fh94O08hItGDKpHTuRoP0lGQlxnvKwAaFR8JXlJsj+/R1XtrsFvlB+N
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
The search involves finding the device endpoint decoder as well.

Dynamic capacity extent processing uses the endpoint decoder HPA
information to calculate the HPA offset.  In addition, well behaved
extents should be contained within an endpoint decoder.

Return the endpoint decoder found to be used in subsequent DCD code.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/core.h   | 6 ++++--
 drivers/cxl/core/mbox.c   | 2 +-
 drivers/cxl/core/memdev.c | 4 ++--
 drivers/cxl/core/region.c | 8 +++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 5d6fe7ab0a78..94ee06cfbdca 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -39,7 +39,8 @@ void cxl_decoder_kill_region(struct cxl_endpoint_decoder *cxled);
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 
@@ -50,7 +51,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 	return ULLONG_MAX;
 }
 static inline
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	return NULL;
 }
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 3ba465823564..584d7d282a97 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -916,7 +916,7 @@ void cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 		guard(rwsem_read)(&cxl_dpa_rwsem);
 
 		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
-		cxlr = cxl_dpa_to_region(cxlmd, dpa);
+		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 		if (cxlr)
 			hpa = cxl_dpa_to_hpa(cxlr, cxlmd, dpa);
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 2565b10a769c..31872c03006b 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -313,7 +313,7 @@ int cxl_inject_poison(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		goto out;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison inject dpa:%#llx region: %s\n", dpa,
@@ -377,7 +377,7 @@ int cxl_clear_poison(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		goto out;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison clear dpa:%#llx region: %s\n", dpa,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 34a6f447e75b..a0c181cc33e4 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2827,6 +2827,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
+	struct cxl_endpoint_decoder *cxled;
 };
 
 static int __cxl_dpa_to_region(struct device *dev, void *arg)
@@ -2860,11 +2861,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
 			dev_name(dev));
 
 	ctx->cxlr = cxlr;
+	ctx->cxled = cxled;
 
 	return 1;
 }
 
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	struct cxl_dpa_to_region_context ctx;
 	struct cxl_port *port;
@@ -2876,6 +2879,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 	if (port && is_cxl_endpoint(port) && cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
+	if (cxled)
+		*cxled = ctx.cxled;
+
 	return ctx.cxlr;
 }
 

-- 
2.46.0

