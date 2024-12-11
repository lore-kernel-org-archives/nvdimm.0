Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C933E23EA8F
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888569; cv=none; b=sSdpfsJLGfpeWWHsG5tXsimnAQRzkatv5fG0FSgyJLVvkUseCdQkPfP9rEM+ePq/yvzMM2R+Xq3NhRs3TGrpROuIeLt1hXRNK4SeoZuh9jvK8RvYsRMMIKnn6qr0ua19lIC1zDiyE3O06fk6MnW7ZMLXLt56K2PV1i6Bb5LC7XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888569; c=relaxed/simple;
	bh=n392KBCDvIwoSF6+QWbw0icQR3UatBllAgEVz+103VE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=WaitodV0S4UL1y0WxWkDEUhyaJaGGvCBXt+LIFZdTq5BwFCYKeTUzU3Nze/u5kxQj0Ccw4UzsMxKmwgNg5jXKXw4YpVwDet3DmHId7yQiu0XB3fFsKiU+Sl9qrZuwJ7I19/gen47Xn25WMbVV3/zvhSAZYoEE+P7MILhLpt594U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=Q/19Hr2Q; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Q/19Hr2Q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888568; x=1765424568;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=n392KBCDvIwoSF6+QWbw0icQR3UatBllAgEVz+103VE=;
  b=Q/19Hr2QhdCH7nMsv441mSeo16Qgo687v3NlZQj+vjtLDr6QGKTvkn9J
   prXuc02jezeqWLKcQQyCit677D57Cu5oPc7YZFW1w6jISK3YNU5SHAnas
   FH2VMyhk8/6+NAHhrEBdie+bv9d+DT6il5ouIe9uIi7aIUXCqHjdSoXrn
   DvOkRaPuvPeyGdaSBWW+tWhcEvBXn3XxUXIXX02YP2bglbYaJFHZ5vC3q
   xl351IUEH/rB+l7LreLOwgAFw1n4169RQitih4XnIODHjBfORQXdxgiN8
   DNAyHC53R4UDK+5lPWRPMbIrcFHbJ0EsQ9s/aA7c7zckphXdlRhjuxrCa
   w==;
X-CSE-ConnectionGUID: qmq5DCFUQDq5D0llwr10nw==
X-CSE-MsgGUID: tH0IRYwSR5yJ4mThqJHDhw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34395741"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34395741"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:48 -0800
X-CSE-ConnectionGUID: RS3vqoEWRGWBgSktnNl+xA==
X-CSE-MsgGUID: FHZrRvJgSIeMj3AUcBPHrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95696879"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:46 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 10 Dec 2024 21:42:26 -0600
Subject: [PATCH v8 11/21] cxl/pci: Factor out interrupt policy check
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-dcd-type2-upstream-v8-11-812852504400@intel.com>
References: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
In-Reply-To: <20241210-dcd-type2-upstream-v8-0-812852504400@intel.com>
To: Dave Jiang <dave.jiang@intel.com>, Fan Ni <fan.ni@samsung.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
 Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, 
 Kees Cook <kees@kernel.org>, "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org, 
 linux-hardening@vger.kernel.org, Li Ming <ming.li@zohomail.com>
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=2298;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=n392KBCDvIwoSF6+QWbw0icQR3UatBllAgEVz+103VE=;
 b=q+a7CgZNZ4v/1fVsNG2Wttg8B+SoYVOrMCCTAVdoVDathDc8/hEZxaNkN6imEC4kPfM6Nmqo7
 WxbEdZkSIrzCNqbgRLELp5hyMOCnZdgxfS0yIeCfwGYFMWWz0GdNgmb
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Factor out event interrupt setting validation.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 650724e6896eb4e39468cfded11e6909f8e207a6..22e6047e3c3db7a16670b7a5aa4797ad20befb22 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -755,6 +755,21 @@ static bool cxl_event_int_is_fw(u8 setting)
 	return mode == CXL_INT_FW;
 }
 
+static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
+					  struct cxl_event_interrupt_policy *policy)
+{
+	if (cxl_event_int_is_fw(policy->info_settings) ||
+	    cxl_event_int_is_fw(policy->warn_settings) ||
+	    cxl_event_int_is_fw(policy->failure_settings) ||
+	    cxl_event_int_is_fw(policy->fatal_settings)) {
+		dev_err(mds->cxlds.dev,
+			"FW still in control of Event Logs despite _OSC settings\n");
+		return false;
+	}
+
+	return true;
+}
+
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
@@ -777,14 +792,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (cxl_event_int_is_fw(policy.info_settings) ||
-	    cxl_event_int_is_fw(policy.warn_settings) ||
-	    cxl_event_int_is_fw(policy.failure_settings) ||
-	    cxl_event_int_is_fw(policy.fatal_settings)) {
-		dev_err(mds->cxlds.dev,
-			"FW still in control of Event Logs despite _OSC settings\n");
+	if (!cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
-	}
 
 	rc = cxl_event_config_msgnums(mds, &policy);
 	if (rc)

-- 
2.47.1

