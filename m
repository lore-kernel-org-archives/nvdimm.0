Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A17A433EAFF
	for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 15:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774105466; cv=none; b=JPcedDf3Tv1cMzJXvexK5FUMxs5PP5ge6WDwZmKE9oD4AnNLOkwnN3aNpkfBTl2jeS1nwU+fjhE+gNlkupq5YjLcxorkNo3jKCDW6KRkHLMI2gJ4RGpbpTxCadxAiBfqqRWL9lCDQIv7KNQJzJbB2cBo8k9SDJQVUVzSMKNDhiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774105466; c=relaxed/simple;
	bh=DqZdLzszMzhm/Vsx1n/l9hukxOl1LDdHzTaf+SEFt2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1BHTiVoTiD8CdHARd1RlkrkGVd59xLS4iAbLDKCwTiBJWS7Kmb12MYYxLhO1l73eyyrV4zmBl7Xs+VXJjkuoFI6tmRTmDUAa+cyN+p6S+WYs/36tlGUlKSjN+DHpkKon+VHLowEzA8Jqa1QfPQ+bRLRD3lTAGoXDwR1yCgs/hU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=mwKhJP/4; arc=none smtp.client-ip=209.85.222.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="mwKhJP/4"
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-8cfbfdabf3fso266828785a.3
        for <nvdimm@lists.linux.dev>; Sat, 21 Mar 2026 08:04:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1774105464; x=1774710264; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GotqY1iYunncyBpBt3k1vF2DkZbep3lRnQKBDrqpHyM=;
        b=mwKhJP/4H9gMH2OXdmr/v/CdeN6JHtQVrAkJoJpPrsymBgD0UmqTmREiFqENmVv8IQ
         QzoO3pIM/LRfnZte1ZYhoFNcJhbqE+o1u9lCA6n08umWkWQJsWfKtTi3+v9JWOQN6yCt
         vYd9m5+yIIMkWLk3pno8/nIDwY6woTIoxDlg4KjM3isIgwqQkfLsbhQjbgGfeI68rRAR
         Yanrh6CgZL8GwaxeXZsFu5AZanXl/1FaeHtQ8U8h+MN8m58pNInTAQj9VXMxuUSrvY96
         Wh78u/K1ODot1/g7Ktz6YHxOTfohGfMepQHZIdhvuM+jcQ4KF8USNwQNpTIR7QG0KMv/
         DM5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774105464; x=1774710264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GotqY1iYunncyBpBt3k1vF2DkZbep3lRnQKBDrqpHyM=;
        b=eSRzwBCtJBf8Ty3Y1jHgPJ0R2ihiYQJDMCLj4OGr1E+FsugBH5m9ZQeUFFW1grUhgV
         fM0Uf/ryWO/4aBQBSihdhmB9mpWqQFWFKKGV58FI6ZwQYlhh+qq0bjss9RuI2kzC3tHY
         6pGnOBVpyNVkDj43qoXvYZPooGUQS1maLfV16OLzNF432SQV26L4kCPDFk5IE1Wn2O14
         Bag1s/FErthIymXoKVwImbIMVV1QDjSBaDP71t/MFdcek3p7+8DWXLRyrl6fxHiRUEMI
         G56lnwKY6rQw98I8yYKCRYkPyDEqY5VSmJ9eBEpNdSgInetBJmzD87/I048BnZ71j4nK
         ROhA==
X-Forwarded-Encrypted: i=1; AJvYcCWiCO40MimhGsr9dSOUDlkx1RZ1jz0JD4157ajo5mCZnQXrQWXQb9A96isyowE6WL1fNU6DEB8=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSFhkAz98rdIvilHyqk5XTCwo9bXGxBQHMwzkfMSz4X1LItLlN
	TwV5e87x0nL0RVWQep1sg03cJyFTrn05cZ66ZXSPM/KaY0uD9mgnHsWHikaiFfhS2Gw=
X-Gm-Gg: ATEYQzwvWY2N0uPmMSUQu/mh7+zqGpb/NPzEb+1NSnLaFJ5e43ntTC4FHYdf0ShW8im
	AKmBaR5UjgNacMqQ3Fb+/dHdCC9hCnpRyMPIVPVlFW8XVcAhgNElE6n5kkqoXtLDBqYzCmEqgJ6
	CkrbhaYh3JC1SBWAv6S4cw5/k+piPvd8c5gKFtSyZmRAQnYHPfsDjJlvrZ6UfQHlwGlyHA65SWc
	GDxVtqEhzJPBN5HL3KUWPuJw/kXfHKohsDjjbbUCBzGhl+1ryxsP7Q3uMiAl8s9+FPnykkIkLxy
	jwe7tNNkXnak5S4fYXx+aHDA6yOaJ/JGA6+3DR/L+z1ezq1lPaU5miBrvR6qbALqYGQRUcdjbJy
	NvFv/++MkOdSdqRnK1+u/Om4MQWLUVJuX5vig447Q46X0gOVdowvKJMDLVJ9vj9HoDWBjkj5RF4
	Kq8bbxj0TWoP6p8LHpgc46XcZPrdmsAranS7hvpAwp4AgATUEncFKM3U+gl4YrsGlDtqyCRJabg
	NYppjL5T6HpTqqG9B0Bs+H3lw==
