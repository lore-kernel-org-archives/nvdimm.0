Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6587238735E
	for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 09:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779529858; cv=none; b=pCXM7YXE+3NBF0/nVszjnkEQeRbj40COuoSfy7VBtU7kuG+MFN5IauH5QWW1pnL7m7VMBZYUALmVH+WT7fid3DynDetcGNByIiuss4d9CkoItLyQgpLECqPEknUB//qwedQDLyBYkdUH4EmR8bM0Y5t8I05UmRv79wXgCH2bKDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779529858; c=relaxed/simple;
	bh=NSpbaQHOz6PZx2jbhipwiuOuTgT/svEhqpqEbO5vPrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W25TFbMBM5yhFaLZuUP7jHNMfLacc2HdECJc/a25LMEafZkiQXicsMCN9FvzkHz2Fv110TSJ68Ux+4ScQtgRSHx6K+zh7Zrtr2dQXSyyg5/2dVVAh0aZDISqOaD9+Mqm8dU/B4F9X+IfsP7XtdpDWaqr0h2XrpaGd0LSW2kl3/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dOvyDjcT; arc=none smtp.client-ip=74.125.82.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dOvyDjcT"
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-2f0ad52830cso10490800eec.1
        for <nvdimm@lists.linux.dev>; Sat, 23 May 2026 02:50:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779529854; x=1780134654; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QP7lQFgFODt86l4WnD6c19IQdk0Fg8SUG4762WjP7rc=;
        b=dOvyDjcT6OI+O/R6AqJl0lNktdTUkKJUWpR9iyN6YRvmXEysxJfvd9U8bO6H3K74bW
         06QGJIQ5PR8qDX+Q3lnUr3OA27HSwSRQXLL+mScf55FJlSoVJ9zmc628BPC61pzUtcmT
         2kGvy+e5eWq/PwEefJoJwUmxCfji0mr6ijl/PT3Q2zlNOvPxVnxtjhLk2ehlnM1Nqn3/
         Mu7D1+7/lNVe53uVrs5RFYX8qGXZLMvnBHjbPAZVx//8bB1PNJsnX1FDgUa1pewRAWb3
         v+nPR92jssUkontn5YyTlIcRQG38p+Qzr68MqTQuIdjVaQTQLEgk7/Wi/3iymdkk1WvC
         2OYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779529855; x=1780134655;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QP7lQFgFODt86l4WnD6c19IQdk0Fg8SUG4762WjP7rc=;
        b=Yi4uNTY68czXxB9orBq7qfF3IjMh9q/2wzcje+ngyWBlt+Qh4f3trouWli/R58eug7
         lvSPUEaUA6p9h7RKLjmLMaFkaM5UHNW+G3e+3oTd6oXtInZsiZEOBl8iOCWOsKG5THcE
         JyaUJARDrrsyUekUAWeM+rwX4fo/ZkN8GgRUIHPldLYLogMiGkWjgxBPb40NFiEVrQUO
         k3PNAUSHKrrgH/J5s6zT8T7gpVlUa+bQb2fc2hAlW7zDK9uyPpyERqp2Q55zgZzKVBdG
         BPeK7ckxq61+CapvZFLD3zxC2FAW5hcIgT2HVNTVHBaUp5TM2VgckgCFD9mbMTqhFCon
         JezQ==
X-Gm-Message-State: AOJu0YzSpk5SxB11pg46zCijYxGTfDUmuq/5cUtsZUtdMIOj0zW8CYNc
	Ym/r1aOklhU02J68JNjFwsyOqtS36waGeIPNC+JXZXvm94RrkPz69/F7
X-Gm-Gg: Acq92OGmtb+K47+8BLdTVYSG+z7RbmRRmJCRbZH0kNFsMo1i/9OPXysLE3lAGF8SGHi
	QufTp/kEm9DBGHWTefjEfoIhqUACPokB5q2NbjmZOemnpCtFRyiAmYIkF6fTdQSASQu4EFBsuJY
	/n93kDKI0pZlVIOnc+PCZkzR6MUAXLjgcs0y+R1V7+KXJLF75pVtFDGh6MiamDzSjTIUQW91l5S
	2PUXARvAhHoPemt+DEafjEvGfZJXkcY8eArYdBxeTtOXwtPMdSHAC4IqcFMW7rMXwvz29VniIKu
	Li8r4Xhj/aToLBre43xEI/1lmSaRyvMz0LocHXeNYbGqFfldpiDdJNgiR4e7kHdvDofJL0Wbt1k
	k/D48p3lpVAmp4SgEG/LbhFHeXVTl91Hjd03pB5vCG31W/Niimlr98TXrAoTAU5YsIrHWm8IOGO
	gFOZf32edHhbazClVSBK52A1iKZjLnhsaMLt9ZypmZIZC9IyVzAioNra2F70tjx/keldQIZ70tw
	tgHfv2gqd/NEHZfRA==
