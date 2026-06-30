Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D133290BD
	for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 21:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782854347; cv=none; b=q/cIxT0JrDojoJacchvQXZlJrVuSL0Ckbynrul6Csz3FhNwfBiRT/Cp+/yErm/9H3bjwATn0Puc08DSZdE8f6XJ1l9zAvTY8hhBZVxv+o+59ZPJzimQ3nO6a9oMukwVJpaIxMjU6Ob7BppGVYYxubBLAxCRmKDg0EplNyhF0X5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782854347; c=relaxed/simple;
	bh=rjpW6mfdWVfgcDTl7obEp04rujP0kEAu2zsHj7K6QS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IA36sqwapbrFcK9VAnPshe0BPm4EGtPgw5lfgSAbQahfVVvLXX9/IubOSt+vjxNkiIrHl8zBXa7vm0J35Z54t6h3HBktpsm1w5ERH5ZjiF0h/fHu3GzebX9kCYfINZGQdENnAOPQHQCttQDDvM89U6XIY+UNt3ZWgwmZRrmQtE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Nsypgiwt; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Nsypgiwt"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-91562bf6c12so553185185a.2
        for <nvdimm@lists.linux.dev>; Tue, 30 Jun 2026 14:19:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1782854343; x=1783459143; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NOkCWnqZVGJ7C+jdT75jmur1k0KIbep2C9BRrd2hTIw=;
        b=NsypgiwtQYqlqRhmLHDd3A/73hANwbCQq6l0Vt/mXkCCw4AxMskaVG+gRQ/d9iur1Z
         I9fihR/m30y5BmdhFkVf9JAqXiV0/4Ejxs3aVj3G5yHK2dgd32hDJi3XQuUW6md+AoLe
         imz5d3zJFYk+czFB5u2+wD907IQ0AYa1GitwIEeS2tGQw/1nR32kCH4rf0vKw2W1uPc7
         6pmGtRwHM3gtFjxwHm1s8u4k9d0NMQ+W5MjSfETx2gmd94k1igCTMqQ9GTYVMZxUEmkj
         nf2VELCR0DImO0LRwvttU6SU4OQfEF2Kh9UnZLAqaqAG5cQv/lrsFS7Xt/C3TBkiJfhI
         pVJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782854343; x=1783459143;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NOkCWnqZVGJ7C+jdT75jmur1k0KIbep2C9BRrd2hTIw=;
        b=mBdAOUNJNFOlA/vajudS+gCoYGSaGPvM5YQe+ihrHKW8Eb6s/bQgi0DI+DzuP81y07
         bZ3QumTkmRiIhQ6pS59zqwqMvduXPzMjnlqWhWv2Kf37T/ZUyDTokG6sI4gat4isPbBW
         wRZ2FrGPeNIcKpysVUKz3AaRV8Yvx4Nx7zGa43xfoQ9Z97eoDaFwgupJgPkEu49vdP5i
         Ifu6b8ue+SmnsMOfu2XtINJRhtSnIeBPb2Tzn70lZZwfppiDQtQ7C5NZiI0nTKnPWcjV
         HTWfq7M2UKagwkjegVAV3/tPlAgchDZzcJUT5O44XoN4gVfFFzUq6wsGrGjftiwNW2tV
         MGlQ==
X-Gm-Message-State: AOJu0Yy7p2UhJROQwub2D+oV6btRkDH230QIFsQM4h/PD7hNk/5SOZyZ
	CNkV0ObLBpDYmcbO4FjSSs6XQlPGliQ1wt2P7MOU+7rzo9QCw8+43G1exGDExwzpphg=
