Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51473DD85B
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386954; cv=none; b=Rj5XHXLohbIVSUw9+IUC99DrG+q3uEBg2AFrGh//gcyTs1/Ya9FelfTGNbrv9ECBGHi7/2CgaBRMKM0l8+sYoaLHE9aRjx3cWSDCirSUOBIJE50ySNiYK+W/MtfM8uMGTpBclz3YlUHtxeqWoTTJ6igL/tTSWffv5uUHPndlCwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386954; c=relaxed/simple;
	bh=bFADmluE1nbdZ81UzcAdDFQhg1uEZArvsw2RvxTKT80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HwnHm0GnKzgtLs9DYEHY4dIC5gvyv0TvfEgBJANU7RBLoOXjKNq6OjE0oWuVZQbKC6uJdDuf1NPiKxTW6XO24ERwZ4vR6R5aiMbrlfSh9n0tFh5/ZIJWmmr5iZXbaMukjjTGv4Np2kmV89klHRSAyQRfLk19JkM/EeFR4qOnZmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QV7CfPtA; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QV7CfPtA"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30b9e755555so4752478eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386952; x=1782991752; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zK+Ki3YSAWlM2+uaWw1lcPLx9bc+rxQrbsQjDrkuayI=;
        b=QV7CfPtAGjE0EGLmEsKMvPPSClMHvKaOkjRXwsrEjD4nhXPkG6eAwzlfymlanxnoF4
         bScpJavNOKFUyQ2K7+nxNXDo3iRyE+Ojr1ZidJY+lLOqpDiaN3Qt5dVEqmdAxrrrdkN6
         uLSWq5T+wByJxyQqv6QIMdJfcUBic0Zq19pJNUgzkzpZ6kO08K3qVmpe+dtiaagYULFL
         hQbpncZyiTbCiEr67tlC/BVSUK8Ilt7YUgamZgdDkD0eb9LIg5LZOJGH49cHaInpQ9Yd
         jGjtVoRACeaN8rgD2b+2jRs7HyhdbRzo9/NjjaXDgyel0umgMmE+aNuGHn/HxlfatqEU
         NELQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386952; x=1782991752;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zK+Ki3YSAWlM2+uaWw1lcPLx9bc+rxQrbsQjDrkuayI=;
        b=eHvvRw2zK0bxYqICjMTUp847N9gmC4Ph5bR1OUZg4ogA5KaLfCVWomso/Qv7lzRLLo
         +Gcf30uanX350Y14dGojWt+IxJXzijaTyeVW+aGY7+/ciBfiYO/FPYfUs/fN8MLLAaPd
         XHdCmjYy39gH/kU6plOnd+y5KWkfFgqfgQF3usEQ/C2LdJkpfrud6eAiIoDQe0oP0TPm
         o9A/QmATSTY/NPDxLd3rVdN5D3rd/hKQDeBKy1hn0x+Nnn8/6ydn0oWxHsgahJzXtza9
         cw5Ey24kLKx/XHlKb2n0YEfQkD4ECUVq4rQbwwFGnHRAfnE9li4NFxPaiajZNbb9KapP
         t43w==
X-Gm-Message-State: AOJu0YyxnIACOa0khJeemDDfrhr8sWC/IWSBeIYnkieq0II0OSB9hDBy
	2ecyC0/640HoFfKM5nQmYYTGEjkYJLLRifGRHW8HkX/jq7UGB9mKb6pw
X-Gm-Gg: AfdE7cnDx3Wixt3IgXDkqjjgR+Ve6ooHIyxsH7OHkkHtVb9DmEloUxByYjEvXfHJEL4
	VUDaf1ID1pWopyReK6J1PXaQQDRhKMV3XeuYBFxcAD4gORYnqrrsy4/E49Wid/X9/kHKVfcyMs3
	0Iu70lR+0xJvcQdQkNZ3ypMG2tP+XnTgIIFahxbn5E1owmVogT1MH8MN8bqwDWOyAN9AAcdZchJ
	8Z0yUKHqQn7Y3A30/MCv59PsK5P7Y5eBD+TvIfRcwbuIrsitlvBcRXUts16CySGCzcLpKST+JsM
	OJwN92raF1HPPtVYKWO/BdgZGabP3oSlR2CwMIPQGt50pBkEuZV6sYht+r1e51snMkAbuRXi3db
	c3ftB7DU3jj96OLhuzISZNEUJVqnbhYyv4Pn9cN64rCDqO0I94BKvlSiUd7nHOg5VOBPe4TrCh1
	Di9Bc9Hg/o/eB++ghnQQUw6AgwKOj3PswlWYe7EtpY2kMDjoL2jo8Nc18cnzYIu/lSRno6bpen6
	NEqfH8=
