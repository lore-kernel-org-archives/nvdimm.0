Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8930F20C026
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:35:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234160; cv=none; b=dnWrUu1OYqA3aDEx+jwY6xKX/ac/53Kb9cHcoU4qFzV74mVDOUAc+2bfbwP9NHe+GA4iXXUMReM/ajMjN6rNSCtb5jWl5QRDyzbvnTdhGf7rAOrmRvUfa2l7naUcULy6FQt9yrTXtnh4isZ+P//rjjRVRM4K5ECp/2VeZsA8WoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234160; c=relaxed/simple;
	bh=chPzWO84oiXrtGP478ibb4m4Jb4ThjzT2O8SA2z3Gp0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=OxUXb7QghAAG1DlAVncV/cAy5PEXfzVVTwM5V6Vx1v67mpGLiDahfujs1KnCoYSQu2RrlOqrrB/TfdHHcOR5xk+oF/xvsIbxoH41Xb7ctD6MUeRwR80yjCNPzHG2EHOgmggjPJYT7gdv91l+Q1NZSvZCvV0Y8nt8hTlgpNCbJ10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=InHjB1Qj; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="InHjB1Qj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234158; x=1761770158;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=chPzWO84oiXrtGP478ibb4m4Jb4ThjzT2O8SA2z3Gp0=;
  b=InHjB1Qj/XmNxwPAXk4JzOqbE95eLzTSazYSIRObw+W439rCKR75mgt3
   l0MktfX+Diw0dnwXL7vy3dwuiEuGx2CarK1brmYjmclTbdKFQX6olT2g4
   GaI5dnroAPDHlI3AA847pKXs0djeJ+09MCMOvgCwnIX3MkoNt2KaXcJCf
   qsfSYZm1sWu1cxpr9O4I8kf5/fMYL9Cj70YzgKf5H6d8H02lBOE1UfLD8
   z47oEbajXXlgdLfX1/CJawJMpZWnxp5ZhQBOwiBFkN2ri+jEdFgwrGenV
   NWPr/ujv8qN7TOGWFOoTRQ57OIetgPvXIOJb1LwOJ+51gxM+D2RZNp5YB
   A==;
X-CSE-ConnectionGUID: N7vwasZVTLey7OpllPfcYw==
X-CSE-MsgGUID: O5GPXCjOTAeYRFpAMfP2rw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52457599"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52457599"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:58 -0700
X-CSE-ConnectionGUID: hUotyWZHSm6Ob7TG2K3Xqg==
X-CSE-MsgGUID: D4cQzzquRFWECzIdsWPMzQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="119561292"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:35:57 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 29 Oct 2024 15:34:52 -0500
Subject: [PATCH v5 17/27] cxl/pci: Factor out interrupt policy check
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-17-8739cb67c374@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=2234;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=chPzWO84oiXrtGP478ibb4m4Jb4ThjzT2O8SA2z3Gp0=;
 b=ngDp+Ofqhx+NYcM+bQlV5kz9VOaYlIuPY6e5JTDG7C/pjU9Y1EQhy04CaRRkqOS0lMS7EEJv9
 ZG9C2toi/InAhFwafH+GCJR+L954EJQ/yKLBnF0R9Ddo1SuvN9EiIlN
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
Changes:
[iweiny: reword commit message]
[iweiny: keep review tags on simple patch]
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

