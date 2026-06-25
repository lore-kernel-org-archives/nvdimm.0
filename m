Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD6B3DEFFB
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 12:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389596; cv=none; b=UrarQw/i4Iy/QXgNURYGxx7BLRTD63fq/tw0hakz9ma3WHWlURwZ8dAw31WekTNieOwL7w2fll7ycDJUzj3ljX2VKT3cWlFr5hGbhtPeHRLYYBXUiKYeHkbX0p9B+nKhEC3LsxlFlXkoBvKuTDrbcXZHkg8gXcesXyeihQWlHtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389596; c=relaxed/simple;
	bh=2D6xc9SycrC04lloJjB6w/v/AZZZvN9W5SslKmmceFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UoNMfTXsZPTtlLxSe1iWnqxRoFS6uAYRi8IvE40zWIgIU9Gi9nyXc/ShhBhdrKzPHNa2X55AMGsmUMR+Nel0OkFJt27ZDSBFmiRRb4HyAfypb5EYyTMe/BHTSjEaan4+CbZUf6x4Lq5fuvrlazKCmVb/QrshHt0q8bLZ4gZzF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D4mChlEV; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D4mChlEV"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1397e093f90so6206295c88.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 05:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782389592; x=1782994392; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XWUBgEux9E0/I6IOMEuEJOaOIVVa2o9RZjpWSR82UuY=;
        b=D4mChlEVyP+hBY1jUYgA0A2yRfF3iv0ba/gChYE7zfWmai9N4I/yj+AsWVYKRMsFw9
         kcAe4ehGPeOfCtZzpS0Ifboh7EAoobijlvvv6Am9w9Ncl6cERQCHx7EoCk8PbjwVCocq
         vOLKDO2nNsFYA1L3CVbVAnu7GhUt5xSf3/8/iFXr6Ap+O/fnMhsa560VglzUPEvmK+J+
         PTf3J8bQwHvTnRNXVxcjuo3GXjb3f0O5dC7wgWGgPCei+IOp1cjCUstks0SEE5ovKrv5
         hNKhF1njdKLzxkvKaU43yU+5Ziu3zfDPol2Mr7gtwXkvMqirK735K6+Vy5z74FYtSBnt
         tfaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782389592; x=1782994392;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XWUBgEux9E0/I6IOMEuEJOaOIVVa2o9RZjpWSR82UuY=;
        b=Q054DCIGGf+tnAvR4G8bIv/xnBgfAXUUULbIGklhgqSg8UUcB40QSI1ernjg6HtTcT
         IFm3i1lwlkcXxZIyt7CQy5O8Y3kmRVOV1OEb06H36tw5I8wfXzJqrZYOo6kbJf3rC9IZ
         Hm5CZHjJglh0Zx+vN6PTKuxVdGUetJiJL38epZk3dY1H8GJGdTDpp4fbenvD1Qdt1CL0
         2PW7hf8KPveWN0sCdXLRHggqRpGWUq/MtLA4sG4rrtS+QfziREjNVqrsPoMnf8HU72bM
         cyWXEeWpDLVAua1sTfSyQRjY+TlVSx4C5On2RKzjVJMfU8LDhyLV9DZIzsu0zoatCCmt
         qKOQ==
X-Gm-Message-State: AOJu0Yw8JQUMGAeEf+G9XpcI2aJf7rDozghcQZTD/oaZ3Rx4v/83AbRl
	Q+Fn0PsqCJpgWh0OCRgZ3cF4+3tJX2bFGYajHyf/AaHhiBuHOa8VsNY4
X-Gm-Gg: AfdE7ckqL+ezXLqchQqNwDZ7SHxTJOTmU8Hdu8KTsJZbis6koB2GO/K8IxvsSh2Gaoj
	rTLzmJnW78HcJVgzPUQBvr8bfmZchLNSBwtEJeobhDpNSmieNRbqlgqiF46qB6Ul5rcFrOxalXR
	KH6Vaeds5d7TJ25f6sS9vS+b8gIRor7jGpLxViqnhhyT5lPIeh9lKRp/q/Q/Jcj0yo77ugpjUZv
	9ilLuWBvv+2x2KDjXJmKM5sSzLg7Hozkv7lN/+gmsFpNucwPJzgWh2HXsVmYnnMkY4YFJGexNJE
	Vdif3rTZMLDk1QAKvktE8TB30+sec6KY5tkKkLzKtaH75R/kYfFx4MgewdmDkixF4Jcq8aWCbP7
	re4w2VarcBNtsG9ExUgYHGIk/HN68d/7kL+5ECZWm3bU9h3GvkgTRrG+5iow0WSxD89+ZvVDbJ3
	IyU35s5H/K060mQkLPQ5fSiJ++SzT3rd6xcs9dtawV8X9qr/nkPTtlBVTTGT6BO+Kfe9+9OtiEc
	gXS3HQ=
