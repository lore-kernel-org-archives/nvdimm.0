Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C5273A6B71
	for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 22:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791673059; cv=none; b=D0zxcur5hTmGIgMIBA1LemLMKAZ7t4X0bzzm1/VzPRMD/HnCI50QDipwzZpQyLCCxjPxMtyJj2nPhYW6nTZtJxybycrncSdK21Uox8Y4jG3FDMBaWi3pDRJ97X2ayjOG3Qrt731dItHTtCqGTStmj1HZoCLTQxEQwL8Jro1cAAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791673059; c=relaxed/simple;
	bh=44qC5nP8900s19Eb1as3683DClkw8tBs8Pufs8xoVHo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cJpjqXDNmh0MXRl7EWrE/NvRL4kS3WC792hoDTmSnIvcuxxeHJ5vU1ezfBU854uWGXYPJqYxWHDmNJQL9GfDsiHBBqGBdKhRGmSFnUl7v/fvh4qPbZlDBJdiJDvVPVgeqXr/8MFLMV4k2Eba4ERZK4Q8OiXp7T+mjIq8kpTERb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=egsXskOn; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="egsXskOn"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-cc4c7fab7b6so458121a12.0
        for <nvdimm@lists.linux.dev>; Sat, 10 Oct 2026 15:57:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791673053; x=1792277853; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Bq0/3a7x3RT2jO913JFjenLkXdb6Sm/BzH7r7LLhwn4=;
        b=egsXskOncIfac7t2PfUnZepK8qzbm4EUYzHkuxVbWZGJVZRaht48mjcCOHrqto0HZx
         DFjbCpTkAeGfrSqAfuaxOMZhvR8JIvQ4tbxztgE9hpwS+Eo8cgcurl2fAU2ZUUgakmLS
         Arp2CWll5+huW0N/Bf/ZDUYjP2bY/TK2ij4Xxzx0AP4gWGnXUZRKFQ2HSdKP64azInJg
         +tzn8P2wyIKTuLGJogHIinwofZcQg3e8tmxl47x8jO0CsnI9T4hcWKe37GrCYxt6N5Al
         AKHBmYQgOTmUPv2Uk/kweXvMzRdPUFsSxkzSq7J7pkqaOhPe1NDuc4iOsE32muQsrspe
         FE6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791673053; x=1792277853;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Bq0/3a7x3RT2jO913JFjenLkXdb6Sm/BzH7r7LLhwn4=;
        b=U6yohr1sS5HpMcwmwi06dpsVzI7L+/UScMojBaf5+7+HVTmtx3SbIPK2bEtS+pJVM7
         00iTRQD3sl6YB0xTMNHdDQ1sJLPyU2eBHq/oY0jfuzbOYV9s9vPWPiyRkKrZqsV7SVbX
         7ktv+1nR+zFKXUHqFe4LHgl0zG8Y51Sp4AHekjTHIUplOks0c7eUW/Jz3AyOwpeywnOx
         DtXx8CZznCgDOgmrJjaVLY3Jaubmr8d5SFBlbD3J11+kGyveyZPmnA+voyxOg+Y90+w4
         wlT/OY4pLdnoVRNcrfVyxOhKOsHSkkmjZBMGG84HeFQNhqtznsoohJeza8jE/nQ5lZ2t
         +IDA==
X-Gm-Message-State: AFq9FYLis77oG3SBbBRxkDww8s1SjHtoRwIUJXKMhS4CP+JAp0ZkJLQ6
	79TpgQDmhfIgmMbamqMsFyGWLoH//7wgVutSvv+OCet/RT30g99vNHiD
