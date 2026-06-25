Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6663F3DCD88
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386945; cv=none; b=rOmyhdTuOx4+IHnm1AeLsMsd+HBLL7Hbw1I/i+DX5U09O3uG99v+rKpuU20Q/awa7gZNbcujUvdJ3IDfaaSmUehX/I+3Z7//RZ+VKFgk0ebjlU2kx1SahTZDNA7ZvSK1vGxG1F/gJIfKbynpktEPaoElMgq3PpZRff9Zd6LzfdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386945; c=relaxed/simple;
	bh=8y9XlZUAuI8NH7j1agX1tPhJRts5Om/MPtrpPoaJtiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uQjA+p9PMXpFNAQecryODpL6cO36Eq7oExQgwVdkk3gtRbIrPZ80t87rAV5yGK1nRtL68/DLUt/jF6PQa+04QipwSVqCRmB61qR340O6etZZZT4M51TaggAQ/z5EuI/Cji065gfDyVij+zY3XEAzJiJ8t+g/DuPTri5l7SXS07k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fzHijKVe; arc=none smtp.client-ip=74.125.82.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fzHijKVe"
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-30bc806fcf8so2618181eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386943; x=1782991743; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rxcP66AgOs2IFf6onVo3lGQfXzZAlPR/1RJXrn4HKEw=;
        b=fzHijKVeaG8Yh69KbMWj1Sph69ZLTjhdFGWZMh+EIvX70vTuxRv42wuAwQu4PhbNPR
         sWnidHIN6p9N29/USq+J//6BOgzddRBJ42qDl0YBHdYPWf7uVcVJJXmAeunynXaq471F
         4hWCp1JG7jbVSHeogzYjofTBGjLgo+eRr2aFop7Daqcxu/iHyP+TIj0+7eIec9VLpPvu
         D6OhXfiMbnDbmu9ZYcGuzMBV30m8Ovb0FYN4toyv3ejLVGD5quvjbXpYJEYlgxz09NkD
         3ZY70H9M1SilajZ4u4I0ZAB1GdF0UkhH8lmQBKyD+VWoiDqv2oaASNnhllYkWnQ8bDio
         Aoag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386943; x=1782991743;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rxcP66AgOs2IFf6onVo3lGQfXzZAlPR/1RJXrn4HKEw=;
        b=Leh/GKpO4dTGXlJJozmCRbWO3yJfEqiJ7K9CLNZdmF67eI5Y+WcoLLvmzbBnBsJFpX
         I+q6qYTg0iLIq1GFCB8iExqwOcdl8Qz9hyD0TX52HyZ6KZ/zebDArhBMVyAUXKobycJd
         QIoRcMdtNykCzZfY1pAPPIU5eWREbhbrDOdhqX8zKIK6s0VKO8mW2jEMigNKT424wpg0
         pD3OZMz6sJE5ySaLg1wJgMZeyOEFQYiwmHLrHCAo7f46QCJOt+hRf7V96FLCMk5IeR8h
         JH5n1xoxiuWNvi3bTFSwaYDAeUZqFIoMfngOGbEv0AgamFyRlrRwwmT3O/vlHQJdBbNp
         nH4A==
X-Gm-Message-State: AOJu0YzGyepil95gMX1JOz735fHtHVgXlvAxSL6SUoAYKtRCWF2HYGBw
	UhZc6yeENkdvLsaODxR+cH3PgR+x7nngnM0scl4Q7iVef8/pYHdi/NNUZkbRJw==
X-Gm-Gg: AfdE7cn4kTRahzER05G7+rOWaAsv0dgfdgs/XCIRso+3SPVP13aQMfQbnPqHHO5V+3B
	U9CcIyTXSVU4c9w8YcSIlCh9mWXioExI/wxgsTGsFQ2/FibdszuNz/0osGDLS+JLWqpSr03EcGz
	yrUCr+/NE5L0zyGmazXsDArKqUyitH21Af+rBCWUjQKGSRSKT0cYzKGgDrHQLiYHdVwgX4m8sN3
	f0zA/TDl6hVT7SpxoM+VggknD6AbDMn2HdeL90OE9McFyUvNBa13yZRrHTlVCjYragGZodUyXgd
	MluUK/KAbQPbQDDKn+rN9w/ZRlUYD44ACMIHGgP5Mga9S6KI5UB4Ia7/DuAetmQQ0LKuuO1lSz9
	Z135Y63sfiIx6AtNTWtFdNAoxecm5G9lIbpNGX4xszfLGW9rP5yopcYL4KLV+sVkXtU3l4c030R
	BaS0RylrosUAZo1MhY6NFZjwrVLdpn9j8GDX3oqEku1F1p6cb4KN47ZIeSMr4kqhbO/2AI