X-Received: by 2002:a05:620a:4456:b0:8b2:ea5a:4149 with SMTP id af79cd13be357-8cfc7f873aamr1145888685a.65.1774105463364;
        Sat, 21 Mar 2026 08:04:23 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cfc90ba89fsm391979885a.40.2026.03.21.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Mar 2026 08:04:22 -0700 (PDT)
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
	kernel-team@meta.com,
	Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/8] dax/kmem: add sysfs interface for atomic whole-device hotplug
Date: Sat, 21 Mar 2026 11:04:04 -0400
Message-ID: <20260321150404.3288786-9-gourry@gourry.net>
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

The dax kmem driver currently onlines memory automatically during
probe using the system's default online policy but provides no way
to control or query the entire region state at runtime.

Additionally, there is no atomic mechanism to offline and remove
the entire set of memory blocks together.  Instead, this is presently
done in two steps: (offline all, remove all).  This creates a race
condition where external entities can operate directly on the blocks
and cause hot-unplug to fail.

Add a new 'hotplug' sysfs attribute that allows userspace to control
and query the entire memory region state.

The interface supports the following states:
  - "unplug": memory is offline and blocks are not present
  - "online": memory is online as normal system RAM
  - "online_movable": memory is online in ZONE_MOVABLE

Valid transitions:
  - unplugged      -> online
  - unplugged      -> online_movable
  - online         -> unplugged
  - online_movable -> unplugged

"offline" (memory blocks exist but are offline by default) is not
supported because it's functionally equivalent to "unplugged" and
entices races between offlining and unplugging.

The initial state after probe currently checks if online_type matches
mhp_get_default_online_type() - and if so calls dax_kmem_do_hotplug.

This causes the creation of memory blocks, despite the fact that we
should be in an unplugged state. This preserves userland backward
compatibility for existing tools that expect the memory blocks to be
present after kmem probe - and can be deprecated over time.

As with any hot-remove mechanism, the removal can fail and if rollback
fails the system can be left in an inconsistent state.

Unbind Note:
  We used to call remove_memory() during unbind, which would fire a
  BUG() if any of the memory blocks were online at that time.  We lift
  this into a WARN in the cleanup routine and don't attempt hotremove
  if ->state is not DAX_KMEM_UNPLUGGED or MMOP_OFFLINE.

  The resources are still leaked but this prevents deadlock on unbind
  if a memory region happens to be impossible to hotremove.

Suggested-by: Hannes Reinecke <hare@suse.de>
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 Documentation/ABI/testing/sysfs-bus-dax |  17 +++
 drivers/dax/kmem.c                      | 164 +++++++++++++++++++++---
 2 files changed, 161 insertions(+), 20 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-dax b/Documentation/ABI/testing/sysfs-bus-dax
index b34266bfae49..faf6f63a368c 100644
--- a/Documentation/ABI/testing/sysfs-bus-dax
+++ b/Documentation/ABI/testing/sysfs-bus-dax
@@ -151,3 +151,20 @@ Description:
 		memmap_on_memory parameter for memory_hotplug. This is
 		typically set on the kernel command line -
 		memory_hotplug.memmap_on_memory set to 'true' or 'force'."
+
+What:		/sys/bus/dax/devices/daxX.Y/hotplug
+Date:		January, 2026
+KernelVersion:	v6.21
+Contact:	nvdimm@lists.linux.dev
+Description:
+		(RW) Controls what hotplug state of the memory region.
+		Applies to all memory blocks associated with the device.
+		Only applies to dax_kmem devices.
+
+                States: [unplugged, online, online_movable]
+                Arguments:
+		  "unplug": memory is offline and blocks are not present
+		  "online": memory is online as normal system RAM
+		  "online_movable": memory is online in ZONE_MOVABLE
+
+		Devices must unplug to online into a different state.
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 8be9286f0ea3..5dbd5b7862fd 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -40,10 +40,16 @@ static int dax_kmem_range(struct dev_dax *dev_dax, int i, struct range *r)
 	return 0;
 }
 
