Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C0671F80C3
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831957; cv=none; b=SMQ0rjwQjIOM9VAm+euQlV96Go3SulKuL+ZGbzHeGRKAXbUZOo9Kfp9MrXQac0jfyPtbRXq0aH2/vf/Rzw/I/mh2qCgo7/X16D84SfZm5mhXKWtgv4Vv/RXjUU47JiUBzOUmKdrz13q+OjHDoGmdQ/3DBj7K3jP8c50UxcQ3lPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831957; c=relaxed/simple;
	bh=pS9Qof+pyeDGeHwjHKLkYWCZilYylGln+u/5SoCi5VM=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=TiPzfMyDd3S2boNswa5pHALz0xEuaGmmtr577atMqC5e3t5ZCIFzknVONkpFk4MYcOH9osk46grMPz02znuMRHAcZi9pqBtwwuY4UK3y1Xhe5q9kwaLcN/3ECSZmHBNRHVwgB1lJP1bRm7A6/6WQJD9dj7mrf4Dg9A/O8qn8BOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=goGXx7GA; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="goGXx7GA"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831955; x=1762367955;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=pS9Qof+pyeDGeHwjHKLkYWCZilYylGln+u/5SoCi5VM=;
  b=goGXx7GAqYrEyOTo2KPI6Ks1QdoM3lVOT2STE9d4B62iWmzegIS1BohF
   5tKntlJoJ36F1/LwNxKnxNQ6zy/G+1iPWX6a2vVfZQhLO6LYjR+6U0Z3W
   fw48xVyR8FA/HfSPN0rr8ofiuLxryRroyEiDXw+RNt7HN6vFFUNqf6Vpg
   5SrII26+GhLsM9fw+4kv5kNJAINibTDztnYNAiVN860TnQctoONkWYPnq
   83OOxw0HHuIue5/+GwokhFD7gWyptuCeN34imVCcimgJsoB8L/+RGJrKc
   RAsjz0lPKOnqW/9oeIdSCbeEalvrfe/DZPYGGawBke5IFhTBEs2A6Z6+A
   g==;
X-CSE-ConnectionGUID: NC9uX3woROWHIGSNdL0vDg==
X-CSE-MsgGUID: TVIEmnYFSWC8hw9KBMBDVw==
X-IronPort-AV: E=McAfee;i="6700,10204,11247"; a="30012720"
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="30012720"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:13 -0800
X-CSE-ConnectionGUID: qLOpTEbUQoW6wl+UzbIj+Q==
X-CSE-MsgGUID: ilESrLmLRQarZV4s1kmIfg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="88624538"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:39:11 -0800
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 05 Nov 2024 12:38:39 -0600
Subject: [PATCH v6 17/27] cxl/pci: Factor out interrupt policy check
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-17-85c7fa2140fe@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=2142;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=pS9Qof+pyeDGeHwjHKLkYWCZilYylGln+u/5SoCi5VM=;
 b=ePwyvzAMiTHtKL4ON8tRaRIaANKOXCa6/Ac0sV4ki4uDeZYPEslpHbh0ffaOJ2floITHn3hi3
 7zHGjVh1iynACfKPf69+f1gOv2Rp4Ll2M8eIWWtVBtgbT0vpE25yCuq
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
Reviewed-by: Li Ming <ming4.li@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/pci.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 8559b0eac011cadd49e67953b7560f49eedff94a..ac085a0b4881fc4f074d23f3606f9a3b7e70d05f 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -742,6 +742,21 @@ static bool cxl_event_int_is_fw(u8 setting)
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
@@ -764,14 +779,8 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
2.47.0

