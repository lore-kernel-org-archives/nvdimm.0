Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1CD820F5B4
	for <nvdimm@lists.linux.dev>; Tue, 29 Oct 2024 20:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730234180; cv=none; b=mPvGbClq/LZhW+JZdicSa6n3XwAgpXKCmq1im7NtMPuxLSRmPRT0Y0q7G0TMuBR74zwtD4MG1UrmqD3nC2wx+xgugZwdYUUe5UNhrzDbW4GniPw03Z7XcnLi5NPqplRUslW6Fin23gmb8Bakac5rGYJLq9yGaSuY7BgCumE+Gh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730234180; c=relaxed/simple;
	bh=ryKKJcPTIqNhXRJn5oaYSJccpjOrLPV1ntassCvEvZo=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ZXfIBR4kq6qjsaCbawtaQjnUq85thVGLLJxrs7GslWaIwAl9qPsCRnQyPb67bYAf2d/c7vKiNFsVHrZEcZVEOIsCAHDmxllxRqZO9Uc8JRY2IlrVFgw2TKd5G+yp1+igXKUg8oqdpoR4yjxLgci2S7vslilXzaruZLKLa8eM4eY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jS8bPZ1k; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jS8bPZ1k"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730234178; x=1761770178;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=ryKKJcPTIqNhXRJn5oaYSJccpjOrLPV1ntassCvEvZo=;
  b=jS8bPZ1kcNgUlh4TwumMXIblq0yCb+wASdS86DT6uZlgkvrmCYma9lCz
   7C2Lq1VbsfA9AxOC9YaxwzSbRIj+9KE8+nKsOFV1yXlPenRDzba+zqnZy
   LIp1TpuRWwehiSqwLeehy6GYWgp6ynhoW5GPfXaW5H8P4NmbJTBjKdUuS
   XuAxcEi8lCwMrYHdGT06YdAQQmAE/z5fVEFDzt43vdLCFxtSecKlQOSS+
   smavZ8WpkWRN8jtlSU8DYtZWacr+6nxSJ2jRw2HriIaxyY1qnnNqA0Vqg
   w36GDOd1r8QiniOqJwEi5OCw2SMZl/rcnQegtQ//HQJJAbQ2pjMd0Ddwp
   g==;
X-CSE-ConnectionGUID: /r2YGMhwQKCwTdXJIWDiuQ==
X-CSE-MsgGUID: arddrroFQW2LGZN/5En06g==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="52457683"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="52457683"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:36:18 -0700
X-CSE-ConnectionGUID: eLc4KMtcTBOOi4A6DfULgg==
X-CSE-MsgGUID: 51fiLA1zRUmwnUGX3JbdiA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,243,1725346800"; 
   d="scan'208";a="119561346"
Received: from ldmartin-desk2.corp.intel.com (HELO localhost) ([10.125.108.77])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Oct 2024 13:36:17 -0700
From: ira.weiny@intel.com
Date: Tue, 29 Oct 2024 15:35:00 -0500
Subject: [PATCH v5 25/27] cxl/mem: Trace Dynamic capacity Event Record
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241029-dcd-type2-upstream-v5-25-8739cb67c374@intel.com>
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
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1730234086; l=3635;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=xpnq087mIDPtTbUC6b/M7wTZVMYGc6/vP1dhcs8GdXQ=;
 b=H5E1OjfKHr5DCPFX61UbY3oAGOj2g/IbFzZYVZNfgEta9HmR1nIzGrOZdj3+wjvA8mUjzJlDn
 X2CNbM5Zrk1DhlnA92+YPtfQczewWwf6igrjqgFJyArL4QeHxWAdqLW
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

From: Navneet Singh <navneet.singh@intel.com>

CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
User space can use trace events for debugging of DC capacity changes.

Add DC trace points to the trace log.

Signed-off-by: Navneet Singh <navneet.singh@intel.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Co-developed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes:
[Jonathan: use %pU for tag]
---
 drivers/cxl/core/mbox.c  |  4 +++
 drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 5cfa5e34e679b5665650d8b2ada47018e5facb1c..e1cfe4b16d5967d27ee6e38059dc7441c5d3341c 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -995,6 +995,10 @@ static void __cxl_event_trace_record(const struct cxl_memdev *cxlmd,
 		ev_type = CXL_CPER_EVENT_DRAM;
 	else if (uuid_equal(uuid, &CXL_EVENT_MEM_MODULE_UUID))
 		ev_type = CXL_CPER_EVENT_MEM_MODULE;
+	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
+		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
+		return;
+	}
 
 	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
 }
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index 8672b42ee4d1b376063b09d29922fcce83a70168..d4526f06cf2a2d0a4b4bc5f9e00238aa43a16e35 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -731,6 +731,71 @@ TRACE_EVENT(cxl_poison,
 	)
 );
 
+/*
+ * Dynamic Capacity Event Record - DER
+ *
+ * CXL rev 3.1 section 8.2.9.2.1.6 Table 8-50
+ */
+
+#define CXL_DC_ADD_CAPACITY			0x00
+#define CXL_DC_REL_CAPACITY			0x01
+#define CXL_DC_FORCED_REL_CAPACITY		0x02
+#define CXL_DC_REG_CONF_UPDATED			0x03
+#define show_dc_evt_type(type)	__print_symbolic(type,		\
+	{ CXL_DC_ADD_CAPACITY,	"Add capacity"},		\
+	{ CXL_DC_REL_CAPACITY,	"Release capacity"},		\
+	{ CXL_DC_FORCED_REL_CAPACITY,	"Forced capacity release"},	\
+	{ CXL_DC_REG_CONF_UPDATED,	"Region Configuration Updated"	} \
+)
+
+TRACE_EVENT(cxl_dynamic_capacity,
+
+	TP_PROTO(const struct cxl_memdev *cxlmd, enum cxl_event_log_type log,
+		 struct cxl_event_dcd *rec),
+
+	TP_ARGS(cxlmd, log, rec),
+
+	TP_STRUCT__entry(
+		CXL_EVT_TP_entry
+
+		/* Dynamic capacity Event */
+		__field(u8, event_type)
+		__field(u16, hostid)
+		__field(u8, region_id)
+		__field(u64, dpa_start)
+		__field(u64, length)
+		__array(u8, tag, CXL_EXTENT_TAG_LEN)
+		__field(u16, sh_extent_seq)
+	),
+
+	TP_fast_assign(
+		CXL_EVT_TP_fast_assign(cxlmd, log, rec->hdr);
+
+		/* Dynamic_capacity Event */
+		__entry->event_type = rec->event_type;
+
+		/* DCD event record data */
+		__entry->hostid = le16_to_cpu(rec->host_id);
+		__entry->region_id = rec->region_index;
+		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
+		__entry->length = le64_to_cpu(rec->extent.length);
+		memcpy(__entry->tag, &rec->extent.tag, CXL_EXTENT_TAG_LEN);
+		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
+	),
+
+	CXL_EVT_TP_printk("event_type='%s' host_id='%d' region_id='%d' " \
+		"starting_dpa=%llx length=%llx tag=%pU " \
+		"shared_extent_sequence=%d",
+		show_dc_evt_type(__entry->event_type),
+		__entry->hostid,
+		__entry->region_id,
+		__entry->dpa_start,
+		__entry->length,
+		__entry->tag,
+		__entry->sh_extent_seq
+	)
+);
+
 #endif /* _CXL_EVENTS_H */
 
 #define TRACE_INCLUDE_FILE trace

-- 
2.47.0

