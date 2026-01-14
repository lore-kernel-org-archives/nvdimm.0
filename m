Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E0A73816EF
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 08:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768380769; cv=none; b=QTDNdeMuFNvznYQLjnNIcmQAyDp3As66DYCOL5biDRbkhbShs9U8g73f01VQVYGdFNhGBOyGQL8TS3QJxG0VWK3TXAE9eyJie5dZfoaJqCyhZdtWzX4yv6dreDHA7lg2sPHovXnHTUqvqu4yMWizQbo2b2sefGiWzVMnfue4+go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768380769; c=relaxed/simple;
	bh=ppAQ1Xz+aQObI+pJwKI87VFbc6xwZ4eiDj36T0P8LFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TAUZq5Swey9EyGxbkMOx3kmCWdgXCHFBkzAIIFFuilWGuIR3CyI5md4iiD28jvpsdmqwVIyTfgXUjKl5+S2Zix4mT8S5zozsF+TaRIQJ42eAXSGfx4aLv5pK1fa/t1dN+8gLyLE8UWrsyB+JZBM06ZsxMPKYy8byk1K3mHY7CZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=rSlzNzXA; arc=none smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="rSlzNzXA"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-50146483bf9so15969081cf.3
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 00:52:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768380763; x=1768985563; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7jiGG+pI5vJ9QdTZL/6UItyqMN2lMDN4VjpLN+CazVs=;
        b=rSlzNzXAtjmdOW/rQjZqpXZH7+3MDS26/m2VRFVr80A88Fp6qoox3AOiyN7vbd6XYT
         IjlW1puCP/elTNhFKA4yu94onmDCv5WF7EyuTTxpemdrC9eecDqjm4oOtmAslFOutvUQ
         LMs9EfL5Yfjdn3beLfYHrFidSPOqXoUTq1c0Te4U700X2zCAzOtd1HbwN3H5Hms8M3/E
         sl+UoQxYF5wKVNkZNxnLjAFDdsqCODdGp0/rsS8GCndwtVVlro60q3MUVAPf+UBUFpn7
         /5WmGj7UCWuNPlZgoQzJApmgRvHkdjqc12Ap/ntB6BQtx1eH9EkrD8zZFPTmixW21ucy
         +/aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768380763; x=1768985563;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7jiGG+pI5vJ9QdTZL/6UItyqMN2lMDN4VjpLN+CazVs=;
        b=IlvcV+UDQUEZeU0WOh8LELnBxe6zCb06b1vGt2j+NWTrn/prUFBEez4qp9Ty7Agyw+
         iAQc8fOLK3LilA+SilwOyiVMCtWrv4W7mzE2ivtCjQmV83ONQiBrFFb+HCSNYtDW/zja
         bM233peJHvj+/ZOVKdED2mjw3m2r7JGxq1AbuMfG3z9dlALV1+AIvOktpXw5nPd7MtX4
         +vEVAZNzTrbRwZkoROQ3oO2//O0HiCHUTaY68dBB0WLcgjvgzHsdsSZo9tvCfyWiHI/L
         j9iX2S9Z1T0CwvUQSTTwpdjBEMoJrl8hj2s/UNTe3i39W9uEzGDP86o/0W8tBYe2I2QL
         FKkA==
X-Forwarded-Encrypted: i=1; AJvYcCVDzYJdztREzAcWnjEwxIdoHVSo0qrHG7ZQCXPoW8TWE4yaHwA/Ys4rA0ue8psuN0/o3naJbVw=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCf42srqDzHp/K2HbY7Eu0Tmii6c1nDUrb9rx+ik+qmkmufj6u
	+opWdCwv8Nt3zqZm++ZZd3BUDY1d7EwcJrE7EFXS9G/3L7BB55NU4u11UsWLlFKilb8=
X-Gm-Gg: AY/fxX6qs5pQm7szMqphK/fP+QCaFumlhEFpVHKCjBUk6sCfcYgZDXDEp//UCVaBFi1
	sG8zbQN3hUi8YaMkUd2rEOTajFhPeS8uZHhPNdidgyezT18WE1bbj+PD+yYHHqBQNqUcB8Mh+bB
	8iG8H8vlZF80sZAY9y6m3xSe0Aiswx/ZuGZvJgf4nrgSmpXEEnt/MXcS5Ab0X+tF888W1JYloF+
	SgfLzzATLJIXqB/85rwyLxvZEL+Tyrttv04jHdSq7sZe/KGzhZy0TDCouagi3na9VlOJCK+KG6A
	JxDXSNaj8GvN60A8RveKn5nGnXpJddkAwB602TLmHegIWSmhrqyzLbRugZUM/ZKZnqRmR2d6esv
	YnRJrv0zlXFg4v5po7mdfJG4qf8uuq93jzD4wpMr2MqhgQa8AcqxIO7oQiIVCHi7S2SCVxatj4N
	oMtkFwMAY+5xMjDYidliYU6MQNER98FoJBZx0OFnP2Z+1Ng5c0Sikf8WbWvHocePjFYYh157CH6
	wA=
