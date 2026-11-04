Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793833357;
	b=3OY0skQ0LZE4yunQqSNvPufe1vZngA4Qu76FgEjoO+RXzaTb7CsG+U5npFA1EqCPs8sz
	 xuzulQTFD8mr13oIfo4Jlhy4+nEfpgLco3O5Igi8jdwL860nGxh9rWieSWpV8+kYtYwf5
	 r5jIm68l5prnKSaCt+uWsLEZGOf/erwqBHuy0xcsy7QyF3kD9f07MEqyETw6ah3zgJ2D6
	 7KEb5T4yyTUYl4HxWvvWtKTkX1anC+jWJ8IAQ2yhkpknq50u6Zfb0AzdN3iGz0xm9aMWd
	 V6KaZGsr5CRi2EUEvYvAxVbVyf5fwpr2gcll0TvDVqvl+MiEx5wP4QDcpuWBLtIJALQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793833357;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:
	 X-Google-Original-From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=UJ8u1Aac89i93fKW/IhHRaklRCdGyzhiA6QnCteajf8=;
	b=qp6Q6m971MMcq6VKi+gUQn6qOYtTSBjj0APlQcYGxQXa1wy+5cR8k90MgWKrOL3NEAaJ
	 BNgiL4c05iAyXFcupBrJcXKEQtG3eRPYzgcouCKaaq71rcXYXk5WlSluHVLcRyn2vfgXa
	 XMBxGSiXbRo2tTR+HAQy+ZdZDjJyIXAPi11cFcJmXztC8t8WyDX1wyCgqNxgMsyqPd/Ep
	 TAl+l75iPqJbqDmVBihaJoWV54ovZI2zF7keNAvOFAyXx3TfCWnfDNW6nldR2sD+AfRnn
	 6yg+Kw1zalPgT2cbzdbEOCZGdfM2edCnljraNwbznjUdmwJ9CLkTFNgHMMFsjV3p4ZA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n6yRKUQa;
	arc=none smtp.remote-ip=209.85.214.173
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B242606D817
	for <nvdimm@lists.linux.dev>; Wed,  4 Nov 2026 23:02:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6B242606D817
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=n6yRKUQa
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2e985106c0cso10606555ad.2
        for <nvdimm@lists.linux.dev>; Wed, 04 Nov 2026 15:02:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793833356; x=1794438156; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UJ8u1Aac89i93fKW/IhHRaklRCdGyzhiA6QnCteajf8=;
        b=n6yRKUQajzFmeiLEbTnc/yWnGgloJhvrfxpv/4VUdazErgeGXbp8ZmEBNvKuFTU2fK
         2veo6jlOrwTY4H+21Y4HFJhVjPyz4OSo2RC9AVDxIAjahSwe9Mb5SBZyl85kkhls/baC
         oorntu46Ft879yhpCn4YIKQyeK1HgSwYDtBcEjZDK8fFM2JgkJbXTvae3vs8kiIJa+4K
         mz7BhZw4T/nX+tVSLukFP54x7hOK944F13qAdcxhJAj91xlw+drlRYpnE60bgLiF+U7m
         dylOmXw0eQ186Ij4wj+78Q1UdxhFwGoPBuAkxQGi3rSzV1nI3vSim0iokCst0FxZ5y17
         jxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793833356; x=1794438156;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UJ8u1Aac89i93fKW/IhHRaklRCdGyzhiA6QnCteajf8=;
        b=e6Rw6FOqtHTpHvzRNake9L4+8pc/BJxk6hLjP7hHqlP2lYnmP7foi2Pm5AGWMXgE1A
         tP1lgc66uooU5q5faL0ftg3y24K7Z8GLwQLGOwdsXVY3H5I5EEzu4S8IJIOzX8kKVBd1
         TZKcFsfS0x56+tMHecfNVeXxW1fiMDZEUGLYvDWeKM1s/HcCltU5V3upvaqSO0kM3fOS
         VEOGaRW2ZPa4qLSxePCPAOLTlTDsXoa/PUEbXIHFqg/iVJ/Bg9XAPS6MYbYr/5Gza/eN
         eqpaaupNNDz6QRMM72k0hISvACiIHBkirI6f83iqp+9/6/urBMzYttvnn2Vg8M7p0dIz
         m78Q==
X-Gm-Message-State: APuU4Z85hCw7CYNYXLyfDqn8td3o8QIWDo/5S0aFt+3IR62IslNirSuK
	mrAQ8kWd7AoapQhrr77EZ1pB/oiDmJxwAeK0xqNNd76n6gM6C418b709
