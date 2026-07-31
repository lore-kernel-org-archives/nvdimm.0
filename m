Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B114386553
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487770; cv=none; b=F0jfC8fsy8ONMd9iZOMTuM83p0AhXj/XcDD9XJD0YvEzP3rcbjkkl/hGInutrL2Sd4H6KTrykBFg8EfVmBuDgHcN3D1h0dK0jmIl0ewaJPhg8MIw/lsNsLdeutr9ueUrc6Qf1VZNj8QyMYMbqoEsFbei4vmeSNPjUmy2A4L9t40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487770; c=relaxed/simple;
	bh=XYCPrEarp34OaxCJDCO8652G7vPD8QRseTGPqPxUGlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XfbM/QopelODO3F5pxglJi1Ry6w6G7T+VzBexawTUDTh98Tr/xY2NKQju247Ju3he3kKq1xEXL2v/SOo4oibKHGRBGrM4KhQhPYIqw2tnbL2POiVXqF3h4x9ohmfIcfgBINZJPSbGBFu5x3um92uu5qb27WHPNxW4+ZF7Da4va0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XEg0d+kL; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XEg0d+kL"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2caea3f742bso8239195ad.0
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487767; x=1786092567; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b4KDHY++FP3qIPmrM4bkpQdwzqFZC4sRb/8sm6+ifG0=;
        b=XEg0d+kLKHyg7eHht9SnN0yoLjWRyD+iSc2/bUiBPFZ0idP3ddq2PoZMkYy7gLfXMq
         z0xKqSKiMyeYHnHQ51g7QSXGk0Z4cl5nU01y8yCta7Ot+N2+PR3VgArvqCoFghT7Lvov
         LqLM+vNqsaK2lCbPaHZfVV+u7I14E7bwPXs1TDqETsCivCs6lSO8NQ5rWtEbdGGbX57a
         i22676d3NbWiJ7gPs0I8lcmJxiYwmLytUpeWlwRnFjSozM8RYgEBPluz3bUp9Sn83eLY
         ukSjGbYCbmCGVs3m+XKm/QgO7BjciKGwuZ70A3vhcZ0GTmyD2GuESdH174vx8h4laYqP
         IX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487767; x=1786092567;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=b4KDHY++FP3qIPmrM4bkpQdwzqFZC4sRb/8sm6+ifG0=;
        b=XlBBH0dJ25TDMo2N4/1ePeX+H2r/NI/CYdPjIdBrTPQE+AlDgtVnatXrFNsVY+6mng
         5sjeOuFogxgOH3ifh7vDBkjL2CfYi8mTBi2ch7f6nhsx4zm7cmfITb1GaWVmiARyXOdF
         UFlI83CTzvRK9ywZ7Duvj3PRIsz2YgIn0L6yyxBaIMdEGXmC9GqLik/mBZrpoS9hF/5U
         67qj4F9Jdh22T4pAHIJn8usiK9Dfat+h/fBpEIhbuqd1kJpIpzGbpNXjjMmPxvuzQkGQ
         OMrIPAx0DgQds0P2XtpiqqklUhBeg8Nh25wUID0EQtILllHFgw257aSmzJcPeS4B3L3v
         1IKg==
X-Gm-Message-State: AOJu0YwouwBmXqTSMeRS1lIi+oPM8MbdP7NhlpqK+sY3eaZYDzfo5N/Z
	GLd5ShX+221SFU262mCyPUPR+/R6ZDgURIz7wzwAErJg9aiMtalghVw3
X-Gm-Gg: AR+sD11Ezj8votqq0JY11LczYN5DgaDLVTqBV/HiL8ddqLOD0qBy51hclhs8kxlDRdz
	2l5B0iNV+3jnNlKi0XCfp4B5QaTmpGJz4AmVmJ8k7wUU3gZ24sTMJWxi9tuAiWEzGTQVJafHEUJ
	H/6mUPjHwz1gDvuIJRGIaSDGwoFrGzPyax0FowY3gnzwgn0a1zmJ9Vie/VPbbpK+Y6L1hUkxTtn
	OyWOB5ttTVlvNELyVo3oq+L5eR9hfg7z7VpMKlIZCB15wiSqqPh1RddVMvhZQGYo/OaGqxhuXfx
	WnD/1F4FfWf4JF/PLok1bULFD8d0ubht8h+ZjrvNNuK4c6VIiCCHzYccfiHpd7dDZGvlk8Iyq6N
	qKq2PQnt2oNlge6fP6rU43v+dNxAqMdoCXRex/EsReZVWuiiGTMugxAGQQRRzBkbE718ZpQvPk8
	mPfnwrApoziLDP8Nl1Rw706LqkReC2iocftE9E1dxVzALvC2wQxluh0RNTVsO09i17LJ/+fkoFR
	HLkEtpRjmWLWvqAvq9HcFebdlDHccrbJT66mBfxTEgZ