X-Gm-Gg: AYBFou35PhmNGrim9dPXQkJN2QYwD1PJcvmjWQzQYIfEJEJkG5FGYXXQb9yDFIQmcgV
	Be+XYDKeK+ReeFEgWLrBlyUUTaQprkJcrlV0wZMAwK/iYjMa9hI6YjbK8yF4C7NhDvJOZcEFsnY
	Ozx/sPjBsBjS4Bu7bPB3XH5MVIK7hqEB1HJlge+rN1eA4wyQIcf6ZSm+PQjcg59JPu/cXZPtfYk
	6sqyUKnS+qKVEOUEPvxWWJ0YLTGMkcw7lReXP8qn6JvVTpe/sHXfDqLP36OI09CUo8WtScOWB9F
	vYgflw3YxvzbhsXF19MyDqP0Ku4VEuEXzxciLVJAsVkoQ266NnhZ86A8mzkjZ0gizGrFE847kzJ
	0qu5RY4+ARaKB7iSl4ASMd0V039bUv6skPMAj7tTmvFv6KDZKyxftv0llUVW5Kypr8CyVWDANup
	KwcOeg/K8Ex7RI10fvtrg8qcF8VY27p0LXjbUNNZIugPGvpYB0F2lWaziMdDcA4+vYj0tlR181U
	xM06IWZoTkkEcI5AspjQmlVOlNp
X-Received: by 2002:a05:6a20:b40a:b0:3e0:c334:52a0 with SMTP id adf61e73a8af0-3e16bed478emr4638208637.49.1791673052890;
        Sat, 10 Oct 2026 15:57:32 -0700 (PDT)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cd3d9e07329sm2603662a12.5.2026.10.10.15.57.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Oct 2026 15:57:32 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v16 6/8] cxl/mem: Configure dynamic capacity interrupts
Date: Sun, 11 Oct 2026 07:54:57 +0900
Message-ID: <20261010225852.10727-7-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261010225852.10727-1-anisa.su@samsung.com>
References: <20261010225852.10727-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism. The interrupt mailbox commands were
extended in CXL 3.1 to support these notifications. Firmware can't
configure DCD events to be FW controlled but can retain control of
memory events.

Configure DCD event log interrupts on devices supporting dynamic
capacity. Disable DCD if interrupts are not supported.

The DCD event log is not drained here. cxl_event_drain_mask() reports
only the logs the driver can service, and the DCD bit is added by
the patch introducing DCD event handling. Until then a DCD interrupt
wakes the event thread, which finds no log it owns and returns.

Care is taken to preserve the interrupt policy set by the FW if FW first
has been selected by the BIOS.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>

---
Changes:
1. When the DCD vector cannot be requested, clear dcd_settings on the
   device with Set Event Interrupt Policy as well as disabling DCD on
   the host, so the device does not keep signalling a vector with no
   handler.  The Set Event Interrupt Policy command moves out of
   cxl_event_config_msgnums() into a new helper,
   cxl_event_set_int_policy(), so cxl_irqsetup() can issue it too.
   [Richard]
---
 drivers/cxl/cxl.h            |  14 ++-
 drivers/cxl/cxlmem.h         |   2 +
 drivers/cxl/pci.c            | 174 +++++++++++++++++++++++++++++------
 tools/testing/cxl/test/mem.c |   2 +-
 4 files changed, 156 insertions(+), 36 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index cab8ce39f465..15356d25369d 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -192,11 +192,15 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
 #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
 #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
 #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
-
-#define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
-				 CXLDEV_EVENT_STATUS_WARN |	\
-				 CXLDEV_EVENT_STATUS_FAIL |	\
-				 CXLDEV_EVENT_STATUS_FATAL)
+#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
+/*
+ * Logs whose ownership follows native_cxl_error; the DCD log is always
+ * OS owned.
+ */
+#define CXLDEV_EVENT_STATUS_STANDARD_LOGS	(CXLDEV_EVENT_STATUS_INFO | \
+						 CXLDEV_EVENT_STATUS_WARN | \
+						 CXLDEV_EVENT_STATUS_FAIL | \
+						 CXLDEV_EVENT_STATUS_FATAL)
 
 /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
 #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index b539b5a5c829..bac7e1ac715f 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -240,7 +240,9 @@ struct cxl_event_interrupt_policy {
 	u8 warn_settings;
 	u8 failure_settings;
 	u8 fatal_settings;
+	u8 dcd_settings;
 } __packed;
