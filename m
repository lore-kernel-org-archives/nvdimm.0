Received: from mail-dl1-f43.google.com (mail-dl1-f43.google.com [74.125.82.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9709639280C
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529475; cv=none; b=H6OSoN8FvEpYH7XPHQ2Z6/aAqmQdFp8Yt1PmxtxqXD8cprckywFAQ6Au8lai/UDOFswfEkrAnvfFaiYRW32mdOHxpn4Usz+bKtMuaa0AQjaUWAkdsdYYiWiCiFViFl968SvOSS6LPDxb5Z7k5ZcsuY8pkKSzG8j+ByrGkDTw4go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529475; c=relaxed/simple;
	bh=9Vatsa44EJ16grZ7fWkxrmMrz8YLYk1hyZyIQz21lpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAwHW0gM9Oz1OIS14sm3OARSW2MVhI3ye22WseTSsXkpoQrxFhVxRJg5yyuV7GX+qQwGuaR1LGqyq7JjQAtFEDOxPcV4XzYc0gfzPsf5jKHbj5iGA5dodz/9bu1e1qgamnTn/euwwQzTDYMtLkuaEdprfp92cso4RUoTFzBkfYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XiDvqLBH; arc=none smtp.client-ip=74.125.82.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XiDvqLBH"
Received: by mail-dl1-f43.google.com with SMTP id a92af1059eb24-134ac81c445so10219230c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529472; x=1780134272; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVlxVqb/noEE3wo4FJD/Az4q6LLE6ik5ntk4peDmfoE=;
        b=XiDvqLBHCx3R/5dtUlDdiPgRAh3d/rOGTBNwO/RffGOFOC/Xp6kIX3OLjsJd6BijVl
         0mq/q3wUjyXMcuyr3rzzdoHvO/hJC7CBJGejZOMG4zLtqzEL3DRX1XXLIqp7cLHoa5w7
         apLC9nul1SDrl53xuf7Wx9zbAcAYpSKTLSIz/a1tCve842rMwaTjPDlEmHy9jUvlUv2E
         0vcKppYOhtvNCZO9kfFBV7jaSfl7ObOJgHxPMmI8StQ/YtZPPYBxp2HkFzRFvkexqpQl
         CtGhAXdNADBRw6/9KMYJHk6tDSpi4VfBnghgF8XthuQOrdVEqH47mvgmACm7SDG+MWdR
         ba3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529472; x=1780134272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZVlxVqb/noEE3wo4FJD/Az4q6LLE6ik5ntk4peDmfoE=;
        b=SAyF+Kbex7sVAEdM8D2vBQ/3a17cm4WMHMuq/LG82BQTBP6Rb3/49hx66pEjinREur
         EhJ08nRpzd7jhBaSg1RR3rqbNVPyhAy1I6S/NNvCrwJCjH2zvZDRnT2UOrV3vxZhz/Bv
         UIyuRwJBVDXOhILeVYnKK/FodvNaVWULxh7y7MHnSVTgsBdmb56rSdLS3mkfTPf4Wfq7
         LsJ4J9uaTDkISf+ZMbMq9X4EaugGrdGUyYR0qHu83hYvX5EkuIn53mZy/2R+/DJEEplc
         OAjLpFDf5nMUH9VvywhmHuzko+dou94xMlg4twt9btFGl4BH+bVIcnovdtI29Y7ylMYR
         9YZQ==
X-Gm-Message-State: AOJu0YzYmC4r3fKqNJR0uHBkYOzvoGbk3b48Vp2j3xEcWzI0nbNu2ha4
	oADEVk72qf+oDzpYGd4bf+aLg+rAjU7egUOyKF9WxUddgIJqwlaOroEr
X-Gm-Gg: Acq92OH2PD5iLefKK/bSA2fe0pNEEuxXZDkAF/byC5NRUw2aztboiqtmgtDLlfVFqQt
	RtpYKW+sO1Dvpz9LSPjyS6kkgQf9Ve3bTto/v31WPdBMzpszh+cpvao2KwwTQI7iC6NhNUfnINY
	os1ZSUBcHGWpQ6BQmTJsV/XQQ9/6UsOBgjqOxhvfBurfPrRwqDurIYrZDpDN9FxPcYoaOch/hYO
	vecaR++ZTj+1XKeumjK9QwGJj6InGq/psYZdmDf4x3+lGjFDVqTOw1wqrvDhfddJ75K1LG4wqVj
	4umxQLJkoQRpFsyJrTw/ybQHSoxn5JrqJYc8HkLYPN6LFe1ZQt4Bi3I4ZLsL/0lStH+gpT3uXRy
	2FF40tyii1/g0BgYbiPhbnmCsDbD6Ii64ksjXOzTQK4ZyPt5oXDhEvzjic297TdUiHntcYQlztz
	TzxSvYIVPtYpa2nl3w/9DbdDvsXfAoe3Yjwz57cTQS8YVTM9eRTa9O5og+TSGgaV2WQ6IxRElQz
	2JjJ6lxlu0jJcilMA==
X-Received: by 2002:a05:7022:ff45:b0:12d:b7e5:a691 with SMTP id a92af1059eb24-1365f80f603mr2633678c88.7.1779529471639;
        Sat, 23 May 2026 02:44:31 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:44:30 -0700 (PDT)
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
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Fan Ni <fan.ni@samsung.com>
Subject: [PATCH v10 28/31] cxl/mem: Trace Dynamic capacity Event Record
Date: Sat, 23 May 2026 02:43:22 -0700
Message-ID: <54f9e863fac7a9c040267a13cd36aa7415e29f4f.1779528761.git.anisa.su@samsung.com>
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

CXL rev 3.1 section 8.2.9.2.1 adds the Dynamic Capacity Event Records.
User space can use trace events for debugging of DC capacity changes.

Add DC trace points to the trace log.

Based on an original patch by Navneet Singh.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/cxl/core/mbox.c  |  5 ++++
 drivers/cxl/core/trace.h | 65 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 486110e1c03d..271f4556db85 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1030,6 +1030,11 @@ static void __cxl_event_trace_record(struct cxl_memdev *cxlmd,
 		ev_type = CXL_CPER_EVENT_MEM_MODULE;
 	else if (uuid_equal(uuid, &CXL_EVENT_MEM_SPARING_UUID))
 		ev_type = CXL_CPER_EVENT_MEM_SPARING;
+	else if (uuid_equal(uuid, &CXL_EVENT_DC_EVENT_UUID)) {
+/* FIXME still valid? */
+		trace_cxl_dynamic_capacity(cxlmd, type, &record->event.dcd);
+		return;
+	}
 
 	cxl_event_trace_record(cxlmd, type, ev_type, uuid, &record->event);
 }
diff --git a/drivers/cxl/core/trace.h b/drivers/cxl/core/trace.h
index a972e4ef1936..421e492d1b3f 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -1099,6 +1099,71 @@ TRACE_EVENT(cxl_poison,
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
+		__field(u8, partition_id)
+		__field(u64, dpa_start)
+		__field(u64, length)
+		__array(u8, uuid, UUID_SIZE)
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
+		__entry->partition_id = rec->partition_index;
+		__entry->dpa_start = le64_to_cpu(rec->extent.start_dpa);
+		__entry->length = le64_to_cpu(rec->extent.length);
+		memcpy(__entry->uuid, &rec->extent.uuid, UUID_SIZE);
+		__entry->sh_extent_seq = le16_to_cpu(rec->extent.shared_extn_seq);
+	),
+
+	CXL_EVT_TP_printk("event_type='%s' host_id='%d' partition_id='%d' " \
+		"starting_dpa=%llx length=%llx tag=%pU " \
+		"shared_extent_sequence=%d",
+		show_dc_evt_type(__entry->event_type),
+		__entry->hostid,
+		__entry->partition_id,
+		__entry->dpa_start,
+		__entry->length,
+		__entry->uuid,
+		__entry->sh_extent_seq
+	)
+);
+
 #endif /* _CXL_EVENTS_H */
 
 #define TRACE_INCLUDE_FILE trace
-- 
2.43.0

