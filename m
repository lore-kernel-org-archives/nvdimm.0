Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7B7219C9F
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013120; cv=none; b=HaT7lTR3wKoRjkPOKHd0vpmiDhXLjO371D0lblf4KDa2OTSCBNXGobhfaQstfY6gFIEGDYUuLseewmUBsfxIkbkcevDuPIcd53TF3/g+8dETipqcyzZmq75+rI/Ky12LoXzrRRu61neJLXTO5X2hCJ3qVsZxSenSpGXdfkieL7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013120; c=relaxed/simple;
	bh=zrkJPQVXZsx8rimt+5mECl38V/+5uCzh28VzTSmy1KA=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=GzyjZX8euHloz88vTE/o2/2B2JvPg7OaLjEt2xCxNHknfiwifKGfg4vnSeFGCWMTaB0KE/hKAlwI0FG0T78yNo7IPN5wlWfSrDaWz8siBdZFg0bh6jY6vyc+ESG2Sre4A1LM8QJujVFMiXHf9lpJzlIJzZ/mPa9pppm9X0OgTs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=ZErF1+CS; arc=none smtp.client-ip=192.198.163.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="ZErF1+CS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013119; x=1762549119;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=zrkJPQVXZsx8rimt+5mECl38V/+5uCzh28VzTSmy1KA=;
  b=ZErF1+CSoHMPpCeN9DRChbaPK2RXddeF3ADCPuKmMvDwXrGr2uA26o+M
   IToH5xGc4cAqlKQlIWzgFos+rXUSS00qU6tgwHjagcklxu7w8XuH4boMM
   6IDm5TFVeup+rVZqxM+7DZCUt9ixwRe0OU1KodvNaw5gZGPKSduoWBidU
   /IcqPwVa8O7k39VwDSnSlb46iIQUI9SbjAmk1GfV+nxgHOQybf5BwF+Tv
   wJagxpDkWob4A5k5b9Sl0yybodlE9nYmNS//zY3B9vWsszd6muNzW+CYO
   CTCm/sUCXT/1Gw5Ea5eXP4/i7TidRz+imfFJgrMkbnAp+w3saOh9JzSm2
   A==;
X-CSE-ConnectionGUID: iLO2hEPmQ5+EH0pD+NhUAQ==
X-CSE-MsgGUID: +hke4BtIQTe0J1cLlbHVBQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="30300336"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="30300336"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by fmvoesa112.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:38 -0800
X-CSE-ConnectionGUID: ooMkMyDHQIGZpA3pHm+lTw==
X-CSE-MsgGUID: CFx1p6rRQ/m1T//7Yz+F/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="90093602"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:58:37 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Thu, 07 Nov 2024 14:58:22 -0600
Subject: [PATCH v7 04/27] cxl/pci: Delay event buffer allocation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-4-56a84e66bc36@intel.com>
References: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
In-Reply-To: <20241107-dcd-type2-upstream-v7-0-56a84e66bc36@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=1469;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=zrkJPQVXZsx8rimt+5mECl38V/+5uCzh28VzTSmy1KA=;
 b=gnuvNin8o92+zuWymm375kanSqfq7hQ4bjMtJFrImeR2pRa47mHQ5N92Ojo7Unwz1VAOuVhRP
 kNCsGMnLFYhBaE8VmgskGIR93Nueu4uhlcUntPicw+++1Ff8quthO2S
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
Link: https://lore.kernel.org/all/663922b475e50_d54d72945b@dwillia2-xfh.jf.intel.com.notmuch/ [1]
Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
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

