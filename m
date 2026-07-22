Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0EE4457B4
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745341; cv=none; b=Gh+kjIPn0sRVd1U+nE/GZ8CAqJ2nKL5RTgmthjVQzddQGsAIKv59u/Xvzi5Ht08xNkD88c7b0K9m7N5YDyjtLsA4v8ZZCSrhizXeqxMkGjKR1IDDdWpZFlI/aD0VnSYXEZIkIu35ktygVhE8ldDG44VAw95K8S8c1ZXcbVg+xyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745341; c=relaxed/simple;
	bh=nJ35d+eSRwcW0nsb3UMSMmMEzxzLr5EKcff45F9EGHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCSGoh79eAz5koPLwpm/LICmGr4hjltb+drBPEXSIHwUNThKPVkq/YBe4Ty6dF2qYPSjIdYK2LBgsqTI1cuprTnjNytpKVheMA6w+dAAixWlODv0oE3pvLX5o9SzAND4FO2px8Xtv1xhScY0J0mZ943cUwXexhWltU+LUDOgD4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=fKN2M0BN; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="fKN2M0BN"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92e5c9211d2so1162311185a.1
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745336; x=1785350136; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rb3wioIcpW4xOhPfXJEKXcvsIiP8tbJgl4SCMKfLhpI=;
        b=fKN2M0BNbG61hLq55/Jk5nMHtMNBc/r3Pk2xYNBxaBUJch/ACz24IktuIyPonmsI4T
         PjIFu4VB6o5qI8+GxehbEiVO4yL5qe8dCpJYw53NzI3S6giT00/LubsltaM3rKLHw3Ty
         O4BjzQDFM/TZCBplD3eU6/1W2v4cfY9kfPlMB9semfUUtx/kuQBsfvVieXDOdGj/6Hwf
         to7FOReXZoczZgJDm9pTFn6ipkEHarPlC69AmqOsDR166uqxyOAtNWurbvkthWeGCQim
         8c6QdYD2rZD8j4ZNl8d2iXtWLL4AvO6B4jyXp5fiB7OOPaCk1qt818b5bBdnWdb3jCbU
         zPjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745336; x=1785350136;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rb3wioIcpW4xOhPfXJEKXcvsIiP8tbJgl4SCMKfLhpI=;
        b=enrJHOB63htBN6oV33RDcgyiRX2rFsX+0jg30p0uyYYVa+JU4WPlQm7Sp3CwlaPyfC
         IduA4LN0YWqxhNKS8zZm3m+T3Nt9NSDqqQCY0+Lz41PI2bHO6tjv1q1mxevl+wgxr9Fw
         XCs+IgGcEF0Y26iAuFM555tM6cBbRp1VehnAW1qk5NwoNkkUVc4b76BSjUp1/jfBYDE1
         8lONeGWN8tKZ1sxIri3jsfGtcRGIXoaewIVnYnFGlANBv6FzAJ10Y0Xx4xbM2Ncm4knI
         giT2yXxIVOK/veFRXbHuFYZ2qwl6B87go1VSBccrG1TspaceqMM2MVVCsgGPeodKxwoo
         FZOw==
X-Gm-Message-State: AOJu0Yw7N8QySOZSpq98cZxuRdByUvSUWEEEIaK5QqjX8kHlExXTELl1
	eY3S/2aQVGGqNvEGlBjoGkY0JnD+XnW5xmz0dQEZMs7tt5zXqjmddf85qAmNOi7Jrz0=
X-Gm-Gg: AR+sD133ZtezjgLBRuJzzmb3JpPSe7lA5Y5ujypfrudxfqSpFjXFYcYGDg6X2To2d/p
	EvfPBW50Hvn5CMLkaIFi9GTG6CpSzRF+sXTexAyS7XA/m8pye9eLmtUMKitbBvhQaMrcxpUT1Jj
	uzSS5kwwhxAICn/llFxHvGo+AbHhUtbegOe2mcjLiS8JMSEdrmM7z56gZfHGxCyNwz0PQZv/81s
	DUSApc/nRMd+v9UbiQp3a3sJWT1G0Iq4m+DR5FRevVakyoHsaUBGkf8BxDILIoVTjKkj9rTzxsw
	lUDGfJPmIkLZUhVNnuAqtw/ERQU5GNYnxVBfTpjUe30aYoFc7Fd60m/TdLJuZB5Nmwz4Ec9eJ3J
	SAONnoqpchFWrpocZ69scNJIXzk6UFrfo6Jcy6+VRr9xU3zt0TewCix1jCNXYD5hQdYEhzuuvCK
	RH9ZEQXYojcaV5vlyh56sjRTSn3nVgBC0IGLS3CRrr33aIWHFCj/DubccoJ0DFMms=
