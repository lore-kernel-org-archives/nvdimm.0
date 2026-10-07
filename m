Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58B513D5668
	for <nvdimm@lists.linux.dev>; Wed,  7 Oct 2026 20:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791404330; cv=none; b=jT5kmqAqNoGNBPDo2uaXcnS8GPKz/VYFLuwSn+9s/O3ytSKlTC/ZRUM4SkqVej1R0VAM/sfTNBL7Ez0fII4QhcB0iHKwrztSkL428oN5IT89c1uiqvg047Mgqx/iAu1PjV0zte14GeoBqFIXAIdLCAHhDEJ5tkQaxtsmD07209k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791404330; c=relaxed/simple;
	bh=tUnyqoKW84WWajsXv0YnjvUk4nwe7giALsLLi9aiwQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAmt/nngMBmRyN/MqIKO18a3CP4op4V8a9rHn3I02iMo/809H7sJQjR2H1ans4yurArXo8kL49B1MTxAEHKbPpeVK6d6vfaXWf0wemACZgeGh3FMLTS4/ska0Duh8xqsFhpGhQ1FGriEZ81YMMygkFXkOARvrfb/J5qxrnBArYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JENFjUA0; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JENFjUA0"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-3964dfb5a69so1474837a91.1
        for <nvdimm@lists.linux.dev>; Wed, 07 Oct 2026 13:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791404327; x=1792009127; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NZrB+ZK9QzheM+fAXTkH4OM5BDNaPKAQVWUlPIMQy+w=;
        b=JENFjUA01HCpbSP2EVMtiQbZyLT1Pos9NLCUCCeySqSEP+ghAnYIm/Fq9VS3Ef7RUY
         L8xoqTLuNVX6DayhZFGH3Rjk5YN/TdUe/jaIxU/Trq6d9xdRiWOOsv2ev1M80LIWZmng
         4MdHOM8LgcDJqXzi4PWwQWI+6OoFNmPy/0s6CSaNoN3GfcIvNkGZA1JVFVVIDowbU4uj
         fIAkb9RhIlGf61yWt+y+rtNK1dE5nDDrJ0WCgDsLjD+GGrO0QYQe+GFz83cy7Z6ak4Ev
         HGcYW2aVzBsXZAeebCP15wfZxkK2ztlp41Gcz8QhLYFcvrXJN5cNvF7rJLyjs2b6VY8j
         Jciw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791404327; x=1792009127;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=NZrB+ZK9QzheM+fAXTkH4OM5BDNaPKAQVWUlPIMQy+w=;
        b=rIZL8w+PLC8LcnVoqOpBSaAknHqYYkDDDcLldtuxq5vcAPo2NpOffV0Uvbwj3s3b9l
         cu/QANVjpcaUFoPcQIMoSsstJjJdoyBAmAkQOOcTxND3B3Iag8sG8t1Y2We4xl1oVM+Y
         skJWCt2Ok+Y4HsEu61fh4NlxDIT1V2wE6iPDaDf1tk0U8Za4KZIhcvd8ZUtXZDfHKqfg
         6z8xVSMYOyDtpCbrGWD6c8NYy69UIEUVKTDsOajCetrdK8YE09qstvu7xDCRiHlsjITt
         uWN4jC9hQMv3VUB3W6fNY+ixU3XlcZtaFRVDIWf4nV77UbqAGqgDCGm4DCqIRXHAKB/a
         LdDA==
X-Gm-Message-State: AFq9FYK58xjeNlg7OzMZA/a5BHZN6wxz+5dxZgCfsYbV4yoleKXD/y/F
	ZxvCB11yzp/3i0Tv9AUqd6LRer2cbx5slAj8KoQifa+bsROnyOovJ5+S
X-Gm-Gg: AYBFou3cvD90r4U7O2m3QTtjSht/CmyOtW7eE493dKIzkrfvH7f46Ene+uPJFsbsqHW
	ZW+z6UQ+YzbxzrR8Ca3s4QG2Z7TrUQ7z64o8q5Jd7XDTKc8+tgothQhrHCBB5TERRILzW5r5xVc
	Pq/hYFbI/WoYWKW6Sl6cJLKwxmyW5QZQUfQ/19aaJWNDegyaRNNZg01fn7KKRGI/b471mffrOjv
	7L+ohG4LJaq8aoL6aJgFVTIKFAWy0uTwriiBR8ORzzj+hArf1oe+O6Hdtgh7gzyB0K1OQirkpPz
	Gkv70RwT256YBVjRcChyO6x6LOvh5cSyy4iLYCdXg21BNYbXnrB75v0t3sLLhpGrZOrbV2qaTjM
	Ne+FJC3ZsjOZfPFJdvi3u78Hzgko1Kv5C8Fi2K2+HBhanxJE5LosgIaKw7ALYpxwpPwR/TDwsyr
	tPFnYv+9iEsiJFevfrrgap5+hrAv0T0135cWVX6T7IsQcRys2Dms7Ss47QQ2hrCK7WmMVnIZHwp
	cusaQkIjZruvjsRIKEHXM7HznZ5utoSfgmKdHdz8mrnJ1tiS4+dxcQH8Juzsm3zhnqg6+cLnwHK
	vmXTIw5xvovwkw==
