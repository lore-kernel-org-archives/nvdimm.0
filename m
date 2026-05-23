Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5700E385503
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529416; cv=none; b=iw4K0JX3rB5D5l5ZlUHWPT6GRmMjk4zHqDHUnLPBimFRqijMFgQxgB34GiZKGlSwRVjO8W5Z4o9wpIh95r0KuwlSp8Y5HUMN9lcBLZWZ8P5stBUj4Vbs9BgDjJvRN4kPCc1S0brlfPT/XSFVLyq/te+eKrXtiXwe32FWYvq0/Zc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529416; c=relaxed/simple;
	bh=bc329ZjKfsjEkL6SZyy8g7yHEPrn1HJgDl86cAwK910=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z+xO1RpjNBb+F7VDbJlK9cbi+gCm1Gvf0edteE8BOO3MefuN5nSQC2jBj7vqspsTskPQSt7erUuuPpMD/qINdv/WLSh0NzUkNzEpCp9UUzBTCTl6lvfJwRElhfUrlSSoiT74jkkTFceACK28LKNhlr40cmcJB3LvyULj5K+pW7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ffOdkrZ8; arc=none smtp.client-ip=74.125.82.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ffOdkrZ8"
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1334825de43so7174929c88.0
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529414; x=1780134214; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M3OwZ94U8bDjUMg9dyoIVeXc+EhCZY7nOy8TPZRIabU=;
        b=ffOdkrZ85haDZDlEHDoyToNhFXN6MhBt8kLDmmTcAUFyVY1nwgb7Y0umRrvzEtgp39
         d7tDXlxkhFSct1U6pOmrftvfH0A6XwkSIE5q2qznh/jYGZhkCUWQsUXSo/CTSmrrWq96
         Be0NdIvG4FW2EwRRWJb9Bv2+adhYb6G7xDj/hyIQPQjfIOGros03fDAbCmDwkpviqcyt
         /4bo+YKouzVMOMmm4Xb4F/RePT/1C61XOp9goybyzNr3zeRKr8PObgAr/BP6WMl/pg+R
         ZncSEtjrBKYaeK4hiItY3invTdgHrNzqWp2QlnArCgIvvmwxJNPa0OBeZotJ7Kcq0Yb+
         X5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529414; x=1780134214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M3OwZ94U8bDjUMg9dyoIVeXc+EhCZY7nOy8TPZRIabU=;
        b=fqw2m4/19wb6nfAuBTFUDYnPnVj1mgUd8nSKF/boEPTtHNG8/XkleP+sO1pl7UsVXM
         2ImJvc3Rw8eoQSgcAwIIszn6A2+TJOZAnZQIDEO7+fzZvRfcfNZZGb3P9td9HWpbRKSu
         +53Wwb6Ce8LIJudQ5THl2/0UihKL79NZmpq8UARx4wvCT2Pp2Bly69h0SpZORo17UYTD
         XfGh2C3DKqYMlPObPagYL6l9gd3w4IBomP5fFw+tsmWMK0EvWMw20u+T2vqxiY5cG4ta
         iOcweaBBX2JY/WVRz2t/unRpwkLmgBDlgzEj31V1wI5EO1pJjAkPIyKLliV31fqhaygw
         HckA==
X-Gm-Message-State: AOJu0YwVI8xefu8C8JVJIiuPdoQF4PuCHK28Nj2tlSOUxOPKAGgCexdQ
	rNHwVHfgEe/xzcYi/u83q2vM7XnbT4+1vlQs4NEjmzIpK7iXt+1UNkZv
X-Gm-Gg: Acq92OGgFyDBproIZtIL9+pvGG1XndG0oPR89eTuBR0iIKAyU8soDuSDrXehjWsgRza
	Ob8t/fhRSlv/S8wHUQ8CNgCOy8Y7PCG/WPqv/AsKmrTA4wWYWnUgy0pwingdlprHaOB66S8mO79
	cJ1Fgr6YbHNgjiGH4sZIdAg8Mic8P0gQviwAUAW5Dp2WvTNs984QX1hnujFeiY/NiOuJJCqIJwU
	g6I++bPv++cyJFx0QpVgbiaiCL42kt4nQlMhcTnp4EVHi1qS9ipLNzYW2qYbDtShfoNq6Jfj6dw
	yB9Nl6imB4x0YZEpPGYx2YfmlaHZUUj9wOBv20NGTSdiEBfFMwC7GJs0zhVk7HKMDHPfs+FlgeQ
	q0hjvmDuooVRkL4FnFLJrThJ+jCMYd8w37SrR4JPzxeEUzrmGqWgobK0RxZS51k9rtH5brBBji1
	NqCBY+qP/F2wubWl+nwLxNrXipHRN2f/CrmLCz63M2lQn4jkdjAwT7qXsqIyu/pLuEVk++/PHu3
	adKj38=
