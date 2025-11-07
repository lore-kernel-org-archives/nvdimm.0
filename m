Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0127331A73
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 22:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762555828; cv=none; b=rTYCUfxdRcCqJSLNbPktoe2C63l+uBFpT2hZEbU57xJlTNmxgKUrt7UvcGjZ4n61hLf3DnuYpbHes3uu1vjrpwDFSitvzOvIvQFAc/fbh24DQgp6AT0Fj/9bnQZW/Z+OJ0P4RY6BjgjDzBus5Sm0SlxRq4YaJAqEMUX81Ppxp94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762555828; c=relaxed/simple;
	bh=tSh2k/90dL3dI0zpcxARGhUF4rlq7O4vW4BNP7CcNwc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c3KtObxZbnKg2vVfCTNXBafjXeLIXx6bE3ELT+r2y/FxC5tAb+lhe41o+UrHvA1RAm5Syzfd+HpXWM71oPlLZSaK7g6MXxNipOh9HjlS7K/68hFMWyem9RZJtpWvBbuPUX9syXxVtIrAOarFMIRN1Td2Rh2d1Mfg7rHOQ7BUfHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=HdKvWxcS; arc=none smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="HdKvWxcS"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4ed7024c8c5so9957991cf.3
        for <nvdimm@lists.linux.dev>; Fri, 07 Nov 2025 14:50:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555824; x=1763160624; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CwxO6b4UaIu9W6F2d/g8AaHHPWCBsuMNbHYfAmKzKTo=;
        b=HdKvWxcSgkVQ+85Ed+3EK/nz/o4nANOpWXscTQjg5klkPjHvtapo+GywGlp02BzZkq
         mgzUH4ONVUAfYnbP+uOibE97ru6E5+n6iMLOWTAI39obUIFeSNVOG+5htXkxp6sq9WDV
         1e0vRyvIZB+MWdA0gXu8tlT68YUTtjoIqRpFfJ/XpCGdR89kjmbJrJmQo1V42UR3EqSA
         tIfpZM7qut0N5UdAsOmDlg5px0XrGrH4RKMNWpGVF63eczCBFQlb3WxZsrQjOoddsRdh
         uVmvB3RzP9oOiFPRc4ADjp7LSq8wJv7idtc8J7iEkJTwGPqVEq4ggRtw+c6vVA3ReqqF
         b6KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555825; x=1763160625;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=CwxO6b4UaIu9W6F2d/g8AaHHPWCBsuMNbHYfAmKzKTo=;
        b=uZgeUlLqAtKZAZiNo5/dbkMYg2qVlbe5RKMbaaCUHxe7EiQlPNc6irXUG+QMAkLjXL
         WTQ/JXan70gKrE1GTwpZNX60cGx5GlaOPzZWsv7/ohZkXwdjSQXiAN6d5Xn3LqbbMQkk
         GMzq5twkEW5XTma9MnQOMuqlLYj9K7XoLWSPtJtTWRgivyCjWj48DWlqGc0o29LfgJXv
         uITAkvEzRqVeltWzTov6CwZDKKxOMvBKMDuR3Iz4+tRJYx4MW+J4jlMGBQxGhdJN/dhR
         Ym7ILubGmzdJpeTiUOFxq/phgKe6Dn/ep1P0+wS279WAlzhVMhHYWKsc9K5eB570TQMQ
         3Tkg==
X-Forwarded-Encrypted: i=1; AJvYcCXibS6OKX592EK50GprwVQfnJYAM7LSsE8F6G07h2nh/at7Asni0Oo3NAi1QM7ztxKZi2Dj70E=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx5Lpx0/OB0VmrMbDZybOqzQWIe3Cg4Xd6LONgMiJqsFOGoTarz
	zGzcrIUinR1thrGDQLKTOPDXImb6EFCP9oIH45ykUfbquVp1tNl/wN2IhQacRhsnDuo=
