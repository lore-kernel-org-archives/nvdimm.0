Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB6263546C4
	for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 18:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784745330; cv=none; b=XDhZdMUASNxhhxiKU2RpqJ6Jas4k/1loCJE5nuHHNGYeORKiaCjt2Ks5mDTtR5hYJIJYEb4LxY8nY1XOSrY7oVeKvIkcOI8tejWOzmSP5qrOXBTKpZRO7OGjadZWqtNYu80/1NQo0AWaAR+LLMVq9IWRgVZ5CZYBD2I8DxRKtD4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784745330; c=relaxed/simple;
	bh=5oK9iWBVO5m3icq9mZsHdP4HXHEqMsBagSx2ZqZAtgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CRxbqLGpxKFgUX3ns8nAIEa0F8Tl7lbD8M3KYtxYYy23JfTWgMQ7Ph0ySMQ5x3YS3RrzO/Ggkl+JlRXV9hQ8p1YIY5mq6fMAktK+xM+8v8R7KPge9fPNcJ1W4HP/gQc+3PuSsnklAqqSA10uMBfyC01/kWfjP487xsrky8QHqmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=XV+oNqof; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="XV+oNqof"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so74310766d6.0
        for <nvdimm@lists.linux.dev>; Wed, 22 Jul 2026 11:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784745328; x=1785350128; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qg2sr9w1J3nOO7FQ1cLX7doN7aPqFEfPWWRPqDtuE0I=;
        b=XV+oNqofaBbZKvqVKWWOcS0r3fUvXQUlbnSJRf+cgdbLXDIxonQaam3OdU0tBUTx6u
         US+nDdBSACzPWgXNgkSIYK+wKCPV1oxWObSeEMw1OfRHF8I0mGs88ykjHqoAvivllPO2
         tTYF3TrocSod6XefteOp+66SunUCIN295jVR20XSXFNHk9GCfV5Fnfd9Pe7iNRNOA0En
         Y/BsTH/Nyy6xiro3x7URFQ667BlT3gfHnwQW9rmTgq7uCqZZ2nS/zdpzVuDqeCa3q6sS
         8932h58QA80i6YdIWIs+fb7Tw4bBfmJEEq0UCzH9EfWgqaiZfcMTaG7XeK38DQyEsF5+
         B8TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784745328; x=1785350128;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qg2sr9w1J3nOO7FQ1cLX7doN7aPqFEfPWWRPqDtuE0I=;
        b=bKhIEwUD3wXQOJIOI70fFH9WdSOy9iYyc1QganhKNA260g9t3axfGZPoascrbjQZVp
         qSe3ERTMOLYw1qa7ytS7seaoxjySE2sxvwTQMaDZOeGooQLqDd98h+pMJWnlccLN8bn0
         OdDQfLEZIn+XfrrKtRwawRXi23NYX06TLKNILgHyOt1uU64jUl3YVuYqqHf20ZUEKwdY
         lsrhUdtr2fivLhgwFosbkKBi83WWx2xy2WgFKlOPqPYM2YUQYhu0B84N6R7XodindJvZ
         vRRzuFrqOdD/CD38agrOtKWrBEIPZef/bMLqU3NLdICEsO6ZS3Nw5nu8b3Q3tUBOQmET
         kUAA==
X-Gm-Message-State: AOJu0YzHH4dkCi9tCun3j5qAT49oAhODHjCVrZ04VWWD54QAyJ3o0jrG
	NCZUPpadzOF4lPPRi2jTucIVjJmswSPEI8QxEa8XtLeY5jqnYiEknqBjVNnl8PDx8JU=
