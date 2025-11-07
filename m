Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3796339B2F
	for <nvdimm@lists.linux.dev>; Fri,  7 Nov 2025 22:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762555830; cv=none; b=m3Mk0Orkb1aJ9Ra5u+iTamBovDiL6aZ01fK4ewn1mzQNdeEAgCkqPobVZE8qjljQ1g/pP5Xl2Vo0sq3L9upffY7xGHB0FduyedXENdUzBsNqVZDg8w0JSmPI0W/AF4Bana8ryUOHOPubt0/E0Y0K2vuRO54gMT9mK6AKybLn7lg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762555830; c=relaxed/simple;
	bh=CNVKe4UoF4HjKWlrvxf/qnyhxQc08gfgs8nx9Dft3Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p36XHsMRX60unagfaL62yjWPWxX0DgLtonWkhJppy50vArWuB1FRc8SoVA8vZAsTucYqqqXjhIWIKMcUz3ZZMVCGpY//6V69xdpyQRTCu8eUaogTWmS28jaHacs0lRE7jNR+pcub0Ugll7/CsWrkPumposX0HTbOgwpFEHn/BnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=TLE+9Mil; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="TLE+9Mil"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-4ed861eb98cso14316241cf.3
        for <nvdimm@lists.linux.dev>; Fri, 07 Nov 2025 14:50:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555827; x=1763160627; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=raBRVFIoxXfgYF0FkwrcuU6SyEb+VTf3BUeepNhNHyc=;
        b=TLE+9MilJjUqSui1BmKa2gCmyvdb+DNtUklJra3vBXMpRGpT7SWk48fg2JfmAZY8MS
         3V/5AoHqX6a3HoZjw5/FZePMXSMMZswAyz80JprGS4zaw1mLxv9hcJxJKc3rclLramcW
         33Vo+Hskv6xIsocP0i86MR+uDNhB+gvcM2CIuW42ROtSAl2Iu2Eaei8A20IyulYqNm68
         FwD3r3Qv9w2oP5yhgv2+TTJo05r1GwFw5VbyeshfcON/zIGMVoDDKW/3CNYqHKCZssMR
         C3qo5jsJ1LtlN64MfMsSYW3Nb6Y8RjMQ8FVCXGXwHVizE/nvBH4at+uzHFTy73SPPXAC
         cpeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555827; x=1763160627;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=raBRVFIoxXfgYF0FkwrcuU6SyEb+VTf3BUeepNhNHyc=;
        b=SWxeYuTas86/Oqx8wch2hPQ/nyWSpP8e5cA88A+miJHc5loYIdqPkPClJNvGegTsyt
         jU4wWNm/OWPXPg3EQK/gswMo72Ckj52Hxn/TXpHBhr47zH+KM/W/7+A444IMQyOqiK+h
         rORpmzSJOtoIrPq5zkflRlj+fnuSMW8z4TCj6Z8SewfsXASzjYmhooXiY80NHJiWaXg7
         WoFBBZ8Udc3IuvAOGB4BaQnV5M+yBFF6zyg9CPNtxHkjlJjmNkmk2gnqMAD+C5MpfPku
         d/tCNESw7Ktfj9TbWjyMWLMgalPrKnbqQu/lZ/xXh9TaCMQ0GOPvWSKN9sfY/Ee5cSiP
         fJDg==
X-Forwarded-Encrypted: i=1; AJvYcCVK1JRoLSMgA4fYmSdKxRjLWsAjOK3jdLiuDN678rLL7gteO8TQR4Q4WxwvUbv91Rkd6hUhYRg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8jYsdgDTY7voB0SAQR1AP0j+vQZJyh3MkvSXUh4K0OOwKbCEb
	bL5mnL8bjaT5GbZQ/7MfPPQR1SAT21Pc8F4moFuorOsHOSC4DVxUHmAPKsqv2FVW+g4=
X-Gm-Gg: ASbGncv6Pwo4U5kQKDpvXQPev+Q8NH1OekLV0hbS4fdrigfPlJ+Z/6mdnr9NUXuXoLB
	aQ142K8C2gXjodt4xj+LeOcnt8mgQPUXV7+x6h/RCDXUe8Fb1Fxjxqj0jmlarn5XlXDzDed+2KN
	W+kcqOiZpItUExSfjl8muKMyR+QzChHO5LbETwgJ9Tp+aWhcpjSipxK9rkEf7F4/KSPpjBuglwM
	YEj8e3I4ks9ToO7KaJEaipaxPsHmmQOsSLu5PjtABXw8KGi/KNX0ziMTkvfcZS4Haoyh4H7Yv06
	dVhFNOyccevmmbkZTMBRW1n8OAgOEi5glrpU1+kJZLwwcP0gHgdOH/G++7bsga2oywYA9/psM/A
	egHh57KLBEIKGBFFF04lHRTng6lER2AXGcFuiK5phdhtCJht1MdiSF+xRTYqgmLtOkFS8rvRXsM
	+6GyCVrLs39qGOiFHaqR2dyRYxE1TKkel0ls5N/phJvMlw+r6X06dIoms7WpwuK274
