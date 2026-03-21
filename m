Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FB60391E71
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105463; cv=none; b=YDLwi2ESRIvoFQ2PTX2WlrF5f0Rg5Hja95ZqzxONei9IddaWYJhd8x2L1VWEGMF5TcKqleG+xzac7Akwgufhinr9anF2SmZhRwHqS0tWBeF/heGpMuPGKppPR/7FFKH6sMDF0k0DHDhNRlv7UXrtlwl0jaBmhCraBAnCV01HWxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105463; c=relaxed/simple;
	bh=Wowz7DV1aUnJYA8F9t35yrzNxk7X9sC3o+wv4gNWZWA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Hr2SthnKFwDm00z3Z4TG7j/O3VteJAq1C8L9V/oIseiU51UN0kieaXulz/CVU0BLQ9h5NljfUn+Ow+s40UCVv180E5gTK24+BXRf6OTsct+AAYJ/+FSZIq3uayh7kPyiSSDKyLreuWUT0cpHfvZ2J3NXlZ9eA+bMKCFHS2zxMo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=DT0FTH5F; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="DT0FTH5F"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8cfc795ca97so149835685a.0
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105460; x=1774710260; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DpXtFQ1E8PxzzJ3jH0sASsMe/zJtVJUABHrep2C4jPI=;
        b=DT0FTH5Fu1SgAan0HKk8aD30M0Lqg/RWwEK751N5NXJHHO7J4UF4poPE5wZaovrspU
         MmDBu0PSuSbvqUR5WjYVbvTbjUM9s7BIbMlSJky78jvnwlUdVpSvMesMULtXi+Z1mfJf
         fUzUBd26qH9SX2h1X+EnNZdBHGTLEjJKlNOrFGcGobY61XrfmTZo6eUVJGy0dgF6BVHh
         BLRgl6YnvEvxY4A+k0ko07o6/mybUiHhoVLP4n6YIzX0Obd1qarlVS2EHqub1d/0nBsP
         +xtOIhe33KtbSikgAnkLrQ0TISkKVdmSqeqShTBoW2aHl06QXfLd674kz3KH65oIwdRr
         Y+hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105460; x=1774710260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DpXtFQ1E8PxzzJ3jH0sASsMe/zJtVJUABHrep2C4jPI=;
        b=GUD4C4oDojWwrkj/1EJGZYSYEVM1S/Q6XGt1FVzQ90rk/PU7l5z0IrC4hSLl8qEf7t
         +9BTVSdvKO4WWHRph/b/EXLuc7bAC+M9syzt4Q1kTmGFaKcTAU+RMNRF+goAleUrAwnu
         KtJvq46EvaOb6KPI7gwctmLqPks6GSjypdGL5zeM2h0oS5mJC+5Myv3tYJ4HpfZSGJrG
         0gysOtrG9Dtiv+l2aujPevZZ7GUSJe8dpgevSEBTMZ+yS4Nkzy4HeCrNYx0WGTIETSur
         BhAQgNpdE5DN+odq49WdcVRPh+rfeYoqOrkTO5bRLTmI70g65IBZPOQQb5Xxwz4pGvDe
         Hc+Q==
X-Forwarded-Encrypted: i=1; AJvYcCWjZpphVRBfGnQ9Ohl+vSVds3lWyhwzJ9jhoIOdSHfOBlPAatZdyMnLvtuSTNgIN/kFWnj5VAI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzm+a02tK0/LgoI0ioQgtXx0CzD4Ib86i8ob1hXzpTOezRcDA6j
	LPECKeWRuxEJzuIn5VRUeRL3kT/x+cVugbqEXseL1g1at+31uk8imhlTFGLOIV2e4Rk=
X-Gm-Gg: ATEYQzzYvZfBRWUYEfXHdbGbiMwVbKL+KRdhhMrE0Dl/P+FPacZb/GK2Zs3y1/FrqxA
	gn2yN9FcIlPEi+7lXZd/FPCzfysprsUwvkMeU6O43xVF8Z489ko19GZB+4qB6Z6X/6+gi2xB1+B
	tc3IiUeWaBxuwOCEU1xrfikpsZ8GFuAvojWccc66fkyR7riDN0ZHJiA3QQQdFzkwMvGEnooEmz1
	O/exbnUxZ+Z4gtm/mzlKXQ8uMTmxsfbtUxSvEW07pNadFhYvzHl8wfep19QG6+elGKbCl+/bVVV
	HKPtXLZXJe61TqCn4uBI8J7eGzwXxKXHhTJ5dDL7g2MM25PgP2UCVHywdubX8VcrjmDIdGH8IpY
	3p8DbxNLtWoseDuSUV9EwP8wJmH+6CHM/l2/14N0QgqyKT5rT4j4z7X9DuYg1vuqdVGARBAIzSy
	jc52EX/82s/CuLXtebqH7m4jgah4ZBPBlzD4Ib/CmhJC/K6/OcTnaXxLkvh3af/F3VfEoqVhJ7a
	I7evASV24KmFl0=