X-Gm-Gg: AfdE7ckd5P5MwO5y2wDYK3tS4e6Bx+0StjPPVxMJ7rEX/RIKns/b5O5amYn9pyHjD1t
	6+Kdumautq5INE7KwtSkn6rj22Vb+RWI+fpz3+IMXckZugqXLVMRsXklTht45ynefe4OjurdGfH
	YYCJiNL5BwSt4Hcs0g1Xo9I6eOtDALZfMsMYON1o8ddebbuGY8DiTpp4SAz4tQfVPpOSkz/dEXp
	40LzAm74Yw0ymyD1J2VMI90q5nSnefSvD+7y272Z46CtvPkfANT67HCebT6qq9UTeuj6Pcy01Hr
	lo/u8WuXNpBIo9fUSO3+pgmtH/eeIz+/nnCqtcNknT51GiPXBqfyi4m/tGmlQP3HG2WdoDhIYAT
	RT4g1EqgBxDWjZq+5xmB57npZjBu7gyy9BkzN8SZT6eIa1qBF9G1YrgwXJEL6jEAdWenysi9Kpt
	n22gchkooDShPU0M3DNM/SBnd3xeJszocskv4SSL72SIETO0M4cX/i5JURmtxhGyi31lRUPHCS9
	Q==
X-Received: by 2002:a05:620a:4411:b0:92e:6c8a:2a1a with SMTP id af79cd13be357-92e6c8a3c36mr414263485a.7.1782854342795;
        Tue, 30 Jun 2026 14:19:02 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e62366303sm335924285a.40.2026.06.30.14.19.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 14:19:02 -0700 (PDT)
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
	apopple@nvidia.com
Subject: [PATCH v6 08/10] dax/kmem: extract hotplug/hotremove helper functions
Date: Tue, 30 Jun 2026 17:18:40 -0400
Message-ID: <20260630211842.2252800-9-gourry@gourry.net>
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

Refactor kmem _probe() _remove() by extracting init, cleanup, hotplug,
and hot-remove logic into separate helper functions:

  - dax_kmem_init_resources: inits IO_RESOURCE w/ request_mem_region
  - dax_kmem_cleanup_resources: cleans up initialized IO_RESOURCE
  - dax_kmem_do_hotplug: handles memory region reservation and adding
  - dax_kmem_do_hotremove: handles memory removal and resource cleanup

This is a pure refactoring with no functional change. The helpers will
enable future extensions to support more granular control over memory
hotplug operations.

We need to split hotplug/hotunplug and init/cleanup in order to have the
resources available for hot-add.  Otherwise, when probe occurs, the dax
devices are never added to sysfs because the resources are never
registered.

Detatching hotunplug/cleanup allows us to re-use the hotunplug code
without destroying the underlying resources.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 327 +++++++++++++++++++++++++++++++--------------
 1 file changed, 225 insertions(+), 102 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 0a184c0878dd..72dcccee41e1 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -63,14 +63,206 @@ static void kmem_put_memory_types(void)
 	mt_put_memory_types(&kmem_memory_types);
 }
 