X-Gm-Gg: AYBFou35lVCY3dDdMXcf6SY6cdKu8xxRdG+zyxFTNioQWlLUtWjQ6wRhaD83SgPSgAQ
	YoafI5OGc619QemYPhkUI9+5AhTHurfDV7BQJwTkQn2Hv5ZrjE7flqHlYmgnwoIIdU5dAchqN6s
	vjPOVSk55t0LL9b0q/99wWLVIgu/lgg/bKA/B4XVoa1+FKsUvd4r5Y+rtssUhnAm8tnozEsZwFz
	7OTgV5rw6c7DD7e2DP55T23GJqDsBi2TUHLP69ZodRlY9FRz0vnqltkVrNc4O25wGDUYy35fvV/
	DLSiuo3nkbmwEVMuy3uPLH/tDn6Wh+pUFB2QO+YQQc2iAIbLQG1dD0symDfPipNvkH8zcwdo+tl
	/tbP/CYEIeAPqePNIVKGllJiP207jgisjfk1K0kKu0n6zXe3Py7mpccU/v7pFUDza3JNZoFUPgT
	HRyz9UeSmtzWRh9px7Pt1ohnPFySUzKteV1ihPhErxYB/H257imcPhGsV7a+aWrkPZtF+j2jgDL
	MjBF01GdL2CXQdLrTCB0HWHogFIePemLNOEZadh/AejVJ7nactw/AgXFTeOyw+wVNgMjvyKpyqL
	1zvRWsEbo6KyobgppyYQQncfGO2pqA==
X-Received: by 2002:a17:902:ce8b:b0:2df:aed3:2ac0 with SMTP id d9443c01a7336-2eb3649c031mr164760135ad.10.1793833355653;
        Wed, 04 Nov 2026 15:02:35 -0800 (PST)
Received: from cxlqual.. ([220.120.90.131])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed0908587dsm10999175ad.36.2026.11.04.15.02.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 15:02:35 -0800 (PST)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
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
	Anisa Su <anisa.su@samsung.com>
Subject: [PATCH v1 02/14] cxl/port: Add dynamic capacity options to endpoint decoder mode
Date: Thu,  5 Nov 2026 08:02:26 +0900
Message-ID: <20261104230445.66625-3-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261104230445.66625-1-anisa.su@samsung.com>
References: <20261104230445.66625-1-anisa.su@samsung.com>
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Post: <mailto:nvdimm@lists.linux.dev>
List-Help: <mailto:nvdimm+help@lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:nvdimm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Endpoints can now carry a dynamic ram partition following the
persistent memory partition. A DC partition is further described by
two properties reported in its CDAT DSMAS entry: shareable and
read-only.

Expand the decoder mode to accept 'dynamic_ram', 'dynamic_ram_shared',
'dynamic_ram_ro' and 'dynamic_ram_shared_ro'. cxl_dpa_set_part()
selects the first dynamic ram partition whose properties match exactly.

DCD may be disabled during validation after the DC partition(s) were
added to the DPA layout, so a decoder may only be assigned to a DC
partition while DCD is enabled for its memdev. Add a helper,
cxled_dcd_enabled(), to check cxl_dcd_supported().

Signed-off-by: Anisa Su <anisa.su@samsung.com>
Tested-by: Wonjae Lee <wj28.lee@samsung.com>
Tested-by: Junhee Park <jh9934.park@samsung.com>
Tested-by: Heesoo Kim <habil.kim@samsung.com>
---
 Documentation/ABI/testing/sysfs-bus-cxl | 25 +++++++----
 drivers/cxl/core/core.h                 | 23 ++++++++++-
 drivers/cxl/core/hdm.c                  | 21 ++++++++--
 drivers/cxl/core/port.c                 | 55 ++++++++++++++++++++++---
 4 files changed, 105 insertions(+), 19 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-bus-cxl b/Documentation/ABI/testing/sysfs-bus-cxl
index 7352dbd70bc7..bcbc44fea6db 100644
--- a/Documentation/ABI/testing/sysfs-bus-cxl
+++ b/Documentation/ABI/testing/sysfs-bus-cxl
@@ -339,22 +339,29 @@ Description:
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/mode
-Date:		May, 2022
-KernelVersion:	v6.0
+Date:		May, 2022, November, 2026
+KernelVersion:	v6.0, v7.5 (dynamic_ram)
 Contact:	linux-cxl@vger.kernel.org
 Description:
 		(RW) When a CXL decoder is of devtype "cxl_decoder_endpoint" it
 		translates from a host physical address range, to a device
 		local address range. Device-local address ranges are further
