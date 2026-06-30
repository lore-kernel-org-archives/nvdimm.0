Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA3132C316
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854349; cv=none; b=WxvAGL04767QvgQJViEAFg3mq9x8/6B5TYeT9WZhsMA6WsxlmsSBz9JFNVSR0PqgUWljijpp1C+NwTyqXUqVRM5k+fhi6BAMrF4LvYa32/AZZxvqbhL06o23NUoqabcpC/WfpPp2TcO/vS2N1kyfzBScPCsifme8fnmaBuqv7/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854349; c=relaxed/simple;
	bh=HlssoDo8s/mZLauODNzjctCN7QoIQrnBvr3YRYV6/GQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s5TSFGPwmRJ/2B9jRBJv3h4UvBkcM2tzWWh53xQLYurpnSmpmXLscjH2hZb4q3aSTwfv3sUbUsksEQYTKgs9AffF97MLo4+BTDss/7DITEWV7bIBj6fUTK3TQKmaSg+JE09GWKR+0TP9CKqXAfBVtdMuNNAMbgN9biQU3TMIhoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=bcRs4pps; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="bcRs4pps"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-92e65e18969so122121885a.1
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854345; x=1783459145; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w8QKrKqISzDTiTy7CVkx59XQyhvZjgTrb9AQUt59JD4=;
        b=bcRs4ppsOzcriVKhueKvnmuKHLwCugsohpxsjyAQUkmxClwDkTFQbDbNgy+hzpcnix
         F7OqFDfWfghotbtFhvRrU4H8IvRLo6p5fjAusxUjxerAvM3KekWkgYnPmCtZ3D/G2N8O
         FiaIlhA3cPz8FzkDKDbx9P5sO80rhvF1l6WiP0l3qz/QEV2MaCFr48jxB57SDzCT7AnI
         EyD/s1Fn7Tz5UYRN+an+DZXms0HhwkI//iFKjUctLLcxdFipCh5rZ3ZupZnDy6/r4KMQ
         XtqoqadNSNxcbYh4lXfFZ6PdMgYhraY1KygPhdR//ETxMSstsoKta9w/Q82o3doRFHT+
         ZgTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854345; x=1783459145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w8QKrKqISzDTiTy7CVkx59XQyhvZjgTrb9AQUt59JD4=;
        b=K/sb1VuITE30l3Os3bsYx7K4PFVYjIokb3vuzk1UCWpsASfA8YEEG5oiL4JTyKOwdt
         gyPOKdChXBdYoN5e4xg3ggso2KNEG7xNr4BsYJz2xXkZYj7GKaOjYHtvgRMKJvG8xiKI
         lwGL7thJXkuHorgmYdKTd2icR1paiTIGYjSYWfHxYDDguQEQiKPWXdei0IStxaqKDfKH
         bRf7ViSry0PhbL/o/Uho4afIPyrpPMKB0i8bqe764iPcshfme7WX8THJ6CvRkvXX5128
         0tV5VOjS30222HJaiW/yh5CWFWwszYxJt1BNt5NjmCtNfO0sj4WUT0cn85O7ULQZHgLz
         Nlww==
X-Gm-Message-State: AOJu0Yz1rkyJyxtM2gz3EeSkc1STwkh1xtasBh5/+GT2QtZg8XOEvyiH
	g+SSJ+vMZymDNoC4Gz6AdPw0nl3TTS2+/nTTeYi8t3UZ/LEZCChHkTqzUBTGboyda/I=
X-Gm-Gg: AfdE7cmTqIIl2myP3eCQqO1EgWWMzIzqVrCVXJyBwsRdVR7ZD/O6pAU1xbYXs9UN13P
	wOH+msVoay+4yW8e8GZL0ggrY5B/z1WUIeP9fZWad4/1/VaYN1Hzvd8zGvpLBsQ0LNqXYiRYtO5
	D741WOySnM8PNv211roiETPtKbf/RIOWnKv2UgaGvDCMVK6jwAaaZosQkECOH4p8XTOK26rKH1N
	RVAyL6fQBELMQNeY4ZKv9KjBgdRl44VceuAsJRkhzuHHhlsk3HHQ3YB7P1pIepIufx4JTCG1t0T
	3H+tjla4FTot6vspLii1yLUbDZ03dtyTKL/17ni+IGmayRHRShQYG+Xwf4gB75GEX6lYesAMyV9
	54mdstnnPlA8I8Ul6AXjqOFpUuuWbZ6/KTmKJhlMtD33a/v0OSGc0/e5Hy60pJVbP2R8FIqa/Ec
	s2TC65caXKgOIfDPaWXxM8F4/dQVIrGczMdyxw4VXjJuI/uRk8uAb4NLIYBonvT8qXCZCwGRhy1
	w==
