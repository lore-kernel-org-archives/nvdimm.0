Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09A522440A
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013152; cv=none; b=tPUBN0Z8b8ytegR3oIWXML/4KJltiGHzruGDzS1pd970ML2BlWIqZwsmRe3iQN+qez6oUH7SY68Tzc6RWg17yl9w5hp3WhvNg+436crHKwGn9zq9OlN4crQjyW4OZCnuD7UHjsjJZvkuw/OVTaFPweqrTU+QNQVD3TE6n4aKHg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013152; c=relaxed/simple;
	bh=uZmt4fu4lfzDks0d1cLXWcBK3mg+gUAha+y5C6U4TW0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=dlPQq+tHhV3ZzxiEjdkK82ZAqeYABGR8kKePe1Hiz1LeeKgUC0sW+MEKOvlCRH7YWl8sZIyYIp0vreMQiILyVOYg/vjUZhh3ouzybChaxVjOYWkADU9+oZb57HjikCffxp82Jr9y79/bURxbpbNbvnqGAGqkrdVWGxkg7U82erQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IhW2O5lr; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IhW2O5lr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013151; x=1762549151;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=uZmt4fu4lfzDks0d1cLXWcBK3mg+gUAha+y5C6U4TW0=;
  b=IhW2O5lrtcH/RKTkEiZ4knieaVsjjw1Jqrs7vczYbw94Qw5Gqve+4YP7
   pNyW8diyd9B3+c64RXXzFO4iB7McQmBjjvY24CGKGYDSpQ+k6yDzAeYwQ
   6NPdq7KmMrqjEKnlS5QUDusGIgWYjwPLtSkqV61kA3F83PhwyV5XXzclA
   8teYpCVO3gLbYAUOnpFU5NRPa16iTarylPZ2FBTghGETWyovegJWCMIH/
   20jYkfnh+oYW2wIl+QW4JtBwIwdV7wuwI9gDRGvjr9jFU4bb6JBVAPs0B
   Asg3E/8AGMZKdUVhjrwLb+65eToVehCpFTNEVMtNqAK1ipK+HGrwZUN75
   Q==;
X-CSE-ConnectionGUID: RJt6dsA6RSaM1oWvDibEnw==
X-CSE-MsgGUID: FKso0dhJTTu3USUytRQqDw==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41441065"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41441065"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:11 -0800
X-CSE-ConnectionGUID: ADnT5862RzCj+UlW8nVn1Q==
X-CSE-MsgGUID: vIzvQEjuS6WaxM1cEjAaLQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="122746038"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:10 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:36 -0600
Subject: [PATCH v7 18/27] cxl/mem: Configure dynamic capacity interrupts
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-18-56a84e66bc36@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=5723;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=ekPEkNyH6ChNNlyl/BpCbwpdWIPAnfjqx/gJRBCHRWQ=;
 b=1oJMPrk6u8Vo8axuHyzDlpG5/SnJSiOoHBUFQsFtbyI4n+b8DEDiMoQZS9yW9gxAw+lI6Xkcq
 Vd4B0lDIFSPDxwtpg6yRplazlKwe2qZIBg8bNnqKsFhSTrsFi6Z6oYD
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism.  The interrupt mailbox commands were
extended in CXL 3.1 to support these notifications.  Firmware can't
configure DCD events to be FW controlled but can retain control of
memory events.

Configure DCD event log interrupts on devices supporting dynamic
capacity.  Disable DCD if interrupts are not supported.

Care is taken to preserve the interrupt policy set by the FW if FW first
has been selected by the BIOS.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming4.li@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/cxlmem.h |  2 ++
 drivers/cxl/pci.c    | 73 ++++++++++++++++++++++++++++++++++++++++++----------
 2 files changed, 62 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index bbdf52ac1d5cb5df82812c13ff50ca7cacfd0db6..863899b295b719b57638ee060e494e5cf2d639fd 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -226,7 +226,9 @@ struct cxl_event_interrupt_policy {
 	u8 warn_settings;
 	u8 failure_settings;
 	u8 fatal_settings;
+	u8 dcd_settings;
 } __packed;
