Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6351820899B
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234122; cv=none; b=ASe0wLsVPsuZhtigw29VwgrWE722iZiEZ+0Fqgg7DHGJDk7Lq8/fDql1FzBC8DocF8BlRlIum9zcyXltYEynxeZW8yIriQGF/++sRW7Ixp7/ObmIWdjKXFINbdoQARX4tnlgiWsMbp9Smzp/vp87UrvHGu6Xvqw9dgiXmWpNfDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234122; c=relaxed/simple;
	bh=yaZyopWtPUuaRe9FVFZEkwznEj/+EDfTkZP0uEn0RuE=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=h1DyJ+CsZ0ri1x9AYL5ecrFsLGEC836NvG1dUIbxbPvPlPVEdj7UNpvD31qGAU2H97i5LgYFgTonLGx6d+J+uILnN4wltODa8WaeiMQxlSl/NVUv8kJUibk8cXnzMOuNxm762kjitlo42xrjCkX6bu2Vq6ULSOhsXAcmJyliOeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lymZp8Uw; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lymZp8Uw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234120; x=1761770120;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=yaZyopWtPUuaRe9FVFZEkwznEj/+EDfTkZP0uEn0RuE=;
  b=lymZp8UwUdXwKdBjCMHzsxHWMTfh7Y0Dbpa5VviQ03M2M7fnngYJlQy+
   6ij22q0i5g8ertLFaT+lwJcgQFR+8t2MxkmieTxSOwjS7QEZuiaw66Jyb
   yKP0701zW+HCtc3i7vfzY7dILQRr2+254Dql01R4rem7a7VdAdWO95jU4
   6RUS36IHvcmavRzqKWCbzPqJUuw98mUOHZRsvLaVS8jhSRqbkuo+yBGcr
   YqcltTHGQmRT2ojMCPxDOeo6FfHvelai4uLZiQqETyNznvB6tGH8MpdvE
   UXsuftLIQqWcx2VHearm4Ysi729NDCVSUF7+s7VqicSYE6wgMyLL57SOU
   w==;
X-CSE-ConnectionGUID: KfgPJUMpSXSTHM/iNaWKEQ==
X-CSE-MsgGUID: o4ID0469TsGgt54Dx08Iww==
X-IronPort-AV: E=McAfee;i="6700,10204,11240"; a="40485346"
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="40485346"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:20 -0700
X-CSE-ConnectionGUID: 7gf1irCCR7auevX7X95eYA==
X-CSE-MsgGUID: bwGhjWs1TYWInWBrL7plIw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="82185194"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:18 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 29 Oct 2024 15:34:39 -0500
Subject: [PATCH v5 04/27] cxl/pci: Delay event buffer allocation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-4-8739cb67c374@intel.com>
References: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
In-Reply-To: <20241029-dcd-type2-upstream-v5-0-8739cb67c374@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=1481;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=yaZyopWtPUuaRe9FVFZEkwznEj/+EDfTkZP0uEn0RuE=;
 b=TYUOn+JFYR1KB0eaeCBP3T68FPokqboL6hbpKFYqCES/egSn89YRb4s28Pu7qGVGjf9zdMzb7
 iV1umvkJw2ZBxTb5x8m6wet2nfNpA8dh4LeQZ42DXmJBNdd1ZkV/YWM
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

The event buffer does not need to be allocated if something has failed in
setting up event irq's.

In prep for adjusting event configuration for DCD events move the buffer
allocation to the end of the event configuration.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes:
[iweiny: keep tags for early simple patch]
[Davidlohr, Jonathan, djiang: move to beginning of series]
	[Dave feel free to pick this up if you like]
---
 drivers/cxl/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 188412d45e0d266b19f7401a1cdc51ed6fb0ea0a..295779c433b2a2e377995b53a70ff2a3158b0a8e 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -764,10 +764,6 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return 0;
 	}
 
-	rc = cxl_mem_alloc_event_buf(mds);
-	if (rc)
-		return rc;
-
 	rc = cxl_event_get_int_policy(mds, &policy);
 	if (rc)
 		return rc;
@@ -781,6 +777,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 		return -EBUSY;
 	}
 
+	rc = cxl_mem_alloc_event_buf(mds);
+	if (rc)
+		return rc;
+
 	rc = cxl_event_irqsetup(mds);
 	if (rc)
 		return rc;

-- 
2.47.0