X-Received: by 2002:a05:7022:2591:b0:134:feba:3fd with SMTP id a92af1059eb24-139dbb05756mr2505123c88.37.1782389592207;
        Thu, 25 Jun 2026 05:13:12 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-139d8f77602sm7422206c88.8.2026.06.25.05.13.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 05:13:11 -0700 (PDT)
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
	Anisa Su <anisa.su@samsung.com>
Subject: [NDCTL PATCH v7 1/5] libcxl, cxl/region: Add Dynamic RAM 1 partition mode support
Date: Thu, 25 Jun 2026 05:09:35 -0700
Message-ID: <20260625121242.603807-2-anisa.su@samsung.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260625121242.603807-1-anisa.su@samsung.com>
References: <20260625121242.603807-1-anisa.su@samsung.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Ira Weiny <iweiny@kernel.org>

Dynamic capacity partitions are exposed as a singular dynamic ram
partition.

Add CXL library support to read this partition information, and use the
new partition in cxl-cli.

Signed-off-by: Ira Weiny <iweiny@kernel.org>
Signed-off-by: Anisa Su <anisa.su@samsung.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/cxl/lib/libcxl.txt |  6 +++--
 cxl/json.c                       | 20 +++++++++++++++
 cxl/lib/libcxl.c                 | 43 ++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  8 ++++++
 cxl/lib/private.h                |  3 +++
 cxl/libcxl.h                     | 10 +++++++-
 cxl/memdev.c                     |  4 ++-
 cxl/region.c                     | 27 +++++++++++++++++---
 8 files changed, 114 insertions(+), 7 deletions(-)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 5c3ebd4..59163e4 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -74,6 +74,7 @@ int cxl_memdev_get_major(struct cxl_memdev *memdev);
 int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dynamic_ram_1_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_version(struct cxl_memdev *memdev);
 size_t cxl_memdev_get_label_size(struct cxl_memdev *memdev);
 int cxl_memdev_nvdimm_bridge_active(struct cxl_memdev *memdev);
@@ -93,8 +94,8 @@ The character device node for command submission can be found by default
 at /dev/cxl/mem%d, or created with a major / minor returned from
 cxl_memdev_get_{major,minor}().
 
-The 'pmem_size' and 'ram_size' attributes return the current
-provisioning of DPA (Device Physical Address / local capacity) in the
+The 'pmem_size', 'ram_size', and 'dynamic_ram_1_size' attributes return the
+current provisioning of DPA (Device Physical Address / local capacity) in the
 device.
 
 cxl_memdev_get_numa_node() returns the affinitized CPU node number if
@@ -453,6 +454,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DYNAMIC_RAM_1,
 };
 enum cxl_decoder_mode cxl_decoder_get_mode(struct cxl_decoder *decoder);
 int cxl_decoder_set_mode(struct cxl_decoder *decoder, enum cxl_decoder_mode mode);
diff --git a/cxl/json.c b/cxl/json.c
index a925488..e832982 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -620,6 +620,20 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		}
 	}
 
+	size = cxl_memdev_get_dynamic_ram_1_size(memdev);
+	if (size) {
+		jobj = util_json_object_size(size, flags);
+		if (jobj)
+			json_object_object_add(jdev, "dynamic_ram_1_size", jobj);
+
+		qos_class = cxl_memdev_get_dynamic_ram_1_qos_class(memdev);
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdev, "dynamic_ram_1_qos_class", jobj);
+		}
+	}
+
 	if (flags & UTIL_JSON_HEALTH) {
 		jobj = util_cxl_memdev_health_to_json(memdev, flags);
 		if (jobj)
@@ -917,6 +931,12 @@ struct json_object *util_cxl_decoder_to_json(struct cxl_decoder *decoder,
 				json_object_object_add(
 					jdecoder, "volatile_capable", jobj);
 		}
+		if (cxl_decoder_is_dynamic_ram_1_capable(decoder)) {
+			jobj = json_object_new_boolean(true);
+			if (jobj)
+				json_object_object_add(
+					jdecoder, "dynamic_ram_1_capable", jobj);
+		}
 	}
 
 	if (cxl_port_is_root(port) &&
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index e55a7b4..240ed75 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -501,6 +501,9 @@ CXL_EXPORT bool cxl_region_qos_class_mismatch(struct cxl_region *region)
 		} else if (region->mode == CXL_DECODER_MODE_PMEM) {
 			if (root_decoder->qos_class != memdev->pmem_qos_class)
 				return true;
+		} else if (region->mode == CXL_DECODER_MODE_DYNAMIC_RAM_1) {
+			if (root_decoder->qos_class != memdev->dynamic_ram_1_qos_class)
+				return true;
 		}
 	}
 