X-Received: by 2002:a05:622a:1b1e:b0:4f4:d295:1f53 with SMTP id d75a77b69052e-501484b9dabmr20297781cf.84.1768380762822;
        Wed, 14 Jan 2026 00:52:42 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148df8759sm10131931cf.10.2026.01.14.00.52.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 00:52:42 -0800 (PST)
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
Subject: [PATCH 5/8] dax/kmem: extract hotplug/hotremove helper functions
Date: Wed, 14 Jan 2026 03:51:57 -0500
Message-ID: <20260114085201.3222597-6-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114085201.3222597-1-gourry@gourry.net>
References: <20260114085201.3222597-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Refactor dev_dax_kmem_probe() and dev_dax_kmem_remove() by extracting
the memory hotplug and hot-remove logic into separate helper functions:

  - dax_kmem_do_hotplug(): handles memory region reservation and adding
  - dax_kmem_do_hotremove(): handles memory removal and resource cleanup

Update to use the new add_memory_driver_managed() signature with
explicit online_type parameter, passing MMOP_SYSTEM_DEFAULT to
maintain existing behavior.

This is a pure refactoring with no functional change. The helpers will
enable future extensions to support more granular control over memory
hotplug operations.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 244 +++++++++++++++++++++++++++------------------
 1 file changed, 149 insertions(+), 95 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index d0dd36c536a0..5225f2bf0b2a 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -65,14 +65,138 @@ static void kmem_put_memory_types(void)
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
+			       struct dax_kmem_data *data)
+{
+	struct device *dev = &dev_dax->dev;
+	int i, rc, mapped = 0;
+	mhp_t mhp_flags;
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
+
+		/*
+		 * Set flags appropriate for System RAM.  Leave ..._BUSY clear
+		 * so that add_memory() can add a child resource.  Do not
+		 * inherit flags from the parent since it may set new flags
+		 * unknown to us that will break add_memory() below.
+		 */
+		res->flags = IORESOURCE_SYSTEM_RAM;
+
+		mhp_flags = MHP_NID_IS_MGID;
+		if (dev_dax->memmap_on_memory)
+			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+
+		/*
+		 * Ensure that future kexec'd kernels will not treat
+		 * this as RAM automatically.
+		 */
+		rc = add_memory_driver_managed(data->mgid, range.start,
+					       range_len(&range), kmem_name,
+					       mhp_flags, MMOP_SYSTEM_DEFAULT);
+
+		if (rc < 0) {
+			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
+				 i, range.start, range.end);
+			remove_resource(res);
+			kfree(res);
+			data->res[i] = NULL;
+			if (mapped)
+				continue;
+			return rc;
+		}
+		mapped++;
+	}
+
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
+		/* Skip ranges not currently added */
+		if (!data->res[i])
+			continue;
+
+		rc = remove_memory(range.start, range_len(&range));
+		if (rc == 0) {
+			remove_resource(data->res[i]);
+			kfree(data->res[i]);
+			data->res[i] = NULL;
+			success++;
+			continue;
+		}
+		any_hotremove_failed = true;
+		dev_err(dev, "mapping%d: %#llx-%#llx offline failed\n",
+			i, range.start, range.end);
+	}
+
+	return success;
+}
+#endif /* CONFIG_MEMORY_HOTREMOVE */
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
 
@@ -134,68 +258,16 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
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
-		rc = add_memory_driver_managed(data->mgid, range.start,
-				range_len(&range), kmem_name, mhp_flags,
-				MMOP_SYSTEM_DEFAULT);
-
-		if (rc < 0) {
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
 	dev_set_drvdata(dev, data);
 
+	rc = dax_kmem_do_hotplug(dev_dax, data);
+	if (rc < 0)
+		goto err_hotplug;
+
 	return 0;
 
-err_request_mem:
+err_hotplug:
+	dev_set_drvdata(dev, NULL);
 	memory_group_unregister(data->mgid);
 err_reg_mgid:
 	kfree(data->res_name);
@@ -209,7 +281,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 #ifdef CONFIG_MEMORY_HOTREMOVE
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	int i, success = 0;
+	int success;
 	int node = dev_dax->target_node;
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
@@ -220,42 +292,24 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
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
2.52.0

