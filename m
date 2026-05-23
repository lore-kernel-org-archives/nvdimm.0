Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806713859DC
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529438; cv=none; b=HWOqeWfvQVNHp8lLpRAoPivQjV3gsq4dVLoeQiUaVG3qzGwdSV7cC9ufKJg229nlBC7i6v2QFAnVYnMJI9N2jcxQRwrst1n3fwJWb9pjsdPA77TUzoczMtHi7MthJO641wukHW7I9uV37juUhjR4vsXCuXZ01GGakvMOARETnVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529438; c=relaxed/simple;
	bh=WdPnNZdBMfPNVkxZQcUkvrepHszswdE8ldfahIBUbPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JSn5sn7GWWMy1jX7taYlqKHLkM0O2YeOknX+0EgFShFJ1G2ZoffrEVWBJBmQqn5EXT/4SEyT7cQaUnEX/4KG4pLJbuU7eZhP3cglwdsNcveoHvjeMOVfL/e8ANLAteoRRVrwUxmpMmsgaWMsTvV7yP0weyY4oiyWcDcCXIcXJIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Fl+wv+xn; arc=none smtp.client-ip=74.125.82.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Fl+wv+xn"
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-132830d8281so2577269c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529435; x=1780134235; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=drGooomvIKHMHD9aQDfS7/igAqAzAvEceRuTEAEvyv8=;
        b=Fl+wv+xnMtTqlEcU26vrpqxMDz98QN+Gkc+Ys0+5bG59W5YsU2kUhHdDIVMOopVNEM
         ajIRHXxWoSOTipV7GO+EPl1AxWDyi/B4pMMMpPiUTliM0mjQdtwulItkGDUvZ24a5E+w
         shuEVe9Ugzu4j4NUQMaWdmpvBB4n01xTwHgkkzlCTE1Xe8PCXEcUvuv+Cis4jqzZiAw5
         mBNz/SzgDEk1SGqVDVq4QtyEfnURqjzssrSTl+X4t4RbhacYnoVQI+ePERWoW1GUlDJj
         2lnlnvmhuL5leRS7n0do+ZM4hcTSG97Qp1biwgfsaN4YgdnueefQ4ptKMPI2g+/hoB9t
         K49w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529435; x=1780134235;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=drGooomvIKHMHD9aQDfS7/igAqAzAvEceRuTEAEvyv8=;
        b=E62wKaXILsLGdTO/gN+MsjI8YH/h7GOiGlteW7Zt2KcHB+2GsZ+Qd3+4EH4ppKyRKD
         eyUIk8NkNBRUk+5qPxWgK1d1kIqhoInadhvfdq2vDt094ZwlQoGpITfQTe+dozJx953S
         wwLy67fC+vQ/cMV0ANu4TZY1x5r2RGg3Uj+PaHkyynOv55voCo62a0CmlXlm9g+vpEPi
         ofPBBe4khM5pwZo1J4bJ36XL0iEIwP3W8pBimEWit/DPA7wkBu24nuen8wlX7L75D1hz
         fgjSK772BbNyqQ8D1kzRgm2vdkliswX8xiuFbXnHQsqSUO0JowcnYL3x7vXVvtyoG9bl
         Crvg==
X-Gm-Message-State: AOJu0YyDHzgaIgMdho4AAz4DuxSEjjYKPGEqNEHzNpvyDL4iGU4jctNS
	cxgvBELQoaRWYu/+UkvvXSpDehlcKpJpL5XcxgvoTrvaMdd0ej1egW7h
X-Gm-Gg: Acq92OFskqfjSKRe3rQARRmODwvmsXJpgyU+LcXGa1HZK8zdCTiLeBNsNBG0Hypgk57
	CgaYEWSpGR9K044DOSep8Y+TxNtYDzGpDg5A56FToCl5rCdGe+hiV+eWop98RY6wRYClL3DjGHr
	TEUxBrc4nI1BfhkK4lPkV+dF9ym3GIYm4DcW8PqsepAf/WrtersoCr64rjl/R6mUNK9cskfpVtZ
	y3cRMTwSQOcKyKFKoJprEY3ucVN07P8xJOMTaumzBXmXqKyED+1K6G22FsNn3tw/x6jnUk9+7qJ
	xgR/tEuoyNPnNl0MzlDlGPhJn4uqE0sZIM353d7EZsUWLa97AqlDDA1Nj89CDcpoAqCj1sfwnrA
	cuzLnCWp48K1NfJXSxFR1jmUVnhd1u5Fz4p1mMxKrGLlNGyJOxhgDxSDZJJC4CDSdxH+5XxPtMm
	vNscDqQAnvj3w4HsjrnBX1ggAu1O1/PRqNIXk7TBoKdDQlvUso3MVt8KKtLk2/Zvnh98CGF5mOJ
	W7uG5c=
X-Received: by 2002:a05:7022:511:b0:134:d708:1a24 with SMTP id a92af1059eb24-1365f8161bemr2409921c88.17.1779529434676;
        Sat, 23 May 2026 02:43:54 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:54 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v10 10/31] cxl/mem: Configure dynamic capacity interrupts
Date: Sat, 23 May 2026 02:43:04 -0700
Message-ID: <7f2e4fe385415e0b77b58f4bd988bc5895557dcf.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

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

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: rebase]
[anisa: accept 4-byte CXL 2.0 GET reply via min_out]
[anisa: drop Reviewed-by tags now that the patch carries new changes]
---
 drivers/cxl/cxlmem.h |  2 ++
 drivers/cxl/pci.c    | 75 ++++++++++++++++++++++++++++++++++++--------
 2 files changed, 64 insertions(+), 13 deletions(-)

diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 10175ca3b7ee..65c009b02da6 100644
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
index 8d12c684d670..83617439bbd3 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -557,6 +557,8 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
 		.opcode = CXL_MBOX_OP_GET_EVT_INT_POLICY,
 		.payload_out = policy,
 		.size_out = sizeof(*policy),
+		/* CXL 2.0 firmware omits dcd_settings; accept the shorter reply */
+		.min_out = CXL_EVENT_INT_POLICY_BASE_SIZE,
 	};
 	int rc;
 
@@ -569,23 +571,34 @@ static int cxl_event_get_int_policy(struct cxl_memdev_state *mds,
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
@@ -632,6 +645,30 @@ static int cxl_event_irqsetup(struct cxl_memdev_state *mds,
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
@@ -657,18 +694,26 @@ static bool cxl_event_validate_mem_policy(struct cxl_memdev_state *mds,
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
 
@@ -676,10 +721,10 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
 	if (rc)
 		return rc;
 
-	if (!cxl_event_validate_mem_policy(mds, &policy))
+	if (native_cxl && !cxl_event_validate_mem_policy(mds, &policy))
 		return -EBUSY;
 
-	rc = cxl_event_config_msgnums(mds, &policy);
+	rc = cxl_event_config_msgnums(mds, &policy, native_cxl);
 	if (rc)
 		return rc;
 
@@ -687,12 +732,16 @@ static int cxl_event_config(struct pci_host_bridge *host_bridge,
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
2.43.0