+#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
 
 /**
  * struct cxl_event_state - Event log driver state
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index ac085a0b4881fc4f074d23f3606f9a3b7e70d05f..13672b8cad5be4b5a955a91e9faaba0a0acd345a 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -672,23 +672,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
 }
 
 static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
-				    struct cxl_event_interrupt_policy *policy)
+				    struct cxl_event_interrupt_policy *policy,
+				    bool native_cxl)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
+	size_t size_in = CXL_EVENT_INT_POLICY_BASE_SIZE;
 	struct cxl_mbox_cmd mbox_cmd;
 	int rc;
 
-	*policy = (struct cxl_event_interrupt_policy) {
-		.info_settings = CXL_INT_MSI_MSIX,
-		.warn_settings = CXL_INT_MSI_MSIX,
-		.failure_settings = CXL_INT_MSI_MSIX,
-		.fatal_settings = CXL_INT_MSI_MSIX,
-	};
+	/* memory event policy is left if FW has control */
+	if (native_cxl) {
+		*policy = (struct cxl_event_interrupt_policy) {
+			.info_settings = CXL_INT_MSI_MSIX,
+			.warn_settings = CXL_INT_MSI_MSIX,
+			.failure_settings = CXL_INT_MSI_MSIX,
+			.fatal_settings = CXL_INT_MSI_MSIX,
+			.dcd_settings = 0,
+		};
+	}
+
+	if (cxl_dcd_supported(mds)) {
+		policy->dcd_settings = CXL_INT_MSI_MSIX;
+		size_in += sizeof(policy->dcd_settings);
+	}
 
 	mbox_cmd = (struct cxl_mbox_cmd) {
 		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
 		.payload_in = policy,
-		.size_in = sizeof(*policy),
+		.size_in = size_in,
 	};
 
 	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
@@ -735,6 +746,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
 	return 0;
 }
 
+static int cxl_irqsetup(struct cxl_memdev_state *mds,
+			struct cxl_event_interrupt_policy *policy,
+			bool native_cxl)
+{
+	struct cxl_dev_state *cxlds = &mds->cxlds;
+	int rc;
+
+	if (native_cxl) {
+		rc = cxl_event_irqsetup(mds, policy);
+		if (rc)
+			return rc;
+	}
+
+	if (cxl_dcd_supported(mds)) {
+		rc = cxl_event_req_irq(cxlds, policy->dcd_settings);
+		if (rc) {
+			dev_err(cxlds->dev, "Failed to get interrupt for DCD event log\n");
+			cxl_disable_dcd(mds);
+		}
+	}
+
+	return 0;
+}
+
 static bool cxl_event_int_is_fw(u8 setting)
 {
 	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
@@ -760,18 +795,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
-	struct cxl_event_interrupt_policy policy;
+	struct cxl_event_interrupt_policy policy = { 0 };
+	bool native_cxl = host_bridge->native_cxl_error;
 	int rc;
 
 	/*
 	 * When BIOS maintains CXL error reporting control, it will process
 	 * event records.  Only one agent can do so.
+	 *
+	 * If BIOS has control of events and DCD is not supported skip event
+	 * configuration.
 	 */
-	if (!host_bridge->native_cxl_error)
+	if (!native_cxl && !cxl_dcd_supported(mds))
 		return 0;
 
 	if (!irq_avail) {
 		dev_info(mds->cxlds.dev, "No interrupt support, disable event processing.\n");
+		if (cxl_dcd_supported(mds)) {
+			dev_info(mds->cxlds.dev, "DCD requires interrupts, disable DCD\n");
+			cxl_disable_dcd(mds);
+		}
 		return 0;
 	}
 
@@ -779,10 +822,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (!cxl_event_validate_mem_policy(mds, &policy))
+	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
+	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
@@ -790,12 +833,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds, &policy);
+	rc = cxl_irqsetup(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
 	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
 
+	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
+		native_cxl ? "OS" : "BIOS",
+		cxl_dcd_supported(mds) ? "supported" : "not supported");
+
 	return 0;
 }
 

-- 
2.47.0

