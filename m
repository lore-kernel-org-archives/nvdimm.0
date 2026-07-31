Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9F6D376BDE
	for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 08:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785487809; cv=none; b=pyCBzg7Z14qbdw8NnUvdbHPiwIWB+EtAynT9rMcRxC2XzMHs6aFBMZFClnu3M+3LK3sdQqB5ryUaIyun9IhldGgJhAHjItybMXhd1OXOvrmDxr0bwFebB9sb1FnMslAHd5+OYXuNcrNQjDPLNrP3mOF0TFXyBDpbdnr2NUywMvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785487809; c=relaxed/simple;
	bh=btNatOLsQqoViiqylOQnAJqclEYWr8c/tMJjbquJJaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mkf5FbYCRNCMVptyr3jpL3gotmy2XnlcS3pBo5M0pAbl9ni4jT13bps/PttlJ2soynIRP/rjBgabt+ScG8x81qE9X4LGzTd9MmYTOSrlEiPrPlC0jKMDqamIpz45xXqfx/Erjw9VMvMg9ZFBpAm8H515nFWff+yeqDkr2tMo7+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NYp+6TGU; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NYp+6TGU"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cc891373e0so7215875ad.2
        for <nvdimm@lists.linux.dev>; Fri, 31 Jul 2026 01:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785487806; x=1786092606; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rwe/gV63+b/gEszupNwAxf6rsJfvimLAKp08K8RKoKI=;
        b=NYp+6TGUqB6RhrNGHCiDQ4LeG4gJbFsNYaX0EwSYibwsLHTuRwH0lj07LQGvdiWqDx
         PMId/fKBbU+RTfKjyG92iZaaB+TNjP1tcA2EzKLR2C0dnxss0YFb+2BMGFyIhciLnJtL
         piPuZmqxAmPBwW3OXeyBMqZhRIMUcFK1LYnPCx6mUknw6is6bekjBujvYzjjURJgZVkw
         +KGuZapM8ahmgW2/9dm+HfQ5dKP0aIKYM5UQkvg/+uUFVaZMBkn9gk9LuMQlUKLyWUCc
         panys22ULunl9Fvl/IgtAkW0WsYikoeDXJTwHWpGG9DcAI0fv/ig60KyZR2H6MmRcP6E
         g0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785487806; x=1786092606;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rwe/gV63+b/gEszupNwAxf6rsJfvimLAKp08K8RKoKI=;
        b=eaL/7zB9uSCZ1djmh+Lhc3YCG5MMIxJnfe5+sGx0vI2Zkae/Z3OsIhRAGeYtZi/fyX
         ti0l9njYIkVJuzmRtgZ0IpimB0Gx81vklii9qfZe19gR2OOCPUcxk+SZoqUAzdn4cDIo
         22/jaHxy3k66g6KYULNTfDH15byNb70HaXqDAMAWqM0bRj193ogDZG7niMHCuy6QjUyA
         14vFLOkb6OB4JDHxuvUc3H5P/CPaDxgxhkw9rc5LliGQE1E/akcwqyXNdxvQfivciEwQ
         T4epFICt8LbHHryat4cgNKMJZzwCGOwp38d7wqQ1YK8v8J5/MEs1mtS5rDN10yTTTvl/
         8klg==
X-Gm-Message-State: AOJu0YyT1xSAVnrXXIf6Y7qa+41Uvt4GKPtIEmQxNV+KHK9ousOaYozS
	B/tyX2x+GppzdzeCiQ8XzNKXvHeby6aIN02P+36Dnkb9d91YlVhaq+HB
