Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDAA3C4561
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 21:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780694386; cv=none; b=KCOPZOIvGc8J5aJYaK45sxZbNp7KwhUqan7OdrdanJMQIvfaRZ9/vDr8LD4xVNLSpX0gNCtg5zdrLvtR1f3fP7UJoh0q2PskXeEHbyZmkk237mGtGpBAqCSNlKKtN+f4IUSZyoxfkqW3db3tJdT/eFkyPUuySQg+T1sJT7D1iKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780694386; c=relaxed/simple;
	bh=9CpRZ1PTLXL19tu3viFtgHaeaSck+ZLsJxDbLqcK7oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzBaJIEVkDEg8tn5aa4lvy8dt/rPKLckvVQnpUivCzzTVIM8NJ5/e83nB9/veQgwrG6k6GbDXnZtzpdlbn9Hd/HycCFMsfmjbr9CaCGEsUaFm+aIaYfWIZa2d121oFnJN4FSHgSsK84JvydsFBbt8zN1/QlMbGcvqnK13gbpbxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=fIphhIPm; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="fIphhIPm"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8ccda0ac4fcso23914136d6.2
        for <nvdimm@lists.linux.dev>; Fri, 05 Jun 2026 14:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1780694372; x=1781299172; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5exm6bvtYER1f7kjLSkpnggeDTqAdK/YdweX4Bm/Ql8=;
        b=fIphhIPm5au+jjS6kX7weSLmiyDQicRSDsExZxk6HhXiDG/tfxCEswf1rQqmfKp/12
         BiimIUskmUWiU0VWaVC7Kd1c7wsyYg/tzwlICtSRcoNF8CLH3IsvdjtyXAhq6c4XFqWK
         ZN9gChjO/rxdR2vx5k2FjvPqSbBGzJ0nWV6r2jmpOEKOC1mm9Nt3xWxGSYuBhW1LJLnu
         BPJwUWnB0F4ZSMDJF55O8OUwt8QJ6EsJxb8ijHRDPUAp8OKvnFxXhu91/sYutIBDVB2M
         WlQSAxYg5NduFTof7//IpJzHk87D0IOuNJirUBWQn3yuLTy+hjsG94V0H6UQK2EGvjNL
         Rzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780694372; x=1781299172;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5exm6bvtYER1f7kjLSkpnggeDTqAdK/YdweX4Bm/Ql8=;
        b=cM/5++Vk6+1YKI4yKQMP09aOV0rWgDLN6VU6hglGNaX15ZK27qFWLsZtsKCORgbYuu
         IVNftmh92zksuXQjzfl9OxVLkRIe3HMtE3vqtQIHr3gpiKPFda720OFEkeGoSABJdYb9
         SktkLkFrNRhzzTrD99lAv+sBsDyYrRWvcloRXpdj5Pzw9cKAtOPSYvefVPeM3Gf/VBFb
         arcZdinSNMBhVwgzq10sKcvZK3cKeoUdktIBkj/udQhSjEILDblRPxpUaTk9/y118rCj
         1oBXTSvmbrwcH+uK6Ys+PH7KCkhRJJ5oYrMTyRHxUc+E58r7Un+A+l4wBvgzpnkpcr+H
         PqFg==
X-Forwarded-Encrypted: i=1; AFNElJ8O919k/ehKEmxZqbZObtGXvgx3evYd6N5TLtgrLgxYJoDtGT39wxHNI7lbqMbQPlJja3uMxVc=@lists.linux.dev
X-Gm-Message-State: AOJu0YwGcN/DJd7P9HdnGGfEa3o4BUSj09kD3FLfzImC40AM9aBiMaOT
	2+CLJABEFNgWsYf13919NUHmdy98+Ndv4VfyUQ6scq1uJPugRagfCQ/c3+fHvqiELpM=