-		split into a 'ram' (volatile memory) range and 'pmem'
-		(persistent memory) range. The 'mode' attribute emits one of
-		'ram', 'pmem', or 'none'. The 'none' indicates the decoder is
-		not actively decoding, or no DPA allocation policy has been
-		set.
+		split into a 'ram' (volatile memory) range, 'pmem' (persistent
+		memory) range, and dynamic capacity ranges. The 'mode'
+		attribute emits one of 'ram', 'pmem', 'none', or a dynamic
+		capacity selector: 'dynamic_ram', 'dynamic_ram_shared',
+		'dynamic_ram_ro' or 'dynamic_ram_shared_ro', composed from the
+		shareable and read-only properties of the partition the decoder
+		points at. The 'none' indicates the decoder is not actively
+		decoding, or no DPA allocation policy has been set.
 
 		'mode' can be written, when the decoder is in the 'disabled'
-		state, with either 'ram' or 'pmem' to set the boundaries for the
-		next allocation.
+		state, with 'ram', 'pmem', or one of the dynamic capacity
+		selectors to set the boundaries for the next allocation. A
+		selector picks the first dynamic capacity partition whose
+		shareable and read-only properties match it exactly, and is
+		accepted only while the driver has dynamic capacity enabled
+		for the device.
 
 
 What:		/sys/bus/cxl/devices/decoderX.Y/dpa_resource
diff --git a/drivers/cxl/core/core.h b/drivers/cxl/core/core.h
index 8a81be004d00..24fbb5718abc 100644
--- a/drivers/cxl/core/core.h
+++ b/drivers/cxl/core/core.h
@@ -6,6 +6,7 @@
 
 #include <cxl/mailbox.h>
 #include <linux/rwsem.h>
+#include <cxlmem.h>
 
 extern const struct device_type cxl_nvdimm_bridge_type;
 extern const struct device_type cxl_nvdimm_type;
@@ -18,6 +19,25 @@ enum cxl_detach_mode {
 	DETACH_INVALIDATE,
 };
 
+static inline struct cxl_memdev_state *
+cxled_to_mds(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
+
+	return to_cxl_memdev_state(cxlmd->cxlds);
+}
+
+/* Type-2 devices have no memdev state; nothing else leaves @cxlds NULL here */
+static inline bool cxled_dcd_enabled(struct cxl_endpoint_decoder *cxled)
+{
+	struct cxl_memdev_state *mds = cxled_to_mds(cxled);
+
+	return mds && cxl_dcd_supported(mds);
+}
+
+const char *cxl_dc_mode_name(bool shareable, bool read_only);
+int cxl_dc_mode_parse(const char *buf, bool *shareable, bool *read_only);
+
 #ifdef CONFIG_CXL_REGION
 
 struct cxl_region_context {
@@ -104,7 +124,8 @@ void __iomem *devm_cxl_iomap_block(struct device *dev, resource_size_t addr,
 
 struct dentry *cxl_debugfs_create_dir(const char *dir);
 int cxl_dpa_set_part(struct cxl_endpoint_decoder *cxled,
-		     enum cxl_partition_mode mode);
+		     enum cxl_partition_mode mode, bool shareable,
+		     bool read_only);
 struct cxl_memdev_state;
 int cxl_mem_get_partition_info(struct cxl_memdev_state *mds);
 int cxl_dpa_alloc(struct cxl_endpoint_decoder *cxled, u64 size);
diff --git a/drivers/cxl/core/hdm.c b/drivers/cxl/core/hdm.c
index fdcef20e01ba..36fba4cff493 100644
--- a/drivers/cxl/core/hdm.c
+++ b/drivers/cxl/core/hdm.c
@@ -619,8 +619,14 @@ int cxl_dpa_free(struct cxl_endpoint_decoder *cxled)
 	return 0;
 }
 
