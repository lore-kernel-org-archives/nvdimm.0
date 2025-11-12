Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A7E934FF63
	for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 19:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762975823; cv=none; b=GY6VyKe6ARNj5HUh3QQLOalA1jUOAFCBAm1Jm2e5IUFEpppHebejiqrY5VdQNBd/F/BBtZ7t6y47v1RKUFH2vue5ZKhf4ii/wvGtNKNaY2pFSvods0e9lXSlB+KJDGN3yTJl3K62oUwYeEt57NCvKGoLkZ5mBxCrkfbpCsln1Zk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762975823; c=relaxed/simple;
	bh=xWEyjgvu6RU6fuiMig9vWVi/ppozqErZlNQJst8wywk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qkmCAiXxWhTTQSG8aXwkcqohVhQXoSLC2hfwAU+d5bkFHmzIwdsWkaBZeXcr1KmhkcogtYxRIRO2xJCqU0kiP4Hn5pWzVhe9Wpgb5QxPcimTiRHhHGJxseEhIa6wmZlIjec/Of4diEompOkHv0VyiSBGcnNuSpvqKcBROGwn6kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TGQYMByR; arc=none smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TGQYMByR"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-8b29b6f3178so5339885a.0
        for <nvdimm@lists.linux.dev>; Wed, 12 Nov 2025 11:30:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975819; x=1763580619; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UkWGDFkxsYcV2vUuZc9I0ZRX3P3sH+nyS9DR2ZbJTF8=;
        b=TGQYMByRDaIAmbWhGp0XKEquN6Ssb5bJpeZAQkBdtG7uxgur0RsqvaVtXOwrmsDTuH
         MOkoVZ58ymetCNifrUmD1E0kF+gccHUeBLtNnjy6tQa30hDkBY+jfI5DQF/ElR2fOdbZ
         L1qNh4GsIqNd/893kMdZeYeqJtATLHFl8gMPRNsUYErx5Tlzna84XHSfhUft0J0yXm8e
         ITAP3OJ1s3l7mvC/2euU2e3x0Woz40/OTKGoY+Lq2I6RilTGWKQ98RK4jPc1vuXJLGhP
         eTeZ5iL2R2XxXtLgzJkld8CaskPiCnVlbProlEl6f/YCH1Zed1GI/CbveXpbowH+RBya
         oy1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975819; x=1763580619;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UkWGDFkxsYcV2vUuZc9I0ZRX3P3sH+nyS9DR2ZbJTF8=;
        b=ZZMT/H/qiZ7FzW29TbtWE1Azf3JMIZaZBT7wD0hB3YmZPuZUBrF8sZrDal9ClWYsl1
         CR+AxAxdOY83ODZzJe/PhlLncy4hYkfiCuuIYFO77Wfc9+Qam6NB7UteOAAe+ajeFnLW
         gbeuZOqFVHCXOy+uVwsg+6lPQAhKbk+gdIrUESuMbOdt2QPQAjn+QY+Xa0Zeno1hzW+M
         4EbGmAj6Z1MwQx9Llz5QkScBmtocFT0IiY8Jza/L72RmX+TL/MXTzjKk6POADzrYGX1T
         h4Ro+5qcc0/rd3aJCwhmGrtMtqOwmpa9LlEeCME7cCD6awM75l2Uav7Q8+B3ZDliF6oS
         Hb9A==
X-Forwarded-Encrypted: i=1; AJvYcCXL5uRH6hdy3n7pO5KNoqf/mQ5wgeV081LLEqUi8Znj3I3LSmCxpCBAoqa/Bx6KzL897Y3yUqg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyxhe4hmpbcO3H3ZmrVGwR44JKDyho7n3KVTRAcv7Fq9Lf7x0ql
	ApdTcqOxh4TWgirt9LEaaS9qVSa6fr0va8+zw6x/j7cHPYOhRIt1bLWz0szgbItcYdA=
X-Gm-Gg: ASbGncuK8gvzJItMvIj4IZy96TQU+3bUlVeHgA2HV8zN+Iocvz4wufezsEE4hQJPyhV
	d6OeqMn+aLoe2ls304e5eKflseCiynQFXlTtFaPc2mzVaZbvakh5u5t8cHM9DoXokNl3XypOKmR
	YTUhFy9eUCZTAkLyyp8VrVk99poU33nrcN1+x4gtKhp3q2ocop+SqV5hkIghINnmVBCH9nDgdgI
	hE8IsQ/lI4Hzuc53iHBjrtJJ98730BgxgAXIibbzKaGKe5E8PS8awJM0AD2337Cljvm6m3lqq/z
	DMsD2F5W82OziOHA5DHRRiibG9laNaB9S0F7I7JSAMVLgudk42sya0H1dJPLj31hEcDHBBRghfB
	sJ3Sh+KqE2rAwdit/eB/aVru2aEHR9YY06QtkyngiaZGyU66U7U/W/Yoeu8uj1kuvLPdwPSUHM4
	T0RVvSXLnxkzMMzqLp5mh4+83lixbeqQxYT/jCC5Zn7HkAPlLK0/N6PPVNPcGQzgHj
X-Google-Smtp-Source: AGHT+IHnA96vKIbRbEVDdRL2YlwlXqxXxNpoq+1tyGBGVESiKZZsfFfpRROUBFK0hifrTyISq2ufZA==
X-Received: by 2002:a05:620a:f01:b0:89d:b480:309f with SMTP id af79cd13be357-8b2ac08bd6amr88119885a.7.1762975819003;
        Wed, 12 Nov 2025 11:30:19 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:18 -0800 (PST)
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
Subject: [RFC PATCH v2 10/11] drivers/cxl: add spm_node bit to cxl region
Date: Wed, 12 Nov 2025 14:29:26 -0500
Message-ID: <20251112192936.2574429-11-gourry@gourry.net>
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

Add spm_node bit to cxl region, forward it to the dax device.

This allows auto-hotplug to occur without an intermediate udev
step to poke the DAX device spm_node bit.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  2 ++
 drivers/dax/cxl.c         |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b06fee1978ba..3348b09dfe9a 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -754,6 +754,35 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(size);
 
+static ssize_t spm_node_show(struct device *dev,
+			     struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->spm_node);
+}
+
+static ssize_t spm_node_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t len)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+	bool val;
+	int rc;
+
+	rc = kstrtobool(buf, &val);
+	if (rc)
+		return rc;
+
+	ACQUIRE(rwsem_write_kill, rwsem)(&cxl_rwsem.region);
+	if ((rc = ACQUIRE_ERR(rwsem_read_intr, &rwsem)))
+		return rc;
+
+	cxlr->spm_node = val;
+	return len;
+}
+static DEVICE_ATTR_RW(spm_node);
+
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
 	&dev_attr_commit.attr,
@@ -762,6 +791,7 @@ static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
 	&dev_attr_mode.attr,
+	&dev_attr_spm_node.attr,
 	NULL,
 };
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 231ddccf8977..ba7cde06dfd3 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -530,6 +530,7 @@ enum cxl_partition_mode {
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
+ * @spm_node: memory can only be added to specific purpose NUMA nodes
  */
 struct cxl_region {
 	struct device dev;
@@ -543,6 +544,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	bool spm_node;
 };
 
 struct cxl_nvdimm_bridge {
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..968d23fc19ed 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.spm_node = cxlr->spm_node,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
-- 
2.51.1