X-Received: by 2002:a05:7301:6588:b0:2d3:2983:c87c with SMTP id 5a478bee46e88-3044904e0a8mr3620540eec.1.1779529854479;
        Sat, 23 May 2026 02:50:54 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3045225b7b6sm4595756eec.25.2026.05.23.02.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 May 2026 02:50:54 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
To: linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@Groves.net>,
	Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: [PATCH v6 2/7] libcxl: Add Dynamic RAM A partition mode support
Date: Sat, 23 May 2026 02:50:37 -0700
Message-ID: <20260523095043.471098-3-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260523095043.471098-1-anisa.su@samsung.com>
References: <20260523095043.471098-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <ira.weiny@intel.com>

Dynamic capacity partitions are exposed as a singular dynamic ram
partition.

Add CXL library support to read this partition information.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  6 +++--
 cxl/lib/libcxl.c                 | 43 ++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  4 +++
 cxl/lib/private.h                |  3 +++
 cxl/libcxl.h                     | 10 +++++++-
 5 files changed, 63 insertions(+), 3 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 5c3ebd4..9921ac1 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -74,6 +74,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
 int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
 int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
@@ -93,8 +94,8 @@ The character device node for command submission can be found by default
 at /dev/cxl/mem%d, or created with a major / minor returned from
 cxl_memdev_get_{major,minor}().
 
-The 'pmem_size' and 'ram_size' attributes return the current
-provisioning of DPA (Device Physical Address / local capacity) in the
+The 'pmem_size', 'ram_size', and 'dynamic_ram_a_size' attributes return the
+current provisioning of DPA (Device Physical Address / local capacity) in the
 device.
 
 cxl_memdev_get_numa_node() returns the affinitized CPU node number if
@@ -453,6 +454,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DYNAMIC_RAM_A,
 };
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
 int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e55a7b4..be0bc03 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -501,6 +501,9 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
 		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
 			if (root_decoder->qos_class != memdev->pmem_qos_class)
 				return true;
+		} else if (region->mode == CXL_DECODER_MODE_DYNAMIC_RAM_A) {
+			if (root_decoder->qos_class != memdev->dynamic_ram_a_qos_class)
+				return true;
 		}
 	}
 
@@ -1426,6 +1429,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/dynamic_ram_a/size", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->dynamic_ram_a_size = strtoull(buf, NULL, 0);
+
 	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
@@ -1438,6 +1445,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	else
 		memdev->ram_qos_class = atoi(buf);
 
+	sprintf(path, "%s/dynamic_ram_a/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->dynamic_ram_a_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->dynamic_ram_a_qos_class = atoi(buf);
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0) {
 		memdev->payload_max = strtoull(buf, NULL, 0);
@@ -1685,6 +1698,11 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
 	return memdev->ram_size;
 }
 
+CXL_EXPORT unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev)
+{
+	return memdev->dynamic_ram_a_size;
+}
+
 CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
 {
 	return memdev->pmem_qos_class;
@@ -1695,6 +1713,11 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
 	return memdev->ram_qos_class;
 }
 
+CXL_EXPORT int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->dynamic_ram_a_qos_class;
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
@@ -2465,6 +2488,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 		else if (strcmp(buf, "none") == 0)
 			decoder->mode = CXL_DECODER_MODE_NONE;
+		else if (strcmp(buf, "dynamic_ram_a") == 0)
+			decoder->mode = CXL_DECODER_MODE_DYNAMIC_RAM_A;
 		else
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 	} else
@@ -2504,6 +2529,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	case CXL_PORT_SWITCH:
 		decoder->pmem_capable = true;
 		decoder->volatile_capable = true;
