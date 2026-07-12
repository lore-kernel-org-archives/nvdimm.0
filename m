Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B3E34214A
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871140; cv=none; b=iyYtLbixDicVvUx+suCy2hSShxgZ6+bWSP4GZs11iBaBnTfxAbqMQlU3CZFBReNsDWsAmKVtrdLW+PDVTkIUlUoNBbQbswQD1X5okzFFkniEnhk6Q1ivT4LDzmqv41vmdPyuq4TIBm16aMUZhyom/2K5qHcstCT7TPXUr8IRNzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871140; c=relaxed/simple;
	bh=Gs/hrZsoHjychWxwqwjv72Syxfj/6QktoWRqnWOvgGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QyjVFQGaP5MeWgv+WVJnar8jsM5tefO/VlGdH6Y24xQGU0cUTeEI5IEHwmjDinAZB799pDCgZ0+csRn2r5ILYTWaYBHqUivUbDIDkg9QzRDomcqhfr3pyMCPhWxCh3lr+C8sDHUZtrWlfWrc77YP8U4KZUlKpuC1ZF2boccoRRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jKMbkGjN; arc=none smtp.client-ip=209.85.222.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jKMbkGjN"
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e5c92c389so117531285a.3
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871131; x=1784475931; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1MtJTbfD/+62uyC9cmiI0PZLLS77jY7zlTT5oKim0nk=;
        b=jKMbkGjNp10KgVmF7xiQtWvVA9T4cHO5LYANC6eHvmsAHdoDlvkblHvpJvoXCCjCUQ
         3yz3K7zD8nZkcfCKEHwrLcHLODTRZIcqsKZw0b3oLWZjrKXAIxjZWEk2ntrNoWT4JIZL
         j7nC2v1bKp9K+24ANt1kdUiyFtM6Fk4DBtwuRYOxgJ8zQIJ/fDfxcZKwGz+GXdKkmwLs
         38aMgIrA1CdcAsLCM+2j/4QHfMRjiRbRKRwyWZRHvwTlYUCsFNT5P9/jxdjw6drKGaZJ
         RFSx/eub2MJZTC4MlYxGxy5Z2ANTIhxa8vjis0dYel8Ih1UCuE6xrMcho/VRhz9R0Uqw
         7fSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871131; x=1784475931;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=1MtJTbfD/+62uyC9cmiI0PZLLS77jY7zlTT5oKim0nk=;
        b=ky3cfFcuimqdDqjWmGz9eIft7Jw+LKoLVGQcGLn6bOYOMzaQcnGF/ivDX7yRRLqsse
         MsFnsxlLhEFRirq0+YxzHw3923EzVcPp5CST/fDbvItob+aml5CxN5NvXjvvQF62mGde
         Rl5SMoQH+znpTIS8+c5XbJEj7eJfvsU2yumdFQG0hnZBUeg1qioVtGRBc2EoLRMfwqnB
         e3Qd8gtLwfR2PK7kMCTrlI8r3EzEnAt4lKjJkGKQWPa+CjoNnXi4YdYFgbouxy8nLbdP
         qfoKkvWShCzI2sqACsaXv/zDCNOdu99siD65Gf8MW+AcgvP2LhMxM4tKXZ49Z1a5B/Dp
         w62w==
X-Forwarded-Encrypted: i=1; AHgh+RriEBU8Lt5HjrPWy/pCWtGhqv8gH7XCfUUWeaXspstDZrMwAXBq8v3//4Ecp/JL4nOcryFrZbA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxAMJYWrVKYGfz6IFhMEckcur2h+tSgo1r9zaREakRcZJ5I1kfK
	0QtCxmOf9zqTNrETJOMSb20qVGQpdMqUQ6u78GJuhGjKyNj8clDCuGl6wrE/2bemRSk=
X-Gm-Gg: AfdE7ckDo+0Oum17Blf29q+OSfLxlMyktm+8jbU5UfJww4MnDJvWfHf3RhyORplXrRx
	Q4o7OSeTNzxrH6QJi9eYT7mT2JMEdIwJ1ACbBOu8GyqH/AyHRjz5FnheSYW6MDP03nKFxIluiP0
	NTjoIjJg8fyZbMyjeqjir0wKhoydR9yewahhFiKIpnhCDZkgZKghElP674G6vitBc+P2fSuW7PT
	tMCigJ/hKp0/qpxnEJgtpk1Xg69bP/He67woHZMmdDNVST792IzcD5ZWWKZ/C8xPNsPXbhhG4IR
	dqtaqqPj2bEfu0DVE5WknVTWSvrrIHroeumEssYVzioGBpVW86mAdCJWR2+aTLVEJxd4LoaJov8
	i0yi1HHV8RhLLqlBNcDCovEtQhecmkQ02qIUozEaOXK913EDR3KggLYCe5uRyFQY9UtMxqVE7TE
	ZbPwlaacKxJleb/hchNtYujXTVp+k0XAwLEHeavituwqm++a2v3TET/O1Cv2I5nFCF+QgXQQMHp
	w==
