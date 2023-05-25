Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBCC01EA8B
	for <nvdimm@lists.linux.dev>; Thu, 25 May 2023 21:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685050845; x=1716586845;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=28mY73y7A9qn9lFFLXyXDzbQPMN6D9GSBchf9t+JBzY=;
  b=CqgQ1WYbd8K+nJSrIEtIngvS1RSU1DeA8AVtjZoMIhBxNcAa7z8hy6ck
   2Gd7NelPZqtlbXOxLHS4BP/v2L4qsYfCPYgqBfvyxFfxl6xeRsO9LZnyI
   x7qcze+USDwXTSNVRBZevtvZkM+SJr9LFOrjdj1QfXgrdUIYWj0Nfl9sv
   dvLb8cftk6ESz5Ph93Mod242HgFDyh0iXjEp+gsbbgWEojw58Tuzd8FJs
   WBHm7Dd1WxGodWJ72GazIJhBR+wYC4cxA23xa+wt5rH51YjhEtHDXvYZJ
   PRRkDxK62JFRS9k6t3tc3r84vfR+yhhFBQkvvW8yBJwGTzlZrtalJiNhw
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="351544768"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="351544768"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10721"; a="879297362"
X-IronPort-AV: E=Sophos;i="6.00,192,1681196400"; 
   d="scan'208";a="879297362"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.212.85.172])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2023 14:40:44 -0700
Subject: [ndctl PATCH v2 2/3] ndctl: cxl: Add QoS class support for the memory
 device
From: Dave Jiang <dave.jiang@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 25 May 2023 14:40:43 -0700
Message-ID: <168505084360.2768411.18081838553625454981.stgit@djiang5-mobl3>
In-Reply-To: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
References: <168505076089.2768411.10498775803334230215.stgit@djiang5-mobl3>
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
 cxl/json.c         |   36 +++++++++++++++++++++++++++++++++++-
 cxl/lib/libcxl.c   |   50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym |    2 ++
 cxl/lib/private.h  |    2 ++
 cxl/libcxl.h       |    7 +++++++
 5 files changed, 96 insertions(+), 1 deletion(-)

diff --git a/cxl/json.c b/cxl/json.c
index 293ba807b44b..448531822b45 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -480,12 +480,32 @@ err_jobj:
 	return NULL;
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
@@ -501,6 +521,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
@@ -508,6 +535,13 @@ struct json_object *util_cxl_memdev_to_json(struct cxl_memdev *memdev,
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
index 6312676a6d22..a17d298ae144 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -73,6 +73,10 @@ static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
 	free(memdev->host_path);
+	if (memdev->ram_qos_class.nr)
+		free(memdev->ram_qos_class.qos);
+	if (memdev->pmem_qos_class.nr)
+		free(memdev->pmem_qos_class.qos);
 	free(memdev);
 }
 
@@ -1175,6 +1179,27 @@ static void *add_cxl_pmem(void *parent, int id, const char *br_base)
 	return NULL;
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
@@ -1184,6 +1209,7 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 	char buf[SYSFS_ATTR_SIZE];
 	struct stat st;
 	char *host;
+	int qnr;
 
 	if (!path)
 		return NULL;
@@ -1211,6 +1237,20 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->ram_size = strtoull(buf, NULL, 0);
 
+	sprintf(path, "%s/pmem/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		goto err_read;
+
+	memdev->pmem_qos_class.qos = get_qos_class(ctx, buf, &qnr);
+	memdev->pmem_qos_class.nr = qnr;
+
+	sprintf(path, "%s/ram/qos_class", cxlmem_base);
+	if (sysfs_read_attr(ctx, path, buf) < 0)
+		goto err_read;
+
+	memdev->ram_qos_class.qos = get_qos_class(ctx, buf, &qnr);
+	memdev->ram_qos_class.nr = qnr;
+
 	sprintf(path, "%s/payload_max", cxlmem_base);
 	if (sysfs_read_attr(ctx, path, buf) < 0)
 		goto err_read;
@@ -1369,6 +1409,16 @@ CXL_EXPORT unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev)
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
index 134406258ddf..8eda705ce5a1 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -253,4 +253,6 @@ global:
 
 LIBCXL_6 {
 	cxl_root_decoder_get_qos_class;
+	cxl_memdev_get_pmem_qos_class;
+	cxl_memdev_get_ram_qos_class;
 } LIBCXL_5;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b00aa4752de5..c48aa2ed2252 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -32,6 +32,8 @@ struct cxl_memdev {
 	struct list_node list;
 	unsigned long long pmem_size;
 	unsigned long long ram_size;
+	struct qos_class ram_qos_class;
+	struct qos_class pmem_qos_class;
 	int payload_max;
 	size_t lsa_size;
 	struct kmod_module *module;
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 9684a8571e88..7ae0453416de 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -33,6 +33,11 @@ void *cxl_get_userdata(struct cxl_ctx *ctx);
 void cxl_set_private_data(struct cxl_ctx *ctx, void *data);
 void *cxl_get_private_data(struct cxl_ctx *ctx);
 
+struct qos_class {
+	int nr;
+	int *qos;
+};
+
 struct cxl_memdev;
 struct cxl_memdev *cxl_memdev_get_first(struct cxl_ctx *ctx);
 struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
@@ -47,6 +52,8 @@ int cxl_memdev_get_minor(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
+struct qos_class *cxl_memdev_get_pmem_qos_class(struct cxl_memdev *memdev);
+struct qos_class *cxl_memdev_get_ram_qos_class(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 
 /* ABI spelling mistakes are forever */


