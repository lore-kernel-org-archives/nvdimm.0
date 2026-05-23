Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 117903876BF
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529444; cv=none; b=qMFXmpcZORm5WIeaJmL/joHRJZR6UAz8nHdyopCxSXWQJGit7YMejKkMpJNw7LkoA5lWrzbZ3cC6XOcmtnfZAxpJLxpy21+7xYbWJfqJbPUd5pr2X0GTYxgGFtTfoTJd+6bp8ZgcIquHWwnCcn4n+7Ia8csfE6LOlY4A80VHkh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529444; c=relaxed/simple;
	bh=z38R1UrW2A3fP0de42veAZZx0/POxEvJRZoYfeRXlVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+pzZxp3sASZsseoUtj26jQRpvt/3KBOiVOqiVOqjv8SDh/qWTabIbPWAh+94Q5aVirfmjjDx+IbU14ZImZax04W2CC+Z6CnJMq7uKGEL6v7sE/iUknlj5A8IJJ/v5cLgfwQO853EyR2QboNc8KbWuDB2/NXs0t9MsCOKkXgphM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hFZ4xn3F; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hFZ4xn3F"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1363e78746eso3080017c88.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529437; x=1780134237; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KYd36Ajui1jTWwp0Hnf0okuHH/+vG5b+1VP/sgdrc0=;
        b=hFZ4xn3Fq9nuuqyJbIShgGawSSxIqnwi0YG8GXaB6HqgyOxEnNg5l8bvslhRGW1cFi
         9I5E17z3A9PbmhcU5NDceiYlEHqi/+g7/3NSj3Dh3QfcXohC1e2nsPuSPT3lf1IBNjJH
         znuG4mkqdCE7Kkni/CxczFNb+uk2Ezb97hJjPp03h3l6eIcIajyoiiFYDjcZq1R1xbnW
         nzSoH746sXktdzi+joxTi9OFZBppuaWyq1IrLVVgh+EI5tmK4XYFQWPu+ldMdnmeTLYq
         yhR3FG6IPrPi7Rx8akjWekFR6bMpM+661FNniO7UxSrUDI2yE83Tvqn56Yb4zrcE16Sx
         KTYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529437; x=1780134237;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+KYd36Ajui1jTWwp0Hnf0okuHH/+vG5b+1VP/sgdrc0=;
        b=GNFGH7up+HbABrf57KrhjlakUbYTVc+GARmtLHw7lUdB3RUwjaUMGMz22A94NOdlbI
         95xu8cvZ231ch+i1Pc9txudNtOjJHi/soDm3eMW/YRX/oeYMgxAmfkauRTjeyz1g8iA7
         XFZz85d7TBm7waqkBlAyMjgaU3loDxMUSWUzofiIyslj37M3nrZ9KH2Miu4AYGfewSQs
         E5Vv2eNwJYn6upd3hKGkLXlqNT/Ty90Hf8e9PfQ5/53e9FSf1WrGIRPAw5iUBC/HwDt5
         HZUGMv++JhbXEIMcXHcVvGjiY1eOcjz89pp2wxoGcdbW0gmcAN0OBppz+yIr50PAvm9G
         /cYw==
X-Gm-Message-State: AOJu0YyE/7PY/4n9y8g1o8zNmbuUtm2IFB/tMY3g/UxT23nS4MFhFoz4
	QXRSkwrVUv1vWz3sJ0KAF4vpL56fXpf/puzpWb5Xhv7hm137WKwGT0LoFh7yUA==
X-Gm-Gg: Acq92OFg7QfxEGN4Kn2pxlcfnTJRz+u5lrieHu6vporztjMuRG7csxztfdtg/fZuj1h
	vuKLWwnG2cB+dbKGFi2AByQRPTP/7TabbpDa16BqxXXwajb8MFaN00v43O2AdG6EFLdHfZpUL5m
	2AjYSG7fErZhxg4W12IZu82D2tSzjcFidQFybKFw+97G7Z7H4EKVt4O3beChZfEx3XGe+6PayxK
	eIUahScsbBEFRiE2z7aVv46qMQCK/liBsobDV6euUzOw7MMc7rayInDm+abCTMBCtFe62gr7xex
	4DxSPCf1xPa7cptu+vXk98bRUpPiF3gq6nGANSzdhSZUGkFShNU48K1rF0pwcySiIBcJFWutjJH
	tjIRTbVrFQLe9NtF1neot3Co8i7R0IV0W0V758axGrk3aTuLu4mET23y2GLD8vS5be8QKgp+oIW
	THynj1gPgZiBtcU4avkI1URc1H68kVbZRHDiu+xZ1pyoIN5l4l0b2XPPvR4Yzbx/2622Xy/jRVC
	PDj4XbxmFRMUY/Duw==
X-Received: by 2002:a05:7022:41aa:b0:12c:2cf8:2f30 with SMTP id a92af1059eb24-1365f811393mr2491801c88.15.1779529437160;
        Sat, 23 May 2026 02:43:57 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:56 -0700 (PDT)
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
	Fan Ni <fan.ni@samsung.com>,
	Li Ming <ming.li@zohomail.com>
Subject: [PATCH v10 11/31] cxl/core: Return endpoint decoder information from region search
Date: Sat, 23 May 2026 02:43:05 -0700
Message-ID: <aca91b273921128f9498f1da92c6844c026d07ed.1779528761.git.anisa.su@samsung.com>
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

cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
The search involves finding the device endpoint decoder as well.

Dynamic capacity extent processing uses the endpoint decoder HPA
information to calculate the HPA offset.  In addition, well behaved
extents should be contained within an endpoint decoder.

Return the endpoint decoder found to be used in subsequent DCD code.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Fan Ni <fan.ni@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes:
[anisa: rebase]
---
 drivers/cxl/core/core.h   | 6 ++++--
 drivers/cxl/core/mbox.c   | 2 +-
 drivers/cxl/core/memdev.c | 4 ++--
 drivers/cxl/core/region.c | 8 +++++++-
 4 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 8881cc9323e0..14723cfd05f0 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -58,7 +58,8 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
@@ -71,7 +72,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
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
index f9a5e21f5d09..01b1a318f34f 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -968,7 +968,7 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 		guard(rwsem_read)(&cxl_rwsem.dpa);
 
 		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
-		cxlr = cxl_dpa_to_region(cxlmd, dpa);
+		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 		if (cxlr) {
 			u64 cache_size = cxlr->params.cache_size;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 064cfd628577..b8b3489f69e5 100644
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
index 7561bf3d8af8..733d77c07493 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -2991,6 +2991,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
+	struct cxl_endpoint_decoder *cxled;
 };
 
 static int __cxl_dpa_to_region(struct device *dev, void *arg)
@@ -3024,11 +3025,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
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
@@ -3042,6 +3045,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 	if (cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
+	if (cxled)
+		*cxled = ctx.cxled;
+
 	return ctx.cxlr;
 }
 
-- 
2.43.0