X-Gm-Gg: ASbGncvnK/zz4UpzRKriEhk9fl4z5k6f18ej/kBhWiW/gqPsmLrzvJ0yYNK3OCEUiZT
	0aTcqD8hnav+mpstkL7q9CBJCy5qQguGfzBvz9gh5v0UNjo/o710493d7xq30xqNrfOktq1c84h
	H8EVuBrQCWwifGbGYJ4R5CXhlMHrinzsDkpKYLsT5tiNahODoRqq/b++cw6AYfK8bx44W2lUTBQ
	c6rxrztPpTCWo4rX+wWrdluZMuSVdluqdH+k8Tc08mQVlVO5zUClwCJaLVNsXCBZzoFAiXFXtmJ
	lKMIdXEhlWqCTjTZrOyNUfA56bKI9+PTRt4xAtW1ZPmhx6Sj0r61VjiwSXpv6y3cukfa4kxzJDS
	MFYR43M5NWuyAmgzXb82gJphWLVULNJX+iJj4cfTk5zRAH5iVXjkMhmzuMpQ7y4+noGwnBsFFCJ
	E0jdSKZCjrYUZfIRrAGkef2270KR0uKe7TJFz0kZmyoN1mzZHKLIvfH/i/PJygJlrRbDKFUfkIt
	eg=
X-Google-Smtp-Source: AGHT+IGGUkY/hMvQZUDcDXSyhiDaml+qPtZeSmCY7fYoXMiela3sPEpJdPQ5lN6VWEde9PlUke632Q==
X-Received: by 2002:a05:622a:1ba9:b0:4ed:43fe:f51e with SMTP id d75a77b69052e-4eda4f8ffb3mr10117651cf.39.1762555824542;
        Fri, 07 Nov 2025 14:50:24 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:24 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH 7/9] drivers/dax: add protected memory bit to dev_dax
Date: Fri,  7 Nov 2025 17:49:52 -0500
Message-ID: <20251107224956.477056-8-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bit is used by dax/kmem to determine whether to set the
MHP_PROTECTED_MEMORY flags, which will make whether hotplug memory
should be restricted to a protected memory NUMA node.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/dax/bus.h         |  1 +
 drivers/dax/dax-private.h |  1 +
 drivers/dax/kmem.c        |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..4321e80276f0 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1361,6 +1361,43 @@ static ssize_t memmap_on_memory_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(memmap_on_memory);
 
+static ssize_t protected_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sysfs_emit(buf, "%d\n", dev_dax->protected_memory);
+}
+
+static ssize_t protected_memory_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	rc = down_write_killable(&dax_dev_rwsem);
+	if (rc)
+		return rc;
+
+	if (dev_dax->protected_memory != val && dev->driver &&
+	    to_dax_drv(dev->driver)->type == DAXDRV_KMEM_TYPE) {
+		up_write(&dax_dev_rwsem);
+		return -EBUSY;
+	}
+
+	dev_dax->protected_memory = val;
+	up_write(&dax_dev_rwsem);
+
+	return len;
+}
+static DEVICE_ATTR_RW(protected_memory);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1388,6 +1425,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
 	&dev_attr_memmap_on_memory.attr,
+	&dev_attr_protected_memory.attr,
 	NULL,
 };
 
@@ -1494,6 +1532,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->protected_memory = data->protected_memory;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..0a885bf9839f 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -24,6 +24,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	bool protected_memory;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..605b7ed87ffe 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -89,6 +89,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	bool protected_memory;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..140c6cb0ac88 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -169,6 +169,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		mhp_flags = MHP_NID_IS_MGID;
 		if (dev_dax->memmap_on_memory)
 			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+		if (dev_dax->protected_memory)
+			mhp_flags |= MHP_PROTECTED_MEMORY;
 
 		/*
 		 * Ensure that future kexec'd kernels will not treat
-- 
2.51.1