X-Received: by 2002:a05:620a:4885:b0:92e:d5f6:2e71 with SMTP id af79cd13be357-930b3eea5damr2411579085a.14.1784745335608;
        Wed, 22 Jul 2026 11:35:35 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:35 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 8/8] dax/kmem: add dax/adistance to make private node adistance configurable
Date: Wed, 22 Jul 2026 14:35:19 -0400
Message-ID: <20260722183519.935213-9-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260722183519.935213-1-gourry@gourry.net>
References: <20260722183519.935213-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

For testing, it is useful to allow adjustments to node location in the
tiering hierarchy - but this is presently a function of static config
data (SRAT/HMAT).

Private nodes have a contract of one owning service per node, meaning
the registering service can set the adistance for that node without
interfering with other hotplugged memory (no other service can hotplug).

Extend kmem to have dax0.0/adistance when `private=1`, so that the
targeted node's tier membership can be moved around.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 68 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c33dac5939edd..9fd50ef44d56b 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -51,6 +51,7 @@ struct dax_kmem_data {
 	int numa_node;
 	int state;
 	struct mutex lock; /* protects hotplug state transitions and config */
+	int adistance; /* node abstract distance */
 	bool dax_file; /* when set, cdev allows mmap */
 	struct mempolicy *policy; /* device-lifetime bind for dax-file mmap */
 	bool private; /* when set, memory is onlined as N_MEMORY_PRIVATE */
@@ -68,6 +69,27 @@ static struct memory_dev_type *kmem_find_alloc_memory_type(int adist)
 	return mt_find_alloc_memory_type(adist, &kmem_memory_types);
 }
 
+/*
+ * Re-register the node's memory type at given abstract distance, refined
+ * by the platform algorithm.  This lets us move nodes to different memory
+ * tiers for testing and if the node does not have static perf data.
+ *
+ * Caller holds data->lock, and device must be in unplugged state.
+ */
+static int kmem_set_adistance(struct dax_kmem_data *data, int adist)
+{
+	struct memory_dev_type *memtype;
+
+	mt_calc_adistance(data->numa_node, &adist);
+	memtype = kmem_find_alloc_memory_type(adist);
+	if (IS_ERR(memtype))
+		return PTR_ERR(memtype);
+	clear_node_memory_type(data->numa_node, NULL);
+	init_node_memory_type(data->numa_node, memtype);
+	data->adistance = adist;
+	return 0;
+}
+
 static void kmem_put_memory_types(void)
 {
 	guard(mutex)(&kmem_memory_type_lock);
@@ -495,6 +517,45 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	return len;
 }
 
+static ssize_t adistance_show(struct device *dev, struct device_attribute *attr,
+			      char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+
+	if (!data)
+		return -ENXIO;
+	return sysfs_emit(buf, "%d\n", data->adistance);
+}
+
+static ssize_t adistance_store(struct device *dev, struct device_attribute *attr,
+			       const char *buf, size_t len)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	int adist;
+	ssize_t rc;
+
+	if (!data)
+		return -ENXIO;
+
+	rc = kstrtoint(buf, 0, &adist);
+	if (rc)
+		return rc;
+	if (adist <= 0)
+		return -EINVAL;
+
+	guard(mutex)(&data->lock);
+
+	/* adistance only reconfigures the device while it holds no memory. */
+	if (data->state != DAX_KMEM_UNPLUGGED)
+		return -EBUSY;
+
+	rc = kmem_set_adistance(data, adist);
+	if (rc)
+		return rc;
+	return len;
+}
+static DEVICE_ATTR_RW(adistance);
+
 static const struct attribute_group dax_kmem_private_group;
 
 static ssize_t private_show(struct device *dev, struct device_attribute *attr,
@@ -529,6 +590,11 @@ static ssize_t private_store(struct device *dev, struct device_attribute *attr,
 	if (enable == data->private)
 		return len;
 
+	/* When toggling private, reset custom adistance to default */
+	rc = kmem_set_adistance(data, MEMTIER_DEFAULT_DAX_ADISTANCE);
+	if (rc)
+		return rc;
+
 	if (enable) {
 		/* Add the per-service opt-in attributes. */
 		rc = sysfs_create_group(&dev->kobj, &dax_kmem_private_group);
@@ -637,6 +703,7 @@ KMEM_PRIVATE_CAP_ATTR(ltpin, NODE_PRIVATE_CAP_LTPIN);
 
 /* Per-service opt-ins. Visibility toggled by 'private' control */
 static struct attribute *dax_kmem_private_attrs[] = {
+	&dev_attr_adistance.attr,
 	&dev_attr_reclaim.attr,
 	&dev_attr_user_numa.attr,
 	&dev_attr_hotunplug.attr,
@@ -719,6 +786,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	data->mgid = rc;
 	data->numa_node = numa_node;
 	data->state = DAX_KMEM_UNPLUGGED;
+	data->adistance = adist;
 	data->np.owner = data;
 	mutex_init(&data->lock);
 
-- 
2.53.0-Meta

