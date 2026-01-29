Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9FA35CBDA
	for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 21:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769720712; cv=none; b=MVCocxVN8n+AGDqp0zeqBMMpGShjJn1dSP9/rLN8ddHqBA1lTfGYsEOmP4XIKfzMkR4UYF8KCGMOX6QC2kZyg4YO9sqkN8+Bzr4/j9yg3jYR3WaSf/JFhFp28HAL/OrBq8of2JJqyy/y6vvW+7B2dY/ihd1tayY4afS1W2gDorU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769720712; c=relaxed/simple;
	bh=QNsY4J+Tc0rw1kzVfyOgqVGbBo/47Sd9HfuK48nkDOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxNbnza3xcTOLrUlPhhJmFHwL7dwGdo/YNIFJGKCCjLZaQXfBLikCNgeNscfShKNWVt8Zb68n+qutAHh4zq7Y/7SbQFicVgvAzx1BsPrEKCm9v+Y2CpCZke2zyjbWXR5cphHWcNaARXec01dWmy4WT2sjfG0swxPvtFKwOMIa2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=oXiPavsf; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="oXiPavsf"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8c52c67f64cso137003085a.0
        for <nvdimm@lists.linux.dev>; Thu, 29 Jan 2026 13:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1769720697; x=1770325497; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=alwv4SGOFS63mWmVzbrgd9Xf0He8PRBJ686/YkdtOI4=;
        b=oXiPavsfaiIDj1i9esmxseWWtzBu+KujZ+H+TtDTvwuOsf53N57cn5PiqVAF0CiYEs
         6pvwY+beF/RdRaZytRXAkS3MifTwWKv3jm7LNsw0ymJ/Qeu8n81TtqqQzqoZJTKmjjJf
         swqr3ynLO5bVJX79xND42TlPrbXFQFX9C9DACzqgR6ySsa7Xsjx6csmSg/Gb+RstaGoE
         9xz6Y/ilcMI6zc4GTxjmh35ibaB6bBFTP0HUrl3EIlAFg7UM+jlBJkbUeoDBnzwRNkOH
         tuhgQVJYR7gadS8P9riKWoinjcMAh2LApncBc7kD+pCqNvqk0HRfzGt+coBFsgbLir4u
         ydSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769720697; x=1770325497;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=alwv4SGOFS63mWmVzbrgd9Xf0He8PRBJ686/YkdtOI4=;
        b=RuDf4kn+2ockEGOlqYCa8ja/m/UKG1KJH2xSmvsd9eqgoUyoSTDokACaS4fqZK2Wnv
         rlBg+bweYqlINSjytgyecM3JeMpGUaUA1JTNU7ez3cPmA5+jZWpAlfa2NA2FC+UuzafU
         RHo68EWvP8lhhtGvNjWLRtp9ody5r/qoMzZYkb0S3sSGn28RbLT5DXjcvECci6qM21O7
         JVcpLfoNMTFzzsJKuhU9NZ00RTHkYTF2oNDC/bBQKm+AxCAN0EpOiOqzQwFp6Js7MxJV
         lHJUDBHxy+2Sg35a/Dc5zKdGxwkmOrwg2zP95MOJRO4vEb5vMESsJLtjOer3FZFNcbCU
         x4iA==
X-Forwarded-Encrypted: i=1; AJvYcCWpR+C7LVy5m2EWcSHwJokystneMOg9IPfU0+U5iMSeZntKk739KI46x/FTAg2zLFqvjDa1rJI=@lists.linux.dev
X-Gm-Message-State: AOJu0YyDnVgfwKJPHp1LV5rzniAgfCOSTaryt/qWAvonoZT3gvQ533l2
	6jWoH5E4RjKgIPO4hbKO9CkCC21odpFNv/nEG0d255dTtBUk1127MA01QAbYHt3wp0qimZeYQdh
	42dmNeyI=
X-Gm-Gg: AZuq6aLvKGWawIAbTW28/e+138YWZ4AmM4PLDF+bJu97rnH59/sPH72BUNIv5Nqxy7I
	wO8DN/dOz2zpekdgpTxr/UHExhtvazusvzYAwbxHkkicMCVEYrh27+JKUfyCpCJ72ySlofHjtRF
	I5GcBvkVTdowRIA02HXRgiOGsmgDF8RP/VPciYsVjxA/CdkPDf3fHrINAancEJTHLeRzC9cKCw4
	KF8uvLmtMmREOjvHux6OzeicibOdtw92zd+CV/LspHV1ZT2tjcbsubhyj7GL/kJH0ff8btRizwX
	2t+iMWmPVlIlkFpQKpgek94Ntb8V1k1iDhDRKYlpRecGcDgIyPQA/JJatqJnrveW97bfQKR9bUn
	flMt9mi+SckQutQ+fCinGL8EiuzhfYsgoftRBAZGpeDt5nyxnY0CXNbGArEayzg40Un/2hhuWth
	rOLcJ0wdIEScVHJtqC0X3DIUwvnta9i0d1ZpEqSYecBwk44he6MsavpqjFTUQ45H6w1v0BdFwEW
	Y4=
X-Received: by 2002:a05:620a:254e:b0:8c2:faed:ded3 with SMTP id af79cd13be357-8c9eb349005mr136193485a.89.1769720697462;
        Thu, 29 Jan 2026 13:04:57 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c71b859eaesm282041685a.46.2026.01.29.13.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 13:04:57 -0800 (PST)
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
Subject: [PATCH 4/9] drivers/cxl,dax: add dax driver mode selection for dax regions
Date: Thu, 29 Jan 2026 16:04:37 -0500
Message-ID: <20260129210442.3951412-5-gourry@gourry.net>
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