X-Received: by 2002:a05:620a:2315:20b0:92e:6286:d57 with SMTP id af79cd13be357-92e696c2f25mr346923085a.7.1782854345341;
        Tue, 30 Jun 2026 14:19:05 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:04 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com,
	david@kernel.org,
	osalvador@suse.de,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	akpm@linux-foundation.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	shuah@kernel.org,
	gourry@gourry.net,
	iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com,
	apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Tue, 30 Jun 2026 17:18:41 -0400
Message-ID: <20260630211842.2252800-10-gourry@gourry.net>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260630211842.2252800-1-gourry@gourry.net>
References: <20260630211842.2252800-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is no atomic mechanism to offline and remove an entire
multi-block DAX kmem device.  This is presently done in two steps:
    1. offline all
    2. remove all

This creates a race condition where another entity operates directly
on the memory blocks and can cause hot-unplug to fail / unbind to
deadlock.

Add a new 'state' sysfs attribute that enables an atomic whole-device
hotplug operation across its entire memory region.

daxX.Y/state mirrors the per-block memoryX/state ABI:
  - [offline, online, online_kernel, online_movable]
  - "unplugged" - is added specifically for dax0.0/state

The valid writable states include:
  - "unplugged":      memory blocks are not present
  - "online":         memory is online, zone chosen by the kernel
  - "online_kernel":  memory is online in ZONE_NORMAL
  - "online_movable": memory is online in ZONE_MOVABLE

Valid transitions:
  - unplugged                -> online[_kernel|_movable]
  - online[_kernel|_movable] -> unplugged
  - offline                  -> unplugged

A device can only be onlined from "unplugged", so it must be returned
there before being onlined into a different state.

For backwards compatibility the memory blocks are always created at
probe - existing tools expect them to be present after kmem binds.

"offline" is therefore a reportable state but is not writable: it only
arises from the legacy auto_online_blocks=offline policy.  Onlining
such a device through this attribute requires unplugging it first in
an effort to get drivers creating DAX devices to set a default.

Unplug is atomic across the whole device: dax_kmem_do_hotremove()
collects every added range and offlines/removes them in one operation.
Either the operation succeeds or is entirely rolled back.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.

  An offline dax device memory is removed on unbind as before.

  If online at unbind, the resources are leaked (as before), but now
  we prevent deadlock if a memory region is impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  26 +++
 drivers/dax/kmem.c                      | 258 ++++++++++++++++++++----
 2 files changed, 248 insertions(+), 36 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..2dcad1e9dad0 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,29 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/state
+Date:		June, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls the state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+		Reading returns the current state; the writable states mirror
+		the per-block /sys/devices/system/memory/memoryX/state ABI::
+
+		  "unplugged": memory blocks are not present
+		  "online": memory is online, zone chosen by the kernel
+		  "online_kernel": memory is online in ZONE_NORMAL
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		"offline" (memory blocks are present but offline) may also be
+		reported - this happens when the device is bound while the
+		auto_online_blocks policy is "offline".  It cannot be written,
+		as it's not useful and creates device destruction races.
+
+		A device can only be onlined from the "unplugged" state, so a
+		device must be returned to "unplugged" before it can be onlined
+		into a different state.
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 72dcccee41e1..19effe0da3dc 100644
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
 
@@ -63,12 +69,22 @@ static void kmem_put_memory_types(void)
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
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: the online policy to use for the memory blocks
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory with the
+ * provided online policy (offline, online, online_movable, online_kernel).
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
@@ -77,9 +93,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
 
@@ -123,14 +145,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
@@ -193,45 +215,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes every currently-added range in the dev_dax region
+ * atomically: either all ranges are offlined and removed, or none are and
+ * the device is returned to its prior state.
  *
- * Returns the number of successfully removed ranges.
+ * Returns 0 on success, or a negative errno on failure.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
 {
 	struct device *dev = &dev_dax->dev;
-	int i, success = 0;
+	struct range *ranges;
+	int i, nr_ranges = 0, rc;
+
+	ranges = kmalloc_array(dev_dax->nr_range, sizeof(*ranges), GFP_KERNEL);
+	if (!ranges)
+		return -ENOMEM;
 
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
+	/* Nothing added means nothing to remove. */
+	if (!nr_ranges) {
+		kfree(ranges);
+		return 0;
+	}
+
+	rc = offline_and_remove_memory_ranges(ranges, nr_ranges);
+	kfree(ranges);
+	if (rc) {
+		/* Recoverable: the ranges rolled back, nothing is leaked yet. */
+		dev_err(dev, "hotremove failed, device left online: %d\n", rc);
+		return rc;
+	}
+
+	/* All ranges removed; release the reserved resources. */
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		if (!data->res[i])
 			continue;
-		}
-		any_hotremove_failed = true;
-		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
-			i, range.start, range.end);
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
 	}
 
