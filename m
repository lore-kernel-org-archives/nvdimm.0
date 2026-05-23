Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD74386C2C
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:43:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529426; cv=none; b=YElfdHFnJF0dKH9GSNWWTG6E1H+4QaUXPoU55lbPH7B5tgVOKvyS31Nubwa5fyCmLsFatC0gsQTNTaIPbTu0f7AOuFVt9NgQ21H/AozPgvvnmy0ecTKg0PSLDlFyphAYPZJnyBxVpCHgJ1qqeLs356tFyKX1XprHpA0hslkPZtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529426; c=relaxed/simple;
	bh=mimTWYFTaHY+FLSmEscwRLS2qecNH3JETIBfD4afc9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+n1thxybUoj6K7tM6+WB/ubs727ag89Rw8ostEKq4HyHMPnLQShM6hrLh2meg7J7X0Q84zRURUq603MwRr8Cg/zkjVpDTr+qve3nzSVmgJRYOBoP/GWDtWH+hsmA2DYJ+9QUjING+XZZiIQnv1du6YBo1OO19Y+YLwIW47IzG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NpHF65nR; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NpHF65nR"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-3042a388168so1871294eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:43:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529424; x=1780134224; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=snhhVzpNXLnSXNel0j3XIF8QPv37i0IqA2Elwz6NcMg=;
        b=NpHF65nRHbo4iSJQ25D7FeHNOdsPKf1Y7ac9hmnrznHHEISFMatCuudIFexAxinXuT
         7FeOzK+MwIEFzrh7BvGUcGPtVs6Oi5sX0z8Daw6nqbmFyuoBqHy3m61mWRxtxV391JvL
         ilXb97jiYFY9xMU7jS3lr1CS4GWhWUUKL/npk/OyMVXXr/B706pFPwKk8D+AP+XF5Aaf
         hcSgDSWNE2E6Iz1r6DGrVw/v0Jzplz694zMi1/xb3IHHxm3yTYm9mN+2lJqENNeEbkU9
         4onBXZtQ5Lc+CAadfJgWunWz0SiAwjAi85Hvd+0PTTvbA51JG6SwwH46b5KeieT0UlvE
         jygQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529424; x=1780134224;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=snhhVzpNXLnSXNel0j3XIF8QPv37i0IqA2Elwz6NcMg=;
        b=mbQ8WnE0KrY/WJDyOfL5YLgFdE0OvvC9WR0H1klLF00XURXMGX5MykSV3Y557IDCg+
         iQRygC9iY5j7ZSSe1BaE+J9hRw3VEC0AV4R7DNLf7ZeNHxC4v814dnsVm5Dy2w6zdW7M
         C+ExZceMIAw1dJTwrDaJnuXoTJQsilLkLrq6we/d2sFp0kgQPwvpZ19hJT6yzN0Nn3Tj
         iI8zGEzwRPhFCw21GnNqNNU4702W/j/gpjcSmZICXh1MdiGCynpI94I4K3zWoZC5w7lM
         WvwjW+Uih8jzlOMrCAd2BhwDcEYSHUf8K+IvQTzJUNjjwvLc94wTcWJ0fC9IZ16T7a1+
         NANg==
X-Gm-Message-State: AOJu0YywpnOESxWkyvGGhcaKo1hG8SEkQw8IfBubUmfMG+OFANIvFh/Y
	syqrloYFSIcxhHDCwLPaUZjcVGjPEtMCnBh0aonBbFydY2cb8IthfmXS
X-Gm-Gg: Acq92OFVzmmdoiNoB53GjhiAXoQBBGQlfkTahyS1j1E3gW+t3pvPt2IbPH7jMlLDphB
	kx0lYh6ZtEm9eJw4lo/hI9ZAZNgECqIGfS4SE4J+gVIHYJOHi0IfFKpmaWV3aRIIgyX+yNqrIzD
	Rob1lMMnSe2lUY1VngwfSQUg/x/m2woZiqzA9h95tI3pUP0NgW3s8snqZRpVKz95lOoBz88WxQe
	R4PhHQ1gbCCJ+1SBUxjTKNkelCesd1casXQXB4BgKAbnloaugDkZwJZAds6Rb9IXHb/j/PHfWeJ
	PNe1AkpSZIWEr5p9DWBc5n1ogN4wGEWVNsU/WeEbe1SV+PMtVHkOEuQS7zY++f6PNsi3M8epYFA
	NVrb/pVZU5tV4ZLBev5YlO5Q1QoJ1f9UBoROdAKqLucRr1nFvXSr3mk2W99m4XuQQqCYozP6uIG
	rRjd9ldjlEOG8pVeW8JS0ASXW8neJWKGHOQxPe1H3xSpEAkx1NxvmEbtuiXGOWYRmUQsjK7RNVJ
	I7m7zI=
X-Received: by 2002:a05:7022:609c:b0:11a:fb0a:ceca with SMTP id a92af1059eb24-13633eb60b4mr3619709c88.16.1779529424123;
        Sat, 23 May 2026 02:43:44 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1366a40305csm2376358c88.7.2026.05.23.02.43.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:43:43 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v10 04/31] cxl/core: Enforce partition order/simplify partition calls
Date: Sat, 23 May 2026 02:42:58 -0700
Message-ID: <22ae445b8a99d26299520e2429c5bf4e64b0d9e6.1779528761.git.anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1779528761.git.anisa.su@samsung.com>
References: <cover.1779528761.git.anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Device partitions have an implied order which is made more complex by
the addition of a dynamic partition.

Remove the ram special case information calls in favor of generic calls
with a check ahead of time to ensure the preservation of the implied
partition order.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>

