Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 370B91350DA
	for <nvdimm@lists.linux.dev>; Wed, 24 Jan 2024 20:54:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706129691; cv=none; b=RJNgJRCsUqY29C/JIVUglaZXMaN6Ys/K7IpyfCIxZvx5s/B5eqnqzxVOZGNEis+SlVslrvlRX5XgWQC0RpqQfSAQro7asMKJvlR7du49+vBnMs7DYeApYw0RQo12tczaPDD+GAdzPzRCssnghBV0Wu5bH/KmyzJSdDpt4s8FcEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706129691; c=relaxed/simple;
	bh=SHRs6MPmhLAgF8cpr9X+b3D3wu0tGINLkiReh3hFoNk=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XG+SWUaV0iizBsi1fjVMLlg+iMKAi3uG/GArE/YExqLANtmwUF1kAix2kn8+de8P6viNkwlopJpERSPit+OMtBHWUW5WgJAQvSvdvLhUNR3wV6tl4GfmcmeSq+SAKsy/IvDMTVXQHHGL1+lqX1BvYT2P7w+vAXxmS87CywWFyp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=UlMFyaTh; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="UlMFyaTh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1706129689; x=1737665689;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SHRs6MPmhLAgF8cpr9X+b3D3wu0tGINLkiReh3hFoNk=;
  b=UlMFyaThfbfH8k2Ah8MHSU9Ic2Mz9ha9H3cs/bCp3u2GOPmAIm+dtEUh
   v2jBxir83dIXm8vdm4EyEMGpklvcRezHZaSnAm0SdcxraMM7jJWM9pOz1
   Xyn4cV3cMQIO9eAUu8a2Ery8uSW7TIWxldgde+eQQClBT7etmNei/UPAF
   fmJuhvf+sqFj3reBbs0OAM7nrVNwr7OFg0QU3M4V5SyAkwn8/KKE7620m
   aXdgaSA+4cawiD28vxgNbfBip5ra+hjc4mUue00qGiJ3HLj/mols9VFUM
   ZoCM3I0U/VY8hUiudcG4JIqBiAZc+CTXMTyIuF7oMdziNMBE++k+whkp4
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="20524161"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="20524161"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10962"; a="786538948"
X-IronPort-AV: E=Sophos;i="6.05,216,1701158400"; 
   d="scan'208";a="786538948"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.209.164.29])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Jan 2024 12:54:48 -0800
Subject: [NDCTL PATCH v3 2/3] ndctl: cxl: Add QoS class support for the memory
 device
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 24 Jan 2024 13:54:47 -0700
Message-ID: <170612968788.2745924.12035270102793649199.stgit@djiang5-mobl3>
In-Reply-To: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
References: <170612961495.2745924.4942817284170536877.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add libcxl API to retrieve the QoS class tokens for the memory
devices. Two API calls are added. One for 'ram' or 'volatile'
mode and another for 'pmem' or 'persistent' mode. Support also added
for displaying the QoS class tokens through the 'cxl list' command.
There can be 1 or more QoS class tokens for the memory device if
they are valid. The qos_class tokens are displayed behind -vvv
verbose level.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v3:
- Rebase to pending branch
- Skip from failing if no qos_class sysfs attrib found
---
 cxl/json.c         |   36 +++++++++++++++++++++++++++++++++++-
 cxl/lib/libcxl.c   |   48 ++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |    2 ++
 cxl/lib/private.h  |    2 ++
 cxl/libcxl.h       |    7 +++++++
 5 files changed, 94 insertions(+), 1 deletion(-)

diff --git a/cxl/json.c b/cxl/json.c
index 48a43ddf14b0..dcbac8c14f03 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -770,12 +770,32 @@ err_free:
 	return jpoison;
 }
 