-	return success;
+	return 0;
+}
+#else
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	return -EBUSY;
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
@@ -247,6 +288,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 {
 	int i;
 
+	/*
+	 * If the device unbind occurs before memory is hotremoved, we can never
+	 * remove the memory (requires reboot).  Attempting an offline operation
+	 * here may cause deadlock and a failure to finish the unbind.
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
@@ -256,6 +309,85 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	int online_type;
+
+	/* "unplugged" is kmem-specific - the rest map to MMOP_ */
+	if (sysfs_streq(buf, "unplugged"))
+		return DAX_KMEM_UNPLUGGED;
+
+	online_type = mhp_online_type_from_str(buf);
+	/* Disallow "offline": it's not useful and creates race conditions */
+	if (online_type == MMOP_OFFLINE)
+		return -EINVAL;
+	return online_type;
+}
+
+static ssize_t state_show(struct device *dev,
+			    struct device_attribute *attr, char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	const char *state_str;
+
+	if (!data)
+		return -ENXIO;
+
+	if (data->state == DAX_KMEM_UNPLUGGED)
+		state_str = "unplugged";
+	else
+		state_str = mhp_online_type_to_str(data->state);
+
+	return sysfs_emit(buf, "%s\n", state_str ?: "unknown");
+}
+
+static ssize_t state_store(struct device *dev, struct device_attribute *attr,
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
+	/* Onlining is only allowed from the unplugged state. */
+	if (data->state != DAX_KMEM_UNPLUGGED)
+		return -EBUSY;
+
+	/* Re-acquire resources if previously unplugged, otherwise no-op */
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
+static DEVICE_ATTR_RW(state);
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -324,6 +456,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -336,9 +472,15 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (online_type == DAX_ONLINE_DEFAULT)
 		online_type = mhp_get_default_online_type();
 
+	/* Always create blocks for backward compatibility, even if offline */
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
 	if (rc < 0)
 		goto err_hotplug;
+	data->state = online_type;
+
+	rc = device_create_file(dev, &dev_attr_state);
+	if (rc)
+		dev_warn(dev, "failed to create state sysfs entry\n");
 
 	return 0;
 
@@ -357,22 +499,62 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 }
 
 #ifdef CONFIG_MEMORY_HOTREMOVE
+/*
+ * Remove the device's added ranges with remove_memory().
+ * Unlike the sysfs unplug path it never offlines and fails if the blocks are
+ * online (-EBUSY), so it is safe from unbind. Failures leak until reboot.
+ *
+ * Returns 0 only if every added range was removed.
+ */
+static int dax_kmem_remove_ranges(struct dev_dax *dev_dax,
+				  struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc = 0;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		if (!data->res[i] || dax_kmem_range(dev_dax, i, &range))
+			continue;
+		if (remove_memory(range.start, range_len(&range))) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx stuck online until reboot\n",
+				 i, range.start, range.end);
+			rc = -EBUSY;
+			continue;
+		}
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
+	}
+	return rc;
+}
+
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
+	device_remove_file(dev, &dev_attr_state);
 	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * If UNPLUGGED: state is known clean and reboot can clean up.
+	 *
+	 * If ONLINE_*: memory cannot be removed here: offlining during an
+	 * uninterruptible unbind can deadlock. Leak the resources until reboot.
+	 *
+	 * If OFFLINE: blocks are attempted to remove with remove_memory(),
+	 * which never attempts offlining. A block onlined behind our back
+	 * fails -EBUSY and is leaked.
 	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+	if (dax_kmem_state_is_online(data->state)) {
+		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
+		any_hotremove_failed = true;
+		return;
+	} else if (data->state == MMOP_OFFLINE &&
+		   dax_kmem_remove_ranges(dev_dax, data)) {
+		any_hotremove_failed = true;
+		dev_warn(dev, "Unplug failed, resources leaked until reboot\n");
 		return;
 	}
 
@@ -393,6 +575,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
+	struct device *dev = &dev_dax->dev;
+
+	device_remove_file(dev, &dev_attr_state);
+
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
 	 * device-dax range and return '0' to ->remove() attempts. The removal
-- 
2.53.0-Meta

