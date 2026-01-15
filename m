Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA7423D2A1
	for <nvdimm@lists.linux.dev>; Thu, 15 Jan 2026 02:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768444983; cv=none; b=o3Z3oKTkC47xX9y2SU5uQY1ihmcKmzynrvtLbg5K4FSzDpfo0lqBWFpl2R824eCdbO49y2twr2WkbIoPj9RE2TIF1s5tcN67UJY15kf0eZMLEtF7wQf3uA5GYXpcg542rKmSyayQYBg9zWQOyAayLM4zudtmFgGdR79RO2p0fQY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768444983; c=relaxed/simple;
	bh=fDcOEzdBe5xRENpKlXhSuHOhCSlbP++yhs6h6KsFKQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ADbrPE9OctEJK52hrp3n8bt3ai6B8eny1lMzEWjGnSiZgLCMjPWwOpcx0f5Ec5vR1FtXUOXhlWOfy/M5+oF9y+jq0Sr5Vqz/rNgdALgs/y6T56+eY700nu3rLh1kD1YDEgvO2LNNCn+kbNtqq0nizyt+U4woL9SYud699gE8MuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=CtW8vpQ/; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="CtW8vpQ/"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-5013c1850bdso4203611cf.0
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 18:43:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768444980; x=1769049780; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
        b=CtW8vpQ/6PTYJfu0rCGPuakez84OF3jyjpbaN9iOyv/RapC1r8+eW1lR6yGLgpjUvs
         UIdpHRvEVQ1V/zBebqPuK/pCD5KTEmd46gkhnKgzcRsY6NyCUaVR74RaqkdUeC5WkyCR
         pXbQvejeelMWPZrTTKdqeVIcXw0147AShxNqf58vQ1R77aK8Qk3XMUkAobQVTpaMP1Cg
         OMkRG54jYiwppCNvlKuHpDrTGm3rwjnn92XQ3Th7omm1jZw2TDw/AkJaLV8thE9j8NBs
         MGEOxchXHkVBsNkSFwru9orWIme3BaFk9OYfraELb0eGg6UbKzzdCPd5OIXg/syoZIEW
         ANsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768444980; x=1769049780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qcW/hY6JWQg4aPWEmrNXUmJDtQucQInwfAPavQZW27U=;
        b=P561MO/OG9TkgAyLQ19Uc1OaRFqYn0knG2TFO4TBNo/tD58gkDYX/13Lfi2atGZE0c
         zTWonSum1ug7ahXtoEe9+bfGgpLdLtlNvhPI2WVuOXFyov51NW53ezbPfApOEiPPYwOC
         8AJt8IFx9LkjlfCGDcmTgkCY1O7Z5YWOfSlZhVUrFuZHluOm88B5W9DtNoQe5L9rk/wY
         j2fr6rWW5YsNHu2hr9vi4CpxayxPbDU7OEcEpefGbtfqn3vAg6jdV4wt15DkAedLgh9A
         s7t9129Ofd2DAS+FNNQjyOUXHm5T1VhuX9vG+XZRsz7ncpmzZLinqTHSKBi1HaA6v5Lp
         PPuw==
X-Forwarded-Encrypted: i=1; AJvYcCXzlKcZtTD84N7+B9XoH0SPa9v6NrqykRU4TDDhqGzDR97F14Z+2Kn4Y+FTmi2E99BUImsEE20=@lists.linux.dev
X-Gm-Message-State: AOJu0YwhuNmpXWpP9xvPuSGaEsUd15/vuvch25JGy/8GllcXc3iZjTVi
	1kFK147B+IAIDS2V0MIEGAY2ifJk5a4IK/VVRhgMyp318rqUig1iTeidUGupdMMWdcw=
X-Gm-Gg: AY/fxX78iBR9Yh7HHWOJTwdsH08eTktdlJ/uvLihDbA11kov3pfIS3jHc3k4f7+1Pr7
	nMMob/b/TpLMkbc7NxRxxerZv1/crT+pTsxxltL0VXx6GaHtYrYfTboD6VpRC+0KWsnrFhITwi9
	PTaFktvqzYsX1cTLeUYBCdEQTNUh9kaHEyZGeQ6WdebIesnl+ui7IfY5wG9gKXhhAqoizPccqS0
	cgDMAKGdLesnzLvUXEnHa0VEc7m9FlkwyIMqOpEZSY9ZvPjcw4oCfBVEPn3wzZgHFzAZrsttguA
	2acLIl5iicBPTTrh/BXhWBHlj4oPZ4K9sYkt4lk5wXDIKi+hVizSb2lfoHPfExrwo/+Wto2c85F
	81E5eKdo/tY8lzVUAgDhdhaxcpD1ke3WBE7bAom8eYGUW+CcwYhVZ1x8mcEcWWC/3+fnzUtwCcD
	565G2IsAIKRpt9YoBtNBISFnXvCu9p8oq56Eonjy8+3wGUINMmf53EPlTV1XwQ71sWk9nEje52Q
	eQ=
