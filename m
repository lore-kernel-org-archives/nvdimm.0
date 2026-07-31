Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6857D3DAABD
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487802; cv=none; b=HGdqt2p4gyT6yH9Nj7ww9YikuHnJgW4ilFx0MMvtZ9gsX7T8dAc7hiU8PHJgyuRwdCCBOF1/nlJEbQQ9nAO1as4oEmx6dJqWH9u42vdvaqhv0sHg2UQ1Qhhp3v5poNUq+Kd6+CLwj/wM5j7xwQS+Gvjm+WIP7JenxWQcbozorg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487802; c=relaxed/simple;
	bh=I1Oek+okhoOwK+0sHjiLmPNTk/neyCQ8YEpTAtO+ClU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJlAUwhh/DK5tyIhXgKEtqr8ifo9WwzARX8Hc2TKIbr7Ln1SLEkWa5w8DNb4BqjUGQL+k+T9NtPUGnG1B8EK4zSGCeif8OsFHEka12FlPTgKGOVTVulDiUFUxqmgcBxpbbJbkc933rQX7AISjRcj6/tWKssC2Ik+5KC07CdaTrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BiUrmShq; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BiUrmShq"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cf50c6f235so8035625ad.0
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487800; x=1786092600; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Uo6RGmhIbdMl//1adJj4V8jslNSDui5/CJfX7a2lY1I=;
        b=BiUrmShqafsG104cZbt+vbExOGZ8onU/plQEoE7b4vPeSNvFxEgDEjc5YZRocfN0kl
         51hy6Gw24PSHA16JrmGN0t5aP/jFnFyHcUooX23WLQtZNv8tPs/lXMkG9AuicSH97zcU
         TzlRNHgO2FcxA8WRbLdWexK0tr1Q6FzqimTBpgEQ6irm/X8r1pCawitj0yL2yK8+VYtW
         uVFpuPZvbLNRLXHhJUkzWENe/F/LKKOSyApn2B7sj6k6sp29TZQVSPF5ZT6TGyB6Mhc2
         5dbMXJmyMMtXos2eTm0AvkvTQB6rJoHtmKXhiNQ4PSaTUV3qJT1SFOPGxHIJ2MbBacsI
         oVkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487800; x=1786092600;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Uo6RGmhIbdMl//1adJj4V8jslNSDui5/CJfX7a2lY1I=;
        b=ZpKZf75XEPJ0w2NKkEOEOAJ0G6ucKRYxmm+ZAWJ6DzC5Ve7PzjZfOpqdyhIzzzq1Hc
         V55Bcstw+z+8O1iFCeJgtYH9kzOl1WEuS+70a2TsjT37vPlmbGMCCNmWGhztmOINpWDM
         +z+Ylr8MMCqRTf80nBso9P+o5M8B65/eSpwaTOntEO9vT1Lk9xbQQLb/xMilYa+iPN9H
         NuA0LUI4hIpvD62w3v6EGdVCPLA9RRym/T5i5Cjqxci11boLu3L0FBw/6oKWIubD3BLv
         pY0fWM1AsL40I7gs8LcBKd+NTlDzLcRiXrs2K+nBiTMcZWC+Z0b0GplIGTNtp0gwJ/lW
         PxZA==
X-Gm-Message-State: AOJu0Yzklbo81BnkVQk+j2umLoFV7CZtRB5H5e1WGRkpyM+xPsY2LCKa
	K0XJQp47j2n4vYx+Hg42LeYwo7/nJ9igVdnLk1pEz40bfh+WzW5rP37V
X-Gm-Gg: AR+sD12KCWgTAX+l/kzGF12lcGHfItV3Z3pbOpzm66VUw+gcAc4/1d33YhoAcbAO2HW
	uWCwTrJO9PT6lWWKnnV42wdyaXmCjt2CtHyXl2rBl9P5RQr5BlS0SxehoVpEUwwNU/zDPzBiI+6
	bTPP4pe5oaWSNzixmWHNj5sy5uXvQXhcj8WAeKe+OvutYjqk5ekMqdsKe5h9eYwMqIkEhe4/ky9
	zqxYU8EQNZMMNEtsyumPpapa8Phcf+6VxIXaVPQhNsmObwJy8dGnPieozgdcY1MaG+6bTBKJqzh
	JFORYST8b1CmeTPkXB9c6VS7W1y3Om0jrc0YlpHW39d42Qca0q6/6pvgLstjY0S5RzatvNc5f//
	qrGHR52jWtk8axU4yvj26N9ka7tfblKOZWUkNB1FlRYO3wnb2Wcw3jlc2m+bBTKM4MJZv5rWJhZ
	C2qCCyareJ6MDCO1iMq+I5s3G2FEWOzcnN14B/liMj7h8I/WNCOhSBEs2bCCDuTrlrpkOcGEQLO
	Os/k9I38vY7/svkpeTITFqYleoRLPfVGKce1wxYLGZKrtqAn1Um3Zg=
X-Received: by 2002:a17:903:4b4c:b0:2c9:d88e:f996 with SMTP id d9443c01a7336-2d046d6d47fmr12839575ad.9.1785487799538;
        Fri, 31 Jul 2026 01:49:59 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:59 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v12 6/8] cxl/mem: Configure dynamic capacity interrupts
Date: Fri, 31 Jul 2026 01:48:11 -0700
Message-ID: <20260731084901.1512819-7-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731084901.1512819-1-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
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

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>

