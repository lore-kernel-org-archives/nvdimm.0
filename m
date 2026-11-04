Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833410;
	b=d/SLeIaSWwUHjxay8ribxVqxsGptXvmKmxhbyAXGz3giZPmqkqstMArrkpY74XbDgQXW
	 rnX+xWXWMTSE9TVzGqavmjrek/69ZddwFuufRt8kJjsgI2SKEUdQSDN/8X93RXlAOdZY9
	 UpyoVfuKE0L6gFhPkoIscvNtiRdLcAPcH+eE/uWb9ADOujCJOSeAy5+Cg+4JL/6u1zgO3
	 gZ57bLA9NnLfMSCG7djIsqb+hq7IO/nU1r/XL3BQxUEky6rrCBMGmgOxIzjKJDia5u7BC
	 PRTSYm6opV4ym/B6C4Y1MmHAU5/RxxZiNfz0CaLB8q29lSpKOvTjL2eiKS5WB+eAEww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833410;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=JheZtoBiAYlT2jI3FTLiO1Qwu06oef/SS/C/KJIK8ZU=;
	b=RocMRTEjohBV4qeVUE1sxAlxDJ4ymwfjZl+hyb6NHx5po3P85aNA9rIH8q94WlKZIx4u
	 mf3RzMLqqurVHgM3qH8n5Ne2y4B7REUy5+s+FRV9IMKjqV0RVz62ocBDV60jw5MXBz/Ob
	 8kHAMqmXB1wNpThEnoCi9EHEmb+8Y0UMz71miDZVD6RfkZWR9abu6x738epuVb4mIrYa2
	 /ZKIvI0cUyI7fKZV5b6a2qTpDy3c7+yModCBFs6wfqjCPWrvkRODgJxu0C1su1kdwubEE
	 n2rs478mouuqD6Bg9AXurO4su0nDtjkoAgGGs9JaTPTWcNsDg75JS8e0kgMUf/KCxSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0BYO9r2;
	arc=none smtp.remote-ip=209.85.214.181
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C151606EE9C
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:03:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C151606EE9C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0BYO9r2
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ed2b4348fcso825ad.2
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:03:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833395; x=1794438195; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=JheZtoBiAYlT2jI3FTLiO1Qwu06oef/SS/C/KJIK8ZU=;
        b=r0BYO9r2h4KLX5da0e4jB5yjOk/LwNF3vUzDX5yP2D+OEzYPHDRTuN4x908GH//l4C
         rUlNGvKLPQ8jIx4X2BHXYerx8hUE8gkxgBpeJhGOMn7Img4Ss4DylHp9Rgrkjo/ONls7
         UDi7zFBxSZf4lfTTBLeNio72j9jEtTHbA3DjOW8hSNUsABhIDzQwRReJhMSnyOVvmAQz
         t//OSlFO0B5+ePmPkvQZ6RZaJAyqX7/6a1La/5usrjHMJ+ex7bJZmye0lRgEgVcSTEm7
         dZmhtbKtWtHrhL0NVuyrceUR2gP7sYVqdGGv8JisCHRUAc2EOk1qe4mDe8bbag4XCzZ5
         NKvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833395; x=1794438195;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=JheZtoBiAYlT2jI3FTLiO1Qwu06oef/SS/C/KJIK8ZU=;
        b=1EeKmo77W5YL4pYwB4RnE/Drs28RRzD7RsgPTWz+QbplWKs2KIE6AKzzLyAeWf9owR
         UhmMvuiH5SdO9ycqsOdFTLIO+3/Gscu7pPuzqjZoAMBH21Kmp6nNKSc2MZhs/C5R0rL3
         wNbK8bLhm5vcF/tiX944EaiccjVxA1qZ2TnLWwAmkMYl5g/LR2HijlCCpadVNMJJVZ8V
         Jc+2w1iQ6r2aPvf1eYH+bdwj0umUTbsG8RkO+YSOp+bFtCAqfrgnGj0Rfc26mCAfRvQH
         +rRHAI7RMjylW0vTCo3PJYTGe+2m+1OdSpghT6Y8MgqnW86r9OfZ1YLSVtEJE/7CNQv4
         OAKA==
