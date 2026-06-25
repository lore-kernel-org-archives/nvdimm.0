Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33373DD502
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 11:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782386950; cv=none; b=dTsMm4E25xSUbyPlQKVHx40mglSIrbzfWYrBXUpWnL30f4j1E4YUhZXAgTBXREM23TxQygc2w1RBXGpkAkikxA+EnQni8xvgjCSlK4tvb6l4Yy50glcrIYu0ZtymhzD0Qokh/gT3F6AexUIQqw00h027HLAbsuCi2Fe4fdpcEbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782386950; c=relaxed/simple;
	bh=0FIgHtCqfeIdiOrbdWlSzNzgpp8YThR4yXQtiZ/aIKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YAqPYsQrM4hECzPWHfp6b0kBTBCO1yS03iG2t7ox1SyL601VUitf2Yd2c1fXb+q3ass33Tk8R6YxSOdGwz+bVS4+u5btmwKRPT22YFfvCYM3cMJ/4YnA/nXmACGGLkfFvhXuKRgdKGgXHH/i8h1CjicZpqshvSGGlbV1dOO4qrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ilhMAox/; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilhMAox/"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-30bf8b2bd20so4520093eec.0
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 04:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782386947; x=1782991747; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mePCkbEkuUSQOa5JktAYkYWokkGxDcbgimTZMnF9nTU=;
        b=ilhMAox/A+z2Gv/Blfqa3/dKQycUx/R/ts5CKfvCr6reTBcjto/yukd+MGdSmGU4vW
         t67klG3qK/xrQJg2RuEx0oBGJmkXqdyCyDM/BuSMBOW6rSES4B9bJVHJ+gq3Fl4bkljx
         APzZ+fme4OA/zhWvl1OcIqMhrY/cekE2cio7sS0xxGn+Kc1kAn97x0WcRrSeVMUfQtTi
         tndXvsd6xx/3Zic9ZIlI0Gh2sig5vh0VcXSFpDppIcSCVDn3GHW8ZhfFP/p7KU4vO7jw
         kCoQ6OETYMePcDsHd/6UKR03qDiuSKRFrx6nqSOaECfVFA9t2b4vmPth+j3DFHgs2+KR
         ReCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782386947; x=1782991747;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mePCkbEkuUSQOa5JktAYkYWokkGxDcbgimTZMnF9nTU=;
        b=Q3fdw7R+/yiyTFaibxkwcszpuzgF8nfpuZ/SIKCk/hfwD+qQLA4tWDr8tB9+O0b25+
         LEH1vrHheIya/8MoEk3ou+eBYqYpXVjpGeF2CzOnKzno4PCwMCvgnQZCOUP6qO8URSXo
         BvPPDoZlwRtu/JbXFkkiVjzY4UBcMIY7aSUO44zKRptj+VuY4xy6ePYQCbsxhA2a5WO+
         ThGjuGp6IxeBqgOJtq/rrb7kFO7oT3NDBduToMaJhC7e8mr2R/lcLUnk22ESofCpX+so
         SVtb6C9MRU3zYzV/D5vMP1xCTTMvWq9H7mxLn302FwdL/kHLwCSZyTD5aDn9A3SdDJhn
         xBtg==
X-Gm-Message-State: AOJu0YzoXzptXU8yK/GvMr6xDeTVU8oUE7EpkZQDo3tzZJvEl9wFBdBx
	8cwyb3vdc7twqk6BB6cSSnPF5h71hoD/KcWSwA9vxZOqKvyjxZfCe3BO
X-Gm-Gg: AfdE7ckwwfbuDkmUrv3cltSN6fhxGE2jGUZGHFf+uPQkXACICHLeiVUjRe1r7HndLZS
	YAH7AlIqd6M05f0ASrbtOKoMUXkRUywRI9u/oL+OUQjYPSqwWk5QtA1A9TEYPMEu0NhFvbbSzGu
	Z7uHYjrHN7w7x/YiCi/pv4SriDPrFXw/Dz6E9In5OYjVZclh/KoFuYeD5LsoV/f1+gRJyJxhfON
	1j0XojM6cy8sJVGF6ATCyi+0LLDtXs4gJlGAcPB8J78UkwBBCC7bKChX+4pQuKDkYYULJSx93ts
	qneAAYWGeRpTUKpf7mW/yzJKhgm8RwCXJ4khATVq0jGr9G9G1XJOB2T5IoGBRlDRsxlMX6PABca
	e3h8uFNAaRhshv37yaE3Il8R0tqH4/iBlzOHV2zJgTNPq/QNAEOviWak8ZqCOxZst7r1cYsrCae
	am3NX4aKinH5C0cUVHUtF8ZB/X5Lq2DQdySpskxAetxXvXAfnTElNe14+wRxlk1qoEPvvX