X-Received: by 2002:a05:7301:624c:b0:30b:e4a3:44d2 with SMTP id 5a478bee46e88-30c84b64c90mr2513452eec.8.1782386942512;
        Thu, 25 Jun 2026 04:29:02 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.29.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:02 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v11 23/31] dax/bus: Factor out dev dax resize logic
Date: Thu, 25 Jun 2026 04:05:00 -0700
Message-ID: <20260625112638.550691-24-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625112638.550691-1-anisa.su@samsung.com>
References: <20260625112638.550691-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic Capacity (DC) DAX regions back their dax devices with per-extent
resource children of the region, rather than carving from a single
contiguous dax_region->res.  Allocating space for a DC dax device — on
initial uuid claim of its backing extents and on shrink-to-0 during
destroy — needs the same allocator the static case uses, but pointed at
a different parent resource.

In preparation for this change, factor out the dev_dax_resize logic.
For static regions use dax_region->res as the parent to find space for
the dax ranges.  Future patches will use the same algorithm with
individual extent resources as the parent.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Jonathan Cameron <jic23@kernel.org>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>

---
Changes:
1. dev_dax_resize(): change resource_size_t alloc (unsigned) to signed
   ssize_t to correctly capture -errno
---
 drivers/dax/bus.c | 133 +++++++++++++++++++++++++++++-----------------
 1 file changed, 83 insertions(+), 50 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 95683dc8fcd0..ffa6b303fc9b 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1057,11 +1057,10 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	return 0;
 }
 
-static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
-		resource_size_t size, struct dax_resource *dax_resource)
+static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
+			       u64 start, resource_size_t size,
+			       struct dax_resource *dax_resource)
 {
-	struct dax_region *dax_region = dev_dax->region;
-	struct resource *res = &dax_region->res;
 	struct device *dev = &dev_dax->dev;
 	struct dev_dax_range *ranges;
 	unsigned long pgoff = 0;
@@ -1079,14 +1078,14 @@ static int alloc_dev_dax_range(struct dev_dax *dev_dax, u64 start,
 		return 0;
 	}
 
-	alloc = __request_region(res, start, size, dev_name(dev), 0);
+	alloc = __request_region(parent, start, size, dev_name(dev), 0);
 	if (!alloc)
 		return -ENOMEM;
 
 	ranges = krealloc(dev_dax->ranges, sizeof(*ranges)
 			* (dev_dax->nr_range + 1), GFP_KERNEL);
 	if (!ranges) {
-		__release_region(res, alloc->start, resource_size(alloc));
+		__release_region(parent, alloc->start, resource_size(alloc));
 		return -ENOMEM;
 	}
 
@@ -1240,50 +1239,45 @@ static bool adjust_ok(struct dev_dax *dev_dax, struct resource *res)
 	return true;
 }
 
-static ssize_t dev_dax_resize(struct dax_region *dax_region,
-		struct dev_dax *dev_dax, resource_size_t size)
+/**
+ * dev_dax_resize_static - Expand the device into the unused portion of the
+ * region. This may involve adjusting the end of an existing resource, or
+ * allocating a new resource.
+ *
+ * @parent: parent resource to allocate this range in
+ * @dev_dax: DAX device to be expanded
+ * @to_alloc: amount of space to alloc; must be <= space available in @parent
+ *
+ * Return the amount of space allocated or -ERRNO on failure
+ */
+static ssize_t dev_dax_resize_static(struct resource *parent,
+				     struct dev_dax *dev_dax,
+				     resource_size_t to_alloc)
 {
-	resource_size_t avail = dax_region_avail_size(dax_region), to_alloc;
-	resource_size_t dev_size = dev_dax_size(dev_dax);
-	struct resource *region_res = &dax_region->res;
-	struct device *dev = &dev_dax->dev;
 	struct resource *res, *first;
-	resource_size_t alloc = 0;
 	int rc;
 
-	if (dev->driver)
-		return -EBUSY;
-	if (size == dev_size)
-		return 0;
-	if (size > dev_size && size - dev_size > avail)
-		return -ENOSPC;
-	if (size < dev_size)
-		return dev_dax_shrink(dev_dax, size);
-
-	to_alloc = size - dev_size;
-	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
-			"resize of %pa misaligned\n", &to_alloc))
-		return -ENXIO;
-
-	/*
-	 * Expand the device into the unused portion of the region. This
-	 * may involve adjusting the end of an existing resource, or
-	 * allocating a new resource.
-	 */
-retry:
-	first = region_res->child;
-	if (!first)
-		return alloc_dev_dax_range(dev_dax, dax_region->res.start, to_alloc, NULL);
+	first = parent->child;
+	if (!first) {
+		rc = alloc_dev_dax_range(parent, dev_dax,
+					   parent->start, to_alloc, NULL);
+		if (rc)
+			return rc;
+		return to_alloc;
+	}
 
