Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC5D1F81A3
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:39:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831961; cv=none; b=CvvplP2Tn2TcZlTR/r8OcdMeMCiDYtUIPgHKFT5ewG6dZIpNki2ztyoT0vd65cW+uDCWjoCSFLZyKKznt8qQMbmgQqcXTEIsQYjIDqD83vuwqzke9h+DJ2J81NM/W31qRzBTEjKx+/L0FSCbSKpZ2DbxUP4rTbNA5cChJlrPrls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831961; c=relaxed/simple;
	bh=K+k0tXosQggrTMURAffVjBncyyVcL5TE5nyLNi6NZqU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sBIU5R098UO0OCJcntB+1JlaNONu1yAO4TK5H0Ya413PRr6rp0GvODltyV0MtBQlXpxdfRRKdt/8XQ+ThdokDRhkC+hXTaescPlsStQ7D+FX/3pm+YcGfUqkghD6c/cnKIxMdkeL0Mmp0YZbW3cw+geINTnWrGIMOc5ppq9JTjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZBCfhXu8; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZBCfhXu8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831960; x=1762367960;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=K+k0tXosQggrTMURAffVjBncyyVcL5TE5nyLNi6NZqU=;
  b=ZBCfhXu8HxcL9T/JkISgU7d+paZh+qsllh+fSLNAjHTsaFj/P6IPhv6y
   OsBVeKWuIXw7Rd6FLo29WV5J7+rJluX2GHK4vFnpLfyPHqJLiQTp88UB+
   aMB38OsPwPZ5QrfyAUkngFlZIVVkoSau/TEeK+5gYPFou4lPpCKDpeqhS
   IVtWXmbm+MbniKjTJzl1ZuByCERxDKOpYzRH+TxPiYPRu7RnyO6+WmeFS
   jwnzGZHkhIfdXgPQSnQSvN6ia6pgz8spl0mSTb3XoQNNjcHE/QUpPRFck
   TbiY0Rj8oWlRSC78/LxlHlU5Dk1WZOYXwTomTUOJ5uuK8/mrFXMFKtEGM
   w==;
X-CSE-ConnectionGUID: jGZH/HGlQQSAMgOvhPPrUA==
X-CSE-MsgGUID: K71t4LUJQGavxLKOzFZAOA==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30012756"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="30012756"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:19 -0800
X-CSE-ConnectionGUID: kktmTYJkQNS6pYmF17GmaA==
X-CSE-MsgGUID: Y/MjTlz6S1CnhSn7rWl1JA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="88624624"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:18 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:41 -0600
Subject: [PATCH v6 19/27] cxl/core: Return endpoint decoder information
 from region search
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-19-85c7fa2140fe@intel.com>
References: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
In-Reply-To: <20241105-dcd-type2-upstream-v6-0-85c7fa2140fe@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Navneet Singh <navneet.singh@intel.com>, Jonathan Corbet <corbet@lwn.net>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Li Ming <ming4.li@intel.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=4661;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=K+k0tXosQggrTMURAffVjBncyyVcL5TE5nyLNi6NZqU=;
 b=kVsf1gxRO9Demot7dEAc1EZqbaq1etK1G91tEGaydv8DJi9zwiK56eaWv/SCx61E42W0jXPHE
 Myl2AIHAaiGDwKEtYZwhjiREGL2nvPBNmMqACBenohels6jEOlHJwyO
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
The search involves finding the device endpoint decoder as well.

Dynamic capacity extent processing uses the endpoint decoder HPA
information to calculate the HPA offset.  In addition, well behaved
extents should be contained within an endpoint decoder.

Return the endpoint decoder found to be used in subsequent DCD code.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/core.h   | 6 ++++--
 drivers/cxl/core/mbox.c   | 2 +-
 drivers/cxl/core/memdev.c | 4 ++--
 drivers/cxl/core/region.c | 8 +++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 5d6fe7ab0a78cddb01c7e0d63ed55c36879c4cef..94ee06cfbdca07b50130299dfe0dd6546e7b9dac 100644
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
index a4b5cb61b4e6f9b17e3e3e0cce356b0ac9f960d0..a06137d95c6822192fb279068abf964f98f0a335 100644
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
index 857a9dd88b20291116d20b9c0bbe9e7961f4491f..f0e68264af7b4aa19e44c5a5e01c0a0614b0f27e 100644
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
index 34a6f447e75b18e6a1c8c27250a3e425bd0cc515..a0c181cc33e4988e5c841d5b009d3d4aed5606c1 100644
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
2.47.0