---
Changes::
[anisa: rebase]
[davidlohr: core/hdm.c: return -EINVAL instead of 0 in cxl_dpa_setup
if partitions are out of order]
---
 drivers/cxl/core/hdm.c    | 11 ++++++++++-
 drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
 drivers/cxl/cxlmem.h      |  9 +++------
 drivers/cxl/mem.c         |  2 +-
 4 files changed, 23 insertions(+), 31 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 28974adaab75..7a5812971f8f 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -464,6 +464,7 @@ static const char *cxl_mode_name(enum cxl_partition_mode mode)
 int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 {
 	struct device *dev = cxlds->dev;
+	int i;
 
 	guard(rwsem_write)(&cxl_rwsem.dpa);
 
@@ -476,9 +477,17 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 		return 0;
 	}
 
+	/* Verify partitions are in expected order. */
+	for (i = 1; i < info->nr_partitions; i++) {
+		if (cxlds->part[i].mode < cxlds->part[i-1].mode) {
+			dev_err(dev, "Partition order mismatch\n");
+			return -EINVAL;
+		}
+	}
+
 	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
 
-	for (int i = 0; i < info->nr_partitions; i++) {
+	for (i = 0; i < info->nr_partitions; i++) {
 		const struct cxl_dpa_part_info *part = &info->part[i];
 		int rc;
 
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 80e65690eb77..71602820f896 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -75,20 +75,12 @@ static ssize_t label_storage_size_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(label_storage_size);
 
-static resource_size_t cxl_ram_size(struct cxl_dev_state *cxlds)
-{
-	/* Static RAM is only expected at partition 0. */
-	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
-		return 0;
-	return resource_size(&cxlds->part[0].res);
-}
-
 static ssize_t ram_size_show(struct device *dev, struct device_attribute *attr,
 			     char *buf)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	unsigned long long len = cxl_ram_size(cxlds);
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_RAM);
 
 	return sysfs_emit(buf, "%#llx\n", len);
 }
@@ -101,7 +93,7 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	unsigned long long len = cxl_pmem_size(cxlds);
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_PMEM);
 
 	return sysfs_emit(buf, "%#llx\n", len);
 }
@@ -424,10 +416,11 @@ static struct attribute *cxl_memdev_attributes[] = {
 	NULL,
 };
 
-static struct cxl_dpa_perf *to_pmem_perf(struct cxl_dev_state *cxlds)
+static struct cxl_dpa_perf *part_perf(struct cxl_dev_state *cxlds,
+				      enum cxl_partition_mode mode)
 {
 	for (int i = 0; i < cxlds->nr_partitions; i++)
-		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
+		if (cxlds->part[i].mode == mode)
 			return &cxlds->part[i].perf;
 	return NULL;
 }
@@ -438,7 +431,7 @@ static ssize_t pmem_qos_class_show(struct device *dev,
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 
-	return sysfs_emit(buf, "%d\n", to_pmem_perf(cxlds)->qos_class);
+	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_PMEM)->qos_class);
 }
 
 static struct device_attribute dev_attr_pmem_qos_class =
@@ -450,20 +443,13 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
 	NULL,
 };
 
-static struct cxl_dpa_perf *to_ram_perf(struct cxl_dev_state *cxlds)
-{
-	if (cxlds->part[0].mode != CXL_PARTMODE_RAM)
-		return NULL;
-	return &cxlds->part[0].perf;
-}
-
 static ssize_t ram_qos_class_show(struct device *dev,
 				  struct device_attribute *attr, char *buf)
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 
-	return sysfs_emit(buf, "%d\n", to_ram_perf(cxlds)->qos_class);
+	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_RAM)->qos_class);
 }
 
 static struct device_attribute dev_attr_ram_qos_class =
@@ -499,7 +485,7 @@ static umode_t cxl_ram_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dpa_perf *perf = to_ram_perf(cxlmd->cxlds);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_RAM);
 
 	if (a == &dev_attr_ram_qos_class.attr &&
 	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
@@ -518,7 +504,7 @@ static umode_t cxl_pmem_visible(struct kobject *kobj, struct attribute *a, int n
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dpa_perf *perf = to_pmem_perf(cxlmd->cxlds);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_PMEM);
 
 	if (a == &dev_attr_pmem_qos_class.attr &&
 	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index cee936fb3d03..10175ca3b7ee 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -383,14 +383,11 @@ struct cxl_security_state {
 
 #define CXL_MAX_DC_PARTITIONS 8
 
-static inline resource_size_t cxl_pmem_size(struct cxl_dev_state *cxlds)
+static inline resource_size_t cxl_part_size(struct cxl_dev_state *cxlds,
+					    enum cxl_partition_mode mode)
 {
-	/*
-	 * Static PMEM may be at partition index 0 when there is no static RAM
-	 * capacity.
-	 */
 	for (int i = 0; i < cxlds->nr_partitions; i++)
-		if (cxlds->part[i].mode == CXL_PARTMODE_PMEM)
+		if (cxlds->part[i].mode == mode)
 			return resource_size(&cxlds->part[i].res);
 	return 0;
 }
diff --git a/drivers/cxl/mem.c b/drivers/cxl/mem.c
index fcffe24dcb42..f19e08279ec7 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -114,7 +114,7 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+	if (cxl_part_size(cxlds, CXL_PARTMODE_PMEM) && IS_ENABLED(CONFIG_CXL_PMEM)) {
 		rc = devm_cxl_add_nvdimm(dev, parent_port, cxlmd);
 		if (rc) {
 			if (rc == -ENODEV)
-- 
2.43.0