X-Received: by 2002:a05:7300:1485:b0:30c:7ab6:7ff7 with SMTP id 5a478bee46e88-30c84bc4e7amr2663337eec.15.1782386946942;
        Thu, 25 Jun 2026 04:29:06 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7cab08c2sm8744614eec.29.2026.06.25.04.29.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 04:29:06 -0700 (PDT)
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
Subject: [PATCH v11 26/31] dax/bus: Tag-aware uuid claim and show on DC dax devices
Date: Thu, 25 Jun 2026 04:05:03 -0700
Message-ID: <20260625112638.550691-27-anisa.su@samsung.com>
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

DC DAX regions are populated with dax_resource children that each carry a
backing tag uuid and a per-allocation sequence number (seq_num).  Add the
userspace claim semantics that resolve those tagged groups into DAX
devices.

A DC region's seed dax device is created at 0-size on probe; userspace
populates it by writing to its 'uuid' attribute:

  * A non-null UUID claims every dax_resource on this region whose tag
    matches, in seq_num order via uuid_claim_tagged().  The match set
    must form a dense 0..n-1 sequence (no gap, no duplicate); the CXL
    side maintains this invariant for both sharable allocations (where
    the device stamps shared_extn_seq) and non-sharable allocations
    (where cxl_realize_group assigns arrival-order seq).  The resulting
    DAX device's size equals the sum of every member extent's size.

  * "0" claims a single untagged dax_resource via
    uuid_claim_untagged().  Untagged extents are independent
    allocations; collapsing several would aggregate unrelated capacity,
    so each uuid="0" write consumes exactly one untagged resource.

  * A write that matches no dax_resource returns -ENOENT; the device
    stays at size 0.

  * A write to an already-claimed device (non-zero size) returns
    -EBUSY; a device's uuid cannot be overwritten once claimed.

uuid_show() reads back the backing tag uuid (or the null UUID for an
untagged claim).  The attribute is read-only (0444) on non-DC dax
devices; writes to it on non-DC regions return -EOPNOTSUPP.

dev_dax_visible() makes the uuid attribute writable on DC dax devices
and read-only elsewhere.

Based on an original patch by Navneet Singh.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>

---
Changes:
[anisa: uuid_show() emits the null uuid ("%pUb" of uuid_null) rather
 than "0" for an untagged or uuid-less device, matching the documented
 read value.]
[anisa: uuid_show()/uuid_store() take their rwsems via ACQUIRE() scoped
 guards instead of explicit down/up with goto unwinding.]
[anisa: uuid_store() refuses to re-claim an already-claimed device
 (-EBUSY) so a uuid cannot be overwritten.]
---
 drivers/dax/bus.c | 262 +++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 259 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index f086ad27d507..d94c0853af10 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -5,6 +5,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/slab.h>
+#include <linux/sort.h>
 #include <linux/dax.h>
 #include <linux/io.h>
 #include "dax-private.h"
@@ -1100,6 +1101,9 @@ static int alloc_dev_dax_range(struct resource *parent, struct dev_dax *dev_dax,
 		},
 		.dax_resource = dax_resource,
 	};
+	/* Pin the extent for this range; trim_dev_dax_range() drops it. */
+	if (dax_resource)
+		dax_resource->use_cnt++;
 
 	dev_dbg(dev, "alloc range[%d]: %pa:%pa\n", dev_dax->nr_range - 1,
 			&alloc->start, &alloc->end);
@@ -1363,6 +1367,89 @@ static ssize_t dev_dax_resize(struct dax_region *dax_region,
 	return 0;
 }
 