X-Gm-Gg: AR+sD137orA4eRSOHKg3xDDM2LGGXqfpja6G90tqZES62aPeNmvq5tDq0U4EVOxIOq2
	VqCHRMgGo7gRgP/GVku83L9EdcbZMMusj3o6xx0jpRCmUyhj9GQdheQTRnbS3JJ+rDHsIJqI9sO
	VPAa0av+i1QIglI91EEPfb+5geuEbJ82YR3tJciqCTqGZME//tfEvEkQyAptp9x4nqhqr9V9i+P
	PrZkKT6hA+i/k2OZ3fXWpKY9t5sZV+yl/Gq3y/csCfvElrllWNM8bSgFuc3lc8XiihjIRxOnm1/
	KBzmZipiB+4jP1bX7EPpQyAKVBKylw0dYa8Xgm9W+t5F1mmGcTkuPLU1BOb0Egmo97uUVFUIBxe
	bTJ95szna78bbUgAZuAO1I4K5HDzC6sTBMpDXmRP3Kp556A4RYco42r/A0EwIte4B0r/yCWlmPV
	DoTdC11S5OjVkzpPz/Ud8Q7o0ITERV0byYJ59okAiFzxHM2f+WXgCUt8PYb3pY+Ww=
X-Received: by 2002:a05:6214:2c12:b0:903:faf8:a93f with SMTP id 6a1803df08f44-907b9bcb694mr64124716d6.30.1784745327474;
        Wed, 22 Jul 2026 11:35:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907ba8b3e96sm27630216d6.1.2026.07.22.11.35.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jul 2026 11:35:27 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com
Subject: [RFC PATCH 2/8] dax/kmem: add private= to online memory as an N_MEMORY_PRIVATE node
Date: Wed, 22 Jul 2026 14:35:13 -0400
Message-ID: <20260722183519.935213-3-gourry@gourry.net>
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

Add a "private" knob to dax/kmem.  Only writable when state=unplugged.

Switches the device between onlining as N_MEMORY and N_MEMORY_PRIVATE.
This marks the node private and excludes it from every fallback zonelist.

Fails if the node already has online (non-private) memory or a if the
node has a different private owner.

The base plumbing for capability bit flags are added here, but no
capabilities are added until later commits.

A private node after this commit is solely accessible via mmap on
the dax character device (/dev/daxN.M).

Because a fully isolated private node cannot reclaim or compact, its
dax-file mappings default to base-page faults (VM_NOHUGEPAGE). This
makes allocation / failures more deterministic, otherwise a fault may
fail due to a lock of given order despite memory still being free.

When/if reclaim is supported (and the node opted-in), this can be relaxed.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/kmem.c | 85 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 83 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index d9021cf148982..c4c18aeb43c69 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -14,6 +14,7 @@
 #include <linux/mempolicy.h>
 #include <linux/memory-tiers.h>
 #include <linux/memory_hotplug.h>
+#include <linux/node_private.h>
 #include <linux/string_helpers.h>
 #include "dax-private.h"
 #include "bus.h"
@@ -52,6 +53,9 @@ struct dax_kmem_data {
 	struct mutex lock; /* protects hotplug state transitions and config */
 	bool dax_file; /* when set, cdev allows mmap */
 	struct mempolicy *policy; /* device-lifetime bind for dax-file mmap */
+	bool private; /* when set, memory is onlined as N_MEMORY_PRIVATE */
+	unsigned long caps; /* NODE_PRIVATE_CAP_* flags */
+	struct node_private np;
 	struct resource *res[];
 };
 
@@ -108,6 +112,13 @@ static int kmem_anon_mmap(struct file *filp, struct vm_area_struct *vma)
 		return -ENXIO;
 
 	vma_set_anonymous(vma);
+	/*
+	 * Default a private node's dax-file mappings to base-page faults.
+	 * Without reclaim/compaction, high-order allocations can fail despite
+	 * memory still being available. Can be relaxed with reclaim support.
+	 */
+	if (data->private)
+		vm_flags_set(vma, VM_NOHUGEPAGE);
 	mpol_get(data->policy);
 	kmem_vma_set_policy(vma, data->policy);
 	return 0;