@@ -1426,6 +1429,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	if (sysfs_read_attr(ctx, path, buf) == 0)
 		memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/dynamic_ram_1/size", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0)
+		memdev->dynamic_ram_1_size = strtoull(buf, NULL, 0);
+
 	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
@@ -1438,6 +1445,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	else
 		memdev->ram_qos_class = atoi(buf);
 
+	sprintf(path, "%s/dynamic_ram_1/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->dynamic_ram_1_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->dynamic_ram_1_qos_class = atoi(buf);
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) == 0) {
 		memdev->payload_max = strtoull(buf, NULL, 0);
@@ -1685,6 +1698,11 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
 	return memdev->ram_size;
 }
 
+CXL_EXPORT unsigned long long cxl_memdev_get_dynamic_ram_1_size(struct cxl_memdev *memdev)
+{
+	return memdev->dynamic_ram_1_size;
+}
+
 CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
 {
 	return memdev->pmem_qos_class;
@@ -1695,6 +1713,11 @@ CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
 	return memdev->ram_qos_class;
 }
 
+CXL_EXPORT int cxl_memdev_get_dynamic_ram_1_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->dynamic_ram_1_qos_class;
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
@@ -2465,6 +2488,8 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 		else if (strcmp(buf, "none") == 0)
 			decoder->mode = CXL_DECODER_MODE_NONE;
+		else if (strcmp(buf, "dynamic_ram_1") == 0)
+			decoder->mode = CXL_DECODER_MODE_DYNAMIC_RAM_1;
 		else
 			decoder->mode = CXL_DECODER_MODE_MIXED;
 	} else
@@ -2504,6 +2529,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	case CXL_PORT_SWITCH:
 		decoder->pmem_capable = true;
 		decoder->volatile_capable = true;
+		decoder->dynamic_ram_1_capable = true;
 		decoder->mem_capable = true;
 		decoder->accelmem_capable = true;
 		sprintf(path, "%s/locked", cxldecoder_base);
@@ -2528,6 +2554,7 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 			{ "cap_type3", &decoder->mem_capable },
 			{ "cap_ram", &decoder->volatile_capable },
 			{ "cap_pmem", &decoder->pmem_capable },
+			{ "cap_dynamic_ram_1", &decoder->dynamic_ram_1_capable },
 			{ "locked", &decoder->locked },
 		};
 
@@ -2778,6 +2805,9 @@ CXL_EXPORT int cxl_decoder_set_mode(struct cxl_decoder *decoder,
 	case CXL_DECODER_MODE_RAM:
 		sprintf(buf, "ram");
 		break;
+	case CXL_DECODER_MODE_DYNAMIC_RAM_1:
+		sprintf(buf, "dynamic_ram_1");
+		break;
 	default:
 		err(ctx, "%s: unsupported mode: %d\n",
 		    cxl_decoder_get_devname(decoder), mode);
@@ -2829,6 +2859,11 @@ CXL_EXPORT bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder)
 	return decoder->volatile_capable;
 }
 
