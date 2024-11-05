Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C071EABC1
	for <nvdimm@lists.linux.dev>; Tue,  5 Nov 2024 18:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730831928; cv=none; b=laLuBw//ZNXVvWtUgONEub132zJZROkogdXkEhjTKP/JfrXH1E7DloxhDKkEKvlaE18NC+/YoGDZGuvtH/wjvblJ/AXxeN5Hc9awCeUDgYe0LAb8f57AVjrtS9o8n9K1x5YpM0OCy+l3TjixHczzgZHW8EuZTi+vFkzW4kZTZ5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730831928; c=relaxed/simple;
	bh=JoHlfcxAJftVbYk8BRgv0BTrjQVm0Kl9TKT0u5ElTVo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=HDt6fTZuuZjwKNXT2Q8VMrdXG7OUZZzRl7VZMUcyilNBZwpUfr5AKoCqvqhmskpUxmiTrBRM6ctwFv8fQPPB6xWhItf4GlcdEOMSxJaPefmIC2maPsikxRTkyq48taWtd4T0G3/faq6k7XpMVgysxIUQQtxeyNUyqXK5j3WAXIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=LXtSL2ho; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="LXtSL2ho"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730831927; x=1762367927;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=JoHlfcxAJftVbYk8BRgv0BTrjQVm0Kl9TKT0u5ElTVo=;
  b=LXtSL2hohyTcK4g5fUqXsGJQ5yFBw4gXrUM4zdPQqAVNPXUFifYtWUo5
   hOEAogCf0n72Dk7Q4MnlI4OHABwvWu6M60jWV6B4I4qXSJeBGAkXfgvPo
   Vd98YxrK29/rIkr0vW6i+MLGBK+6U4MNiucBg5YeAFnKTDj4YLxlzBTtm
   TTUC8isbm8KsfbndZ4Ldd9F/ZnWG+keu0hT6JQJdAR/pGHdqjAcW8Jfeh
   iIgkbome4ofnPYTeCmrEaX058P8umGDUYXU3n5wzeLFhTAvEIRrTSQVlR
   dN5Fntv3AMtfFElcsYuiSpdKQbHUwUigIuEu1rcy+uYZtrj9xOTVu0L7h
   g==;
X-CSE-ConnectionGUID: i63GXqaQT72opBxVmeaFYA==
X-CSE-MsgGUID: 1EZ9NgacT222F7Bww6qWmQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="41153142"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="41153142"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:47 -0800
X-CSE-ConnectionGUID: PtdsNPUHRLerhpO5QExBmA==
X-CSE-MsgGUID: V18NgdGeSqySG1xsEQPgXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,260,1725346800"; 
   d="scan'208";a="84235667"
Received: from spandruv-mobl4.amr.corp.intel.com (HELO localhost) ([10.125.109.247])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2024 10:38:44 -0800
From: ira.weiny@intel.com
Date: Tue, 05 Nov 2024 12:38:29 -0600
Subject: [PATCH v6 07/27] cxl/mbox: Flag support for Dynamic Capacity
 Devices (DCD)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241105-dcd-type2-upstream-v6-7-85c7fa2140fe@intel.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730831904; l=4110;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=aSCfDRIC6e3FEZwRSJpd4dHA/NNKjjYvtAtyGCqpz4Y=;
 b=BasEQlyNSuAhSC4VrmbRfobUsKVC7ztSsZTmmgi03xVdYyOdZTWunDEXk5e7edwE1makB57Aa
 /vCPNBo4EF7Bnz488ZdqbC7gvXx+Cp/n5xBCje12wR7UX7+i+Skf+xK
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

Per the CXL 3.1 specification software must check the Command Effects
Log (CEL) for dynamic capacity command support.

Detect support for the DCD commands while reading the CEL, including:

	Get DC Config
	Get DC Extent List
	Add DC Response
	Release DC

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Li Ming <ming4.li@intel.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/mbox.c | 33 +++++++++++++++++++++++++++++++++
 drivers/cxl/cxlmem.h    | 15 +++++++++++++++
 2 files changed, 48 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 5175138c4fb7382426145640d7d04967b02b22dc..aac3bfc0d2c3f916dd870b9f8288b24d90fc9974 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -164,6 +164,34 @@ static void cxl_set_security_cmd_enabled(struct cxl_security_state *security,
 	}
 }
 
+static bool cxl_is_dcd_command(u16 opcode)
+{
+#define CXL_MBOX_OP_DCD_CMDS 0x48
+
+	return (opcode >> 8) == CXL_MBOX_OP_DCD_CMDS;
+}
+
+static void cxl_set_dcd_cmd_enabled(struct cxl_memdev_state *mds,
+				    u16 opcode)
+{
+	switch (opcode) {
+	case CXL_MBOX_OP_GET_DC_CONFIG:
+		set_bit(CXL_DCD_ENABLED_GET_CONFIG, mds->dcd_cmds);
+		break;
+	case CXL_MBOX_OP_GET_DC_EXTENT_LIST:
+		set_bit(CXL_DCD_ENABLED_GET_EXTENT_LIST, mds->dcd_cmds);
+		break;
+	case CXL_MBOX_OP_ADD_DC_RESPONSE:
+		set_bit(CXL_DCD_ENABLED_ADD_RESPONSE, mds->dcd_cmds);
+		break;
+	case CXL_MBOX_OP_RELEASE_DC:
+		set_bit(CXL_DCD_ENABLED_RELEASE, mds->dcd_cmds);
+		break;
+	default:
+		break;
+	}
+}
+
 static bool cxl_is_poison_command(u16 opcode)
 {
 #define CXL_MBOX_OP_POISON_CMDS 0x43
@@ -751,6 +779,11 @@ static void cxl_walk_cel(struct cxl_memdev_state *mds, size_t size, u8 *cel)
 			enabled++;
 		}
 
+		if (cxl_is_dcd_command(opcode)) {
+			cxl_set_dcd_cmd_enabled(mds, opcode);
+			enabled++;
+		}
+
 		dev_dbg(dev, "Opcode 0x%04x %s\n", opcode,
 			enabled ? "enabled" : "unsupported by driver");
 	}
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 2a25d1957ddb9772b8d4dca92534ba76a909f8b3..e8907c403edbd83c8a36b8d013c6bc3391207ee6 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -239,6 +239,15 @@ struct cxl_event_state {
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
@@ -461,6 +470,7 @@ static inline struct cxl_dev_state *mbox_to_cxlds(struct cxl_mailbox *cxl_mbox)
  * @lsa_size: Size of Label Storage Area
  *                (CXL 2.0 8.2.9.5.1.1 Identify Memory Device)
  * @firmware_version: Firmware version for the memory device.
+ * @dcd_cmds: List of DCD commands implemented by memory device
  * @enabled_cmds: Hardware commands found enabled in CEL.
  * @exclusive_cmds: Commands that are kernel-internal only
  * @total_bytes: sum of all possible capacities
@@ -485,6 +495,7 @@ struct cxl_memdev_state {
 	struct cxl_dev_state cxlds;
 	size_t lsa_size;
 	char firmware_version[0x10];
+	DECLARE_BITMAP(dcd_cmds, CXL_DCD_ENABLED_MAX);
 	DECLARE_BITMAP(enabled_cmds, CXL_MEM_COMMAND_ID_MAX);
 	DECLARE_BITMAP(exclusive_cmds, CXL_MEM_COMMAND_ID_MAX);
 	u64 total_bytes;
@@ -554,6 +565,10 @@ enum cxl_opcode {
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
2.47.0