X-Gm-Gg: Acq92OFauGPO5j0vExHK28cs5v88AwciZcsTTbrWZ2mZ/2Yn6JpJ4ugrK/Q6lfyAvwc
	EhTdN4iBSa/Y+py10DKfa88fxjlpC1qCE/p04GLUo6bIircwfEGRmZlE8V05HxDt+QgzewZ1y+/
	lz2GyohRfE/jhPRi81+qULxgSmE0F81wQTjHiFcqWxbmpAgbZLUUqHMb0uLqhk38G8kog9wb1Uq
	Jbr9IJLwEVMdV7eAwbu3Z5+aRIfEz5qgXiaG3T93rCU8BWrXW566bUWmsI6QijFv4cv99h0Upif
	kN0uCQzGpeIkFcKS/zvlH0SmHNqhaZZHQ5BT2ZZ4EJkwrkxrVhxGSfU6uY5X4AliprUrMnRtW3e
	enmOh7HwsebqMpIMk4HXQloYlARdjlvNyaeeYjt13P8duhl8LuqILRHd4WmJJyRzpaMMuJn45gw
	8Jw/ef/VG7BLJeVshVfoU4cjw+9vFOlMoiof9weoCKJ6MjnD6LwRnmRWy6Ru/nILhoiugr03GUE
	/qYDQ465CeGlvHQ7MOXYMw=
X-Received: by 2002:ad4:4087:0:b0:8ce:e29b:6a91 with SMTP id 6a1803df08f44-8cee6290932mr70372996d6.42.1780694371381;
        Fri, 05 Jun 2026 14:19:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd277bbcsm90518196d6.49.2026.06.05.14.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Jun 2026 14:19:31 -0700 (PDT)
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
	apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v4 8/9] dax/kmem: add sysfs interface for atomic hotplug
Date: Fri,  5 Jun 2026 22:19:10 +0100
Message-ID: <20260605211911.2160954-9-gourry@gourry.net>
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

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

Additionally, there is no atomic mechanism to offline and remove
the entire set of memory blocks together.  Instead, this is presently
done in two steps: (offline all, remove all).  This creates a race
condition where external entities can operate directly on the blocks
and cause hot-unplug to fail.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the entire memory region state.  The writable states mirror
the per-block /sys/devices/system/memory/memoryX/state ABI:
  - "unplugged": memory blocks are not present
  - "online": memory is online, zone chosen by the kernel
  - "online_kernel": memory is online in ZONE_NORMAL
  - "online_movable": memory is online in ZONE_MOVABLE

The "unplugged" state is new and only applies to kmem/hotplug.

Valid transitions:
  - unplugged                               -> online[_kernel|_movable]
  - online | online_kernel | online_movable -> unplugged
  - offline                                 -> unplugged

A device can only be onlined from "unplugged", so it must be returned
there before being onlined into a different state.

For backwards compatibility the memory blocks are always created at
probe: existing tools expect them to be present once the kmem driver
binds.  When the configured policy (mhp_get_default_online_type())
selects an online state the blocks are onlined into that policy's zone;
when the policy is offline the blocks are created but left offline and
the device reports the state "offline".

"offline" is therefore a reportable state but is not writable: it only
arises from the legacy auto_online_blocks=offline policy. Onlining such
a device through this attribute requires unplugging it first.

The "offline" state may be deprecated later if the memory block ABI
changes and userland migrates to using the region-wide hotplug.

Unplug is atomic across the whole device: dax_kmem_do_hotremove()
collects every added range and offlines/removes them in one operation
via offline_and_remove_memory_ranges().  Either all ranges are removed
and the device becomes "unplugged", or offlining is rolled back and the
device is left fully online, so the reported 'hotplug' state always
matches reality.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.  Memory that is
  merely offline (the legacy "offline" state) is removed on unbind as
  before; only online memory is left pinned.

  The resources are still leaked but this prevents deadlock on unbind
  if a memory region happens to be impossible to hotremove.

Inconsistency Note:

  Since memory blocks can still be modified individually, the hotplug
  attribute can become out of sync with the state of the system if
  userland software mixes and matches the use of memory_block ABI and
  kmem/hotplug ABI.  It's suggests to use one or the other.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  25 +++
 drivers/dax/kmem.c                      | 254 ++++++++++++++++++++----
 2 files changed, 238 insertions(+), 41 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..931eb4e20358 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,28 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/hotplug
