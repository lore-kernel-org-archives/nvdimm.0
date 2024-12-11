Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5745C23EA70
	for <nvdimm@lists.linux.dev>; Wed, 11 Dec 2024 03:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733888566; cv=none; b=La+ZbmXQJF5uJU/+kJc/UVALQsA05GeP2bWasOXY9zQN8rM859nfy1HeAZ9G7si+Qea9r0NkU+2x7VYZeRgomD0ueWkylqxQrPAZcCI68gNbKswMhwxBLXEOsaaR8HR+CIj/ij/IHJ9QxeZaD9QIx5PKwt+aNMCpaqzHf0RTfm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733888566; c=relaxed/simple;
	bh=ddZkqpCh2syz4nwZfzVcqCI+/63UR8w/6p15BrOj3aU=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=QrbFz09MDJ/P9HSBWtxiHkd1La5J+SVRnTPxKa3lrhy9YdBxpY9cYK9prWsdKOf3+1IvsHp9G1PrcQA98U6l/cNlzfFSq0JaNnbjWJX/s+EqMl26AY0xVTQ1gZ3ewU8DLn7hwN2jCzPKs1kzFi3iN+sMKirBSB3HLRW2CmHVvAE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jx5wx8pg; arc=none smtp.client-ip=198.175.65.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jx5wx8pg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733888565; x=1765424565;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=ddZkqpCh2syz4nwZfzVcqCI+/63UR8w/6p15BrOj3aU=;
  b=jx5wx8pggSLcFQSkx9A55h/J64gGzBqR0RSQ6iaJi9x+svlhZlS+M49p
   z8ASf+JDD/J3ikQb+Qq+buqyxzS0Kl0JUFEPFTy61bZ8ywZRNLLClvvNQ
   S9I9YxFbiRLOsMUSpeJrN+2ohhGNkMhRxiqi7emz9zqzTYsG042bJqk4Z
   mx3XNpC19HjzMJx+lpD1UpOakmzHOaLa8KIdIXyy7ckKV/gqVjixk4P7n
   ztOb3hfM0mmlw7VE4WX86xK3A0eWJt+gtHtzjRO8HQYGBzlEKRfX0nX/4
   qy4OBpAx9gZgHDIAS3KGcIml6yy8K996A5HBgjOD/3n/HZjRNnrZ6OKHk
   A==;
X-CSE-ConnectionGUID: 9OZoS1IER/Cm5G0NWIKWlw==
X-CSE-MsgGUID: wQ7HgGKJT2GK+UB+xj+dSw==
X-IronPort-AV: E=McAfee;i="6700,10204,11282"; a="34395729"
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="34395729"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:45 -0800
X-CSE-ConnectionGUID: Fl+IRs35QDCHGO4Kv3OJfw==
X-CSE-MsgGUID: RYkuMFzpRDqYp9NN5as4qw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,224,1728975600"; 
   d="scan'208";a="95696871"
Received: from lstrano-mobl6.amr.corp.intel.com (HELO localhost) ([10.125.109.231])
  by orviesa006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Dec 2024 19:42:43 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 10 Dec 2024 21:42:25 -0600
Subject: [PATCH v8 10/21] cxl/events: Split event msgnum configuration from
 irq setup
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241210-dcd-type2-upstream-v8-10-812852504400@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1733888537; l=2687;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ddZkqpCh2syz4nwZfzVcqCI+/63UR8w/6p15BrOj3aU=;
 b=Dg+1ORntWKkEXskjARKEcNDeiUEHfO+ywrXMxq6MtI46hoOmxdrmK7S0gsA4gkViN7/o8V+/y
 kRdB/EzUQ80ANsjG1n+jk7RqcKhgcaEMUltEre6R1MYbcCAnCo4O7V9
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
Reviewed-by: Li Ming <ming.li@zohomail.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 5082625a7b3f51a84f894a3265e922e51b794b68..650724e6896eb4e39468cfded11e6909f8e207a6 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -715,35 +715,31 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
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
@@ -790,11 +786,15 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
2.47.1

