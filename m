Received: from mail-dy1-f174.google.com (mail-dy1-f174.google.com [74.125.82.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CB4F3DA5A1
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386915; cv=none; b=l52qHA3t1DzYmupggtw5up0MN9XrfLXdUDMnoANsjbZiD7CSn6AfFRthPe5CSGM2k9g+CFTAumhXPM/h5tNsQdE4h9D37136FphfH6mHTGcWQ+mMi0vSvNyBHgjCxT9Y2Y30RBdneFbDn0/KkKYwNFVBaCEJWUji9mXFZZLsdZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386915; c=relaxed/simple;
	bh=SIu3Sr1acO+axIy8Bc96/9RKsqyGEi5yvCupNPAM+ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HEK+KL/tvlck4J6aG6Tuc+GPfw4WqagrTDCPO5Ot69dBDUO3d9WWMX0VZz2imShjzr4+ReDd9tGXtH2NQW4w6mPsWEJTowfkwkMzcQ0NSpaJGc9AjnGUD931LhcDs4e8bJKl87FVx1Qz/t7T/xiqK28dhuHi8lqjYFdzMZu3BEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Su7rmFj8; arc=none smtp.client-ip=74.125.82.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Su7rmFj8"
Received: by mail-dy1-f174.google.com with SMTP id 5a478bee46e88-30c591fb1cbso3141602eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386913; x=1782991713; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iDmOUMRUdAg56Sm80IhGFuCYySgwRIFizUN8oLNDcwE=;
        b=Su7rmFj8kw4NwZtArQXi+D3YHHIHwxvnWaXp8ici5ZnC0And1tFVuh8D7nskqvbcYN
         Lh5PJ5jDlxQlzSagUvpwtjzFiOfhjFSKAg/Wp/zUWunqlnBAlqYRbv0iu7NQhHThD3OW
         xpa+a07Ta8Ml5EkW06MYbVtR+i8e2B4xhKbIXvryGW1Zk1xfCkmLFo5Act4bXvJNZmXS
         Fe8LBEJac4uATBXyNcjGg6lEhW+59G2d5ries+Qx1Alju+GWpHlFTS/mWFZ8P9ZbKqbN
         c1m8PAjlTex1lfzJsz29434EbU8aau5RgRhgRuRRmOTU+fgxQa/8ApNgrq8mPTTYusdA
         j7jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386913; x=1782991713;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iDmOUMRUdAg56Sm80IhGFuCYySgwRIFizUN8oLNDcwE=;
        b=EhfxY3m4jF3goRXgsLlapUMLKRcO7pg44ZRMsUE4sZ/6+nEIg684zNp6ORzQfqyjIF
         sy7YX9JJrM452Yc26pkLsLFmP1xrZcdVPJIdiGbRJ+0v/BW2/wCvL7S9e3BHLwfN7XGo
         bhsCzkDkjZzHMbA3T5KuC3+lVxrnj7SE+FbqbqzJCWsioyHMpRvOgIIkF/CoYSjW/x/A
         m9zNwFbgvNsp/KJ/RuRvJmppT5jmO+w6ww3ZcYaDatbYlkoHuArda4NSy0ZQkRhc6QZU
         1rz2TzfWiP1Bh9lqPId+/TNcKG7xV6OfZaci0PfPAx0pEJN81cekPRpFE5DKO8OKQJuS
         MCBg==
X-Gm-Message-State: AOJu0YwxkcL3TlpAKDw8UYsTRsnrWrsMdSsVeJrg+4lZwWOHbhjqqO+F
	iN2Hkwl7bw/gFo7YbNP5RwUzHoRkk9f5GGt6WdDMG/f90wMpjFrCSPjE
X-Gm-Gg: AfdE7clC8piNQnHKNYhtlckbEfR9O1Z5AahhpQnk5wXCUvBVzf7bVN12cQLwXOjYfvQ
	9sCUKx98cpZ6uWfldsQBnVfMdRObbVExJoFlX6yDhgE3meGd5RO9yRalcmwTt4Lyd79/YnXQkOP
	Uu86DWeHo2YQ/cvdPwt4EaZ0UZfCGpScnePMl1Czm6traMptLemEPZMO+By8Be8/i0pDrVlhuYn
	7e7hJPMxDccKlaAjsIFDSYlYyZnN9enC1YnpyO/9IuUz7U+44gjo8hLRA2bv5VkHKmsaHBTjLAj
	CjPDFqO6oD2EouZu6XaWFRMwoiK6CmDIEhkxOLAyA7DeNiu2NA3g0lLxpojuARopkcdLy0/TDAj
	lLaUw4M7yfmau2M7pnpbDN1dI+zTUmkJqSsyLXGvJJJKnl82bFwQafA45kA60qoF2CRMmc/J6A+
	LcGh7E2R4hOKoHTy4E+g7+R0NsYwe+6g7lixmwg0SnlhW5lkn5ya3uNaLoUqduwg668i2y
X-Received: by 2002:a05:7300:e410:b0:30c:25fb:d28f with SMTP id 5a478bee46e88-30c84d81ba5mr2272037eec.25.1782386913089;
        Thu, 25 Jun 2026 04:28:33 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:32 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 10/31] cxl/mem: Configure dynamic capacity interrupts
Date: Thu, 25 Jun 2026 04:04:47 -0700
Message-ID: <20260625112638.550691-11-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity Devices (DCD) support extent change notifications
through the event log mechanism.  The interrupt mailbox commands were
extended in CXL 3.1 to support these notifications.  Firmware can't
configure DCD events to be FW controlled but can retain control of
memory events.

Configure DCD event log interrupts on devices supporting dynamic
capacity.  Disable DCD if interrupts are not supported.

Care is taken to preserve the interrupt policy set by the FW if FW first
has been selected by the BIOS.

Accept the 4-byte CXL 2.0 reply on GET Event Interrupt Policy by setting
min_out to CXL_EVENT_INT_POLICY_BASE_SIZE; pre-CXL 3.1 firmware omits
dcd_settings and would otherwise fail the size check.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: add CXLDEV_EVENT_STATUS_DCD (bit 4) to CXLDEV_EVENT_STATUS_ALL;
previously added in a later commit but moved to current commit]