@@ -187,6 +198,10 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 	if (online_type < MMOP_OFFLINE || online_type > MMOP_ONLINE_MOVABLE)
 		return -EINVAL;
 
+	/* Capabilities are stable as long as memory is online */
+	if (data->private)
+		data->np.caps = data->caps;
+
 	for (i = 0; i < dev_dax->nr_range; i++) {
 		struct range range;
 
@@ -215,7 +230,7 @@ static int dax_kmem_do_hotplug(struct dev_dax *dev_dax,
 		 */
 		rc = __add_memory_driver_managed(data->mgid, range.start,
 				range_len(&range), kmem_name, mhp_flags,
-				online_type, NULL);
+				online_type, data->private ? &data->np : NULL);
 
 		if (rc) {
 			dev_warn(dev, "mapping%d: %#llx-%#llx memory add failed\n",
@@ -480,6 +495,55 @@ static ssize_t state_store(struct device *dev, struct device_attribute *attr,
 	return len;
 }
 
+static const struct attribute_group dax_kmem_private_group;
+
+static ssize_t private_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+
+	if (!data)
+		return -ENXIO;
+	return sysfs_emit(buf, "%d\n", data->private);
+}
+
+static ssize_t private_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t len)
+{
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+	bool enable;
+	int rc;
+
+	if (!data)
+		return -ENXIO;
+
+	rc = kstrtobool(buf, &enable);
+	if (rc)
+		return rc;
+
+	guard(mutex)(&data->lock);
+
+	if (data->state != DAX_KMEM_UNPLUGGED)
+		return -EBUSY;
+
+	if (enable == data->private)
+		return len;
+
+	if (enable) {
+		/* Add the per-service opt-in attributes. */
+		rc = sysfs_create_group(&dev->kobj, &dax_kmem_private_group);
+		if (rc)
+			return rc;
+		data->private = true;
+	} else {
+		sysfs_remove_group(&dev->kobj, &dax_kmem_private_group);
+		data->private = false;
+	}
+
+	return len;
+}
+static DEVICE_ATTR_RW(private);
+
 static ssize_t dax_file_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
@@ -531,6 +595,14 @@ static ssize_t dax_file_store(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(dax_file);
 
+/* Per-service opt-ins. Visibility toggled by 'private' control */
+static struct attribute *dax_kmem_private_attrs[] = {
+	NULL,
+};
+static const struct attribute_group dax_kmem_private_group = {
+	.attrs = dax_kmem_private_attrs,
+};
+
 static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 {
 	struct device *dev = &dev_dax->dev;
@@ -601,6 +673,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	data->mgid = rc;
 	data->numa_node = numa_node;
 	data->state = DAX_KMEM_UNPLUGGED;
+	data->np.owner = data;
 	mutex_init(&data->lock);
 
 	dev_set_drvdata(dev, data);
@@ -668,6 +741,9 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	struct device *dev = &dev_dax->dev;
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
+	if (data->private)
+		sysfs_remove_group(&dev->kobj, &dax_kmem_private_group);
+
 	/* If enabled, clean up the dax-file char device configuration. */
 	if (data->dax_file) {
 		kmem_dax_file_cdev_del(dev_dax);
@@ -707,7 +783,11 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 #else
 static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 {
-	struct dax_kmem_data *data = dev_get_drvdata(&dev_dax->dev);
+	struct device *dev = &dev_dax->dev;
+	struct dax_kmem_data *data = dev_get_drvdata(dev);
+
+	if (data && data->private)
+		sysfs_remove_group(&dev->kobj, &dax_kmem_private_group);
 
 	/* If enabled, clean up the dax-file char device configuration. */
 	if (data && data->dax_file) {
@@ -732,6 +812,7 @@ static DEVICE_ATTR_RW(state);
 static struct attribute *dev_dax_kmem_attrs[] = {
 	&dev_attr_state.attr,
 	&dev_attr_dax_file.attr,
+	&dev_attr_private.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(dev_dax_kmem);
-- 
2.53.0-Meta

