Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83E631063B
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 23:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768434672; cv=none; b=HjeJVUSpO5cvAT79CTMHv3e15kQzDUF9XfeTgu6DcnR+3oOi+Kr5KgnnGITGts0EJil1NoQgsFuvEx6cZa579N8WZvnwcxSZsfXKJaptIgAc2IoDnwbnzpom84bu4WpwYh8iaTRXI8ifI7/7btewAuBByh4/asmWj2MsO7UI/+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768434672; c=relaxed/simple;
	bh=nRAut67R7AZnmpI2c6KDyJy5GJhpgCVlac//vrUZeCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7K9gWhilvnm/25L24uFAtF/ToHCyCgcfpF8Ok7a4jbcmmx2OlNsQAU2FhA3usWDCVKfLhCqX5wYnXlYFuRbWADFmRPP7RC1U9km/qHyz+1q8c1JPYvR0kHj7m6t0VnvRv9NFoTIUBRe8Y2XX9VQVXcKbbX8RmJ54aSLB94Kk0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=BMqkAlII; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="BMqkAlII"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8c6a0702b86so1587385a.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 15:51:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768434669; x=1769039469; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D6NjMNgXdh9z9NOdem2QceXvpTYCSkYsdbHZHUdgJ+E=;
        b=BMqkAlII41PZ+zpQvAFHGGAul9jI1uviRRqDgZCnETSrPbTOg05eYSc4iJ6mRVYeY7
         HyfSn9BMTkD3LSi0zB5PwjQo+CjuzjNPR3jkek3dHSECA/XAsRQjwMrtbv3xq9geoiN/
         RlbGm9BVlv3aHo+CI0bEc2BoTqWWmSV7bxtYRl4A7S7riegguzaPmrvkV47ZANv91qNo
         7E9epHnsDEf9tQJbMID7lUifKUgkTOW122uWKGuQGE9XaeUgonfbIgpSuB7t1jzQsI5T
         ZR+VxomQv3ATd41JlBdFjleAcguf3I9rai5foGEj6440n0UCrU7TyLZAkosQUPx0RtCV
         W76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768434669; x=1769039469;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D6NjMNgXdh9z9NOdem2QceXvpTYCSkYsdbHZHUdgJ+E=;
        b=ijaCG4R5tGWIx8P9G1PeXJ1W8+38eUU3eDuTUvTJqZJ9kKgZQ2ENnxcc15Y+PgtiQf
         /HOXZcNGLyYUuUfciZ55nmvG1rubuk7OLJkV0nMvKk0axaVzhw/ibIpleT0l4uoWA+Va
         VGWGm1LfnbmUzcxhm0kw07Eh0jrTWd+ru2zal584hynja6ZxKreQ8W5YUKFnmPfEcvGf
         f2pOzXSxzyO+WHAFTlMJbKtsvHcHogKH0Okx9zPGbiKldwuW/2N30pXVOaq4UEnL4daW
         bahHS+1XZLriHN7nIsLThD/M9qfymTNXDtnOwKQ7JNsvDSPFHzDGsvcmIFyuB70XUXla
         2ynA==
X-Forwarded-Encrypted: i=1; AJvYcCVfqFaYSUsSYRc1gv4Gbh+0htJhiqoRBoN7ssAZzeE9EC/LGl/3nzRXwo9fq/bx3Dcq7rAnXNo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwLKG8fycIfPaLKjhLoXrPKC0Az4TMUVb2cTeaZ/ttY5kFaAroc
	B5hlis/wGY8+GRZ3Bfvwj2+B1XHavAv2yljLZJ/+Lt7jrpYdjFY9aB8IV7GT5LMgjrY=
X-Gm-Gg: AY/fxX7btCNdT9BjVRQwx2fAlfgSO+HY8R75+6QPBYbYIGPnosnQWFUqK78FWUxmvjs
	Ez7uWVhmenqeZdWIaJ/RYtzzS7fntzhfXx1/p+LVlJQjDiBTcsb1lvLTaMfLItnYCKgFN8QjZGe
	irI8q38ztKynlXfFyZKdn/tS6MYjmEf2hOtS8XokYZCL9Jz4ul8Wuawzx+cWfz0Ek06OCmje9ap
	E0lf/AmzRlVm/LfozGn7wD40qLDTkiNXKmtCiQulCSP9RUCBkwPDqGhzT+qw/EuK393dhBQwOSV
	5+H0DQdwNw3FUQYauXKtCqo22v3fOjlNPLIK9hZlspHwyzllPt49X/TGuoZk4Yv2wwwiD1V+FN7
	r2JLZCbP9/M2AcHn/0pECAOVdc68Dj5NkVToNuulUm0HAUbFUF2JEkk03EQq1XzYPxX8SzOft4x
	UPFLCUt5C1hvbmjBsC3K6DyaqVYGEkVH9xBaQu+xmOwXmdWcy7D1iLHG7EZZ6dpbvzrEaexzOgO
	70=
