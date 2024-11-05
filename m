Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEF311F7540
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831952; cv=none; b=d9bEBb5/rUEMvSGv648JU+EvwA0hcXichUrXv4eqV6K429bE1MnaAQwhsmddexwArG/1CYoJWEbt6DB3XXLMeJxHcsw2tCyIQmng2d0z+/PeZXhF0cED7s4ALiOrsAdFoqm6FvF7yrNte/xj2N2uvZYkY9rm4vwvOPqTt9hUOo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831952; c=relaxed/simple;
	bh=SiMgcrGnVQyiKC7DqMtxFALjaH10RqY0abQa+E/1rcw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=eLp7faqeaniMEI18WqZVg1pwa6Nxeo6WRJ3FMzCNnVyNo4oPv2VQ1ESL5eX4rP4zhc42boa+oMA35FXPM3MKjddJtj56WW1/y+H49ChcwYBd4bOY+v8OwNLuUaQc+iSOS9wCOdP/1I9MvwubYqNIqfXoAsOZKNjHM4wtJYL8GgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EbgasbtE; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EbgasbtE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831951; x=1762367951;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=SiMgcrGnVQyiKC7DqMtxFALjaH10RqY0abQa+E/1rcw=;
  b=EbgasbtE7XGbPNHTHRam3biMwufcKlK2qffief+ZIBy20y/rb9mAPGuc
   F5+bZAhqGXDcxm7mW64hq4BvbXRJ+yaKg/KfPnYhHnqW3FQkJV8s+zEpb
   clZwH6yzy/WXESe3JqPXTfRk//vNHmm2haj8d8Z5F5rgyUOR6ogvWJ5eK
   7kFXku2OFVpN1mgGH4k55uAAkOzR71x3i73y+ZvEJUCZ67tgu2UT64ZS/
   J8WxKzz+rsTWr3P5OGC90Z9ETuuWeArO5syH7ZWWyVIRN7mHd/wDvXR26
   W5TOQ9UyxOzxxsya6PkdQSbG5TltcYfZwhn0lMISBSq94CKCugBu19O/e
   Q==;
X-CSE-ConnectionGUID: RpLvmEHTQx2yvo3OBzRy9A==
X-CSE-MsgGUID: obddwm/9Qay0W1qcg9sfug==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41153340"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41153340"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:11 -0800
X-CSE-ConnectionGUID: fzy6P2SzQdGWPVew3KPtxQ==
X-CSE-MsgGUID: cva6dS4ZSnm2723CDDrNlw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84235706"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:09 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:38 -0600
Subject: [PATCH v6 16/27] cxl/events: Split event msgnum configuration from
 irq setup
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-16-85c7fa2140fe@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=2685;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=SiMgcrGnVQyiKC7DqMtxFALjaH10RqY0abQa+E/1rcw=;
 b=RbIXs3jP6IJHmai1ZN4NK0LyAzClpDeUyeqW9hjHN+SxzAsH1KF9TPgclW/UXiLkvK2GmlXZ9
 qxjEKfu5q94CZJuOjFbknKhMLgJ6dtJ4d3aXnW85NJ0EZlmdZBh78J+
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

Dynamic Capacity Devices (DCD) require event interrupts to process
memory addition or removal.  BIOS may have control over non-DCD event
processing.  DCD interrupt configuration needs to be separate from
memory event interrupt configuration.

Split cxl_event_config_msgnums() from irq setup in preparation for
separate DCD interrupts configuration.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index c8454b3ecea5c053bf9723c275652398c0b2a195..8559b0eac011cadd49e67953b7560f49eedff94a 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -702,35 +702,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	return cxl_event_get_int_policy(mds, policy);
 }
 
-static int cxl_event_irqsetup(struct cxl_memdev_state *mds)
+static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
+			      struct cxl_event_interrupt_policy *policy)
 {
 	struct cxl_dev_state *cxlds = &mds->cxlds;
-	struct cxl_event_interrupt_policy policy;
 	int rc;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
-	if (rc)
-		return rc;
-
-	rc = cxl_event_req_irq(cxlds, policy.info_settings);
+	rc = cxl_event_req_irq(cxlds, policy->info_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Info log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.warn_settings);
+	rc = cxl_event_req_irq(cxlds, policy->warn_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Warn log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.failure_settings);
+	rc = cxl_event_req_irq(cxlds, policy->failure_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Failure log\n");
 		return rc;
 	}
 
-	rc = cxl_event_req_irq(cxlds, policy.fatal_settings);
+	rc = cxl_event_req_irq(cxlds, policy->fatal_settings);
 	if (rc) {
 		dev_err(cxlds->dev, "Failed to get interrupt for event Fatal log\n");
 		return rc;
@@ -777,11 +773,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_event_config_msgnums(mds, &policy);
+	if (rc)
+		return rc;
+
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds);
+	rc = cxl_event_irqsetup(mds, &policy);
 	if (rc)
 		return rc;
 

-- 
2.47.0

