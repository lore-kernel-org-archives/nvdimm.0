Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.178
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833353;
	b=OWTiRJzYXMMI64dU434NTjFy4PgAKj+dVfdNE5Wz4nXJdiz3OdVcm4fkiBvbmgCU3VUQ
	 nanZBc/eUnnJHB7WmSkENC/fvuYodCDgvmdb+PFUYmOOpGTx953f4N8qyP4uL0OUi54En
	 30z2AdqxUcXqydefB6eWjy704u7hepicYDCwOgoTokKxa4WXJ0p8/VLeUE4NnEQZLWSV9
	 ftnhZ32/jMyT5g6bRPyxoVdzddablp5Ktw7OzuzBMTkRI7t2+Q8RpBE3GDPav8P6M5BHO
	 hoJ+Uy76Qz10b0lrECbiLUvM2o5q6JoihR9I9NKISVZyB9KXWyxjyzCi65D1XMynSWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833353;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=rE6d1fjh9gAYO1BJRk5cgo6jEJphiJR3e20EHTFc4lc=;
	b=ivi14iLTsU8KiGPFpvuPclj9IiEBVj5Ejr3WOEzSCCJXQepwnwgswEXrbiYLjCBe3N+J
	 h/M9eWQoDc2fFdRJcOIfwUlIGEjVsEwf1PcW7Xmf2ekI5eRS2AJ/xB7UXzljkB5YDuxuz
	 cyAxdRv9OtzA5lFXaR9IF5MTIOwkogSf16MHxW8qAMBtU0UyXwNNCm9xoEE4wGh90cSOi
	 vDgoYvHuSuknzBvq57W+hBu48gPDAs+fXksc1qnuZ428yp+47Iui71wRfXTAjr2JzPB2j
	 CWIwj0udhw7C7k3VJ5QYi9SLrkesbpwmlNLbTwLU9eqvs2ylbx7sESCZZKk54mfcp3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yBkwHQaN;
	arc=none smtp.remote-ip=209.85.214.178
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14171606D809
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 14171606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=yBkwHQaN
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2e5fb79ce82so7550015ad.0
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833352; x=1794438152; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rE6d1fjh9gAYO1BJRk5cgo6jEJphiJR3e20EHTFc4lc=;
        b=yBkwHQaNGAX4RYFyiQUTah/B1LZ8viMiAZfesSzQDbGkwupbC62rSVpZFDp60BQiNq
         oqzZqqG9hoVu+XQSqJD+4P4fAnWqNEpDOm4qg2P8ILXGUk+TJnuImaA7qiyLSaMW7IqH
         gXYMtQrs+EXWkxNOdqUsDIz0krYDUIHvQYJOgZK3SmCcfcozdiWyhOaT2dUAgNou+py+
         TjwjNdBVfGJuZ24kB4VUSNZcHrym35si+ZXJVsyA0woAibWihnPkzzvbR8Zpq/bZHn1r
         gQxzqAZaRGp1ZX1BUz/CRrPi4+dxhA2A/OYKTaPnzfefeEpafq4LfuOEmJRcw9uwHhhX
         v3+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833352; x=1794438152;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rE6d1fjh9gAYO1BJRk5cgo6jEJphiJR3e20EHTFc4lc=;
        b=2MuCQMK2LS/3uiSX6B5yjfC+DgI8t/MgaP99dlZE5Y5z7S7c7GxBa+S6b4qPdGWzeS
         u+Yi+o8fvl0Ptxvf1sdnksiSPhesUi8HkNBGxXhB2NnqzjYc9LmKEo2KCID3oN+kM8KR
         zg1CeeII/3lxFoU6keXxrObxgUQXBbMCXl+xFW8FY98NXf+EOG1wHlL8epEDtmWq0U9n
         LItYy4KeclZCqDff+ste2xw2RC0/p2g9bA8OH65oT0iQJj+8MP2NKkWFRMzLplRfICIh
         e/EI+aCU3liWEf28O8o2y3pkwP5hJlZlxh9X6UWEidGG7Ffja4mVNtNhMSzcvEEl3EjY
         y8rg==
X-Gm-Message-State: APuU4Z+gCbCZLP7PHqThUVZwLy2SE3vORmYJKfcci52qvCREomBHkcVC
	3Dxt7KpkR4lmFkgz6+QvRNAeoODGnBTp9uP247VKLwWsWN8WJ5cWBjq5
