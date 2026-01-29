Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A9735CBB6
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720708; cv=none; b=tytgqGERJxXeWgve0HAVOG0EayuEEFO8bmLBhTIeONAdLOiPxlibZENlGbCkOWtkpm7Heb0i6And65LnDEmorYRfVTN8NaQnCtESkGxEdAOyekF0J1uPpS/f50uf9r+HAHFJlxV/DIP6UghvRU91ZtN4/5Aweq5tQn+f5qCuXlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720708; c=relaxed/simple;
	bh=iBrRdDjjJNCNPe98g9cITjVy6s0GzL4YINvlGeB4imc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M7VqrR/XsqZIKdgimZLdftx3xYitRVv8Z0CMHJbyyVEWbj+dMEGWLoY5AZw3YW34GePC7nNNIaDHonVaFS93RRML/OuGcebY2Mv5lTccOSu5W3TEOpfR3leUGXqItR05XYMG1y9vchIbXNHd/u2Tau1Xum88zhd1/rzni2dtA+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Frs8fW/H; arc=none smtp.client-ip=209.85.219.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Frs8fW/H"
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-8947404b367so16549116d6.3
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:05:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720703; x=1770325503; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mpgSTfoH6x9FkcQxT+wr5JUESeygPnLUnHeiLg7bHkA=;
        b=Frs8fW/HFxAiZEfMi+G9qfKeg0amNJYa9AMrbBO2EjRo9OV05HoqTlwMQOlifu1QR7
         5ndt+OJVyC/+0JPi7p8eds6EvCoqvMDQI+U7qa9lCe5iZotwaNWY4JcPSkq0ELI5MyPQ
         vxyCKH881xLQEROwvUa1Wu1NHbz2h9lIsch7onjAcF66Caw6Tb4UzMLK2PbIzrzJSnVX
         OiPMjp3pOVv7QuUyyY4diNkR+4z0e+o6pUBDrU29xHgvS46bSyAlQ2/H6M4K2yHjzWrj
         SAhP7Ma5mYhG+z1+CZROZ4EqTSfzBB7WV470U7AuOGfhiNHavmoTiYjkEchoIQGWxOeU
         OVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720703; x=1770325503;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mpgSTfoH6x9FkcQxT+wr5JUESeygPnLUnHeiLg7bHkA=;
        b=nRQ1GSle1pYusHHkfDX9eDOsPxMr7YrA1LlpagNrmRVSfOEkeJc9QnPb4eiWKI9se7
         BQpwDevk1Lx1lDam6Ni5Y+ds7cMWJUoO2oOln1VCVd2iCutBJNrape0oRU9VXIGlna0m
         zX+EuCcMFrVGYh1mx7FrfvJ9Js4LM8tPdlfyb5ybPzsL1bMP0SbpvGLuDbVPy13xi4vb
         XwkRl1EyRuwLazpyMu7xrWWE88dbegvvTORnegcf/f7/6D2m9qMbX5+DX3d3ONfFm9XP
         E2BHfTDnzGgotZpm/5DXtSIcQkvBZ5YJHOlyFZ+9SJLV5Pvk2hZ11VLi102rwgB/M8i7
         YX2g==
X-Forwarded-Encrypted: i=1; AJvYcCUKcgfOLmQeryVoW8J3+NMqAc4JQn4tNvPEQJJU4eWANAWSDDRgA5ud7duQ0BtH7OqF73Pwg2Q=@lists.linux.dev
X-Gm-Message-State: AOJu0YwyPbI1Tm4L41Oz6rMlwBHc8Cwn+E6N/BuEPIakAz3AzIVXoN24
	pEeM7snP5LcWUz/Xn03p46gyn7NzqBK1Js82YSMlNIwETBNX5IRlfnanbV2BiBRpNBE=
X-Gm-Gg: AZuq6aK2x2dawr+5RRTqsiLoNnyJNZG4/4utJ6A1x3HycCXneDppmfWEAdWkb0V9drV
	9ebgWplkPlgTkMhuWArKaygLHFl71vxTpoVdo2n4phJKV5Djlg1wm4+RMgdJoMdssMjtRbTH+1R
	yqe7uGXYTeyPy4aXk7pBNRFuqaHAdAMHYJD3qcr/Kkv+ajfcDyVJ1NPhrIZzVesmb+5P3KlD16/
	DulibopIbGxodMUe5mZ278iprNEbc+555dR62/5SthR2Y4/IBCUFogwh2ItsaMfUVCB5oNTh5QW
	rjACO6AwVOtgtxSHD8zRJFrJWfx6Wsu45tr3qwKrl5yrNwwlA7TTaVBV89USL4cqZX5nblHITos
	2t/Kh8z7Xec/Wq/6INUFG8nWVA8Vl/KdIxS9asy5EvIdELIPiRZweaZj88qgZR5sB/Ak+IzXZ8u
	FJdjI46QSI6wfhfWHI4xHZiV99JmSiPjAhYBwvZM/P43LanJvi2iXFecSmVHJ7n1KYs/t9Fh7he
	n0=
