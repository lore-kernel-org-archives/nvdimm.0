Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59862352FA5
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975819; cv=none; b=RHZvgLpxsyoIqSrhBW5n7/hKik64zgwalQ1aZ6TTd3mVWzP5WXsM5J9oE6iizMv5i+qlNMWhuFbqDAtJ1Yia7sQVrCkQ5wa9HbC2veQtoRl8EqS63QjvDQ0IHLaY/sdcrYteTZhZAHBkevGY+PGlPkxtyB2uGBnIXwZO2DeYd4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975819; c=relaxed/simple;
	bh=KDT4LvBi3S/XOOUfgA+q7nj0PsLuynWQ2oewm937Vbs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WQ7/LUAPrNCjXY+K+3DjPybobYT5+IZWxsMx+ehjkzTBty6DLS2pvmdydB23qwb/81ASivVw/lpkeB/lGGX0fFQT149fjyFohEK/c4rib7dmR6wcyndIRc3fK3eKv8Bx2dJrdjQ1Wo6N169bF0Xpl664L6U1eoKE5hlkGt+GcA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=R5SoCvsf; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="R5SoCvsf"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-8b28f983333so4587285a.3
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975816; x=1763580616; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8LOzdRF3F1ID8i/f4610zpV6s32IDb3v5xseVevQWo=;
        b=R5SoCvsf9t6JaucIY/HdEVWpz7DI3eFBOzFJf3/SZz0CagDT9RV00yu+CZd7NMpTA3
         BF/MPZP32Q4cQG0As1i1GRpwWYafdHCVH87PX7wtxIU3J2KxDvD/weCBbIdhLsgDNbKr
         JedLw80+OhGruh7n4Uy5Qa2s50/+bVSFjiohy8FFw6wHyd5Xro5H+S6M1BYTRYwOL1NU
         dIfwN3/LQgslgOJF/Wp7I5oRB7xxr0nvI10lQ2HQ6gIvAlZzqB6U9eYi9dmW2pYpN23j
         wpgZf9tKZJ0q0VwwnCeKP3gNybjFEQuwPGC5P+Ut0MMxOQ/W0V4lr2penEGvZa2p9yHv
         S2tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975816; x=1763580616;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x8LOzdRF3F1ID8i/f4610zpV6s32IDb3v5xseVevQWo=;
        b=FJYa7pV3ilTIKDherYEB8HTKiuQrUhR8Li8YRw6g+WuWwGDhF1Ycj2ytWeXYjERkAb
         UEDm1x6BqLZdKtLKbyMgraxRX3D9R4EYdPdqiE/zZEs0KXNeJBmMcfsIRllE1YCAyGaH
         cZj897k2as3AGoEbDlds5/bqIW0MgrPKx87gh0RbMUz633w5YBZv7kOa1yaZAnBwaoW7
         UiRKIL8RbN4qGZ6HQOjRapxdXv7h1AmMKcsBfMoqijzl0FKHcpzitAX07hf3EMV4gD33
         Tyq4ShfRQ/RxjNMjMk4kvUmGonNTcWdcY1DL2wpx3O/sv4tA/ku7akt7j62jFzIQ1MGU
         m1FQ==
X-Forwarded-Encrypted: i=1; AJvYcCXH2MGeTWCn0tvVGMBU1cyKHnLEgm9nkGg5mKsFEkEl3jvJauXRCZD+OtKtW4mxAFs8mG7RGAY=@lists.linux.dev
X-Gm-Message-State: AOJu0YxhJFNUFqQ8R+Ca9Cy1spbPcudb8avhoGlxr/HCwFd+PrqDOtrh
	id5YRNZ2rUOgjE/LbqtmCj6YwxiBs0HutyV9n9AtLlu4IMVGi1RPkoa5dtfz7SSrPPg=
X-Gm-Gg: ASbGncuk1XizraNK6sg5QvoAtpTdoW+3VIbIs2ERAxpQnR9uUeVlb6HwfSehq0i4xzp
	qTP/E+HYGzxNB8V3gSzQo6A15kUKMeSa8YnWXCaCiVrM94rAjKdFC1RNCj5sVIVMXRElfH6yAJB
	Ki62BRHr/f9VNJ/vBUmFDXWjjhZRlB989APSmcgOP0zJLVkL04JLeaGJIz0RjNvVS71ofEfh+LF
	s8HYqehLcbCB2kaP9FMd2mjAH5tbNcKL+CvtAvYv2nXZthVp5M8xkU8Zsoz3+ctrl9JZcJbMXPM
	eGl4mN0/BcZf1yeF5KKk8nOurisUilAXg7mzmyQGLnFCNWzmNQsbR1DYibp1f//dh00FZLeq9/6
	LUyH/drGq/dW83QmYlQnyJE+yAt/aFLNCb5uYFP0OjPYr3XboX5X9+m+Ngad7U+68OHKMejGh9t
	pNQUUw6Y9JO9Xh47klxP4EmlN2WXZZpcNdF/bvtvHjG9AHLGYMIsluOxkP0wE0uj54
