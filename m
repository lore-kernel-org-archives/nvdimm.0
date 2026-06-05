Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF11B3BFE5A
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694370; cv=none; b=ocqRPZaSyI9kh6P3wVOXJB4NagoBmAvh+pWgDhEeB36SwYnGMNqiHkQsXhIJFXka7IBCHxpJeccly+J+lOT6UEnk35fABPQOEGqZc3r+gvxu/63DWwd0mrzOnmRvVRzGKaOFdkbXhTtk8JqM0SI+MLvVsIBVGI410o8uVbzprP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694370; c=relaxed/simple;
	bh=1zTws9fmQmhgRciJvlP2AWzY+uWAfxRF9YfrcryFsNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MA9y4eqJL5ZhYseoYPwSQnCtLIKeyz0kxwxq69yij6BBlqI/IcFxLcMgoHSr8P++eWqL7NQbSwGGDv1ZfnxwwBpQ6fwyreAsCw5VbK5ID+nEwe9nbuhLAZkU8fbhAxBOS2x5UBWVyhQlDLkVO2gY7BFed6Vp1KM0nO0aaqNdvHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mcsxRHcN; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mcsxRHcN"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-5174a1d78f8so21285001cf.2
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694368; x=1781299168; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P2vGSHo9hdkHiErFpk6jdcKlA83TnjxiiQnZVrYQBSY=;
        b=mcsxRHcNekUx+JiXnLexSRTKwkE5NfunaM3Ha851HXfH2Dmp2jAVT+tnoqn77P7oHg
         Mn29WYZ08UF+c2BDsC/8CmVz8NOLTdA7jBVZW9uWbpGmokfjbQKw1AylpqY5p8iLVvEr
         xeC8Mrdhq4V1vfHBZDubxSuBsf27jIvE67NINjRG0Su3SXLGzCjMDUOFaGXPoVEXJwbV
         KXR1LwenfHOk+5TaR0bq64Q8YrFnp3FtJGxWpNuzLStyYDrye31qna4PyNwaLOBrIAmw
         afTDkrThOz+KXPne07ndus3KnPUXXZMRFuSzU/u1cIZtbg5s63o6rYcf2gP4aFa8x7zw
         sj6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694368; x=1781299168;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=P2vGSHo9hdkHiErFpk6jdcKlA83TnjxiiQnZVrYQBSY=;
        b=Xhndo8CTePhiGWu9W0r54oMM5h7oHzWoenhmi0wu8Uh5eMZRAqrnide33p1gUNwg7t
         ARDmCPDYkxpN9FsRz7DOUlh0eMdN/dePYuyfvzmUs5PCwFnzPH5rHzTR/dxTzpGefbdT
         3QhO7R5dxvhwg88wDqsinxU781TCZi0p2QO3qQYCQi3c0k3dViZrm+kBkGIh8K+0049H
         USPuuOvMaELY6Ntkf04LKNWsnW4lma9C0ao43ffhjU2AtogWJMPT0O0tB1AR6xAOlM8A
         YKxJDlPpj/rd6oxX0ANNsqIKeMwvd3azTzzIbdf15Bni7vSARCbVBaba3zs8ZBYq3n25
         nRAg==
X-Forwarded-Encrypted: i=1; AFNElJ+FdwWbY5Znrhz6MMhusekVux4OZAHWds2lyHfiqXMWhtDXh+JYXo8YaNHvit8UuZsQD/D0ViQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxP8k2aSUzrY3xTdbn6bdG/tRasMSHcnf/jZZaQBCo+WiNPr+mc
	LePrdMY69Bl3wcHGxmCYyLjNFx0MdfK0Pk8poVBvVxl4PKdq8nLmkEACDlbmEXbsn5U=