X-Received: by 2002:ad4:5aa2:0:b0:894:78e4:27cc with SMTP id 6a1803df08f44-894ea026eeemr11955076d6.38.1769720703415;
        Thu, 29 Jan 2026 13:05:03 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:05:03 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	terry.bowman@amd.com,
	john@jagalactic.com
Subject: [PATCH 7/9] cxl/core: add cxl_devdax_region driver for explicit userland region binding
Date: Thu, 29 Jan 2026 16:04:40 -0500
Message-ID: <20260129210442.3951412-8-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260129210442.3951412-1-gourry@gourry.net>
References: <20260129210442.3951412-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a new cxl_devdax_region driver that probes CXL regions in device
dax mode and creates dax_region devices. This allows explicit binding to
the device_dax dax driver instead of the kmem driver.

Exports to_cxl_region() to core.h so it can be used by the driver.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/core.h       |  2 ++
 drivers/cxl/core/dax_region.c | 16 ++++++++++++++++
 drivers/cxl/core/region.c     | 21 +++++++++++++++++----
 drivers/cxl/cxl.h             |  1 +
 4 files changed, 36 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 217dd708a2a6..ea4df8abc2ad 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -46,6 +46,8 @@ u64 cxl_dpa_to_hpa(struct cxl_region *cxlr, const struct cxl_memdev *cxlmd,
 int devm_cxl_add_dax_region(struct cxl_region *cxlr, enum dax_driver_type);
 int devm_cxl_add_pmem_region(struct cxl_region *cxlr);
 
+extern struct cxl_driver cxl_devdax_region_driver;
+
 #else
 static inline u64 cxl_dpa_to_hpa(struct cxl_region *cxlr,
 				 const struct cxl_memdev *cxlmd, u64 dpa)
diff --git a/drivers/cxl/core/dax_region.c b/drivers/cxl/core/dax_region.c
index 0602db5f7248..391d51e5ec37 100644
--- a/drivers/cxl/core/dax_region.c
+++ b/drivers/cxl/core/dax_region.c
@@ -111,3 +111,19 @@ int devm_cxl_add_dax_region(struct cxl_region *cxlr,
 	put_device(dev);
 	return rc;
 }
+
+static int cxl_devdax_region_driver_probe(struct device *dev)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	if (cxlr->mode != CXL_PARTMODE_RAM)
+		return -ENODEV;
+
+	return devm_cxl_add_dax_region(cxlr, DAXDRV_DEVICE_TYPE);
+}
+
+struct cxl_driver cxl_devdax_region_driver = {
+	.name = "cxl_devdax_region",
+	.probe = cxl_devdax_region_driver_probe,
+	.id = CXL_DEVICE_REGION,
+};
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index 61ec939c1462..6200ca1cc2dd 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -39,8 +39,6 @@
  */
 static nodemask_t nodemask_region_seen = NODE_MASK_NONE;
 
-static struct cxl_region *to_cxl_region(struct device *dev);
-
 #define __ACCESS_ATTR_RO(_level, _name) {				\
 	.attr	= { .name = __stringify(_name), .mode = 0444 },		\
 	.show	= _name##_access##_level##_show,			\
@@ -2430,7 +2428,7 @@ bool is_cxl_region(struct device *dev)
 }
 EXPORT_SYMBOL_NS_GPL(is_cxl_region, "CXL");
 
-static struct cxl_region *to_cxl_region(struct device *dev)
+struct cxl_region *to_cxl_region(struct device *dev)
 {
 	if (dev_WARN_ONCE(dev, dev->type != &cxl_region_type,
 			  "not a cxl_region device\n"))
@@ -3726,11 +3724,26 @@ static struct cxl_driver cxl_region_driver = {
 
 int cxl_region_init(void)
 {
-	return cxl_driver_register(&cxl_region_driver);
+	int rc;
+
+	rc = cxl_driver_register(&cxl_region_driver);
+	if (rc)
+		return rc;
+
+	rc = cxl_driver_register(&cxl_devdax_region_driver);
+	if (rc)
+		goto err_dax;
+
+	return 0;
+
+err_dax:
+	cxl_driver_unregister(&cxl_region_driver);
+	return rc;
 }
 
 void cxl_region_exit(void)
 {
+	cxl_driver_unregister(&cxl_devdax_region_driver);
 	cxl_driver_unregister(&cxl_region_driver);
 }
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index c06a239c0008..674d5f870c70 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -859,6 +859,7 @@ int cxl_dvsec_rr_decode(struct cxl_dev_state *cxlds,
 			struct cxl_endpoint_dvsec_info *info);
 
 bool is_cxl_region(struct device *dev);
+struct cxl_region *to_cxl_region(struct device *dev);
 
 extern const struct bus_type cxl_bus_type;
 
-- 
2.52.0