X-Google-Smtp-Source: AGHT+IHll+IKPvcEc2EdGPBw2QQZcQZ6T6jlawQUNb6L1NrYv5cDZU0Tf0FeuJID2gzeZN1UxCbY+g==
X-Received: by 2002:a05:620a:2a0f:b0:84e:2544:6be7 with SMTP id af79cd13be357-8b29b815e49mr640273285a.65.1762975816129;
        Wed, 12 Nov 2025 11:30:16 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:15 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH v2 09/11] drivers/dax: add spm_node bit to dev_dax
Date: Wed, 12 Nov 2025 14:29:25 -0500
Message-ID: <20251112192936.2574429-10-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This bit is used by dax/kmem to determine whether to set the
MHP_SPM_NODE flags, which determines whether the hotplug memory
is SysRAM or Specific Purpose Memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/dax/bus.c         | 39 +++++++++++++++++++++++++++++++++++++++
 drivers/dax/bus.h         |  1 +
 drivers/dax/dax-private.h |  1 +
 drivers/dax/kmem.c        |  2 ++
 4 files changed, 43 insertions(+)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index fde29e0ad68b..b0de43854112 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -1361,6 +1361,43 @@ static ssize_t memmap_on_memory_store(struct device *dev,
 }
 static DEVICE_ATTR_RW(memmap_on_memory);
 
+static ssize_t spm_node_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct dev_dax *dev_dax = to_dev_dax(dev);
+
+	return sysfs_emit(buf, "%d\n", dev_dax->spm_node);
+}
+
+static ssize_t spm_node_store(struct device *dev,
+			      struct device_attribute *attr,
+			      const char *buf, size_t len)
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
+	if (dev_dax->spm_node != val && dev->driver &&
+	    to_dax_drv(dev->driver)->type == DAXDRV_KMEM_TYPE) {
+		up_write(&dax_dev_rwsem);
+		return -EBUSY;
+	}
+
+	dev_dax->spm_node = val;
+	up_write(&dax_dev_rwsem);
+
+	return len;
+}
+static DEVICE_ATTR_RW(spm_node);
+
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1388,6 +1425,7 @@ static struct attribute *dev_dax_attributes[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_numa_node.attr,
 	&dev_attr_memmap_on_memory.attr,
+	&dev_attr_spm_node.attr,
 	NULL,
 };
 
@@ -1494,6 +1532,7 @@ static struct dev_dax *__devm_create_dev_dax(struct dev_dax_data *data)
 	ida_init(&dev_dax->ida);
 
 	dev_dax->memmap_on_memory = data->memmap_on_memory;
+	dev_dax->spm_node = data->spm_node;
 
 	inode = dax_inode(dax_dev);
 	dev->devt = inode->i_rdev;
diff --git a/drivers/dax/bus.h b/drivers/dax/bus.h
index cbbf64443098..51ed961b6a3c 100644
--- a/drivers/dax/bus.h
+++ b/drivers/dax/bus.h
@@ -24,6 +24,7 @@ struct dev_dax_data {
 	resource_size_t size;
 	int id;
 	bool memmap_on_memory;
+	bool spm_node;
 };
 
 struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data);
diff --git a/drivers/dax/dax-private.h b/drivers/dax/dax-private.h
index 0867115aeef2..3d1b1f996383 100644
--- a/drivers/dax/dax-private.h
+++ b/drivers/dax/dax-private.h
@@ -89,6 +89,7 @@ struct dev_dax {
 	struct device dev;
 	struct dev_pagemap *pgmap;
 	bool memmap_on_memory;
+	bool spm_node;
 	int nr_range;
 	struct dev_dax_range *ranges;
 };
diff --git a/drivers/dax/kmem.c b/drivers/dax/kmem.c
index c036e4d0b610..3c3dd1cd052c 100644
--- a/drivers/dax/kmem.c
+++ b/drivers/dax/kmem.c
@@ -169,6 +169,8 @@ static int dev_dax_kmem_probe(struct dev_dax *dev_dax)
 		mhp_flags = MHP_NID_IS_MGID;
 		if (dev_dax->memmap_on_memory)
 			mhp_flags |= MHP_MEMMAP_ON_MEMORY;
+		if (dev_dax->spm_node)
+			mhp_flags |= MHP_SPM_NODE;
 
 		/*
 		 * Ensure that future kexec'd kernels will not treat
-- 
2.51.1