X-Received: by 2002:a05:6214:2123:b0:882:6797:3a67 with SMTP id 6a1803df08f44-89275ad80acmr64527286d6.13.1768434668684;
        Wed, 14 Jan 2026 15:51:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890772346f8sm188449106d6.35.2026.01.14.15.51.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 15:51:07 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev,
	kernel-team@meta.com,
	dan.j.williams@intel.com,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	david@kernel.org,
	mst@redhat.com,
	jasowang@redhat.com,
	xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com,
	osalvador@suse.de,
	akpm@linux-foundation.org
Subject: [PATCH v2 5/5] dax/kmem: add memory notifier to block external state changes
Date: Wed, 14 Jan 2026 18:50:21 -0500
Message-ID: <20260114235022.3437787-6-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-1-gourry@gourry.net>
References: <20260114235022.3437787-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add a memory notifier to prevent external operations from changing the
online/offline state of memory blocks managed by dax_kmem. This ensures
state changes only occur through the driver's hotplug sysfs interface,
providing consistent state tracking and preventing races with auto-online
policies or direct memory block sysfs manipulation.

The goal of this is to prevent `daxN.M/hotplug` from becoming
inconsistent with the state of the memory blocks it owns.

The notifier uses a transition protocol with memory barriers:
  - Before initiating a state change, set target_state then in_transition
  - Use barrier to ensure target_state is visible before in_transition
  - The notifier checks in_transition, then uses barrier before reading
    target_state to ensure proper ordering on weakly-ordered architectures

The notifier callback:
  - Returns NOTIFY_DONE for non-overlapping memory (not our concern)
  - Returns NOTIFY_BAD if in_transition is false (block external ops)
  - Validates the memory event matches target_state (MEM_GOING_ONLINE
    for online operations, MEM_GOING_OFFLINE for offline/unplug)
  - Returns NOTIFY_OK only for driver-initiated operations with matching
    target_state

This prevents scenarios where:
  - Users manually change memory state via /sys/devices/system/memory/
  - Other kernel subsystems interfere with driver-managed memory state
    (may be important for regions trying to preserve hot-unpluggability)

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 157 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 154 insertions(+), 3 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c222ae9d675d..f3562f65376c 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -53,6 +53,9 @@ struct dax_kmem_data {
 	struct dev_dax *dev_dax;
 	int state;
 	struct mutex lock; /* protects hotplug state transitions */
+	bool in_transition;
+	int target_state;
+	struct notifier_block mem_nb;
 	struct resource *res[];
 };
 
@@ -71,6 +74,116 @@ static void kmem_put_memory_types(void)
 	mt_put_memory_types(&kmem_memory_types);
 }
 