X-Received: by 2002:a17:902:c407:b0:2cf:a1c0:d4ca with SMTP id d9443c01a7336-2d046e4e65fmr13231395ad.22.1785487767301;
        Fri, 31 Jul 2026 01:49:27 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.49.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:49:26 -0700 (PDT)
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
Subject: [PATCH v12 1/8] cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
Date: Fri, 31 Jul 2026 01:48:06 -0700
Message-ID: <20260731084901.1512819-2-anisa.su@samsung.com>
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

Per the CXL 4.0 specification software must check the Command Effects
Log (CEL) for dynamic capacity command support.

Detect support for the DCD commands while reading the CEL, including:

        Get DC Config
        Get DC Extent List
        Add DC Response
        Release DC

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>

---
Changes:
1. mbox.c: leave mds->dcd_supported false so the hardware enablement
   patches can be upstreamed ahead of the extent and DAX work; the
   event handling patch re-enables it.
---
 drivers/cxl/core/mbox.c | 44 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    | 20 +++++++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 7c6c5b7450a5..4790524c32a7 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -165,6 +165,38 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
 	}
 }
 
+static bool cxl_is_dcd_command(u16 opcode)
+{
+#define CXL_MBOX_OP_DCD_CMDS 0x48
+
+	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
+}
+
+static void cxl_set_dcd_cmd_enabled(u16 opcode, unsigned long *cmd_mask)
+{
+	switch (opcode) {
+	case CXL_MBOX_OP_GET_DC_CONFIG:
+		set_bit(CXL_DCD_ENABLED_GET_CONFIG, cmd_mask);
+		break;
+	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
+		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, cmd_mask);
+		break;
+	case CXL_MBOX_OP_ADD_DC_RESPONSE:
+		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, cmd_mask);
+		break;
+	case CXL_MBOX_OP_RELEASE_DC:
+		set_bit(CXL_DCD_ENABLED_RELEASE, cmd_mask);
+		break;
+	default:
+		break;
+	}
+}
+
+static bool cxl_verify_dcd_cmds(unsigned long *cmds_seen)
+{
+	return bitmap_full(cmds_seen, CXL_DCD_ENABLED_MAX);
+}
+
 static bool cxl_is_poison_command(u16 opcode)
 {
 #define CXL_MBOX_OP_POISON_CMDS 0x43
@@ -757,6 +789,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
 	struct cxl_cel_entry *cel_entry;
 	const int cel_entries = size / sizeof(*cel_entry);
+	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX) = {};
 	struct device *dev = mds->cxlds.dev;
 	int i, ro_cmds = 0, wr_cmds = 0;
 
@@ -785,11 +818,22 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 			enabled++;
 		}
 
+		if (cxl_is_dcd_command(opcode)) {
+			cxl_set_dcd_cmd_enabled(opcode, dcd_cmds);
+			enabled++;
+		}
+
 		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
 			enabled ? "enabled" : "unsupported by driver");
 	}
 
 	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
+	/*
+	 * Disabled until event handling implemented.
+	 */
+	if (cxl_verify_dcd_cmds(dcd_cmds))
+		dev_dbg(dev, "Device supports DCD; capability disabled\n");
+	mds->dcd_supported = false;
 }
 
 static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index ed419d0c59f2..616eeaeee5b9 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -252,6 +252,20 @@ struct cxl_event_state {
 	struct mutex log_lock;
 };
 
+/**
+ * CXL r4.0 Section 8.2.10.9 - Memory Device Command Sets. See Table 8-308.
+ *
+ * The 48h Command Set (Opcodes 4800h - 4803h) defines the device-enabled DCD
+ * commands.
+ */
+enum dcd_cmd_enabled_bits {
+	CXL_DCD_ENABLED_GET_CONFIG,
+	CXL_DCD_ENABLED_GET_EXTENT_LIST,
+	CXL_DCD_ENABLED_ADD_RESPONSE,
+	CXL_DCD_ENABLED_RELEASE,
+	CXL_DCD_ENABLED_MAX
+};
+
 /* Device enabled poison commands */
 enum poison_cmd_enabled_bits {
 	CXL_POISON_ENABLED_LIST,
@@ -427,6 +441,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @partition_align_bytes: alignment size for partition-able capacity
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
+ * @dcd_supported: all DCD commands are supported
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -446,6 +461,7 @@ struct cxl_memdev_state {
 	u64 partition_align_bytes;
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
+	bool dcd_supported;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -507,6 +523,10 @@ enum cxl_opcode {
 	CXL_MBOX_OP_UNLOCK		= 0x4503,
 	CXL_MBOX_OP_FREEZE_SECURITY	= 0x4504,
 	CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE	= 0x4505,
+	CXL_MBOX_OP_GET_DC_CONFIG	= 0x4800,
+	CXL_MBOX_OP_GET_DC_EXTENT_LIST	= 0x4801,
+	CXL_MBOX_OP_ADD_DC_RESPONSE	= 0x4802,
+	CXL_MBOX_OP_RELEASE_DC		= 0x4803,
 	CXL_MBOX_OP_MAX			= 0x10000
 };
 
-- 
2.43.0