+#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
 
 /**
  * struct cxl_event_state - Event log driver state
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 7b754af2168d..1d94e9ebb1a2 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -510,11 +510,22 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *pdev)
 	return true;
 }
 
+/* Event logs the driver drains: standard logs when native_cxl */
+static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge)
+{
+	if (host_bridge->native_cxl_error)
+		return CXLDEV_EVENT_STATUS_STANDARD_LOGS;
+	return 0;
+}
+
 static irqreturn_t cxl_event_thread(int irq, void *id)
 {
 	struct cxl_dev_id *dev_id = id;
 	struct cxl_dev_state *cxlds = dev_id->cxlds;
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct pci_host_bridge *host_bridge =
+		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
+	u32 mask = cxl_event_drain_mask(host_bridge);
 	u32 status;
 
 	do {
@@ -523,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
 		 * ignore the reserved upper 32 bits
 		 */
 		status = readl(cxlds->regs.status + CXLDEV_DEV_EVENT_STATUS_OFFSET);
-		/* Ignore logs unknown to the driver */
-		status &= CXLDEV_EVENT_STATUS_ALL;
+		/* Ignore logs unknown to the driver or owned by BIOS */
+		status &= mask;
 		if (!status)
 			break;
 		cxl_mem_get_event_records(mds, status);
@@ -551,53 +562,81 @@ static int cxl_event_req_irq(struct cxl_dev_state *cxlds, u8 setting)
 }
 
 static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
-				    struct cxl_event_interrupt_policy *policy)
+				    struct cxl_event_interrupt_policy *policy,
+				    size_t *policy_size)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
 	struct cxl_mbox_cmd mbox_cmd = {
 		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
 		.payload_out = policy,
 		.size_out = sizeof(*policy),
+		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
+		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
 	};
 	int rc;
 
 	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
-	if (rc < 0)
+	if (rc < 0) {
 		dev_err(mds->cxlds.dev,
 			"Failed to get event interrupt policy : %d", rc);
+		return rc;
+	}
 
+	if (policy_size)
+		*policy_size = mbox_cmd.size_out;
 	return rc;
 }
 
-static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
-				    struct cxl_event_interrupt_policy *policy)
+static int cxl_event_set_int_policy(struct cxl_memdev_state *mds,
+				    struct cxl_event_interrupt_policy *policy,
+				    size_t policy_size)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
-	struct cxl_mbox_cmd mbox_cmd;
-	int rc;
-
-	*policy = (struct cxl_event_interrupt_policy) {
-		.info_settings = CXL_INT_MSI_MSIX,
-		.warn_settings = CXL_INT_MSI_MSIX,
-		.failure_settings = CXL_INT_MSI_MSIX,
-		.fatal_settings = CXL_INT_MSI_MSIX,
-	};
-
-	mbox_cmd = (struct cxl_mbox_cmd) {
+	struct cxl_mbox_cmd mbox_cmd = {
 		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
 		.payload_in = policy,
-		.size_in = sizeof(*policy),
+		.size_in = policy_size,
 	};
+	int rc;
 
 	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
-	if (rc < 0) {
+	if (rc < 0)
 		dev_err(mds->cxlds.dev, "Failed to set event interrupt policy : %d",
 			rc);
-		return rc;
+	return rc;
+}
+
+static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
+				    struct cxl_event_interrupt_policy *policy,
+				    bool native_cxl, size_t policy_size)
+{
+	int rc;
+
+	/* memory event policy is left if FW has control */
+	if (native_cxl) {
+		*policy = (struct cxl_event_interrupt_policy) {
+			.info_settings = CXL_INT_MSI_MSIX,
+			.warn_settings = CXL_INT_MSI_MSIX,
+			.failure_settings = CXL_INT_MSI_MSIX,
+			.fatal_settings = CXL_INT_MSI_MSIX,
+			.dcd_settings = 0,
+		};
 	}
 
+	/*
+	 * A CXL 3.0+ device can carry dcd_settings field without DCD command
+	 * support, so size the request by the device's policy_size and only
+	 * enable the DCD interrupt when DCD commands are supported.
+	 */
+	if (cxl_dcd_supported(mds))
+		policy->dcd_settings = CXL_INT_MSI_MSIX;
+
+	rc = cxl_event_set_int_policy(mds, policy, policy_size);
+	if (rc)
+		return rc;
+
 	/* Retrieve final interrupt settings */
-	return cxl_event_get_int_policy(mds, policy);
+	return cxl_event_get_int_policy(mds, policy, NULL);
 }
 
 static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