CXL regions may wish not to auto-configure their memory as dax kmem,
but the current plumbing defaults all cxl-created dax devices to the
kmem driver.  This exposes them to hotplug policy, even if the user
intends to use the memory as a dax device.

Add plumbing to allow CXL drivers to select whether a DAX region should
default to kmem (DAXDRV_KMEM_TYPE) or device (DAXDRV_DEVICE_TYPE).

Add a 'dax_driver' field to struct cxl_dax_region and update
devm_cxl_add_dax_region() to take a dax_driver_type parameter.

In drivers/dax/cxl.c, the IORESOURCE_DAX_KMEM flag used by dax driver
matching code is now set conditionally based on dax_region->dax_driver.

Exports `enum dax_driver_type` to linux/dax.h for use in the cxl driver.

All current callers pass DAXDRV_KMEM_TYPE for backward compatibility.

Cc: John Groves <john@jagalactic.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/core.h   | 1 +
 drivers/cxl/core/region.c | 6 ++++--
 drivers/cxl/cxl.h         | 2 ++
 drivers/dax/bus.h         | 6 +-----
 drivers/dax/cxl.c         | 6 +++++-
 include/linux/dax.h       | 5 +++++
 6 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 1fb66132b777..dd987ef2def5 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -6,6 +6,7 @@
 
 #include <cxl/mailbox.h>
 #include <linux/rwsem.h>
+#include <linux/dax.h>
 
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index eef5d5fe3f95..e4097c464ed3 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -3450,7 +3450,8 @@ static void cxlr_dax_unregister(void *_cxlr_dax)
 	device_unregister(&cxlr_dax->dev);
 }
 
-static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
+static int devm_cxl_add_dax_region(struct cxl_region *cxlr,
+				   enum dax_driver_type dax_driver)
 {
 	struct cxl_dax_region *cxlr_dax;
 	struct device *dev;
@@ -3461,6 +3462,7 @@ static int devm_cxl_add_dax_region(struct cxl_region *cxlr)
 		return PTR_ERR(cxlr_dax);
 
 	cxlr_dax->online_type = mhp_get_default_online_type();
+	cxlr_dax->dax_driver = dax_driver;
 	dev = &cxlr_dax->dev;
 	rc = dev_set_name(dev, "dax_region%d", cxlr->id);
 	if (rc)
@@ -3994,7 +3996,7 @@ static int cxl_region_probe(struct device *dev)
 					p->res->start, p->res->end, cxlr,
 					is_system_ram) > 0)
 			return 0;
-		return devm_cxl_add_dax_region(cxlr);
+		return devm_cxl_add_dax_region(cxlr, DAXDRV_KMEM_TYPE);
 	default:
 		dev_dbg(&cxlr->dev, "unsupported region mode: %d\n",
 			cxlr->mode);
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 07d57d13f4c7..c06a239c0008 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -12,6 +12,7 @@
 #include <linux/node.h>
 #include <linux/io.h>
 #include <linux/range.h>
+#include <linux/dax.h>
 
 extern const struct nvdimm_security_ops *cxl_security_ops;
 
@@ -592,6 +593,7 @@ struct cxl_dax_region {
 	struct cxl_region *cxlr;
 	struct range hpa_range;
 	int online_type; /* MMOP_ value for kmem driver */
+	enum dax_driver_type dax_driver;
 };
 
 /**
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 4ac92a4edfe7..9144593b4029 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -2,6 +2,7 @@
 /* Copyright(c) 2016 - 2018 Intel Corporation. All rights reserved. */
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
+#include <linux/dax.h>
 #include <linux/device.h>
 #include <linux/range.h>
 
@@ -29,11 +30,6 @@ struct dev_dax_data {
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
 
-enum dax_driver_type {
-	DAXDRV_KMEM_TYPE,
-	DAXDRV_DEVICE_TYPE,
-};
-
 struct dax_device_driver {
 	struct device_driver drv;
 	struct list_head ids;
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 856a0cd24f3b..b13ecc2f9806 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -11,14 +11,18 @@ static int cxl_dax_region_probe(struct device *dev)
 	struct cxl_dax_region *cxlr_dax = to_cxl_dax_region(dev);
 	int nid = phys_to_target_node(cxlr_dax->hpa_range.start);
 	struct cxl_region *cxlr = cxlr_dax->cxlr;
+	unsigned long flags = 0;
 	struct dax_region *dax_region;
 	struct dev_dax_data data;
 
+	if (cxlr_dax->dax_driver == DAXDRV_KMEM_TYPE)
+		flags |= IORESOURCE_DAX_KMEM;
+
 	if (nid == NUMA_NO_NODE)
 		nid = memory_add_physaddr_to_nid(cxlr_dax->hpa_range.start);
 
 	dax_region = alloc_dax_region(dev, cxlr->id, &cxlr_dax->hpa_range, nid,
-				      PMD_SIZE, IORESOURCE_DAX_KMEM);
+				      PMD_SIZE, flags);
 	if (!dax_region)
 		return -ENOMEM;
 
diff --git a/include/linux/dax.h b/include/linux/dax.h
index bf103f317cac..e62f92d0ace1 100644
--- a/include/linux/dax.h
+++ b/include/linux/dax.h
@@ -19,6 +19,11 @@ enum dax_access_mode {
 	DAX_RECOVERY_WRITE,
 };
 
+enum dax_driver_type {
+	DAXDRV_KMEM_TYPE,
+	DAXDRV_DEVICE_TYPE,
+};
+
 struct dax_operations {
 	/*
 	 * direct_access: translate a device-relative
-- 
2.52.0