+CXL_EXPORT bool cxl_decoder_is_dynamic_ram_1_capable(struct cxl_decoder *decoder)
+{
+	return decoder->dynamic_ram_1_capable;
+}
+
 CXL_EXPORT bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder)
 {
 	return decoder->mem_capable;
@@ -2903,6 +2938,8 @@ static struct cxl_region *cxl_decoder_create_region(struct cxl_decoder *decoder,
 		sprintf(path, "%s/create_pmem_region", decoder->dev_path);
 	else if (mode == CXL_DECODER_MODE_RAM)
 		sprintf(path, "%s/create_ram_region", decoder->dev_path);
+	else if (mode == CXL_DECODER_MODE_DYNAMIC_RAM_1)
+		sprintf(path, "%s/create_dynamic_ram_1_region", decoder->dev_path);
 
 	rc = sysfs_read_attr(ctx, path, buf);
 	if (rc < 0) {
@@ -2954,6 +2991,12 @@ cxl_decoder_create_ram_region(struct cxl_decoder *decoder)
 	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_RAM);
 }
 
+CXL_EXPORT struct cxl_region *
+cxl_decoder_create_dynamic_ram_1_region(struct cxl_decoder *decoder)
+{
+	return cxl_decoder_create_region(decoder, CXL_DECODER_MODE_DYNAMIC_RAM_1);
+}
+
 CXL_EXPORT int cxl_decoder_get_nr_targets(struct cxl_decoder *decoder)
 {
 	return decoder->nr_targets;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index ed4429f..4a8443c 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -320,3 +320,11 @@ LIBCXL_12 {
 global:
 	cxl_region_locked_state;
 } LIBCXL_11;
+
+LIBCXL_13 {
+global:
+	cxl_memdev_get_dynamic_ram_1_size;
+	cxl_memdev_get_dynamic_ram_1_qos_class;
+	cxl_decoder_is_dynamic_ram_1_capable;
+	cxl_decoder_create_dynamic_ram_1_region;
+} LIBCXL_12;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index d2d71fc..fb45e15 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -52,8 +52,10 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	unsigned long long dynamic_ram_1_size;
 	int ram_qos_class;
 	int pmem_qos_class;
+	int dynamic_ram_1_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
@@ -159,6 +161,7 @@ struct cxl_decoder {
 	unsigned int interleave_granularity;
 	bool pmem_capable;
 	bool volatile_capable;
+	bool dynamic_ram_1_capable;
 	bool mem_capable;
 	bool accelmem_capable;
 	bool locked;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index e91af90..8ee6937 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -75,8 +75,10 @@ struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+unsigned long long cxl_memdev_get_dynamic_ram_1_size(struct cxl_memdev *memdev);
 int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
 int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
+int cxl_memdev_get_dynamic_ram_1_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
@@ -210,6 +212,7 @@ enum cxl_decoder_mode {
 	CXL_DECODER_MODE_MIXED,
 	CXL_DECODER_MODE_PMEM,
 	CXL_DECODER_MODE_RAM,
+	CXL_DECODER_MODE_DYNAMIC_RAM_1,
 };
 
 static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
@@ -219,9 +222,10 @@ static inline const char *cxl_decoder_mode_name(enum cxl_decoder_mode mode)
 		[CXL_DECODER_MODE_MIXED] = "mixed",
 		[CXL_DECODER_MODE_PMEM] = "pmem",
 		[CXL_DECODER_MODE_RAM] = "ram",
+		[CXL_DECODER_MODE_DYNAMIC_RAM_1] = "dynamic_ram_1",
 	};
 
-	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_RAM)
+	if (mode < CXL_DECODER_MODE_NONE || mode > CXL_DECODER_MODE_DYNAMIC_RAM_1)
 		mode = CXL_DECODER_MODE_NONE;
 	return names[mode];
 }
@@ -235,6 +239,8 @@ cxl_decoder_mode_from_ident(const char *ident)
 		return CXL_DECODER_MODE_RAM;
 	else if (strcmp(ident, "pmem") == 0)
 		return CXL_DECODER_MODE_PMEM;
+	else if (strcmp(ident, "dynamic_ram_1") == 0)
+		return CXL_DECODER_MODE_DYNAMIC_RAM_1;
 	return CXL_DECODER_MODE_NONE;
 }
 
@@ -264,6 +270,7 @@ cxl_decoder_get_target_type(struct cxl_decoder *decoder);
 bool cxl_decoder_is_pmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_volatile_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_mem_capable(struct cxl_decoder *decoder);
+bool cxl_decoder_is_dynamic_ram_1_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_accelmem_capable(struct cxl_decoder *decoder);
 bool cxl_decoder_is_locked(struct cxl_decoder *decoder);
 unsigned int
