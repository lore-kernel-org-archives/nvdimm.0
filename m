Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484C23D8907
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386919; cv=none; b=ceQqbUez4RIQvWJVAM1cVCS4XAhOXNThgrn2PnW/s8/TqoH62dwpZXdQAGjLjMvvkaIVnc3TgXI3+ZG9HHm/fW5xCnlQdTq3i4bTQpzFHm06R7Z8HAjw9kA57iUZPyEIFAFSi27tCHx68bryBZs2JxJ61VERrJPtxK86i00Tlkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386919; c=relaxed/simple;
	bh=pRpHyanrZqHDb85R3QQAE0iGNcoHJQR3GBO9g0jR6bg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=itefUjhAkQ/H8OCphaG4qWduo8JX/n9bGGvk/A5k+66+ZD4DXjQIxeAE5RPErebWO0E6gyzZHTRHvweT+ocjSuJDPvRS0tovUnZm+srXThitlF/9VRco4F5ydYaOwO9HbyNVzKdoK/aJVZsnGPyOajTtrcfqBsU/1Q6L58jNtuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=pevTx+9J; arc=none smtp.client-ip=74.125.82.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pevTx+9J"
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-30c09f29b64so661972eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386917; x=1782991717; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UgiBSimmdGNU6Nje679vrsJQbrZsmI3lN+XZE3w4lfM=;
        b=pevTx+9Jwbvbca95zajbrwdXGxiBIWnez5KcRsMok7smcc2c0+LA/yl5qEh2Zj+EEL
         0bh5h+SCMhrPyAJobh4G4YyGqSBuX1rFr0CFzZVu1+HzRFwvnVx/iAwV0b/VrT2zYJ5Q
         ccDzYoEAbw23hDMPzF8ClHXsRrSTwiCveg3Z6Vebm9J60GeqDIn2ua4X8ZUnRAbe19b9
         vM4TZSD+T6y7XlRhNmh5oNPH4zZMRaGsyOl8Qn4iiUpg175eEkqHkAywhlQduBwkR2JS
         35TFFlPLmOxuq891jwyXXxIpHx35Vka9Wd/tLlu+EvCl5pJFmNjOEgNVXuIggikPdFBS
         3MiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386917; x=1782991717;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UgiBSimmdGNU6Nje679vrsJQbrZsmI3lN+XZE3w4lfM=;
        b=jw7JsHuKP8J29VMzHykLjdMUagw0WKKwUeXopkFMuo26p1aUU17XCtYs/NWYfnTipb
         o+vS56bjrFfzD8vd0VNy3JYxcPAVOVOumUGiFNzkSkUFSrxlciYdsnR0ZYF2ZuWOA2lF
         Fz5n5wganWdu6jycVNCzmPGjT6fOyn2R3UbUWPCbVVTeLIFNRLoijk6IGMdmTl5UQmlB
         9xxEdo/dV+eKKn5fmcUsbMGdp7MxlqM0YqleBc6qBg2csL5vy5ywilC0R8jEkot31Jzp
         ei5mpCBQ5iM8824+UcczYjAHDEtJJxBtyU9E7YSipiLmhWP3JvYKzqDtUMhTwjdx/J8U
         WOxQ==
X-Gm-Message-State: AOJu0YxVKyUq6x+VxgLIZCx+IeXXukJpnVOtw02QxhNVTtyoXBP8mg8n
	vTnSAlptyRtfy9CgMJrEdhV+nfRGOmnleNwFcHYund+xqk0GUKkUa6Zt
X-Gm-Gg: AfdE7clv8SpHTbw22HjczZsTEs3iAx5mfmXYNDl01783Jzk/xrs6ybTxVh7vA0Xol3L
	kAqncNHhQo2WyU99+2gU5SGZAVD8znjEj0j+ljeuoeHG1z93QX/hQ44F5exhKbFvj3asBFGxFoT
	Ztp9D+SdlvHedbbYx/1D71cPq5uIRGC0CcUQH5yCVoJmR/YsXIbrp8Ap/y3aiM/U9bpzJ0vrNAm
	cfiSR+sFMkZv0iQx0Tg7WP8bpPlZu7VmAx5N8P2rwzMQNy838uzMCuQt1MrI3EnV3IZqSwbQQC2
	Rv1DvSZViNM+vg5Eob77TNZiU2hXtCzaxh4cOTMEmcNN+G8CjBOQA90R1ee+GMX0HrynWwpS121
	cMWlBDxYLaG4ASqqp8MOU4ytOixxTa7815buyPtVRz0jD0WRldH26WKrpYVuVQihGTyYPxC34aD
	HKn9d4+4OVjF6cXK6rSj/eCwUZg5SM7g4WsRlpGoTeqy6+MrLaNB12ALrDs+T8pErhGj3e
X-Received: by 2002:a05:693c:2a12:b0:30c:5506:4415 with SMTP id 5a478bee46e88-30c55675d6amr6930347eec.19.1782386917365;
        Thu, 25 Jun 2026 04:28:37 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:28:37 -0700 (PDT)
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
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>
Subject: [PATCH v11 11/31] cxl/core: Return endpoint decoder information from region search
Date: Thu, 25 Jun 2026 04:04:48 -0700
Message-ID: <20260625112638.550691-12-anisa.su@samsung.com>
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

cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
The search involves finding the device endpoint decoder as well.

Dynamic capacity extent processing uses the endpoint decoder HPA
information to calculate the HPA offset.  In addition, well behaved
extents should be contained within an endpoint decoder.

Return the endpoint decoder found to be used in subsequent DCD code.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 drivers/cxl/core/core.h   | 6 ++++--
 drivers/cxl/core/mbox.c   | 2 +-
 drivers/cxl/core/memdev.c | 4 ++--
 drivers/cxl/core/region.c | 8 +++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 9ed141fa1334..1e3f19d8c9a3 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -56,7 +56,8 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
@@ -69,7 +70,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 	return ULLONG_MAX;
 }
 static inline
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	return NULL;
 }
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index bdb908c6e7f3..2ab400788824 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -964,7 +964,7 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 		guard(rwsem_read)(&cxl_rwsem.dpa);
 
 		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
-		cxlr = cxl_dpa_to_region(cxlmd, dpa);
+		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 		if (cxlr) {
 			u64 cache_size = cxlr->params.cache_size;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 20417db933aa..1a2b4d8bdd76 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -320,7 +320,7 @@ int cxl_inject_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		return rc;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison inject dpa:%#llx region: %s\n", dpa,
@@ -389,7 +389,7 @@ int cxl_clear_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		return rc;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison clear dpa:%#llx region: %s\n", dpa,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index ba03ec5e27c3..f6e93bc59ae7 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3001,6 +3001,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
+	struct cxl_endpoint_decoder *cxled;
 };
 
 static int __cxl_dpa_to_region(struct device *dev, void *arg)
@@ -3034,11 +3035,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
 			dev_name(dev));
 
 	ctx->cxlr = cxlr;
+	ctx->cxled = cxled;
 
 	return 1;
 }
 
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	struct cxl_dpa_to_region_context ctx;
 	struct cxl_port *port = cxlmd->endpoint;
@@ -3052,6 +3055,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 	if (cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
+	if (cxled)
+		*cxled = ctx.cxled;
+
 	return ctx.cxlr;
 }
 
-- 
2.43.0