X-Received: by 2002:a05:7301:37c4:b0:304:ab8:f899 with SMTP id 5a478bee46e88-30c84bcdac4mr2548007eec.8.1782386951792;
        Thu, 25 Jun 2026 04:29:11 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.29.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:11 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>,
	Fan Ni <nifan.cxl@gmail.com>
Subject: [PATCH v11 28/31] cxl/mem: Trace Dynamic capacity Event Record
Date: Thu, 25 Jun 2026 04:05:05 -0700
Message-ID: <20260625112638.550691-29-anisa.su@samsung.com>
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

CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
User space can use trace events for debugging of DC capacity changes.

Add DC trace points to the trace log.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>

---
Changes:
[anisa: bump comments to reference the CXL r4.0 spec (section
 8.2.10.2.1.6, Table 8-229).]
[anisa: fix partition_index to updated_region_index, reporting it only
 for Region Configuration Updated events (U8_MAX otherwise).]
---
 drivers/cxl/core/mbox.c  |  4 +++
 drivers/cxl/core/trace.h | 75 ++++++++++++++++++++++++++++++++++++++++
 include/cxl/event.h      |  4 +--
 3 files changed, 81 insertions(+), 2 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 6f0d776e7e78..2e56ab639100 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1027,6 +1027,10 @@ static void __cxl_event_trace_record(struct cxl_memdev *cxlmd,
 		ev_type = CXL_CPER_EVENT_MEM_MODULE;
 	else if (uuid_equal(uuid, &CXL_EVENT_MEM_SPARING_UUID))
 		ev_type = CXL_CPER_EVENT_MEM_SPARING;
+	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
+		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
+		return;
+	}
 
 	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
 }
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index a972e4ef1936..e5b88887d11b 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -1099,6 +1099,81 @@ TRACE_EVENT(cxl_poison,
 	)
 );
 
+/*
+ * Dynamic Capacity Event Record - DER
+ *
+ * CXL r4.0 section 8.2.10.2.1.6 Table 8-229
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
+		__field(u8, updated_region_index)
+		__field(u64, dpa_start)
+		__field(u64, length)
+		__array(u8, uuid, UUID_SIZE)
+		__field(u16, sh_extent_seq)
+	),
+
+	TP_fast_assign(
+		CXL_EVT_TP_fast_assign(cxlmd, log, rec->hdr);
+		__entry->hdr_uuid = CXL_EVENT_DC_EVENT_UUID;
+
+		/* Dynamic_capacity Event */
+		__entry->event_type = rec->event_type;
+
+		/* DCD event record data */
+		__entry->hostid = le16_to_cpu(rec->host_id);
+		/*
+		 * The Updated Region Index is only defined for Region
+		 * Configuration Updated events (Table 8-229); report U8_MAX
+		 * (not a valid index) for other event types where the field
+		 * is reserved.
+		 */
+		if (rec->event_type == CXL_DC_REG_CONF_UPDATED)
+			__entry->updated_region_index = rec->updated_region_index;
+		else
+			__entry->updated_region_index = U8_MAX;
+		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
+		__entry->length = le64_to_cpu(rec->extent.length);
+		memcpy(__entry->uuid, &rec->extent.uuid, UUID_SIZE);
+		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
+	),
+
+	CXL_EVT_TP_printk("event_type='%s' host_id='%d' updated_region_index='%d' " \
+		"starting_dpa=%llx length=%llx tag=%pU " \
+		"shared_extent_sequence=%d",
+		show_dc_evt_type(__entry->event_type),
+		__entry->hostid,
+		__entry->updated_region_index,
+		__entry->dpa_start,
+		__entry->length,
+		__entry->uuid,
+		__entry->sh_extent_seq
+	)
+);
+
 #endif /* _CXL_EVENTS_H */
 
 #define TRACE_INCLUDE_FILE trace
diff --git a/include/cxl/event.h b/include/cxl/event.h
index fa3cd895f656..601eae40def9 100644
--- a/include/cxl/event.h
+++ b/include/cxl/event.h
@@ -161,7 +161,7 @@ struct cxl_extent_list_node {
 
 /*
  * Dynamic Capacity Event Record
- * CXL rev 3.1 section 8.2.9.2.1.6; Table 8-50
+ * CXL r4.0 section 8.2.10.2.1.6; Table 8-229
  */
 #define CXL_DCD_EVENT_MORE			BIT(0)
 struct cxl_event_dcd {
@@ -169,7 +169,7 @@ struct cxl_event_dcd {
 	u8 event_type;
 	u8 validity_flags;
 	__le16 host_id;
-	u8 partition_index;
+	u8 updated_region_index;
 	u8 flags;
 	u8 reserved1[0x2];
 	struct cxl_extent extent;
-- 
2.43.0