X-Gm-Message-State: APuU4Z+O5a9HvKsg2n8yhqKMk2i12xx3H55CtmosuC8q4BrqgBOPvzh/
	4Qi9mQxCazWcLCsg93auvD4wfiA/EWgHMlYa67ME9MYO8tdDw2m+N6/o
X-Gm-Gg: AYBFou3HS5F9QDIM3zF4RiWL/uBa/KyfjbioDpk/qNEBUV/ZlAaDMWXPQYpy4Q9NHDy
	i9Ih1+Cd6iR01uxtkAY+4PxgOZ1ZCK106KkPK2Ts9c41GfcDTArJtYnuKI/UN+sYVBtDK4iuH7+
	BGVcsU+mww9SDCoy3jB3k8zBa7J+15LIGNQhXFKKVxk1Q1CkBkyqv16BDBlKcdXaqyYx8l1tSPv
	gs3hVwFmyD19IVhM+dUMepr6bv0pI6u6F5E6JcwVLGCoX6Pf7OQe+sqBm0PHSuMmLB3KWUfybAr
	7c4R7pUfazN8ze9tq4RnMIsr3ddQz7FuydlOj4dhlCliKvG45sXWOZRqVgbTLqBZhJ0t2iG4Buc
	Qiq8lUvRUsIOCU0BsfsOXisi0dfL6/rUqa7UZLrx3oHYxtmk+okLyZvVqaqnXDzcGEBv5eaCHQ3
	PE8/kk/Dhdm3WgE9zQNdcFL5KLBGV9rzXiz1gEZ31IvEcNyualEHv4NIVuI3Dsxfad5qyJ30kHG
	ad5TpY0R1twjXryTzsQNOz54nMX1Oa0SBV2N2a0fQBtgMfmN8Y5hN31m7EelCEd4K1HfBJUQHNi
	i39KPcPWbsWac4D7u1taEK6ABBh5cw==
X-Received: by 2002:a17:902:d510:b0:2ea:1b9b:b938 with SMTP id d9443c01a7336-2eb364852abmr160514515ad.55.1793833395260;
        Wed, 04 Nov 2026 15:03:15 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:03:14 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 13/14] cxl/mem: Trace Dynamic capacity Event Record
Date: Thu,  5 Nov 2026 08:02:37 +0900
Message-ID: <20261104230445.66625-14-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104230445.66625-1-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

CXL r4.0 section 8.2.10.2.1.6 defines the Dynamic Capacity Event Record.
User space can use trace events for debugging of DC capacity changes.

Add DC trace points to the trace log.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 drivers/cxl/core/mbox.c  |  4 +++
 drivers/cxl/core/trace.h | 76 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 80 insertions(+)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index a18b41ff5d23..c60c10d7bd31 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1041,6 +1041,10 @@ static void __cxl_event_trace_record(struct cxl_memdev *cxlmd,
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
index 64c6ce0878e2..d7b237203bb5 100644
--- a/drivers/cxl/core/trace.h
+++ b/drivers/cxl/core/trace.h
@@ -1108,6 +1108,82 @@ TRACE_EVENT(cxl_poison,
 	)
 );
 
+/*
+ * Dynamic Capacity Event Record - DER
+ *
+ * CXL r4.0 section 8.2.10.2.1.6 Table 8-229
+ */
+
+TRACE_DEFINE_ENUM(DCD_ADD_CAPACITY);
+TRACE_DEFINE_ENUM(DCD_RELEASE_CAPACITY);
+TRACE_DEFINE_ENUM(DCD_FORCED_CAPACITY_RELEASE);
+TRACE_DEFINE_ENUM(DCD_REGION_CONFIGURATION_UPDATED);
+
+#define show_dc_evt_type(type)	__print_symbolic(type,				\
+	{ DCD_ADD_CAPACITY,			"Add capacity" },		\
+	{ DCD_RELEASE_CAPACITY,			"Release capacity" },		\
+	{ DCD_FORCED_CAPACITY_RELEASE,		"Forced capacity release" },	\
+	{ DCD_REGION_CONFIGURATION_UPDATED,	"Region Configuration Updated" } \
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
+		if (rec->event_type == DCD_REGION_CONFIGURATION_UPDATED)
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
-- 
2.43.0