X-Google-Smtp-Source: AGHT+IFm7+5mwYzM+NrPR3r2lO2/HN8TDlNByi59dSrMG4CDuhQ9TLgCeHpdJXuwA3iY2H9OGim97w==
X-Received: by 2002:ac8:5751:0:b0:4e8:a0bf:f5b5 with SMTP id d75a77b69052e-4eda4fd4dd3mr9303801cf.73.1762555827556;
        Fri, 07 Nov 2025 14:50:27 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:27 -0800 (PST)
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
Subject: [RFC PATCH 8/9] drivers/cxl: add protected_memory bit to cxl region
Date: Fri,  7 Nov 2025 17:49:53 -0500
Message-ID: <20251107224956.477056-9-gourry@gourry.net>
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

Add protected_memory bit to cxl region.  The setting is subsequently
forwarded to the dax device it creates. This allows the auto-hotplug
process to occur without an intermediate step requiring udev to poke
the DAX device protected memory bit explicitly before onlining.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 drivers/cxl/core/region.c | 30 ++++++++++++++++++++++++++++++
 drivers/cxl/cxl.h         |  2 ++
 drivers/dax/cxl.c         |  1 +
 3 files changed, 33 insertions(+)

diff --git a/drivers/cxl/core/region.c b/drivers/cxl/core/region.c
index b06fee1978ba..a0e28821961c 100644
--- a/drivers/cxl/core/region.c
+++ b/drivers/cxl/core/region.c
@@ -754,6 +754,35 @@ static ssize_t size_show(struct device *dev, struct device_attribute *attr,
 }
 static DEVICE_ATTR_RW(size);
 
+static ssize_t protected_memory_show(struct device *dev,
+				     struct device_attribute *attr, char *buf)
+{
+	struct cxl_region *cxlr = to_cxl_region(dev);
+
+	return sysfs_emit(buf, "%d\n", cxlr->protected_memory);
+}
+
+static ssize_t protected_memory_store(struct device *dev,
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
+	cxlr->protected_memory = val;
+	return len;
+}
+static DEVICE_ATTR_RW(protected_memory);
+
 static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_uuid.attr,
 	&dev_attr_commit.attr,
@@ -762,6 +791,7 @@ static struct attribute *cxl_region_attrs[] = {
 	&dev_attr_resource.attr,
 	&dev_attr_size.attr,
 	&dev_attr_mode.attr,
+	&dev_attr_protected_memory.attr,
 	NULL,
 };
 
diff --git a/drivers/cxl/cxl.h b/drivers/cxl/cxl.h
index 231ddccf8977..0ff4898224ba 100644
--- a/drivers/cxl/cxl.h
+++ b/drivers/cxl/cxl.h
@@ -530,6 +530,7 @@ enum cxl_partition_mode {
  * @coord: QoS access coordinates for the region
  * @node_notifier: notifier for setting the access coordinates to node
  * @adist_notifier: notifier for calculating the abstract distance of node
+ * @protected_memory: mark region memory as protected from kernel allocation
  */
 struct cxl_region {
 	struct device dev;
@@ -543,6 +544,7 @@ struct cxl_region {
 	struct access_coordinate coord[ACCESS_COORDINATE_MAX];
 	struct notifier_block node_notifier;
 	struct notifier_block adist_notifier;
+	bool protected_memory;
 };
 
 struct cxl_nvdimm_bridge {
diff --git a/drivers/dax/cxl.c b/drivers/dax/cxl.c
index 13cd94d32ff7..a4232a5507b5 100644
--- a/drivers/dax/cxl.c
+++ b/drivers/dax/cxl.c
@@ -27,6 +27,7 @@ static int cxl_dax_region_probe(struct device *dev)
 		.id = -1,
 		.size = range_len(&cxlr_dax->hpa_range),
 		.memmap_on_memory = true,
+		.protected_memory = cxlr->protected_memory,
 	};
 
 	return PTR_ERR_OR_ZERO(devm_create_dev_dax(&data));
-- 
2.51.1