@@ -633,6 +672,37 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
 	return 0;
 }
 
+static int cxl_irqsetup(struct cxl_memdev_state *mds,
+			struct cxl_event_interrupt_policy *policy,
+			bool native_cxl, size_t policy_size)
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
+			/* No handler will service the DCD vector; tell the device */
+			policy->dcd_settings = CXL_INT_NONE;
+			rc = cxl_event_set_int_policy(mds, policy, policy_size);
+			if (rc)
+				dev_warn(cxlds->dev,
+					 "DCD disabled but its interrupt policy could not be cleared: %d\n",
+					 rc);
+		}
+	}
+
+	return 0;
+}
+
 static bool cxl_event_int_is_fw(u8 setting)
 {
 	u8 mode = FIELD_GET(CXLDEV_EVENT_INT_MODE_MASK, setting);
@@ -651,46 +721,90 @@ static bool cxl_event_fw_owns_mem_logs(struct cxl_event_interrupt_policy *policy
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
-	struct cxl_event_interrupt_policy policy;
+	struct cxl_event_interrupt_policy policy = { 0 };
+	bool native_cxl = host_bridge->native_cxl_error;
+	size_t policy_size;
+	u32 mask;
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
 
-	rc = cxl_event_get_int_policy(mds, &policy);
+	rc = cxl_event_get_int_policy(mds, &policy, &policy_size);
 	if (rc)
-		return rc;
+		goto err;
+
+	/*
+	 * dcd_settings cannot be sent to a device whose policy is too short
+	 * to hold it, so the device would never accept the setting
+	 * cxl_irqsetup() arms the DCD interrupt with.
+	 */
+	if (cxl_dcd_supported(mds) && policy_size < sizeof(policy)) {
+		dev_warn(mds->cxlds.dev,
+			 "DCD supported but interrupt policy is only %zu bytes\n",
+			 policy_size);
+		cxl_disable_dcd(mds);
+		/* DCD was the only reason to be here */
+		if (!native_cxl)
+			return 0;
+	}
 
-	if (cxl_event_fw_owns_mem_logs(&policy)) {
+	if (native_cxl && cxl_event_fw_owns_mem_logs(&policy)) {
 		dev_err(mds->cxlds.dev,
 			"FW still in control of Event Logs despite _OSC settings\n");
 		return -EBUSY;
 	}
 
-	rc = cxl_event_config_msgnums(mds, &policy);
+	rc = cxl_event_config_msgnums(mds, &policy, native_cxl, policy_size);
 	if (rc)
-		return rc;
+		goto err;
 
 	rc = cxl_mem_alloc_event_buf(mds);
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds, &policy);
+	rc = cxl_irqsetup(mds, &policy, native_cxl, policy_size);
 	if (rc)
 		return rc;
 
-	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
+	mask = cxl_event_drain_mask(host_bridge);
+	if (mask)
+		cxl_mem_get_event_records(mds, mask);
+
+	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
+		native_cxl ? "OS" : "BIOS",
+		cxl_dcd_supported(mds) ? "supported" : "not supported");
 
 	return 0;
+
+err:
+	/*
+	 * Failed to Get/Set interrupt policy for DCD while BIOS owns the
+	 * other logs. Disable DCD and continue.
+	 */
+	if (!native_cxl) {
+		dev_warn(mds->cxlds.dev,
+			 "Event interrupt policy failed (%d), disabling DCD\n", rc);
+		cxl_disable_dcd(mds);
+		return 0;
+	}
+	return rc;
 }
 
 static int cxl_pci_type3_init_mailbox(struct cxl_dev_state *cxlds)
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 7b756000a1a6..c740372bdaaa 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -1818,7 +1818,7 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	if (rc)
 		dev_dbg(dev, "No CXL FWCTL setup\n");
 
-	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
+	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_STANDARD_LOGS);
 	cxl_mock_test_feat_init(mdata);
 
 	return 0;
-- 
2.43.0