+static struct json_object *get_qos_json_object(struct json_object *jdev,
+					       struct qos_class *qos_class)
+{
+	struct json_object *jqos_array = json_object_new_array();
+	struct json_object *jobj;
+	int i;
+
+	if (!jqos_array)
+		return NULL;
+
+	for (i = 0; i < qos_class->nr; i++) {
+		jobj = json_object_new_int(qos_class->qos[i]);
+		if (jobj)
+			json_object_array_add(jqos_array, jobj);
+	}
+
+	return jqos_array;
+}
+
 struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		unsigned long flags)
 {
 	const char *devname = cxl_memdev_get_devname(memdev);
-	struct json_object *jdev, *jobj;
+	struct json_object *jdev, *jobj, *jqos;
 	unsigned long long serial, size;
+	struct qos_class *qos_class;
 	int numa_node;
 
 	jdev = json_object_new_object();
@@ -791,6 +811,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdev, "pmem_size", jobj);
+
+		if (flags & UTIL_JSON_QOS_CLASS) {
+			qos_class = cxl_memdev_get_pmem_qos_class(memdev);
+			jqos = get_qos_json_object(jdev, qos_class);
+			if (jqos)
+				json_object_object_add(jdev, "pmem_qos_class", jqos);
+		}
 	}
 
 	size = cxl_memdev_get_ram_size(memdev);
@@ -798,6 +825,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
 		jobj = util_json_object_size(size, flags);
 		if (jobj)
 			json_object_object_add(jdev, "ram_size", jobj);
+
+		if (flags & UTIL_JSON_QOS_CLASS) {
+			qos_class = cxl_memdev_get_ram_qos_class(memdev);
+			jqos = get_qos_json_object(jdev, qos_class);
+			if (jqos)
+				json_object_object_add(jdev, "ram_qos_class", jqos);
+		}
 	}
 
 	if (flags & UTIL_JSON_HEALTH) {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 9a1ac7001803..c69a18c4d237 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -88,6 +88,10 @@ static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
 	free(memdev->host_path);
+	if (memdev->ram_qos_class.nr)
+		free(memdev->ram_qos_class.qos);
+	if (memdev->pmem_qos_class.nr)
+		free(memdev->pmem_qos_class.qos);
 	free(memdev);
 }
 
@@ -1224,6 +1228,27 @@ static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
 	return -ENOMEM;
 }
 
+static int *get_qos_class(struct cxl_ctx *ctx, char *buf, int *entries)
+{
+	int *varray = NULL;
+	int i = 0;
+	char *p;
+
+	p = strtok(buf, ",");
+	while (p != NULL) {
+		int val = atoi(p);
+
+		varray = reallocarray(varray, i + 1, sizeof(int));
+		varray[i] = val;
+		p = strtok(NULL, ",");
+		i++;
+	}
+
+	*entries = i;
+
+	return varray;
+}
+
 static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 {
 	const char *devname = devpath_to_devname(cxlmem_base);
@@ -1233,6 +1258,7 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	char buf[SYSFS_ATTR_SIZE];
 	struct stat st;
 	char *host;
+	int qnr;
 
 	if (!path)
 		return NULL;
@@ -1260,6 +1286,18 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->pmem_qos_class.qos = get_qos_class(ctx, buf, &qnr);
+		memdev->pmem_qos_class.nr = qnr;
+	}
+
+	sprintf(path, "%s/ram/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) == 0) {
+		memdev->ram_qos_class.qos = get_qos_class(ctx, buf, &qnr);
+		memdev->ram_qos_class.nr = qnr;
+	}
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1483,6 +1521,16 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
 	return memdev->ram_size;
 }
 
+CXL_EXPORT struct qos_class *cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev)
+{
+	return &memdev->pmem_qos_class;
+}
+
+CXL_EXPORT struct qos_class *cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev)
+{
+	return &memdev->ram_qos_class;
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
index 4847ff448f71..1fe3654bc7ff 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -47,6 +47,8 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	struct qos_class ram_qos_class;
+	struct qos_class pmem_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index e5c08da77f77..84d1683f234c 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -58,6 +58,11 @@ static inline enum cxl_fwl_status cxl_fwl_status_from_ident(char *status)
 	return CXL_FWL_STATUS_UNKNOWN;
 }
 
+struct qos_class {
+	int nr;
+	int *qos;
+};
+
 struct cxl_memdev;
 struct cxl_memdev *cxl_memdev_get_first(struct cxl_ctx *ctx);
 struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
@@ -72,6 +77,8 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+struct qos_class *cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
+struct qos_class *cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);


