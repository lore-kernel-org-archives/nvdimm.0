Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ACFA3612A;
	Thu,  8 Feb 2024 20:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707423312; cv=none; b=sgN2VpIKDvd2XibOFD2gK/WQVdCJuXIGh/Fa3ZGPTyfSwIlqOhIG1rqJAg8EKOHUU7oy0afuNUZ8yrK/HMvl9EZr91oIeSmf42Nco8+J2RcfIQ2O+5PR6M5REMjrTbJOuagYnBdISrV0z2Jl2suqJwTu3Hchjy2DCLwVTbT7h7A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707423312; c=relaxed/simple;
	bh=QQslDRUw3qJ5pjWjjXuFKY/uwOEaJc0CC+jkUSPMC5g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXRp6xmpPyPLCg/ChKxPXdj7IWq3KUwTR80DF8i6mdUHFLwSE+Zl23mMSWq1j0CjGPTfC2Vh/lkSeu4sqeotKhPpuHnAANSJWxNi7hMuCSQ49j2eBHzaZKDvnTTZxoOQTYVExEhQvDMSbH4FGi9YW991Ls27uW9kkurY11iODP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0DE1C433F1;
	Thu,  8 Feb 2024 20:15:11 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com,
	Alison Schofield <alison.schofield@intel.com>
Subject: [NDCTL PATCH v7 2/4] ndctl: cxl: Add QoS class support for the memory device
Date: Thu,  8 Feb 2024 13:11:56 -0700
Message-ID: <20240208201435.2081583-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240208201435.2081583-1-dave.jiang@intel.com>
References: <20240208201435.2081583-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add libcxl API to retrieve the QoS class tokens for the memory
devices. Two API calls are added. One for 'ram' or 'volatile'
mode and another for 'pmem' or 'persistent' mode. Support also added
for displaying the QoS class tokens through the 'cxl list' command.

Reviewed-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v7: Add check for invalid qos_class for json
---
 cxl/json.c         | 15 +++++++++++++++
 cxl/lib/libcxl.c   | 22 ++++++++++++++++++++++
 cxl/lib/libcxl.sym |  2 ++
 cxl/lib/private.h  |  2 ++
 cxl/libcxl.h       |  2 ++
 5 files changed, 43 insertions(+)

diff --git a/cxl/json.c b/cxl/json.c
index 1d380e23d6ff..c8bd8c27447a 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -777,6 +777,7 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 	struct json_object *jdev, *jobj;
 	unsigned long long serial, size;
 	int numa_node;
+	int qos_class;
 
 	jdev = json_object_new_object();
 	if (!jdev)
@@ -791,6 +792,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdev, "pmem_size", jobj);
+
+		qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdev, "pmem_qos_class", jobj);
+		}
 	}
 
 	size = cxl_memdev_get_ram_size(memdev);
@@ -798,6 +806,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdev, "ram_size", jobj);
+
+		qos_class = cxl_memdev_get_ram_qos_class(memdev);
+		if (qos_class != CXL_QOS_CLASS_NONE) {
+			jobj = json_object_new_int(qos_class);
+			if (jobj)
+				json_object_object_add(jdev, "ram_qos_class", jobj);
+		}
 	}
 
 	if (flags & UTIL_JSON_HEALTH) {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 9a1ac7001803..6c293f1dfc91 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1260,6 +1260,18 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->pmem_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->pmem_qos_class = atoi(buf);
+
+	sprintf(path, "%s/ram/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		memdev->ram_qos_class = CXL_QOS_CLASS_NONE;
+	else
+		memdev->ram_qos_class = atoi(buf);
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1483,6 +1495,16 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
 	return memdev->ram_size;
 }
 
+CXL_EXPORT int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->pmem_qos_class;
+}
+
+CXL_EXPORT int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
+{
+	return memdev->ram_qos_class;
+}
+
 CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev)
 {
 	return memdev->firmware_version;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 384fea2c25e3..465c78dc6c70 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -283,4 +283,6 @@ LIBCXL_8 {
 global:
 	cxl_memdev_wait_sanitize;
 	cxl_root_decoder_get_qos_class;
+	cxl_memdev_get_pmem_qos_class;
+	cxl_memdev_get_ram_qos_class;
 } LIBCXL_7;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 4847ff448f71..07dc8c784f1d 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -47,6 +47,8 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	int ram_qos_class;
+	int pmem_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index e5c08da77f77..a180f01cb05e 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -72,6 +72,8 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+int cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
+int cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
-- 
2.43.0