+/**
+ * dax_kmem_do_hotplug - hotplug memory for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Hotplugs all ranges in the dev_dax region as system memory.
+ *
+ * Returns the number of successfully mapped ranges, or negative error.
+ */
+static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
+			       struct dax_kmem_data *data,
+			       int online_type)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc, onlined = 0;
+	mhp_t mhp_flags;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		/*
+		 * init_resources() is best-effort: if a reservation conflict
+		 * occurs it keeps the range but leaves res[i]=NULL. For hotplug
+		 * on probe systems, this means kmem will partially online.
+		 *
+		 * We have to keep this behavior not to break those systems.
+		 * For those systems - atomicity only applies to valid ranges.
+		 */
+		if (!data->res[i])
+			continue;
+
+		mhp_flags = MHP_NID_IS_MGID;
+		if (dev_dax->memmap_on_memory)
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+
+		/*
+		 * Ensure that future kexec'd kernels will not treat
+		 * this as RAM automatically.
+		 */
+		rc = __add_memory_driver_managed(data->mgid, range.start,
+				range_len(&range), kmem_name, mhp_flags,
+				online_type);
+
+		if (rc) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
+				 i, range.start, range.end);
+			/*
+			 * Release the reservation for the range that failed to
+			 * add so a later hotremove does not try to remove memory
+			 * that was never added.
+			 */
+			if (data->res[i]) {
+				remove_resource(data->res[i]);
+				kfree(data->res[i]);
+				data->res[i] = NULL;
+			}
+			if (onlined)
+				continue;
+			return rc;
+		}
+		onlined++;
+	}
+
+	return onlined;
+}
+
+/**
+ * dax_kmem_init_resources - create memory regions for dax kmem
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Initializes all the resources for the DAX
+ *
+ * Returns the number of successfully mapped ranges, or negative error.
+ */
+static int dax_kmem_init_resources(struct dev_dax *dev_dax,
+				   struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc, mapped = 0;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct resource *res;
+		struct range range;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		/* Skip ranges already added */
+		if (data->res[i])
+			continue;
+
+		/* Region is permanently reserved if hotremove fails. */
+		res = request_mem_region(range.start, range_len(&range),
+					 data->res_name);
+		if (!res) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
+				 i, range.start, range.end);
+			/*
+			 * Once some memory has been onlined we can't
+			 * assume that it can be un-onlined safely.
+			 */
+			if (mapped)
+				continue;
+			return -EBUSY;
+		}
+		data->res[i] = res;
+		/*
+		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
+		 * so that add_memory() can add a child resource.  Do not
+		 * inherit flags from the parent since it may set new flags
+		 * unknown to us that will break add_memory() below.
+		 */
+		res->flags = IORESOURCE_SYSTEM_RAM;
+		mapped++;
+	}
+	return mapped;
+}
+
+#ifdef CONFIG_MEMORY_HOTREMOVE
+/**
+ * dax_kmem_do_hotremove - hot-remove memory for dax kmem device
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Removes all ranges in the dev_dax region.
+ *
+ * Returns the number of successfully removed ranges.
+ */
+static int dax_kmem_do_hotremove(struct dev_dax *dev_dax,
+				 struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, success = 0;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		struct range range;
+		int rc;
+
+		rc = dax_kmem_range(dev_dax, i, &range);
+		if (rc)
+			continue;
+
+		/* range was never added during probe, count as removed */
+		if (!data->res[i]) {
+			success++;
+			continue;
+		}
+
+		rc = remove_memory(range.start, range_len(&range));
+		if (rc == 0) {
+			/* Release the resource for the successfully removed range */
+			remove_resource(data->res[i]);
+			kfree(data->res[i]);
+			data->res[i] = NULL;
+			success++;
+			continue;
+		}
+		any_hotremove_failed = true;
+		dev_err(dev, "mapping%d: %#llx-%#llx hotremove failed\n",
+			i, range.start, range.end);
+	}
+
+	return success;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
+
+/**
+ * dax_kmem_cleanup_resources - remove the dax memory resources
+ * @dev_dax: the dev_dax instance
+ * @data: the dax_kmem_data structure with resource tracking
+ *
+ * Removes all resources in the dev_dax region.
+ */
+static void dax_kmem_cleanup_resources(struct dev_dax *dev_dax,
+				       struct dax_kmem_data *data)
+{
+	int i;
+
+	for (i = 0; i < dev_dax->nr_range; i++) {
+		if (!data->res[i])
+			continue;
+		remove_resource(data->res[i]);
+		kfree(data->res[i]);
+		data->res[i] = NULL;
+	}
+}
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
 	unsigned long total_len = 0, orig_len = 0;
 	struct dax_kmem_data *data;
 	struct memory_dev_type *mtype;