X-Received: by 2002:a17:90b:5483:b0:3a4:71b7:eb63 with SMTP id 98e67ed59e1d1-3a8a0845159mr2211662a91.10.1791404326644;
        Wed, 07 Oct 2026 13:18:46 -0700 (PDT)
Received: from 4470NRD-ASU.ssi.samsung.com (c-24-19-224-150.hsd1.wa.comcast.net. [24.19.224.150])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9ff7ab034sm967623a91.4.2026.10.07.13.18.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Oct 2026 13:18:46 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Dan Williams <djbw@kernel.org>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Ira Weiny <iweiny@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Fan Ni <nifan.cxl@gmail.com>,
	Li Ming <ming.li@zohomail.com>,
	Benjamin Cheatham <benjamin.cheatham@amd.com>,
	Gregory Price <gourry@gourry.net>,
	Richard Cheng <icheng@nvidia.com>,
	Anisa Su <anisa.su@samsung.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH v15 7/8] cxl/core: Enforce partition order/simplify partition calls
Date: Wed,  7 Oct 2026 13:16:40 -0700
Message-ID: <20261007201828.952-8-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261007201828.952-1-anisa.su@samsung.com>
References: <20261007201828.952-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Device partitions share one flat DPA space in a fixed order: static
volatile capacity at DPA 0, static persistent capacity immediately above
it, and dynamic capacity above all static capacity.  The static pair is
mandated by CXL r4.0 8.2.10.9.2.1 "Get Partition Info", Table 8-310: the
device "shall provide this volatile capacity starting at DPA 0" and
"shall provide this persistent capacity starting at the DPA immediately
following the volatile capacity".  Dynamic capacity has no such rule.
Table 8-347 only requires the region base to be 256M aligned, so placing
it directly above static capacity is a Linux requirement,
enforced by cxl_configure_dcd().

    DPA 0                                                     end
    +---------------+---------------+---------------------------+
    |      ram      |     pmem      |       dynamic_ram_1       |
    +---------------+---------------+---------------------------+
    part[0]         part[1]         part[2]

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Co-developed-by: Anisa Su <anisa.su@samsung.com>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Reviewed-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Reviewed-by: Alison Schofield <alison.schofield@intel.com>
---
 drivers/cxl/core/hdm.c    | 10 ++++++++++
 drivers/cxl/core/memdev.c | 32 +++++++++-----------------------
 drivers/cxl/cxlmem.h      |  9 +++------
 drivers/cxl/mem.c         |  2 +-
 include/cxl/cxl.h         | 20 ++++++++++++++++++++
 5 files changed, 43 insertions(+), 30 deletions(-)

diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index 379540246333..ec5742debb52 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -470,6 +470,16 @@ int cxl_dpa_setup(struct cxl_dev_state *cxlds, const struct cxl_dpa_info *info)
 		return 0;
 	}
 