X-Gm-Gg: Acq92OEMxoHBfJNDzp34FQw5oWdHTy6bfhhC2jp+ya/1sqvATYr1qz+79JkQDA5lsx0
	wSNPD2OcQpq36rORGhsut6K9aEtzoAsCx1dD2amUyd1o4//i+HV0HPnGjJQyy1+WDu4itlMDhKP
	ybj6NPL0Fw9y/HBNvBxuJdL/bh6C2sEyaG6FDT5tqsjjGnSTuzP6Uhc7//nRfrdmJQK876cXQQa
	r8iAvnO0zAb+nla5TQRt8jr0Eco3GKLC9fe+bBrhn4BZNvqUsIGRl8RDrBHyORdjj3XSA0hvwtp
	Fig18umAzEIwsCNJgvbd8VhyRz+Om3c99SGHFL2wglc0DLvFkbUb2Pdh/4SA+GtOFQJUkmB5C8Z
	zyTHOcNsxspW/PT0lUkac/jy3I9cmI7ZXyt7uPJNVRzE7lHXLYL9JZhqrDfsDCStEJyUPTWssdO
	LGZ9LWbyXnZz57FLgPiIsPQ+Qntmnqrpo7ZowINnNNmPkkj5lJlW1Hc9Ns9jwuRpQA2d6YIl3wV
	78N/7bInirnVLhuc3BQQRnJkFzS5v8Jew==
X-Received: by 2002:a05:622a:514:b0:50f:6415:1eb4 with SMTP id d75a77b69052e-51795bbf29bmr79531471cf.49.1780694367941;
        Fri, 05 Jun 2026 14:19:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	nvdimm@lists.linux.dev
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	shuah@kernel.org,
	gourry@gourry.net,
	alison.schofield@intel.com,
	Smita.KoralahalliChannabasappa@amd.com,
	ira.weiny@intel.com,
	apopple@nvidia.com
Subject: [PATCH v4 6/9] dax: plumb hotplug online_type through dax
Date: Fri,  5 Jun 2026 22:19:08 +0100
Message-ID: <20260605211911.2160954-7-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260605211911.2160954-1-gourry@gourry.net>
References: <20260605211911.2160954-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no way for drivers leveraging dax_kmem to plumb through a
preferred auto-online policy - the system default policy is forced.

Add 'enum mmop' field to DAX device creation path to allow drivers
to specify an auto-online policy when using the kmem driver.

Current callers initialize online_type to mhp_get_default_online_type()
to retain backward compatibility and to make explicit to the drivers
what is actually happening underneath.

No functional changes to existing callers.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         | 3 +++
 drivers/dax/bus.h         | 2 ++
 drivers/dax/cxl.c         | 1 +
 drivers/dax/dax-private.h | 3 +++
 drivers/dax/hmem/hmem.c   | 1 +
 drivers/dax/kmem.c        | 5 +++--
 drivers/dax/pmem.c        | 1 +
 7 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 492573b47f66..6611fe399f59 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2017-2018 Intel Corporation. All rights reserved. */
 #include <linux/memremap.h>
+#include <linux/memory_hotplug.h>
 #include <linux/device.h>
 #include <linux/mutex.h>
 #include <linux/list.h>
@@ -394,6 +395,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
 			.size = 0,
 			.id = -1,
 			.memmap_on_memory = false,
+			.online_type = mhp_get_default_online_type(),
 		};
 		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
 
@@ -1527,6 +1529,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->online_type = data->online_type;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 5909171a4428..c53a9427f8e4 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -3,6 +3,7 @@
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
 #include <linux/device.h>
+#include <linux/memory_hotplug.h>
 #include <linux/platform_device.h>
 #include <linux/range.h>
 #include <linux/workqueue.h>
@@ -26,6 +27,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	enum mmop online_type;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 3ab39b77843d..0eaef700bb2a 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 81e4af49e39c..0787325bc8dd 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/memory_hotplug.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -79,6 +80,7 @@ struct dev_dax_range {
  * @dev: device core
  * @pgmap: pgmap for memmap setup / lifetime (driver owned)
  * @memmap_on_memory: allow kmem to put the memmap in the memory
+ * @online_type: MMOP_* online type for memory hotplug
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
@@ -95,6 +97,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	enum mmop online_type;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index af21f66bf872..0ef6e9ae660d 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -37,6 +37,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 592171ec10f4..41ccb618a146 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -172,8 +172,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				dev_dax->online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
diff --git a/drivers/dax/pmem.c b/drivers/dax/pmem.c
index bee93066a849..a5f987814da5 100644
--- a/drivers/dax/pmem.c
+++ b/drivers/dax/pmem.c
@@ -63,6 +63,7 @@ static struct dev_dax *__dax_pmem_probe(struct device *dev)
 		.pgmap = &pgmap,
 		.size = range_len(&range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return devm_create_dev_dax(&data);
-- 
2.54.0