-	int i, rc, mapped = 0;
-	mhp_t mhp_flags;
+	int i, rc;
 	int numa_node;
 	int online_type;
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
@@ -133,73 +325,27 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
+	dev_set_drvdata(dev, data);
+
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		goto err_resources;
+
 	/* Resolve system default at bind time in case it changed */
 	online_type = dev_dax->online_type;
 	if (online_type == DAX_ONLINE_DEFAULT)
 		online_type = mhp_get_default_online_type();
 
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct resource *res;
-		struct range range;
-
-		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc)
-			continue;
-
-		/* Region is permanently reserved if hotremove fails. */
-		res = request_mem_region(range.start, range_len(&range), data->res_name);
-		if (!res) {
-			dev_warn(dev, "mapping%d: %#llx-%#llx could not reserve region\n",
-					i, range.start, range.end);
-			/*
-			 * Once some memory has been onlined we can't
-			 * assume that it can be un-onlined safely.
-			 */
-			if (mapped)
-				continue;
-			rc = -EBUSY;
-			goto err_request_mem;
-		}
-		data->res[i] = res;
-
-		/*
-		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
-		 * so that add_memory() can add a child resource.  Do not
-		 * inherit flags from the parent since it may set new flags
-		 * unknown to us that will break add_memory() below.
-		 */
-		res->flags = IORESOURCE_SYSTEM_RAM;
-
-		mhp_flags = MHP_NID_IS_MGID;
-		if (dev_dax->memmap_on_memory)
-			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
-
-		/*
-		 * Ensure that future kexec'd kernels will not treat
-		 * this as RAM automatically.
-		 */
-		rc = __add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags,
-				online_type);
-
-		if (rc) {
-			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
-					i, range.start, range.end);
-			remove_resource(res);
-			kfree(res);
-			data->res[i] = NULL;
-			if (mapped)
-				continue;
-			goto err_request_mem;
-		}
-		mapped++;
-	}
-
-	dev_set_drvdata(dev, data);
+	rc = dax_kmem_do_hotplug(dev_dax, data, online_type);
+	if (rc < 0)
+		goto err_hotplug;
 
 	return 0;
 
-err_request_mem:
+err_hotplug:
+	dax_kmem_cleanup_resources(dev_dax, data);
+err_resources:
+	dev_set_drvdata(dev, NULL);
 	memory_group_unregister(data->mgid);
 err_reg_mgid:
 	kfree(data->res_name);
@@ -213,7 +359,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -224,48 +370,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	 * there is no way to hotremove this memory until reboot because device
 	 * unbind will succeed even if we return failure.
 	 */
-	for (i = 0; i < dev_dax->nr_range; i++) {
-		struct range range;
-		int rc;
-
-		rc = dax_kmem_range(dev_dax, i, &range);
-		if (rc)
-			continue;
-
-		/* range was never added during probe */
-		if (!data->res[i]) {
-			success++;
-			continue;
-		}
-
-		rc = remove_memory(range.start, range_len(&range));
-		if (rc == 0) {
-			remove_resource(data->res[i]);
-			kfree(data->res[i]);
-			data->res[i] = NULL;
-			success++;
-			continue;
-		}
-		any_hotremove_failed = true;
-		dev_err(dev,
-			"mapping%d: %#llx-%#llx cannot be hotremoved until the next reboot\n",
-				i, range.start, range.end);
+	success = dax_kmem_do_hotremove(dev_dax, data);
+	if (success < dev_dax->nr_range) {
+		dev_err(dev, "Hotplug regions stuck online until reboot\n");
+		return;
 	}
 
-	if (success >= dev_dax->nr_range) {
-		memory_group_unregister(data->mgid);
-		kfree(data->res_name);
-		kfree(data);
-		dev_set_drvdata(dev, NULL);
-		/*
-		 * Clear the memtype association on successful unplug.
-		 * If not, we have memory blocks left which can be
-		 * offlined/onlined later. We need to keep memory_dev_type
-		 * for that. This implies this reference will be around
-		 * till next reboot.
-		 */
-		clear_node_memory_type(node, NULL);
-	}
+	dax_kmem_cleanup_resources(dev_dax, data);
+	memory_group_unregister(data->mgid);
+	kfree(data->res_name);
+	kfree(data);
+	dev_set_drvdata(dev, NULL);
+	/*
+	 * Clear the memtype association on successful unplug.
+	 * If not, we have memory blocks left which can be
+	 * offlined/onlined later. We need to keep memory_dev_type
+	 * for that. This implies this reference will be around
+	 * till next reboot.
+	 */
+	clear_node_memory_type(node, NULL);
 }
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
-- 
2.53.0-Meta