+/*
+ * Select the first partition of @mode. For dynamic capacity the shareable
+ * and read-only flags must match exactly as well, so each selector names
+ * one kind of partition.
+ */
 int cxl_dpa_set_part(struct cxl_endpoint_decoder *cxled,
-		     enum cxl_partition_mode mode)
+		     enum cxl_partition_mode mode, bool shareable,
+		     bool read_only)
 {
 	struct cxl_memdev *cxlmd = cxled_to_memdev(cxled);
 	struct cxl_dev_state *cxlds = cxlmd->cxlds;
@@ -631,9 +637,16 @@ int cxl_dpa_set_part(struct cxl_endpoint_decoder *cxled,
 	if (cxled->cxld.flags & CXL_DECODER_F_ENABLE)
 		return -EBUSY;
 
-	for (part = 0; part < cxlds->nr_partitions; part++)
-		if (cxlds->part[part].mode == mode)
-			break;
+	for (part = 0; part < cxlds->nr_partitions; part++) {
+		struct cxl_dpa_partition *p = &cxlds->part[part];
+
+		if (p->mode != mode)
+			continue;
+		if (mode == CXL_PARTMODE_DYNAMIC_RAM &&
+		    (p->shareable != shareable || p->read_only != read_only))
+			continue;
+		break;
+	}
 
 	if (part >= cxlds->nr_partitions) {
 		dev_dbg(dev, "unsupported mode: %d\n", mode);
diff --git a/drivers/cxl/core/port.c b/drivers/cxl/core/port.c
index f3705ea44db7..9b71b58d4e36 100644
--- a/drivers/cxl/core/port.c
+++ b/drivers/cxl/core/port.c
@@ -203,6 +203,40 @@ static ssize_t target_list_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(target_list);
 
+/* Dynamic capacity selectors: the flags name one kind of DC partition */
+static const struct {
+	const char *name;
+	bool shareable;
+	bool read_only;
+} cxl_dc_modes[] = {
+	{ "dynamic_ram",		false,	false },
+	{ "dynamic_ram_shared",		true,	false },
+	{ "dynamic_ram_ro",		false,	true },
+	{ "dynamic_ram_shared_ro",	true,	true },
+};
+
+const char *cxl_dc_mode_name(bool shareable, bool read_only)
+{
+	for (int i = 0; i < ARRAY_SIZE(cxl_dc_modes); i++)
+		if (cxl_dc_modes[i].shareable == shareable &&
+		    cxl_dc_modes[i].read_only == read_only)
+			return cxl_dc_modes[i].name;
+	return "";
+}
+
+/* Map a dynamic_ram selector to its partition flags; -EINVAL if unknown */
+int cxl_dc_mode_parse(const char *buf, bool *shareable, bool *read_only)
+{
+	for (int i = 0; i < ARRAY_SIZE(cxl_dc_modes); i++) {
+		if (!sysfs_streq(buf, cxl_dc_modes[i].name))
+			continue;
+		*shareable = cxl_dc_modes[i].shareable;
+		*read_only = cxl_dc_modes[i].read_only;
+		return 0;
+	}
+	return -EINVAL;
+}
+
 static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
 			 char *buf)
 {
@@ -215,6 +249,9 @@ static ssize_t mode_show(struct device *dev, struct device_attribute *attr,
 
 	if (part < 0)
 		desc = "none";
+	else if (cxlds->part[part].mode == CXL_PARTMODE_DYNAMIC_RAM)
+		desc = cxl_dc_mode_name(cxlds->part[part].shareable,
+					cxlds->part[part].read_only);
 	else
 		desc = cxlds->part[part].res.name;
 
@@ -225,17 +262,25 @@ static ssize_t mode_store(struct device *dev, struct device_attribute *attr,
 			  const char *buf, size_t len)
 {
 	struct cxl_endpoint_decoder *cxled = to_cxl_endpoint_decoder(dev);
+	bool shareable = false, read_only = false;
 	enum cxl_partition_mode mode;
 	ssize_t rc;
 
-	if (sysfs_streq(buf, "pmem"))
+	if (sysfs_streq(buf, "pmem")) {
 		mode = CXL_PARTMODE_PMEM;
-	else if (sysfs_streq(buf, "ram"))
+	} else if (sysfs_streq(buf, "ram")) {
 		mode = CXL_PARTMODE_RAM;
-	else
-		return -EINVAL;
+	} else {
+		if (cxl_dc_mode_parse(buf, &shareable, &read_only))
+			return -EINVAL;
+		mode = CXL_PARTMODE_DYNAMIC_RAM;
+	}
+
+	/* The DC partition may outlive DCD support; refuse it when disabled */
+	if (mode == CXL_PARTMODE_DYNAMIC_RAM && !cxled_dcd_enabled(cxled))
+		return -ENXIO;
 
-	rc = cxl_dpa_set_part(cxled, mode);
+	rc = cxl_dpa_set_part(cxled, mode, shareable, read_only);
 	if (rc)
 		return rc;
 
-- 
2.43.0