X-Received: by 2002:a05:622a:1f11:b0:4ee:4a3a:bd05 with SMTP id d75a77b69052e-5014849d291mr69984841cf.74.1768444979611;
        Wed, 14 Jan 2026 18:42:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50148ee050esm26853761cf.30.2026.01.14.18.42.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 18:42:59 -0800 (PST)
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
Subject: [PATCH] dax/kmem: add build config for protected dax memory blocks
Date: Wed, 14 Jan 2026 21:42:22 -0500
Message-ID: <20260115024222.3486455-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260114235022.3437787-6-gourry@gourry.net>
References: <20260114235022.3437787-6-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Since this protection may break userspace tools, it should
be an opt-in until those tools have time to update to the
new daxN.M/hotplug interface instead of memory blocks.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/Kconfig | 18 ++++++++++++++++++
 drivers/dax/kmem.c  | 29 ++++++++++++++++++++---------
 2 files changed, 38 insertions(+), 9 deletions(-)

diff --git a/drivers/dax/Kconfig b/drivers/dax/Kconfig
index d656e4c0eb84..cc13c22eb8f8 100644
--- a/drivers/dax/Kconfig
+++ b/drivers/dax/Kconfig
@@ -78,4 +78,22 @@ config DEV_DAX_KMEM
 
 	  Say N if unsure.
 
+config DEV_DAX_KMEM_PROTECTED
+	bool "Protect DAX_KMEM memory blocks being changed"
+	depends on DEV_DAX_KMEM
+	default n
+	help
+	  Prevents actions from outside the KMEM DAX driver from changing
+	  DAX KMEM memory block states. For example, the memory block
+	  sysfs functions (online, state) will return -EBUSY, and normal
+	  calls to memory_hotplug functions from other drivers and kernel
+	  sources will fail.
+
+	  This may break existing memory block management patterns that
+	  depend on offlining DAX KMEM blocks from userland before unbinding
+	  the driver.  Use this only if your tools have been updated to use
+	  the daxN.M/hotplug interface.
+
+	  Say N if unsure.
+
 endif
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index f3562f65376c..094b8a51099e 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -184,6 +184,21 @@ static int dax_kmem_memory_notifier_cb(struct notifier_block *nb,
 	return NOTIFY_BAD;
 }
 
+static int dax_kmem_register_notifier(struct dax_kmem_data *data)
+{
+	if (!IS_ENABLED(DEV_DAX_KMEM_PROTECTED))
+		return 0;
+	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
+	return register_memory_notifier(&data->mem_nb);
+}
+
+static void dax_kmem_unregister_notifier(struct dax_kmem_data *data)
+{
+	if (!IS_ENABLED(DEV_DAX_KMEM_PROTECTED))
+		return;
+	unregister_memory_notifier(&data->mem_nb);
+}
+
 /**
  * dax_kmem_do_hotplug - hotplug memory for dax kmem device
  * @dev_dax: the dev_dax instance
@@ -563,13 +578,9 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	if (rc < 0)
 		goto err_resources;
 
-	/* Register memory notifier to block external operations */
-	data->mem_nb.notifier_call = dax_kmem_memory_notifier_cb;
-	rc = register_memory_notifier(&data->mem_nb);
-	if (rc) {
-		dev_warn(dev, "failed to register memory notifier\n");
+	rc = dax_kmem_register_notifier(data);
+	if (rc)
 		goto err_notifier;
-	}
 
 	/*
 	 * Hotplug using the system default policy - this preserves backwards
@@ -595,7 +606,7 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 	return 0;
 
 err_hotplug:
-	unregister_memory_notifier(&data->mem_nb);
+	dax_kmem_unregister_notifier(data);
 err_notifier:
 	dax_kmem_cleanup_resources(dev_dax, data);
 err_resources:
@@ -619,7 +630,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 
 	device_remove_file(dev, &dev_attr_hotplug);
 	dax_kmem_cleanup_resources(dev_dax, data);
-	unregister_memory_notifier(&data->mem_nb);
+	dax_kmem_unregister_notifier(data);
 	memory_group_unregister(data->mgid);
 	kfree(data->res_name);
 	kfree(data);
@@ -640,7 +651,7 @@ static void dev_dax_kmem_remove(struct dev_dax *dev_dax)
 	struct dax_kmem_data *data = dev_get_drvdata(dev);
 
 	device_remove_file(dev, &dev_attr_hotplug);
-	unregister_memory_notifier(&data->mem_nb);
+	dax_kmem_unregister_notifier(data);
 
 	/*
 	 * Without hotremove purposely leak the request_mem_region() for the
-- 
2.52.0