+	/* Verify partitions are in expected order. */
+	for (int i = 1; i < info->nr_partitions; i++) {
+		if (info->part[i].mode < info->part[i - 1].mode) {
+			dev_err(dev, "Partition order mismatch: %d (%s) follows %d (%s)\n",
+				i, cxl_mode_name(info->part[i].mode),
+				i - 1, cxl_mode_name(info->part[i - 1].mode));
+			return -EINVAL;
+		}
+	}
+
 	cxlds->dpa_res = DEFINE_RES_MEM(0, info->size);
 
 	for (int i = 0; i < info->nr_partitions; i++) {
diff --git a/drivers/cxl/core/memdev.c b/drivers/cxl/core/memdev.c
index 7aa79a1a53e4..3ad68341d294 100644
--- a/drivers/cxl/core/memdev.c
+++ b/drivers/cxl/core/memdev.c
@@ -77,20 +77,12 @@ static ssize_t label_storage_size_show(struct device *dev,
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
@@ -103,7 +95,7 @@ static ssize_t pmem_size_show(struct device *dev, struct device_attribute *attr,
 {
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
-	unsigned long long len = cxl_pmem_size(cxlds);
+	unsigned long long len = cxl_part_size(cxlds, CXL_PARTMODE_PMEM);
 
 	return sysfs_emit(buf, "%#llx\n", len);
 }
@@ -426,10 +418,11 @@ static struct attribute *cxl_memdev_attributes[] = {
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
@@ -440,7 +433,7 @@ static ssize_t pmem_qos_class_show(struct device *dev,
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
 
-	return sysfs_emit(buf, "%d\n", to_pmem_perf(cxlds)->qos_class);
+	return sysfs_emit(buf, "%d\n", part_perf(cxlds, CXL_PARTMODE_PMEM)->qos_class);
 }
 
 static struct device_attribute dev_attr_pmem_qos_class =
@@ -452,20 +445,13 @@ static struct attribute *cxl_memdev_pmem_attributes[] = {
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
@@ -501,7 +487,7 @@ static umode_t cxl_ram_visible(struct kobject *kobj, struct attribute *a, int n)
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dpa_perf *perf = to_ram_perf(cxlmd->cxlds);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_RAM);
 
 	if (a == &dev_attr_ram_qos_class.attr &&
 	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
@@ -520,7 +506,7 @@ static umode_t cxl_pmem_visible(struct kobject *kobj, struct attribute *a, int n
 {
 	struct device *dev = kobj_to_dev(kobj);
 	struct cxl_memdev *cxlmd = to_cxl_memdev(dev);
-	struct cxl_dpa_perf *perf = to_pmem_perf(cxlmd->cxlds);
+	struct cxl_dpa_perf *perf = part_perf(cxlmd->cxlds, CXL_PARTMODE_PMEM);
 
 	if (a == &dev_attr_pmem_qos_class.attr &&
 	    (!perf || perf->qos_class == CXL_QOS_CLASS_INVALID))
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index 9106affd7c81..35268d1c387c 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -412,14 +412,11 @@ struct cxl_security_state {
 
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
index 798e5c369cfc..9c4ef401cbad 100644
--- a/drivers/cxl/mem.c
+++ b/drivers/cxl/mem.c
@@ -139,7 +139,7 @@ static int cxl_mem_probe(struct device *dev)
 		return -ENXIO;
 	}
 
-	if (cxl_pmem_size(cxlds) && IS_ENABLED(CONFIG_CXL_PMEM)) {
+	if (cxl_part_size(cxlds, CXL_PARTMODE_PMEM) && IS_ENABLED(CONFIG_CXL_PMEM)) {
 		rc = devm_cxl_add_nvdimm(dev, parent_port, cxlmd);
 		if (rc) {
 			if (rc == -ENODEV)
diff --git a/include/cxl/cxl.h b/include/cxl/cxl.h
index 728decda57fd..1c04a7823f64 100644
--- a/include/cxl/cxl.h
+++ b/include/cxl/cxl.h
@@ -130,6 +130,26 @@ struct cxl_dpa_perf {
 	int qos_class;
 };
 
+/*
+ * Partitions share one flat DPA space in a fixed order:
+ *
+ *   DPA 0                                                     end
+ *   +---------------+---------------+---------------------------+
+ *   |      ram      |     pmem      |       dynamic_ram_1       |
+ *   +---------------+---------------+---------------------------+
+ *     part[0]         part[1]         part[2]
+ *
+ * The static ram and pmem partition order is mandated by CXL r4.0
+ * 8.2.10.9.2.1 "Get Partition Info" (opcode 4100h), Table 8-310: volatile
+ * capacity starts at DPA 0 and persistent capacity starts at the DPA
+ * immediately following it.  A dynamic partition has no such
+ * requirement -- 8.2.10.9.9.1 "Get Dynamic Capacity Configuration"
+ * (opcode 4800h), Table 8-347, only requires the DC Region Base to be
+ * 256MB aligned -- but Linux follows that precedent and requires it to
+ * start at the DPA immediately following static capacity: after pmem,
+ * after ram on a device with no pmem, or at DPA 0 on a device with no
+ * static capacity at all.  cxl_configure_dcd() enforces it.
+ */
 enum cxl_partition_mode {
 	CXL_PARTMODE_RAM,
 	CXL_PARTMODE_PMEM,
-- 
2.43.0