---
Changes:
1. pci.c: size the Set Event Interrupt Policy payload by the device's
   policy layout (from the Get reply length) rather than by DCD command
   support. A CXL 3.0+ device carries the dcd_settings field for spec
   compliance even without DCD commands, so keying the size on
   cxl_dcd_supported() sent a short payload and failed the set. Reported
   by Benjamin Cheatham.
2. pci.c: add cxl_event_drain_mask() (standard logs when native_cxl, DCD
   when supported) and use it for both cxl_event_thread()'s drain mask and
   the initial drain in cxl_event_config(). Gating DCD on support stops a
   disabled-but-armed DCD from spinning the thread; draining the DCD log
   initially even when !native_cxl stops pre-existing DCD events (and
   future edge-triggered interrupts) from being stranded.
---
 drivers/cxl/cxl.h    |   4 +-
 drivers/cxl/cxlmem.h |   2 +
 drivers/cxl/pci.c    | 119 +++++++++++++++++++++++++++++++++++--------
 3 files changed, 104 insertions(+), 21 deletions(-)

diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c0e5308e4d1b..51396eb993e7 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -192,11 +192,13 @@ static inline int ways_to_eiw(unsigned int ways, u8 *eiw)
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
index eb1e6f7a2038..666e01326dae 100644
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
index df13fb8802c3..6cb344ec4f3a 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -509,11 +509,30 @@ static bool cxl_alloc_irq_vectors(struct pci_dev *pdev)
 	return true;
 }
 
+/*
+ * Event logs the driver drains: standard logs when native_cxl, DCD when
+ * supported.
+ */
+static u32 cxl_event_drain_mask(struct pci_host_bridge *host_bridge,
+				struct cxl_memdev_state *mds)
+{
+	u32 mask = 0;
+
+	if (host_bridge->native_cxl_error)
+		mask |= CXLDEV_EVENT_STATUS_ALL & ~CXLDEV_EVENT_STATUS_DCD;
+	if (cxl_dcd_supported(mds))
+		mask |= CXLDEV_EVENT_STATUS_DCD;
+	return mask;
+}
+
 static irqreturn_t cxl_event_thread(int irq, void *id)
 {
 	struct cxl_dev_id *dev_id = id;
 	struct cxl_dev_state *cxlds = dev_id->cxlds;
 	struct cxl_memdev_state *mds = to_cxl_memdev_state(cxlds);
+	struct pci_host_bridge *host_bridge =
+		pci_find_host_bridge(to_pci_dev(cxlds->dev)->bus);
+	u32 mask = cxl_event_drain_mask(host_bridge, mds);
 	u32 status;
 
 	do {
@@ -522,8 +541,8 @@ static irqreturn_t cxl_event_thread(int irq, void *id)
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
@@ -550,42 +569,62 @@ static int cxl_event_req_irq(struct cxl_dev_state *cxlds, u8 setting)
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
 
 static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
-				    struct cxl_event_interrupt_policy *policy)
+				    struct cxl_event_interrupt_policy *policy,
+				    bool native_cxl, size_t policy_size)
 {
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
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
+	/*
+	 * A CXL 3.0+ device can carry dcd_settings field without DCD command
+	 * support, so size the request by the device's policy_size and only
+	 * enable the DCD interrupt when DCD commands are supported.
+	 */
+	if (cxl_dcd_supported(mds))
+		policy->dcd_settings = CXL_INT_MSI_MSIX;
 
 	mbox_cmd = (struct cxl_mbox_cmd) {
 		.opcode = CXL_MBOX_OP_SET_EVT_INT_POLICY,
 		.payload_in = policy,
-		.size_in = sizeof(*policy),
+		.size_in = policy_size,
 	};
 
 	rc = cxl_internal_send_cmd(cxl_mbox, &mbox_cmd);
@@ -596,7 +635,7 @@ static int cxl_event_config_msgnums(struct cxl_memdev_state *mds,
 	}
 
 	/* Retrieve final interrupt settings */
-	return cxl_event_get_int_policy(mds, policy);
+	return cxl_event_get_int_policy(mds, policy, NULL);
 }
 
 static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
@@ -632,6 +671,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
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
@@ -657,29 +720,39 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
 static int cxl_event_config(struct pci_host_bridge *host_bridge,
 			    struct cxl_memdev_state *mds, bool irq_avail)
 {
-	struct cxl_event_interrupt_policy policy;
+	struct cxl_event_interrupt_policy policy = { 0 };
+	bool native_cxl = host_bridge->native_cxl_error;
+	size_t policy_size;
+	u32 status;
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
 		return rc;
 
-	if (!cxl_event_validate_mem_policy(mds, &policy))
+	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
+	rc = cxl_event_config_msgnums(mds, &policy, native_cxl, policy_size);
 	if (rc)
 		return rc;
 
@@ -687,11 +760,17 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	rc = cxl_event_irqsetup(mds, &policy);
+	rc = cxl_irqsetup(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
-	cxl_mem_get_event_records(mds, CXLDEV_EVENT_STATUS_ALL);
+	status = cxl_event_drain_mask(host_bridge, mds);
+	if (status)
+		cxl_mem_get_event_records(mds, status);
+
+	dev_dbg(mds->cxlds.dev, "Event config : %s DCD %s\n",
+		native_cxl ? "OS" : "BIOS",
+		cxl_dcd_supported(mds) ? "supported" : "not supported");
 
 	return 0;
 }
-- 
2.43.0