X-Received: by 2002:a05:620a:4055:b0:8cf:dd4b:8a53 with SMTP id af79cd13be357-8cfdd4b9250mr167236585a.30.1774105459722;
        Sat, 21 Mar 2026 08:04:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:18 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de
Cc: dan.j.williams@intel.com,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH 6/8] dax: plumb hotplug online_type through dax
Date: Sat, 21 Mar 2026 11:04:02 -0400
Message-ID: <20260321150404.3288786-7-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260321150404.3288786-1-gourry@gourry.net>
References: <20260321150404.3288786-1-gourry@gourry.net>
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

Cc:David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         |  3 +++
 drivers/dax/bus.h         |  2 ++
 drivers/dax/cxl.c         |  1 +
 drivers/dax/dax-private.h |  3 +++
 drivers/dax/hmem/hmem.c   |  1 +
 drivers/dax/kmem.c        | 13 +++++++++++--
 6 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index c94c09622516..2c6140dc9382 100644
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
@@ -395,6 +396,7 @@ static ssize_t create_store(struct device *dev, struct device_attribute *attr,
 			.size = 0,
 			.id = -1,
 			.memmap_on_memory = false,
+			.online_type = mhp_get_default_online_type(),
 		};
 		struct dev_dax *dev_dax = __devm_create_dev_dax(&data);
 
@@ -1494,6 +1496,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->online_type = data->online_type;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..f037cd8a2d51 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -3,6 +3,7 @@
 #ifndef __DAX_BUS_H__
 #define __DAX_BUS_H__
 #include <linux/device.h>
+#include <linux/memory_hotplug.h>
 #include <linux/range.h>
 
 struct dev_dax;
@@ -24,6 +25,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	enum mmop online_type;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..d6fbec863361 100644
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
index c6ae27c982f4..734fb83f5eb4 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -8,6 +8,7 @@
 #include <linux/device.h>
 #include <linux/cdev.h>
 #include <linux/idr.h>
+#include <linux/memory_hotplug.h>
 
 /* private routines between core files */
 struct dax_device;
@@ -77,6 +78,7 @@ struct dev_dax_range {
  * @dev: device core
  * @pgmap: pgmap for memmap setup / lifetime (driver owned)
  * @memmap_on_memory: allow kmem to put the memmap in the memory
+ * @online_type: MMOP_* online type for memory hotplug
  * @nr_range: size of @ranges
  * @ranges: range tuples of memory used
  */
@@ -91,6 +93,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	enum mmop online_type;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/hmem/hmem.c b/drivers/dax/hmem/hmem.c
index 1cf7c2a0ee1c..acbc574ced93 100644
--- a/drivers/dax/hmem/hmem.c
+++ b/drivers/dax/hmem/hmem.c
@@ -36,6 +36,7 @@ static int dax_hmem_probe(struct platform_device *pdev)
 		.id = -1,
 		.size = region_idle ? 0 : range_len(&mri->range),
 		.memmap_on_memory = false,
+		.online_type = mhp_get_default_online_type(),
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 798f389df992..d4c34b2e3766 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -16,6 +16,11 @@
 #include "dax-private.h"
 #include "bus.h"
 
+/* Internal function exported only to kmem module */
+extern int __add_memory_driver_managed(int nid, u64 start, u64 size,
+				       const char *resource_name,
+				       mhp_t mhp_flags, enum mmop online_type);
+
 /* Memory resource name used for add_memory_driver_managed(). */
 static const char *kmem_name;
 /* Set if any memory will remain added when the driver will be unloaded. */
@@ -49,6 +54,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
 	int i, rc, mapped = 0;
+	enum mmop online_type;
 	mhp_t mhp_flags;
 	int numa_node;
 	int adist = MEMTIER_DEFAULT_LOWTIER_ADISTANCE;
@@ -111,6 +117,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
+	online_type = dev_dax->online_type;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct resource *res;
 		struct range range;
@@ -151,8 +159,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		 * Ensure that future kexec'd kernels will not treat
 		 * this as RAM automatically.
 		 */
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags);
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
-- 
2.53.0