[anisa: check native_cxl before cxl_mem_get_event_records]
---
 drivers/cxl/cxl.h    |  4 +-
 drivers/cxl/cxlmem.h |  2 +
 drivers/cxl/pci.c    | 94 ++++++++++++++++++++++++++++++++++++--------
 3 files changed, 83 insertions(+), 17 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 1297594beaec..864f6d3c03d4 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -180,11 +180,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
 #define CXLDEV_EVENT_STATUS_WARN		BIT(1)
 #define CXLDEV_EVENT_STATUS_FAIL		BIT(2)
 #define CXLDEV_EVENT_STATUS_FATAL		BIT(3)
+#define CXLDEV_EVENT_STATUS_DCD			BIT(4)
 
 #define CXLDEV_EVENT_STATUS_ALL (CXLDEV_EVENT_STATUS_INFO |	\
 				 CXLDEV_EVENT_STATUS_WARN |	\
 				 CXLDEV_EVENT_STATUS_FAIL |	\
-				 CXLDEV_EVENT_STATUS_FATAL)
+				 CXLDEV_EVENT_STATUS_FATAL |	\
+				 CXLDEV_EVENT_STATUS_DCD)
 
 /* CXL rev 3.0 section 8.2.9.2.4; Table 8-52 */
 #define CXLDEV_EVENT_INT_MODE_MASK	GENMASK(1, 0)
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index afc195d8c090..bcf976829c3e 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -218,7 +218,9 @@ struct cxl_event_interrupt_policy {
 	u8 warn_settings;
 	u8 failure_settings;
 	u8 fatal_settings;
+	u8 dcd_settings;
 } __packed;
+#define CXL_EVENT_INT_POLICY_BASE_SIZE 4 /* info, warn, failure, fatal */
 
 /**
  * struct cxl_event_state - Event log driver state
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index 8d12c684d670..95a4bf7c1e46 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -514,7 +514,19 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
 	struct cxl_dev_id *dev_id = id;
 	struct cxl_dev_state *cxlds = dev_id->cxlds;
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct pci_host_bridge *host_bridge =
+		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
 	u32 status;
+	u32 mask;
+
+	/*
+	 * Only drain logs the driver owns.  When BIOS owns event reporting
+	 * (!native_cxl) the driver is only here for the Dynamic Capacity log;
+	 * processing the standard logs would steal firmware-first events from
+	 * BIOS, so mask them out.
+	 */
+	mask = host_bridge->native_cxl_error ? CXLDEV_EVENT_STATUS_ALL
+					     : CXLDEV_EVENT_STATUS_DCD;
 
 	do {
 		/*
@@ -522,8 +534,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
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
@@ -557,6 +569,8 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
 		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
 		.payload_out = policy,
 		.size_out = sizeof(*policy),
+		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
+		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
 	};
 	int rc;
 
@@ -569,23 +583,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
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
@@ -632,6 +657,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
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
@@ -657,18 +706,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
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
 
@@ -676,10 +733,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (!cxl_event_validate_mem_policy(mds, &policy))
+	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
+	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
@@ -687,11 +744,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds, &policy);
+	rc = cxl_irqsetup(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
-	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
+	if (native_cxl)
+		cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
+
+	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
+		native_cxl ? "OS" : "BIOS",
+		cxl_dcd_supported(mds) ? "supported" : "not supported");
 
 	return 0;
 }
-- 
2.43.0