X-Received: by 2002:a05:620a:290b:b0:91d:6ac3:565a with SMTP id af79cd13be357-92ef2b3865fmr597461385a.12.1783871131232;
        Sun, 12 Jul 2026 08:45:31 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:30 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
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
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH v7 09/10] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Sun, 12 Jul 2026 11:45:03 -0400
Message-ID: <20260712154505.3564379-10-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>
References: <20260712154505.3564379-1-gourry@gourry.net>
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
  An offline dax device memory is removed on unbind as before.

  If online at unbind, the resources are leaked (as before), but now
  we prevent deadlock if a memory region is impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Reviewed-by: Dan Williams <djbw@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  24 +++
 drivers/dax/bus.h                       |   2 +
 drivers/dax/kmem.c                      | 243 ++++++++++++++++++++----
 3 files changed, 233 insertions(+), 36 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49a..60703fffa99e0 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,27 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/state
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
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index 5909171a4428b..bfc31923f3ff4 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -16,6 +16,8 @@ struct dax_region;
 #define IORESOURCE_DAX_STATIC BIT(0)
 #define IORESOURCE_DAX_KMEM BIT(1)
 
+#define DAX_KMEM_UNPLUGGED	(-1) /* Do not create memory blocks */
+
 struct dax_region *alloc_dax_region(struct device *parent, int region_id,
 		struct range *range, int target_node, unsigned int align,
 		unsigned long flags);
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 6174f7d3d05bd..a48d699cf344c 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -45,6 +45,8 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -63,12 +65,22 @@ static void kmem_put_memory_types(void)
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
@@ -77,9 +89,15 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
 
@@ -123,14 +141,14 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
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
@@ -193,45 +211,64 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
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
+	ranges = kmalloc_objs(*ranges, dev_dax->nr_range);
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
+
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
 
-		rc = remove_memory(range.start, range_len(&range));
-		if (rc == 0) {
-			/* Release the resource for the successfully removed range */
-			remove_resource(data->res[i]);
-			kfree(data->res[i]);
-			data->res[i] = NULL;
-			success++;
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
 
@@ -247,6 +284,18 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
@@ -256,6 +305,81 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
+	if (rc < 0) {
+		/* Total failure, drop the reservations we took. */
+		dax_kmem_cleanup_resources(dev_dax, data);
+		return rc;
+	}
+
+	data->state = online_type;
+	return len;
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -324,6 +448,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_reg_mgid;
 	data->mgid = rc;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -334,6 +460,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
 	if (rc < 0)
 		goto err_hotplug;
+	data->state = online_type;
 
 	return 0;
 
@@ -352,26 +479,59 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
 
 	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
+	 * Remove every range that is still added.  dax_kmem_remove_ranges()
+	 * uses remove_memory(), which never offlines: an online block fails
+	 * with -EBUSY rather than deadlocking an uninterruptible unbind.
+	 *
+	 * data->state only tracks daxX.Y/state writes, so it can be stale if
+	 * blocks were toggled via memoryX/state. Do not trust it here and
+	 * attempt simply remove_memory() - which reports the true state of
+	 * each range anyway. Anything left online is leaked until reboot.
 	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
+	if (dax_kmem_remove_ranges(dev_dax, data)) {
 		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+		any_hotremove_failed = true;
 		return;
 	}
 
-	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -399,10 +559,21 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 }
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
+static DEVICE_ATTR_RW(state);
+
+static struct attribute *dev_dax_kmem_attrs[] = {
+	&dev_attr_state.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(dev_dax_kmem);
+
 static struct dax_device_driver device_dax_kmem_driver = {
 	.probe = dev_dax_kmem_probe,
 	.remove = dev_dax_kmem_remove,
 	.type = DAXDRV_KMEM_TYPE,
+	.drv = {
+		.dev_groups = dev_dax_kmem_groups,
+	},
 };
 
 static int __init dax_kmem_init(void)
-- 
2.53.0-Meta