-	rc = -ENOSPC;
 	for (res = first; res; res = res->sibling) {
 		struct resource *next = res->sibling;
+		resource_size_t alloc;
 
 		/* space at the beginning of the region */
-		if (res == first && res->start > dax_region->res.start) {
-			alloc = min(res->start - dax_region->res.start, to_alloc);
-			rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, alloc, NULL);
-			break;
+		if (res == first && res->start > parent->start) {
+			alloc = min(res->start - parent->start, to_alloc);
+			rc = alloc_dev_dax_range(parent, dev_dax,
+						 parent->start, alloc, NULL);
+			if (rc)
+				return rc;
+			return alloc;
 		}
 
 		alloc = 0;
@@ -1292,21 +1286,58 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 			alloc = min(next->start - (res->end + 1), to_alloc);
 
 		/* space at the end of the region */
-		if (!alloc && !next && res->end < region_res->end)
-			alloc = min(region_res->end - res->end, to_alloc);
+		if (!alloc && !next && res->end < parent->end)
+			alloc = min(parent->end - res->end, to_alloc);
 
 		if (!alloc)
 			continue;
 
 		if (adjust_ok(dev_dax, res)) {
 			rc = adjust_dev_dax_range(dev_dax, res, resource_size(res) + alloc);
-			break;
+			if (rc)
+				return rc;
+			return alloc;
 		}
-		rc = alloc_dev_dax_range(dev_dax, res->end + 1, alloc, NULL);
-		break;
+		rc = alloc_dev_dax_range(parent, dev_dax, res->end + 1, alloc, NULL);
+		if (rc)
+			return rc;
+		return alloc;
 	}
-	if (rc)
-		return rc;
+
+	/* available was already calculated and should never be an issue */
+	dev_WARN_ONCE(&dev_dax->dev, 1, "space not found?");
+	return 0;
+}
+
+static ssize_t dev_dax_resize(struct dax_region *dax_region,
+		struct dev_dax *dev_dax, resource_size_t size)
+{
+	resource_size_t avail = dax_region_avail_size(dax_region);
+	resource_size_t dev_size = dev_dax_size(dev_dax);
+	struct device *dev = &dev_dax->dev;
+	resource_size_t to_alloc;
+	ssize_t alloc;
+
+	if (dev->driver)
+		return -EBUSY;
+	if (size == dev_size)
+		return 0;
+	if (size > dev_size && size - dev_size > avail)
+		return -ENOSPC;
+	if (size < dev_size)
+		return dev_dax_shrink(dev_dax, size);
+
+	to_alloc = size - dev_size;
+	if (dev_WARN_ONCE(dev, !alloc_is_aligned(dev_dax, to_alloc),
+			"resize of %pa misaligned\n", &to_alloc))
+		return -ENXIO;
+
+retry:
+	alloc = dev_dax_resize_static(&dax_region->res, dev_dax, to_alloc);
+	if (alloc < 0)
+		return alloc;
+	if (alloc == 0)
+		return -ENOSPC;
 	to_alloc -= alloc;
 	if (to_alloc)
 		goto retry;
@@ -1412,7 +1443,8 @@ static ssize_t mapping_store(struct device *dev, struct device_attribute *attr,
 
 	to_alloc = range_len(&r);
 	if (alloc_is_aligned(dev_dax, to_alloc))
-		rc = alloc_dev_dax_range(dev_dax, r.start, to_alloc, NULL);
+		rc = alloc_dev_dax_range(&dax_region->res, dev_dax, r.start,
+					 to_alloc, NULL);
 	up_write(&dax_dev_rwsem);
 	up_write(&dax_region_rwsem);
 
@@ -1700,7 +1732,8 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	device_initialize(dev);
 	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
 
-	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size, NULL);
+	rc = alloc_dev_dax_range(&dax_region->res, dev_dax, dax_region->res.start,
+				 data->size, NULL);
 	if (rc)
 		goto err_range;
 
-- 
2.43.0

