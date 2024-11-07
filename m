Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A26E0218942
	for <nvdimm@lists.linux.dev>; Thu,  7 Nov 2024 20:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731013170; cv=none; b=c1uBJgNF5axNrZZV2rP0YcyDOxwRYtwEyuCTA5BRCxvnz9Sl7y5Fu+Kqc4GgalFROOTq9zxwou8DXhvQ6yfhDgGqSqepGoqoM8CcvWEopil8+wnq9m5vRvZsjG7vydips0L6pwDzwnW7LiC81hUn1tO4gaOwJTvy0hzvOEf0sZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731013170; c=relaxed/simple;
	bh=nTzBiYM0ZGEhiXRDqoR0889r/eTviFwdO8Ts8yXZInw=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=XUuZyl5QMGJyQL6DJNGh2hjK2krCv388WGxrt7FxC/ovqQQMyLefCo5S3n3z+oOrNwdLAHONBddPFpGWsgvsx2NxaYNVYiGYgj2/KsZNUYLTuFUgvBEXO7KdjjjLZCpXg7r4Ad1t0Y5S9phqruGWjNrIHF4ekbcU/zCniS9osnA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=WxFJ1v5F; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="WxFJ1v5F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1731013169; x=1762549169;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=nTzBiYM0ZGEhiXRDqoR0889r/eTviFwdO8Ts8yXZInw=;
  b=WxFJ1v5FXb747dBXt21DVxlWOxQ+aFcYdg8rOZJy1O2a9Pg6Ard2JFlz
   ITRHwQkG7WwLxUX4oD1e3Z7JLkAVpoku8YKdhADDfE9zFYUsISeLZwmZL
   5AIJagkpN17reEOCfCSgb5/DuZiPcThQ4lblTlfb2ENe1i3sThhlYjHTF
   mX5lA9ubnGhKViyA0VyMWRTgAqEHIhzo+NmwWVD91Txc794bqGMrAmOAH
   RXob1yCGbsdhXHrttgioVXTt9l5+zzHPxOEjwgmLaaI5exeMu9puzkOa0
   PGnvMr/D0MpiPcWy4nN11TsQM05mPrxAa8cCsjNC4LNKvaxz+/1w2zI6n
   Q==;
X-CSE-ConnectionGUID: iAjYpHx2T4qjxgtGbpAWBQ==
X-CSE-MsgGUID: vPfQ+uhKS2SAxQaVzeD9RQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11249"; a="33727900"
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="33727900"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:28 -0800
X-CSE-ConnectionGUID: yRYjAStDQZKbpdB/esBiCQ==
X-CSE-MsgGUID: kLHVG+gJRWmfP03JbbHSFg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,136,1728975600"; 
   d="scan'208";a="89876029"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.125.110.195])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Nov 2024 12:59:26 -0800
From: ira.weiny@intel.com
Date: Thu, 07 Nov 2024 14:58:43 -0600
Subject: [PATCH v7 25/27] cxl/mem: Trace Dynamic capacity Event Record
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241107-dcd-type2-upstream-v7-25-56a84e66bc36@intel.com>
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
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
X-Mailer: b4 0.15-dev-2a633
X-Developer-Signature: v=1; a=ed25519-sha256; t=1731013104; l=3591;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=vaAw0rjPm835wNAX6U7iwIQUmgsQgCIKUhARp6y953I=;
 b=NROw/mk2M8pm3PbtWDijQxm9w4vsjzu7l1WEsIQdGivOL/prKxB7y3JylDRE9+K3YGw6k5RFQ
 zQmdcQNpfDHB+3LNrEWCZ6zs7xQsBKkUDzj6XSzoUyPwhOMTLEVCDsK
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
 drivers/cxl/core/mbox.c  |  4 +++
 drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 69 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index e0030166ea185f8ad9194f597906d61497897654..8261ce126a4bd23e5f717a9035f75668753ec276 100644
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