+/**
+ * dax_kmem_start_transition - begin a driver-initiated state transition
+ * @data: the dax_kmem_data structure
+ * @target: the target state (MMOP_ONLINE, MMOP_ONLINE_MOVABLE, or MMOP_OFFLINE)
+ *
+ * Sets up state for a driver-initiated memory operation. The memory notifier
+ * will only allow operations that match this target state while in transition.
+ * Uses store-release to ensure target_state is visible before in_transition.
+ */
+static void dax_kmem_start_transition(struct dax_kmem_data *data, int target)
+{
+	data->target_state = target;
+	smp_store_release(&data->in_transition, true);
+}
+
+/**
+ * dax_kmem_end_transition - end a driver-initiated state transition
+ * @data: the dax_kmem_data structure
+ *
+ * Clears the in_transition flag after a state change completes or aborts.
+ */
+static void dax_kmem_end_transition(struct dax_kmem_data *data)
+{
+	WRITE_ONCE(data->in_transition, false);
+}
+
+/**
+ * dax_kmem_overlaps_range - check if a memory range overlaps with this device
+ * @data: the dax_kmem_data structure
+ * @start: start physical address of the range to check
+ * @size: size of the range to check
+ *
+ * Returns true if the range overlaps with any of the device's memory ranges.
+ */
+static bool dax_kmem_overlaps_range(struct dax_kmem_data *data,
+				    u64 start, u64 size)
+{
+	struct dev_dax *dev_dax = data->dev_dax;
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+		struct range check = DEFINE_RANGE(start, start + size - 1);
+
+		if (dax_kmem_range(dev_dax, i, &range))
+			continue;
+
+		if (!data->res[i])
+			continue;
+
+		if (range_overlaps(&range, &check))
+			return true;
+	}
+	return false;
+}
+
+/**
+ * dax_kmem_memory_notifier_cb - memory notifier callback for dax kmem
+ * @nb: the notifier block (embedded in dax_kmem_data)
+ * @action: the memory event (MEM_GOING_ONLINE, MEM_GOING_OFFLINE, etc.)
+ * @arg: pointer to memory_notify structure
+ *
+ * This callback prevents external operations (e.g., from sysfs or auto-online
+ * policies) on memory blocks managed by dax_kmem. Only operations initiated
+ * by the driver itself (via the hotplug sysfs interface) are allowed.
+ *
+ * Returns NOTIFY_OK to allow the operation, NOTIFY_BAD to block it,
+ * or NOTIFY_DONE if the memory doesn't belong to this device.
+ */
+static int dax_kmem_memory_notifier_cb(struct notifier_block *nb,
+				       unsigned long action, void *arg)
+{
+	struct dax_kmem_data *data = container_of(nb, struct dax_kmem_data,
+						  mem_nb);
+	struct memory_notify *mhp = arg;
+	const u64 start = PFN_PHYS(mhp->start_pfn);
+	const u64 size = PFN_PHYS(mhp->nr_pages);
+
+	/* Only interested in going online/offline events */
+	if (action != MEM_GOING_ONLINE && action != MEM_GOING_OFFLINE)
+		return NOTIFY_DONE;
+
+	/* Check if this memory belongs to our device */
+	if (!dax_kmem_overlaps_range(data, start, size))
+		return NOTIFY_DONE;
+
+	/*
+	 * Block all operations unless we're in a driver-initiated transition.
+	 * When in_transition is set, only allow operations that match our
+	 * target_state to prevent races with external operations.
+	 *
+	 * Use load-acquire to pair with the store-release in
+	 * dax_kmem_start_transition(), ensuring target_state is visible.
+	 */
+	if (!smp_load_acquire(&data->in_transition))
+		return NOTIFY_BAD;
+
+	/* Online operations expect MEM_GOING_ONLINE */
+	if (action == MEM_GOING_ONLINE &&
+	    (data->target_state == MMOP_ONLINE ||
+	     data->target_state == MMOP_ONLINE_MOVABLE))
+		return NOTIFY_OK;
+
+	/* Offline/hotremove operations expect MEM_GOING_OFFLINE */
+	if (action == MEM_GOING_OFFLINE && data->target_state == MMOP_OFFLINE)
+		return NOTIFY_OK;
+
+	return NOTIFY_BAD;
+}
+
 /**
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
@@ -325,11 +438,27 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
 	if (data->state == online_type)
 		return len;
 
+	/*
+	 * Start transition with target_state for the notifier.
+	 * For unplug, use MMOP_OFFLINE since memory goes offline before removal.
+	 */
+	if (online_type == DAX_KMEM_UNPLUGGED || online_type == MMOP_OFFLINE)
+		dax_kmem_start_transition(data, MMOP_OFFLINE);
+	else
+		dax_kmem_start_transition(data, online_type);
+
 	if (online_type == DAX_KMEM_UNPLUGGED) {
+		int expected = 0;
+
+		for (rc = 0; rc < dev_dax->nr_range; rc++)
+			if (data->res[rc])
+				expected++;
+
 		rc = dax_kmem_do_hotremove(dev_dax, data);
-		if (rc < 0) {
+		dax_kmem_end_transition(data);
+		if (rc < expected) {
 			dev_warn(dev, "hotplug state is inconsistent\n");
-			return rc;
+			return rc == 0 ? -EBUSY : -EIO;
 		}
 		data->state = DAX_KMEM_UNPLUGGED;
 		return len;
@@ -339,10 +468,14 @@ static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
 	 * online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE
 	 * Cannot switch between online types without unplugging first
 	 */
-	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE) {
+		dax_kmem_end_transition(data);
 		return -EBUSY;
+	}
 
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	dax_kmem_end_transition(data);
+
 	if (rc < 0)
 		return rc;
 
@@ -430,13 +563,26 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_resources;
 
+	/* Register memory notifier to block external operations */
+	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
+	rc = register_memory_notifier(&data->mem_nb);
+	if (rc) {
+		dev_warn(dev, "failed to register memory notifier\n");
+		goto err_notifier;
+	}
+
 	/*
 	 * Hotplug using the system default policy - this preserves backwards
 	 * for existing users who rely on the default auto-online behavior.
+	 *
+	 * Start transition with resolved system default since the notifier
+	 * validates the operation type matches.
 	 */
 	online_type = mhp_get_default_online_type();
 	if (online_type != MMOP_OFFLINE) {
+		dax_kmem_start_transition(data, online_type);
 		rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+		dax_kmem_end_transition(data);
 		if (rc < 0)
 			goto err_hotplug;
 		data->state = online_type;
@@ -449,6 +595,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	return 0;
 
 err_hotplug:
+	unregister_memory_notifier(&data->mem_nb);
+err_notifier:
 	dax_kmem_cleanup_resources(dev_dax, data);
 err_resources:
 	dev_set_drvdata(dev, NULL);
@@ -471,6 +619,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 
 	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
+	unregister_memory_notifier(&data->mem_nb);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -488,8 +637,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
 	device_remove_file(dev, &dev_attr_hotplug);
+	unregister_memory_notifier(&data->mem_nb);
 
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
-- 
2.52.0