+Date:		January, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls the hotplug state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+		Reading returns the current state; the writable states mirror
+		the per-block /sys/devices/system/memory/memoryX/state ABI:
+		  "unplugged": memory blocks are not present
+		  "online": memory is online, zone chosen by the kernel
+		  "online_kernel": memory is online in ZONE_NORMAL
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		"offline" (memory blocks are present but offline) may also be
+		reported - this happens when the device is bound while the
+		auto_online_blocks policy is offline.  It cannot be written and
+		is deprecated; it may be removed in the future.
+
+		A device can only be onlined from the "unplugged" state, so a
+		device must be returned to "unplugged" before it can be onlined
+		into a different state.
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 5bf36ab73f86..46ee06d9f56b 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -42,9 +42,15 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	return 0;
 }
 
+#define DAX_KMEM_UNPLUGGED	(-1)
+
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	int numa_node;
+	struct dev_dax *dev_dax;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -63,23 +69,41 @@ static void kmem_put_memory_types(void)
 	mt_put_memory_types(&kmem_memory_types);
 }
 
+/* True for the online states a kmem dax device can hold. */
+static bool dax_kmem_state_is_online(int state)
+{
+	return state == MMOP_ONLINE ||
+	       state == MMOP_ONLINE_KERNEL ||
+	       state == MMOP_ONLINE_MOVABLE;
+}
+
 /**
- * dax_kmem_do_hotplug - hotplug memory for dax kmem device
+ * dax_kmem_do_hotplug - add the dev_dax memory ranges as system memory
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_OFFLINE to add the blocks offline, otherwise the online
+ *		 state (MMOP_ONLINE, MMOP_ONLINE_KERNEL, MMOP_ONLINE_MOVABLE)
+ *		 to bring them online in.
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Adds all ranges in the dev_dax region as system memory, onlining them in
+ * the requested zone unless @online_type is MMOP_OFFLINE.
  *
- * Returns the number of successfully mapped ranges, or negative error.
+ * Returns the number of successfully added ranges, or negative error.
  */
 static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 			       struct dax_kmem_data *data,
 			       int online_type)
 {
 	struct device *dev = &dev_dax->dev;
-	int i, rc, onlined = 0;
+	int i, rc, added = 0;
 	mhp_t mhp_flags;
 
+	if (dax_kmem_state_is_online(data->state))
+		return -EINVAL;
+
+	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -112,14 +136,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 				kfree(data->res[i]);
 				data->res[i] = NULL;
 			}
-			if (onlined)
+			if (added)
 				continue;
 			return rc;
 		}
-		onlined++;
+		added++;
 	}
 
-	return onlined;
+	return added;
 }
 
 /**
@@ -182,45 +206,65 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes every currently-added range in the dev_dax region
+ * atomically: either all ranges are offlined and removed, or none are and
+ * the device is left fully online (see offline_and_remove_memory_ranges()).
  *
- * Returns the number of successfully removed ranges.
+ * Returns 0 on success, or a negative errno if the device could not be
+ * fully unplugged (in which case nothing was removed).
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
 {
 	struct device *dev = &dev_dax->dev;
-	int i, success = 0;
+	struct range *ranges;
+	int i, nr_ranges = 0, rc;
 
+	ranges = kmalloc_array(dev_dax->nr_range, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
+
+	/* Collect the ranges that were actually added during probe. */
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
-		int rc;
 
-		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc)
+		if (!data->res[i])
 			continue;
-
-		/* range was never added during probe, count as removed */
-		if (!data->res[i]) {
-			success++;
+		if (dax_kmem_range(dev_dax, i, &range))
 			continue;
-		}
+		ranges[nr_ranges++] = range;
+	}
 
-		rc = remove_memory(range.start, range_len(&range));
-		if (rc == 0) {
-			/* Release the resource for the successfully removed range */
-			remove_resource(data->res[i]);
-			kfree(data->res[i]);
-			data->res[i] = NULL;
-			success++;
-			continue;
-		}
+	/* Nothing added means nothing to remove. */
+	if (!nr_ranges) {
+		kfree(ranges);
+		return 0;
+	}
+
+	rc = offline_and_remove_memory_ranges(ranges, nr_ranges);
+	kfree(ranges);
+	if (rc) {
 		any_hotremove_failed = true;
-		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
-			i, range.start, range.end);
+		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
+		return rc;
 	}
 