@@ -272,6 +279,7 @@ unsigned int cxl_decoder_get_interleave_ways(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_get_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_pmem_region(struct cxl_decoder *decoder);
 struct cxl_region *cxl_decoder_create_ram_region(struct cxl_decoder *decoder);
+struct cxl_region *cxl_decoder_create_dynamic_ram_1_region(struct cxl_decoder *decoder);
 struct cxl_decoder *cxl_decoder_get_by_name(struct cxl_ctx *ctx,
 					    const char *ident);
 struct cxl_memdev *cxl_decoder_get_memdev(struct cxl_decoder *decoder);
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 6e44d15..c9a1d0c 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -269,8 +269,10 @@ static int __reserve_dpa(struct cxl_memdev *memdev,
 
 	if (mode == CXL_DECODER_MODE_RAM)
 		avail_dpa = cxl_memdev_get_ram_size(memdev);
-	else
+	else if (mode == CXL_DECODER_MODE_PMEM)
 		avail_dpa = cxl_memdev_get_pmem_size(memdev);
+	else
+		avail_dpa = cxl_memdev_get_dynamic_ram_1_size(memdev);
 
 	cxl_decoder_foreach(port, decoder) {
 		size = cxl_decoder_get_dpa_size(decoder);
diff --git a/cxl/region.c b/cxl/region.c
index 85d4d9b..0a62a8e 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -303,7 +303,8 @@ static int parse_create_options(struct cxl_ctx *ctx, int count,
 
 	if (param.type) {
 		p->mode = cxl_decoder_mode_from_ident(param.type);
-		if (p->mode == CXL_DECODER_MODE_RAM && param.uuid) {
+		if ((p->mode == CXL_DECODER_MODE_RAM ||
+		     p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_1) && param.uuid) {
 			log_err(&rl,
 				"can't set UUID for ram / volatile regions");
 			goto err;
@@ -417,6 +418,9 @@ static void collect_minsize(struct cxl_ctx *ctx, struct parsed_params *p)
 		case CXL_DECODER_MODE_PMEM:
 			size = cxl_memdev_get_pmem_size(memdev);
 			break;
+		case CXL_DECODER_MODE_DYNAMIC_RAM_1:
+			size = cxl_memdev_get_dynamic_ram_1_size(memdev);
+			break;
 		default:
 			/* Shouldn't ever get here */ ;
 		}
@@ -448,8 +452,10 @@ static int create_region_validate_qos_class(struct parsed_params *p)
 
 		if (p->mode == CXL_DECODER_MODE_RAM)
 			qos_class = cxl_memdev_get_ram_qos_class(memdev);
-		else
+		else if (p->mode == CXL_DECODER_MODE_PMEM)
 			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+		else
+			qos_class = cxl_memdev_get_dynamic_ram_1_qos_class(memdev);
 
 		/* No qos_class entries. Possibly no kernel support */
 		if (qos_class == CXL_QOS_CLASS_NONE)
@@ -488,6 +494,12 @@ static int validate_decoder(struct cxl_decoder *decoder,
 			return -EINVAL;
 		}
 		break;
+	case CXL_DECODER_MODE_DYNAMIC_RAM_1:
+		if (!cxl_decoder_is_dynamic_ram_1_capable(decoder)) {
+			log_err(&rl, "%s is not dynamic_ram_1 capable\n", devname);
+			return -EINVAL;
+		}
+		break;
 	default:
 		log_err(&rl, "unknown type: %s\n", param.type);
 		return -EINVAL;
@@ -509,9 +521,11 @@ static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
 		return;
 
 	/*
-	 * default to pmem if both types are set, otherwise the single
+	 * default to pmem if all types are set, otherwise the single
 	 * capability dominates.
 	 */
+	if (cxl_decoder_is_dynamic_ram_1_capable(p->root_decoder))
+		p->mode = CXL_DECODER_MODE_DYNAMIC_RAM_1;
 	if (cxl_decoder_is_volatile_capable(p->root_decoder))
 		p->mode = CXL_DECODER_MODE_RAM;
 	if (cxl_decoder_is_pmem_capable(p->root_decoder))
@@ -699,6 +713,13 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 				param.root_decoder);
 			return -ENXIO;
 		}
+	} else if (p->mode == CXL_DECODER_MODE_DYNAMIC_RAM_1) {
+		region = cxl_decoder_create_dynamic_ram_1_region(p->root_decoder);
+		if (!region) {
+			log_err(&rl, "failed to create region under %s\n",
+				param.root_decoder);
+			return -ENXIO;
+		}
 	} else {
 		log_err(&rl, "region type '%s' is not supported\n",
 			param.type);
-- 
2.43.0

