Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924553438AF
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 15:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783871133; cv=none; b=u6bLg3Q8c4sXi0hjebTglyatEa4352VvkZPI5RWn6pcfSgFQRm/nFpCszrDDLQEa4av0SZqzeGh79wXK0ntoA9PHJlXKqInCwHOKySqH3Gf0v5WIHb4ACntMoqNb3k1C712WcSE/6/15CKQtHM5Sypwo1VJJfvpmvWkohBIHUHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783871133; c=relaxed/simple;
	bh=CQgzBRruGlOBdStAkSN+ZHVIq/ho3VqxALjNcSGxk4M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QmCR+t+IZvvWXFnkLYN13og/wTwmkN08KjHLdIbdHVWPtJyG7e7ABocvjPPh86Mc2UEbjPZSJ1TcKACa1/WJQN6V5FJsXWHNvgbWEbUE042xbWq4hnhil8gonhD8lOaCaJoQ5vnk8T60Olqk5WhhZ8S7+aqVmbF5W8bcMc2aZeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=jUva5a9R; arc=none smtp.client-ip=209.85.160.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="jUva5a9R"
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-51c2b2c9eccso16461291cf.2
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 08:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783871129; x=1784475929; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9m4Re3kSEFpR6uNzVdviqzECHvX8FpKIStu+nZnUI9c=;
        b=jUva5a9RipMGCq34CaKVC8veDix+/pG/24mSCBVneZVUgtleT2DuTj2WeJ2Ymo+T02
         R3yLggxGcrJE33/4+fZ0v3VP81/2WTSw0f6tdfCqEtV665mR4oiP/hZKCiGv8RIHYSk0
         x0KkXUYF+kYOiAVbTOUlx6LEuYbtTFfEDD8jc2eIUhsa9CvCDc48N3fr807cdY3pWLAp
         KCM75fyBszmqDW7UhlcPr/xzUwcby0EwaHQVMKN9o65ovTYOk9fTU4QKuxy3OAT42tUz
         ahOQQKt/ARzlZmMuiurPVoBD5ObbZsAMmdBXtwVZLuScUWvhEmuCi0a3muinBdSmc+f/
         OQBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783871129; x=1784475929;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=9m4Re3kSEFpR6uNzVdviqzECHvX8FpKIStu+nZnUI9c=;
        b=tIM46Uo8eVZ/AUHUSJKZLEdRuPfXTmTlJIPwjJ4YgJ934sa4doKYbPIGREPpz3MEoY
         EPz34X7m0spKPX3W+yyOCzvLDCCBOCa2NrSAwhFi0ZLM0d9rsbeLCoLrJoNZkQprQxN2
         Q6qzTKGUKf6SAPkD+c2K3zIwJtUb1m4Ta3byLnk0OX/gW4AGlOiQ2SJCKdHC+j9lkKVt
         rbwqlzCV0oqz10gCtC6xFy9kAwQ4+lwW5psRgmEcU/9HVfV1H9IcbFBitdgxRMctczyc
         63ODo1IUISFBblLD5tRk/ew29QU/cCYty1TWbolAYlmRthX79knH+lILa92VTMQu3Wna
         Zz8Q==
X-Forwarded-Encrypted: i=1; AHgh+RoN2CzvYdxpYgRZB9Seup2PfjJUsFtcYpsspiXdLMpk+8GG2qIY0VJCirh5osL5CvpnFFoRZH4=@lists.linux.dev
X-Gm-Message-State: AOJu0YxFzCrGV3iCkEwW64jrNyHBy21VM6Ouz23WEsPBHtwa++xwgPtH
	oNHEkYlUYzaa2PVVGLeB7X20dui03kMbehenwLaAGanQkSyUb+lAetMaB5fM2bprBuM=
X-Gm-Gg: AfdE7cnDJRF5BH66bscEbJKYfnJYN4zanxIYc0+m2j+0ZBjtcjTe3+W3Q46lN2WW4tX
	+G//Vrzbrh663NQKK6pQzhc0nGT9Wy3q1Vx5iCp5DYr0REumoI9K2SbsIfEfVpIaPRon08gp/QK
	JckM262XcRFaLvF0AZkpicvBi4aklhXhrPp6siROsJONaa0CBwbOJR83U+EuCb3jb6yDWt+WtzE
	cnIzYPg34JK/WGBeM5V/LKhK1mCZICINtUgvudo4L9oCtQurGdom/Lpn6y2RCBNzuMLqjjKcSS8
	h1CCQfPZpnjAelTBf4j8SD87n0QNGReo97AHVMx+p1XjS4dCle9IxzI9x2nKNL1np0nSAc7H885
	16BXA9pL689JyYguTHX02Dy5+zJEM2G0JbeZAiuxe/GKSXb6L5U2ApB3HIcy/fZhzuC5rz+PYLO
	rqFxJcc/HNOW2+2rNXswUY9kZyPEOfe+IxsilppburkcORuVMtoRPo2i+YpIE1xw7dsZIKO9dn9
	w==
X-Received: by 2002:a05:620a:2552:b0:92e:8405:7ad2 with SMTP id af79cd13be357-92ef2be2c70mr599484085a.41.1783871129312;
        Sun, 12 Jul 2026 08:45:29 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92ee5d61facsm862186485a.42.2026.07.12.08.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 08:45:28 -0700 (PDT)
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
	gourry@gourry.net
Subject: [PATCH v7 08/10] dax/kmem: extract hotplug/hotremove helper functions
Date: Sun, 12 Jul 2026 11:45:02 -0400
Message-ID: <20260712154505.3564379-9-gourry@gourry.net>
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

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 323 +++++++++++++++++++++++++++++++--------------
 1 file changed, 223 insertions(+), 100 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index 38ed5c4e9c83d..6174f7d3d05bd 100644
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
+		 * unknown to us that will break add_memory() later.
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
 	int adist = MEMTIER_DEFAULT_DAX_ADISTANCE;
 	int online_type = mhp_get_default_online_type();
@@ -133,68 +325,22 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		goto err_reg_mgid;
 	data->mgid = rc;
 
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
+	dev_set_drvdata(dev, data);
 
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
+	rc = dax_kmem_init_resources(dev_dax, data);
+	if (rc < 0)
+		goto err_resources;
 
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
@@ -208,7 +354,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -219,48 +365,25 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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