X-Received: by 2002:a05:7022:f313:b0:136:9ebf:3bef with SMTP id a92af1059eb24-1369ebf3d04mr123434c88.26.1779529414299;
        Sat, 23 May 2026 02:43:34 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:33 -0700 (PDT)
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
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 01/31] cxl/mbox: Flag support for Dynamic Capacity Devices (DCD)
Date: Sat, 23 May 2026 02:42:55 -0700
Message-ID: <4700826deb086665c9e1c643156864eaecfe1fef.1779528761.git.anisa.su@samsung.com>
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

Per the CXL 3.1 specification software must check the Command Effects
Log (CEL) for dynamic capacity command support.

Detect support for the DCD commands while reading the CEL, including:

	Get DC Config
	Get DC Extent List
	Add DC Response
	Release DC

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
---
 drivers/cxl/core/mbox.c | 43 +++++++++++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    | 15 ++++++++++++++
 2 files changed, 58 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index aaa5c6277ebf..7ef5708bf210 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -165,6 +165,42 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
 	}
 }
 
+static bool cxl_is_dcd_command(u16 opcode)
+{
+#define CXL_MBOX_OP_DCD_CMDS 0x48
+
+	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
+}
+
+static void cxl_set_dcd_cmd_enabled(struct cxl_memdev_state *mds, u16 opcode,
+				    unsigned long *cmd_mask)
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
+static bool cxl_verify_dcd_cmds(struct cxl_memdev_state *mds, unsigned long *cmds_seen)
+{
+	DECLARE_BITMAP(all_cmds, CXL_DCD_ENABLED_MAX);
+
+	bitmap_fill(all_cmds, CXL_DCD_ENABLED_MAX);
+	return bitmap_equal(cmds_seen, all_cmds, CXL_DCD_ENABLED_MAX);
+}
+
 static bool cxl_is_poison_command(u16 opcode)
 {
 #define CXL_MBOX_OP_POISON_CMDS 0x43
@@ -757,6 +793,7 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 	struct cxl_mailbox *cxl_mbox = &mds->cxlds.cxl_mbox;
 	struct cxl_cel_entry *cel_entry;
 	const int cel_entries = size / sizeof(*cel_entry);
+	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX);
 	struct device *dev = mds->cxlds.dev;
 	int i, ro_cmds = 0, wr_cmds = 0;
 
@@ -785,11 +822,17 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 			enabled++;
 		}
 
+		if (cxl_is_dcd_command(opcode)) {
+			cxl_set_dcd_cmd_enabled(mds, opcode, dcd_cmds);
+			enabled++;
+		}
+
 		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
 			enabled ? "enabled" : "unsupported by driver");
 	}
 
 	set_features_cap(cxl_mbox, ro_cmds, wr_cmds);
+	mds->dcd_supported = cxl_verify_dcd_cmds(mds, dcd_cmds);
 }
 
 static struct cxl_mbox_get_supported_logs *cxl_get_gsl(struct cxl_memdev_state *mds)
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 776c50d1db51..53444af448d7 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -230,6 +230,15 @@ struct cxl_event_state {
 	struct mutex log_lock;
 };
 
+/* Device enabled DCD commands */
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
@@ -405,6 +414,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @partition_align_bytes: alignment size for partition-able capacity
  * @active_volatile_bytes: sum of hard + soft volatile
  * @active_persistent_bytes: sum of hard + soft persistent
+ * @dcd_supported: all DCD commands are supported
  * @event: event log driver state
  * @poison: poison driver state info
  * @security: security driver state info
@@ -424,6 +434,7 @@ struct cxl_memdev_state {
 	u64 partition_align_bytes;
 	u64 active_volatile_bytes;
 	u64 active_persistent_bytes;
+	bool dcd_supported;
 
 	struct cxl_event_state event;
 	struct cxl_poison_state poison;
@@ -485,6 +496,10 @@ enum cxl_opcode {
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