+/* DC extents are all-or-nothing: an extent is either free or fully claimed. */
+static bool dax_resource_in_use(const struct dax_resource *dax_resource)
+{
+	return dax_resource->use_cnt > 0;
+}
+
+struct dax_uuid_match {
+	const struct dax_region *dax_region;
+	const uuid_t *uuid;
+};
+
+static int find_uuid_extent(struct device *dev, const void *data)
+{
+	const struct dax_uuid_match *match = data;
+	struct dax_resource *dax_resource;
+
+	if (!match->dax_region->dc_ops->is_extent(dev))
+		return 0;
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource || dax_resource_in_use(dax_resource))
+		return 0;
+	return uuid_equal(&dax_resource->uuid, match->uuid);
+}
+
+struct dax_tag_collect {
+	const struct dax_region *dax_region;
+	const uuid_t *uuid;
+	struct dax_resource **arr;
+	unsigned int count;
+	unsigned int cap;
+};
+
+static int collect_uuid_extent(struct device *dev, void *data)
+{
+	struct dax_tag_collect *c = data;
+	struct dax_resource *dax_resource;
+
+	if (!c->dax_region->dc_ops->is_extent(dev))
+		return 0;
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource || dax_resource_in_use(dax_resource))
+		return 0;
+	if (!uuid_equal(&dax_resource->uuid, c->uuid))
+		return 0;
+
+	if (c->count == c->cap)
+		return -ENOSPC;
+	c->arr[c->count++] = dax_resource;
+	return 0;
+}
+
+static int count_uuid_extent(struct device *dev, void *data)
+{
+	struct dax_tag_collect *c = data;
+	struct dax_resource *dax_resource;
+
+	if (!c->dax_region->dc_ops->is_extent(dev))
+		return 0;
+
+	dax_resource = dev_get_drvdata(dev);
+	if (!dax_resource || dax_resource_in_use(dax_resource))
+		return 0;
+	if (!uuid_equal(&dax_resource->uuid, c->uuid))
+		return 0;
+
+	c->count++;
+	return 0;
+}
+
+static int dax_resource_seq_cmp(const void *a, const void *b)
+{
+	const struct dax_resource * const *pa = a;
+	const struct dax_resource * const *pb = b;
+
+	if ((*pa)->seq_num < (*pb)->seq_num)
+		return -1;
+	if ((*pa)->seq_num > (*pb)->seq_num)
+		return 1;
+	return 0;
+}
+
 static ssize_t size_store(struct device *dev, struct device_attribute *attr,
 		const char *buf, size_t len)
 {
@@ -1595,13 +1682,178 @@ static DEVICE_ATTR_RO(numa_node);
 static ssize_t uuid_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	int rc;
+
+	ACQUIRE(rwsem_read_intr, rwsem)(&dax_dev_rwsem);
+	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
+		return rc;
+
+	for (int i = 0; i < dev_dax->nr_range; i++) {
+		struct dax_resource *r = dev_dax->ranges[i].dax_resource;
+
+		if (r && !uuid_is_null(&r->uuid))
+			return sysfs_emit(buf, "%pUb\n", &r->uuid);
+	}
 	return sysfs_emit(buf, "%pUb\n", &uuid_null);
 }
 