X-Gm-Gg: AR+sD13cCtwKEPqYT5yHCHyNpQj21Ym2EflP7Kh2tIA+uXol+HSz/IoihfknMLjHZWU
	JEp79u3cw9urizbFFbETnl626KVP4XxqZMIugWL9QEVb48ibnE/JCZEHpOZm9wjy+JVtSi2VKlQ
	mWgHV6J8gsqen7U+EFJZj1TyYOkWK8xAeLfXbQpTFh4/XR1lF9g0VH/0LTcTJ+aYAwfOW5Ty8fJ
	5vkV9cW6NK1AOXwsTfO+kjuf9GqcYQAfCei0c4e5VIivv5Pr79hMoAZxYW60RPQgbhlEXJdQIEI
	wux8MuUn/iYGATgHOhwvUl8yER1VOuBrNOK/6mM4z+6LIkwv8yNR9NOQEpWuOTqJ0pHflJo8Ww7
	iubCWQz1qBknXGj0MV2mISPc21D5ZJ0iKm+e9g+RrocVIq2CDxjIjLN11xQW02PMMwFPHVhZaLu
	NhcGXUJb+L8539rBJjD3a97hmGfYLmh8ZBB0QSl6PoAT4bv68pi9bvGbQTUnYyqZ7KMaLO1NnDU
	zmQEjJpDtwk/KyCCGexi1GZwfZ/PTOYT2vsFnq2kcIL
X-Received: by 2002:a17:903:38c4:b0:2c6:a172:55a6 with SMTP id d9443c01a7336-2d046d812ebmr13117815ad.9.1785487805687;
        Fri, 31 Jul 2026 01:50:05 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d04ae5abaesm2708425ad.27.2026.07.31.01.50.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 01:50:05 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Wonjae Lee <wj28.lee@samsung.com>,
	Junhee Park <jh9934.park@samsung.com>,
	Heesoo Kim <habil.kim@samsung.com>,
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v12 7/8] cxl/core: Return endpoint decoder information from region search
Date: Fri, 31 Jul 2026 01:48:12 -0700
Message-ID: <20260731084901.1512819-8-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260731084901.1512819-1-anisa.su@samsung.com>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
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
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
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
index 07555ae63859..e4bd220faa92 100644
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
@@ -61,7 +62,8 @@ static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
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
index a6cdea9f4080..b18ea02ed2e6 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -969,7 +969,7 @@ void cxl_event_trace_record(struct cxl_memdev *cxlmd,
 		guard(rwsem_read)(&cxl_rwsem.dpa);
 
 		dpa = le64_to_cpu(evt->media_hdr.phys_addr) & CXL_DPA_MASK;
-		cxlr = cxl_dpa_to_region(cxlmd, dpa);
+		cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 		if (cxlr) {
 			u64 cache_size = cxlr->params.cache_size;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 33a3d2e7b13a..1565a5cf0f32 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -317,7 +317,7 @@ int cxl_inject_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		return rc;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison inject dpa:%#llx region: %s\n", dpa,
@@ -386,7 +386,7 @@ int cxl_clear_poison_locked(struct cxl_memdev *cxlmd, u64 dpa)
 	if (rc)
 		return rc;
 
-	cxlr = cxl_dpa_to_region(cxlmd, dpa);
+	cxlr = cxl_dpa_to_region(cxlmd, dpa, NULL);
 	if (cxlr)
 		dev_warn_once(cxl_mbox->host,
 			      "poison clear dpa:%#llx region: %s\n", dpa,
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 1e211542b6b6..ec5e5b7090cf 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3012,6 +3012,7 @@ int cxl_get_poison_by_endpoint(struct cxl_port *port)
 struct cxl_dpa_to_region_context {
 	struct cxl_region *cxlr;
 	u64 dpa;
+	struct cxl_endpoint_decoder *cxled;
 };
 
 static int __cxl_dpa_to_region(struct device *dev, void *arg)
@@ -3045,11 +3046,13 @@ static int __cxl_dpa_to_region(struct device *dev, void *arg)
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
@@ -3063,6 +3066,9 @@ struct cxl_region *cxl_dpa_to_region(const struct cxl_memdev *cxlmd, u64 dpa)
 	if (cxl_num_decoders_committed(port))
 		device_for_each_child(&port->dev, &ctx, __cxl_dpa_to_region);
 
+	if (cxled)
+		*cxled = ctx.cxled;
+
 	return ctx.cxlr;
 }
 
-- 
2.43.0