-	return success;
+	/* All ranges removed; release the reserved resources. */
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		if (!data->res[i])
+			continue;
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
+	}
+
+	return 0;
+}
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -EBUSY;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
@@ -236,6 +280,20 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 {
 	int i;
 
+	/*
+	 * If the device unbind occurs before memory is hotremoved, we can never
+	 * remove the memory (requires reboot).  Attempting an offline operation
+	 * here may cause deadlock and a failure to finish the unbind.
+	 *
+	 * This WARN used to be a BUG called by remove_memory().
+	 *
+	 * Note: This leaks the resources.
+	 */
+	if (WARN(((data->state != DAX_KMEM_UNPLUGGED) &&
+		  (data->state != MMOP_OFFLINE)),
+		 "Hotplug memory regions stuck online until reboot"))
+		return;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		if (!data->res[i])
 			continue;
@@ -245,6 +303,107 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplugged"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "online"))
+		return MMOP_ONLINE;
+	if (sysfs_streq(buf, "online_kernel"))
+		return MMOP_ONLINE_KERNEL;
+	if (sysfs_streq(buf, "online_movable"))
+		return MMOP_ONLINE_MOVABLE;
+	return -EINVAL;
+}
+
+static ssize_t hotplug_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	switch (data->state) {
+	case DAX_KMEM_UNPLUGGED:
+		state_str = "unplugged";
+		break;
+	case MMOP_OFFLINE:
+		state_str = "offline";
+		break;
+	case MMOP_ONLINE:
+		state_str = "online";
+		break;
+	case MMOP_ONLINE_KERNEL:
+		state_str = "online_kernel";
+		break;
+	case MMOP_ONLINE_MOVABLE:
+		state_str = "online_movable";
+		break;
+	default:
+		state_str = "unknown";
+		break;
+	}
+
+	return sysfs_emit(buf, "%s\n", state_str);
+}
+
+static ssize_t hotplug_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int online_type;
+	int rc;
+
+	if (!data)
+		return -ENXIO;
+
+	online_type = dax_kmem_parse_state(buf);
+	if (online_type < DAX_KMEM_UNPLUGGED)
+		return online_type;
+
+	guard(mutex)(&data->lock);
+
+	/* Already in requested state */
+	if (data->state == online_type)
+		return len;
+
+	if (online_type == DAX_KMEM_UNPLUGGED) {
+		rc = dax_kmem_do_hotremove(dev_dax, data);
+		if (rc)
+			return rc;
+		data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	/*
+	 * Onlining is only allowed from the unplugged state.  An already-online
+	 * device (or one left in the legacy offline state) must be unplugged
+	 * first.
+	 */
+	if (data->state != DAX_KMEM_UNPLUGGED)
+		return -EBUSY;
+
+	/*
+	 * A previous unplug releases the per-range resources, so re-acquire
+	 * them here (mirroring probe).  This is a no-op for ranges that are
+	 * still reserved (e.g. transitioning from the offline state).
+	 */
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		return rc;
+
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		return rc;
+
+	data->state = online_type;
+	return len;
+}
+static DEVICE_ATTR_RW(hotplug);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -312,6 +471,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -320,11 +483,19 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_resources;
 
 	/*
-	 * Hotplug using the configured online type for this device.
+	 * Always create the memory blocks for backwards compatibility: existing
+	 * tools expect them to be present after the kmem driver binds.  Under
+	 * the offline policy they are added but left offline (state
+	 * MMOP_OFFLINE); otherwise they are onlined per the configured policy.
 	 */
 	rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
 	if (rc < 0)
 		goto err_hotplug;
+	data->state = dev_dax->online_type;
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -345,23 +516,20 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
+	device_remove_file(dev, &dev_attr_hotplug);
 	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * Blocks added under the legacy offline policy are present but offline;
+	 * remove them on unbind as the driver always has.  If removal fails,
+	 * leak the resources rather than freeing state that still backs present
+	 * memory.  Online memory is left alone (dax_kmem_cleanup_resources()
+	 * warns and leaks it) since offlining it here could deadlock the unbind.
 	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+	if (data->state == MMOP_OFFLINE && dax_kmem_do_hotremove(dev_dax, data))
 		return;
-	}
-
 	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
@@ -379,6 +547,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_hotplug);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
-- 
2.54.0