+static ssize_t uuid_claim_untagged(struct dax_region *dax_region,
+				   struct dev_dax *dev_dax)
+{
+	struct dax_uuid_match match = {
+		.dax_region = dax_region,
+		.uuid = &uuid_null,
+	};
+	struct dax_resource *dax_resource;
+	resource_size_t to_alloc;
+	struct device *extent_dev;
+	ssize_t alloc;
+
+	extent_dev = device_find_child(dax_region->dev, &match,
+				       find_uuid_extent);
+	if (!extent_dev)
+		return -ENOENT;
+
+	dax_resource = dev_get_drvdata(extent_dev);
+	to_alloc = resource_size(dax_resource->res);
+	if (!alloc_is_aligned(dev_dax, to_alloc)) {
+		put_device(extent_dev);
+		return -EINVAL;
+	}
+	alloc = __dev_dax_resize(dax_resource->res, dev_dax, to_alloc,
+				 dax_resource);
+	put_device(extent_dev);
+	if (alloc < 0)
+		return alloc;
+	if (alloc == 0)
+		return -ENOENT;
+	return 0;
+}
+
+static ssize_t uuid_claim_tagged(struct dax_region *dax_region,
+				 struct dev_dax *dev_dax, const uuid_t *uuid)
+{
+	struct dax_tag_collect c = {
+		.dax_region = dax_region,
+		.uuid = uuid,
+	};
+	unsigned int i;
+	ssize_t rc;
+
+	/* Two-pass: count, then collect into a sized array. */
+	device_for_each_child(dax_region->dev, &c, count_uuid_extent);
+	if (!c.count)
+		return -ENOENT;
+
+	c.arr = kmalloc_array(c.count, sizeof(*c.arr), GFP_KERNEL);
+	if (!c.arr)
+		return -ENOMEM;
+	c.cap = c.count;
+	c.count = 0;
+
+	rc = device_for_each_child(dax_region->dev, &c, collect_uuid_extent);
+	if (rc)
+		goto out;
+
+	sort(c.arr, c.count, sizeof(*c.arr), dax_resource_seq_cmp, NULL);
+
+	/*
+	 * Tagged groups carry a dense 0..n-1 @seq_num regardless of source —
+	 * the device-stamped shared_extn_seq (already 0..n-1) for a sharable
+	 * partition, or cxl-side arrival order for a non-sharable one (see
+	 * &struct dax_resource).  A gap or out-of-range value here means an
+	 * extent went missing on the cxl side (e.g. a per-extent failure in
+	 * cxl_add_pending) or a cxl-side validation gap; in either case
+	 * refuse the whole group rather than carve a partial allocation.
+	 */
+	for (i = 0; i < c.count; i++) {
+		if (c.arr[i]->seq_num != i) {
+			dev_WARN_ONCE(dax_region->dev, 1,
+				"tag %pUb seq invariant violated at slot %u (got %u)\n",
+				uuid, i, c.arr[i]->seq_num);
+			rc = -EINVAL;
+			goto out;
+		}
+	}
+
+	for (i = 0; i < c.count; i++) {
+		resource_size_t to_alloc = resource_size(c.arr[i]->res);
+		ssize_t alloc;
+
+		if (!alloc_is_aligned(dev_dax, to_alloc)) {
+			rc = -EINVAL;
+			goto rollback;
+		}
+		alloc = __dev_dax_resize(c.arr[i]->res, dev_dax, to_alloc,
+					 c.arr[i]);
+		if (alloc < 0) {
+			rc = alloc;
+			goto rollback;
+		}
+		if (alloc == 0) {
+			rc = -ENOSPC;
+			goto rollback;
+		}
+	}
+	rc = 0;
+	goto out;
+
+rollback:
+	/*
+	 * Partial failure: trim every range we added in this attempt.
+	 * trim_dev_dax_range pops the most-recently-appended range from
+	 * dev_dax->ranges[] and decrements its dax_resource->use_cnt, so
+	 * looping until we have undone @i additions restores both
+	 * dev_dax->ranges[] and the matched dax_resources' use_cnt.
+	 */
+	while (i-- > 0)
+		trim_dev_dax_range(dev_dax);
+out:
+	kfree(c.arr);
+	return rc;
+}
+
 static ssize_t uuid_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
-	return -EOPNOTSUPP;
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_region *dax_region = dev_dax->region;
+	uuid_t uuid;
+	ssize_t rc;
+
+	if (!is_dynamic(dax_region))
+		return -EOPNOTSUPP;
+
+	if (sysfs_streq(buf, "0"))
+		uuid_copy(&uuid, &uuid_null);
+	else {
+		rc = uuid_parse(buf, &uuid);
+		if (rc)
+			return rc;
+	}
+
+	ACQUIRE(rwsem_write_kill, region_rwsem)(&dax_region_rwsem);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &region_rwsem)))
+		return rc;
+
+	if (!dax_region->dev->driver)
+		return -ENXIO;
+
+	ACQUIRE(rwsem_write_kill, dev_rwsem)(&dax_dev_rwsem);
+	if ((rc = ACQUIRE_ERR(rwsem_write_kill, &dev_rwsem)))
+		return rc;
+
+	/* A claimed device already has capacity; do not overwrite its uuid. */
+	if (dev_dax_size(dev_dax))
+		return -EBUSY;
+
+	if (uuid_is_null(&uuid))
+		rc = uuid_claim_untagged(dax_region, dev_dax);
+	else
+		rc = uuid_claim_tagged(dax_region, dev_dax, &uuid);
+
+	return rc < 0 ? rc : len;
 }
 static DEVICE_ATTR_RW(uuid);
 
@@ -1661,8 +1913,12 @@ static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 		return 0;
 	if (a == &dev_attr_mapping.attr && is_dynamic(dax_region))
 		return 0;
-	if ((a == &dev_attr_align.attr ||
-	     a == &dev_attr_size.attr) && is_static(dax_region))
+	if (a == &dev_attr_uuid.attr && !is_dynamic(dax_region))
+		return 0444;
+	if (a == &dev_attr_align.attr &&
+	    (is_static(dax_region) || is_dynamic(dax_region)))
+		return 0444;
+	if (a == &dev_attr_size.attr && is_static(dax_region))
 		return 0444;
 	return a->mode;
 }
-- 
2.43.0