+#define DAX_KMEM_UNPLUGGED	(-1)
+
 struct dax_kmem_data {
 	const char *res_name;
 	int mgid;
 	struct memory_dev_type *mtype;
+	int numa_node;
+	struct dev_dax *dev_dax;
+	int state;
+	struct mutex lock; /* protects hotplug state transitions */
 	struct resource *res[];
 };
 
@@ -51,8 +57,10 @@ struct dax_kmem_data {
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
+ * @online_type: MMOP_ONLINE or MMOP_ONLINE_MOVABLE
  *
- * Hotplugs all ranges in the dev_dax region as system memory.
+ * Hotplugs all ranges in the dev_dax region as system memory using
+ * the specified online type.
  *
  * Returns the number of successfully mapped ranges, or negative error.
  */
@@ -64,6 +72,12 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 	int i, rc, onlined = 0;
 	mhp_t mhp_flags;
 
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
+	if (online_type != MMOP_ONLINE && online_type != MMOP_ONLINE_MOVABLE)
+		return -EINVAL;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -156,9 +170,9 @@ static int dax_kmem_init_resources(struct dev_dax *dev_dax,
  * @dev_dax: the dev_dax instance
  * @data: the dax_kmem_data structure with resource tracking
  *
- * Removes all ranges in the dev_dax region.
+ * Offlines and removes all ranges in the dev_dax region.
  *
- * Returns the number of successfully removed ranges.
+ * Returns the number of successfully removed ranges, or negative error.
  */
 static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 				 struct dax_kmem_data *data)
@@ -178,7 +192,7 @@ static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
 		if (!data->res[i])
 			continue;
 
-		rc = remove_memory(range.start, range_len(&range));
+		rc = offline_and_remove_memory(range.start, range_len(&range));
 		if (rc == 0) {
 			/* Release the resource for the successfully removed range */
 			remove_resource(data->res[i]);
@@ -214,6 +228,20 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
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
@@ -223,6 +251,98 @@ static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
 	}
 }
 
+static int dax_kmem_parse_state(const char *buf)
+{
+	if (sysfs_streq(buf, "unplug"))
+		return DAX_KMEM_UNPLUGGED;
+	if (sysfs_streq(buf, "online"))
+		return MMOP_ONLINE;
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
+		if (rc < 0) {
+			dev_warn(dev, "hotplug state is inconsistent\n");
+			return rc;
+		}
+		if (rc < dev_dax->nr_range)
+			dev_warn(dev, "partial hotremove: %d of %d ranges removed\n",
+				 rc, dev_dax->nr_range);
+		else
+			data->state = DAX_KMEM_UNPLUGGED;
+		return len;
+	}
+
+	/*
+	 * online_type is MMOP_ONLINE or MMOP_ONLINE_MOVABLE
+	 * Cannot switch between online types without unplugging first
+	 */
+	if (data->state == MMOP_ONLINE || data->state == MMOP_ONLINE_MOVABLE)
+		return -EBUSY;
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
@@ -291,6 +411,10 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 	data->mtype = mtype;
+	data->numa_node = numa_node;
+	data->dev_dax = dev_dax;
+	data->state = DAX_KMEM_UNPLUGGED;
+	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
 
@@ -301,9 +425,17 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	/*
 	 * Hotplug using the configured online type for this device.
 	 */
-	rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
-	if (rc < 0)
-		goto err_hotplug;
+	if (dev_dax->online_type != MMOP_OFFLINE ||
+	    dev_dax->online_type == mhp_get_default_online_type()) {
+		rc = dax_kmem_do_hotplug(dev_dax, data, dev_dax->online_type);
+		if (rc < 0)
+			goto err_hotplug;
+		data->state = dev_dax->online_type;
+	}
+
+	rc = device_create_file(dev, &dev_attr_hotplug);
+	if (rc)
+		dev_warn(dev, "failed to create hotplug sysfs entry\n");
 
 	return 0;
 
@@ -324,23 +456,11 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
-	/*
-	 * We have one shot for removing memory, if some memory blocks were not
-	 * offline prior to calling this function remove_memory() will fail, and
-	 * there is no way to hotremove this memory until reboot because device
-	 * unbind will succeed even if we return failure.
-	 */
-	success = dax_kmem_do_hotremove(dev_dax, data);
-	if (success < dev_dax->nr_range) {
-		dev_err(dev, "Hotplug regions stuck online until reboot\n");
-		return;
-	}
-
+	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
@@ -358,6 +478,10 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
2.53.0