+		decoder->dynamic_ram_a_capable = true;
 		decoder->mem_capable = true;
 		decoder->accelmem_capable = true;
 		sprintf(path, "%s/locked", cxldecoder_base);
@@ -2528,6 +2554,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			{ "cap_type3", &decoder->mem_capable },
 			{ "cap_ram", &decoder->volatile_capable },
 			{ "cap_pmem", &decoder->pmem_capable },
+			{ "cap_dynamic_ram_a", &decoder->dynamic_ram_a_capable },
 			{ "locked", &decoder->locked },
 		};
 
@@ -2778,6 +2805,9 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 	case CXL_DECODER_MODE_RAM:
 		sprintf(buf, "ram");
 		break;
+	case CXL_DECODER_MODE_DYNAMIC_RAM_A:
+		sprintf(buf, "dynamic_ram_a");
+		break;
 	default:
 		err(ctx, "%s: unsupported mode: %d\n",
 		    cxl_decoder_get_devname(decoder), mode);
@@ -2829,6 +2859,11 @@ CXL_EXPORT bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder)
 	return decoder->volatile_capable;
 }
 
+CXL_EXPORT bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder)
+{
+	return decoder->dynamic_ram_a_capable;
+}
+
 CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
 {
 	return decoder->mem_capable;
@@ -2903,6 +2938,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
 	else if (mode == CXL_DECODER_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
+	else if (mode == CXL_DECODER_MODE_DYNAMIC_RAM_A)
+		sprintf(path, "%s/create_dynamic_ram_a_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
 	if (rc < 0) {
@@ -2954,6 +2991,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
 }
 
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder)
+{
+	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_DYNAMIC_RAM_A);
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index ed4429f..258bdd3 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -294,6 +294,10 @@ global:
 	cxl_memdev_get_fwctl;
 	cxl_fwctl_get_major;
 	cxl_fwctl_get_minor;
+	cxl_memdev_get_dynamic_ram_a_size;
+	cxl_memdev_get_dynamic_ram_a_qos_class;
+	cxl_decoder_is_dynamic_ram_a_capable;
+	cxl_decoder_create_dynamic_ram_a_region;
 } LIBECXL_8;
 
 LIBCXL_10 {
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index d2d71fc..37b7b06 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -52,8 +52,10 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	unsigned long long dynamic_ram_a_size;
 	int ram_qos_class;
 	int pmem_qos_class;
+	int dynamic_ram_a_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
@@ -159,6 +161,7 @@ struct cxl_decoder {
 	unsigned int interleave_granularity;
 	bool pmem_capable;
 	bool volatile_capable;
+	bool dynamic_ram_a_capable;
 	bool mem_capable;
 	bool accelmem_capable;
 	bool locked;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index e91af90..fd41122 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -75,8 +75,10 @@ struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dynamic_ram_a_size(struct cxl_memdev *memdev);
 int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
 int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
+int cxl_memdev_get_dynamic_ram_a_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
@@ -210,6 +212,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DYNAMIC_RAM_A,
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
@@ -219,9 +222,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_MODE_MIXED] = "mixed",
 		[CXL_DECODER_MODE_PMEM] = "pmem",
 		[CXL_DECODER_MODE_RAM] = "ram",
+		[CXL_DECODER_MODE_DYNAMIC_RAM_A] = "dynamic_ram_a",
 	};
 
-	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
+	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DYNAMIC_RAM_A)
 		mode = CXL_DECODER_MODE_NONE;
 	return names[mode];
 }
@@ -235,6 +239,8 @@ cxl_decoder_mode_from_ident(const char *ident)
 		return CXL_DECODER_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_DECODER_MODE_PMEM;
+	else if (strcmp(ident, "dynamic_ram_a") == 0)
+		return CXL_DECODER_MODE_DYNAMIC_RAM_A;
 	return CXL_DECODER_MODE_NONE;
 }
 
@@ -264,6 +270,7 @@ cxl_decoder_get_target_type(struct cxl_decoder *decoder);
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
+bool cxl_decoder_is_dynamic_ram_a_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
 unsigned int
@@ -272,6 +279,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_dynamic_ram_a_region(struct cxl_decoder *decoder);
 struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
 					    const char *ident);
 struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
-- 
2.43.0