X-Gm-Gg: AYBFou2Jp58U2GmiBGpqPpmEV1baQGVX6z1S1a2vzVax/GGBkQsZEHeG8Zs+hl4je//
	0GnHsGEcFIDYfyVAC5WTFrAj3W2MwKFgqENNLSvjx2OCSWDguybAuuarzZGJokXIZsu9SkNZrhm
	hv5jpu3nqgY5MVlaOVfnkAog2/HcZnz6nB3snLVSRQXHaIshYHo+c6TYEl+1a0OfL7K1p5nwcBM
	//Da14AX4i8g8NFBFaxo27Jun6NKMkexZ8qEyta73JK/4MqT+kpmQkHkQf5u66pkrY8akoaYYQ8
	sjlZkEUXcgNrlBCRfcdn/8wk3Ysrwl81yomRDAOZas7/i7gJlLsuU8vplo6B/wNXTi5t9m2IzFg
	uNyzEu2QmMAvdK8YufbotW4qf0Rg/yvP/5Mmjg7mhfY2loLOiX1e7A1hZ5JlfSeJL6y3Uf996xL
	WQTFlwqbJuJv7Sx9G2Lw0hBF9+SsxwmZHMyjMIf8coLORDw85Zz7IdBInSalsi15dzDBz7Dz5FN
	fhgjg8D4nvxS4yAYZhYJqDYdm7c8WmXd1CQFG0Wve4FMYshU9AphFQVbMVlw+85cnX4OkBIlWQz
	F7MkdDMOPkTuV7niyZ/DLjG+F6beGA==
X-Received: by 2002:a17:902:c945:b0:2ed:107a:4f5d with SMTP id d9443c01a7336-2ed107a508fmr25016345ad.1.1793833352240;
        Wed, 04 Nov 2026 15:02:32 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:31 -0800 (PST)
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
Subject: [PATCH v1 01/14] cxl/core: Return endpoint decoder information from region search
Date: Thu,  5 Nov 2026 08:02:25 +0900
Message-ID: <20261104230445.66625-2-anisa.su@samsung.com>
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

cxl_dpa_to_region() finds the region from a <DPA, device> tuple.
The search involves finding the device endpoint decoder as well.

Dynamic capacity extent processing uses the endpoint decoder HPA
information to calculate the HPA offset.  In addition, well behaved
extents should be contained within an endpoint decoder.

Return the endpoint decoder found to be used in subsequent DCD code.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Fan Ni <nifan.cxl@gmail.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Li Ming <ming.li@zohomail.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 drivers/cxl/core/core.h   |  8 ++++++--
 drivers/cxl/core/mbox.c   |  2 +-
 drivers/cxl/core/memdev.c |  4 ++--
 drivers/cxl/core/region.c | 12 +++++++++++-
 4 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 79918fde1575..8a81be004d00 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -47,7 +47,8 @@ int cxl_decoder_detach(struct cxl_region *cxlr,
 int cxl_region_init(void);
 void cxl_region_exit(void);
 int cxl_get_poison_by_endpoint(struct cxl_port *port);
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa);
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled);
 u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 		   u64 dpa);
 int devm_cxl_add_dax_region(struct cxl_region *cxlr);
@@ -61,8 +62,11 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 	return ULLONG_MAX;
 }
 static inline
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
+	if (cxled)
+		*cxled = NULL;
 	return NULL;
 }
 static inline int cxl_get_poison_by_endpoint(struct cxl_port *port)
diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index 39485b6bcb97..13a68f5cef69 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -966,7 +966,7 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 		guard(rwsem_read)(&cxl_rwsem.dpa);
 
 		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
-		cxlr = cxl_dpa_to_region(cxlmd, dpa);
+		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 		if (cxlr) {
 			u64 cache_size = cxlr->params.cache_size;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 787988e92965..81f1e0441787 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -309,7 +309,7 @@ int cxl_inject_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		return rc;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison inject dpa:%#llx region: %s\n", dpa,
@@ -378,7 +378,7 @@ int cxl_clear_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		return rc;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison clear dpa:%#llx region: %s\n", dpa,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index a048bd5c06cb..f4a9839c73d2 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3045,6 +3045,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
+	struct cxl_endpoint_decoder *cxled;
 };
 
 static int __cxl_dpa_to_region(struct device *dev, void *arg)
@@ -3078,15 +3079,21 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
 			dev_name(dev));
 
 	ctx->cxlr = cxlr;
+	ctx->cxled = cxled;
 
 	return 1;
 }
 
-struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
+/* @cxled receives the decoder mapping @dpa, if any, even with no region. */
+struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa,
+				     struct cxl_endpoint_decoder **cxled)
 {
 	struct cxl_dpa_to_region_context ctx;
 	struct cxl_port *port = cxlmd->endpoint;
 
+	if (cxled)
+		*cxled = NULL;
+
 	if (!cxlmd->dev.driver)
 		return NULL;
 
@@ -3096,6 +3103,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 	if (cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
+	if (cxled)
+		*cxled = ctx.cxled;
+
 	return ctx.cxlr;
 }
 
-- 
2.43.0

