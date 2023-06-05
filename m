Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171E4DDC0
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 20:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685996474; x=1717532474;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=J8Nfv+kzAtWjVhkwwH6Z8qaOCS1RLetx48jsfYGvsG8=;
  b=j9qlG6HM9I+psDTse1nP9V65m+JPRxzGkqkinrmAr3qzE2PlWOuJXnCE
   vjgX1iNcrQHYOOlb/l7zCdoFNnlzNV03ZD+fbeYp7ZgaE2fvfuOqXSKsH
   LG8uLrTar2UVp3c182LtBQaOUKdbKV8dhZLlCVGk5Hs+gPkwcjQke+iaT
   YQnBAe9/VH8D6d3HmI+NTeZV2MEAiKYr06jUjrF6Av8C8/BmJ/ko7ovy/
   26DB6JdLOQEUyWQtwymspfK5R/jQYB0WE+sCxXKsKx6u2tumhFi7XbhYW
   X0YfWpJE+kQb4l0bLv3oQd7XkDYZ/INMpvvPzrbmNPzsBjmew1lV2EYV0
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336093178"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336093178"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="832934310"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="832934310"
Received: from kmsalzbe-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.52.9])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:11 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 05 Jun 2023 14:21:05 -0600
Subject: [PATCH ndctl v2 3/5] cxl/fw_loader: add APIs to get current state
 of the FW loader mechanism
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-vv-fw_update-v2-3-a778a15e860b@intel.com>
References: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
In-Reply-To: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=7944;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=J8Nfv+kzAtWjVhkwwH6Z8qaOCS1RLetx48jsfYGvsG8=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCl1ztvEwrOKv8/3vKj87ufE41seSE28esP6t7DWJN4Sj
 q0Z6x2jO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRQC9Ghrb/Ejbz49du/t4y
 zXyWEIPuMs20DNF9Lod0paXqNKS2ODIyPPZ6rDr118Hcwryiuti/O+3ylRSW31z5J3Ei/421H3f
 2cQAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add a way to interface with the firmware loader mechanism for cxl
memdevs. Add APIs to retrieve the current status of the fw loader, and
the remaining size if a fw upload is in progress. Display these in the
'firmware' section of memdev listings.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/private.h  | 10 ++++++
 cxl/lib/libcxl.c   | 95 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 cxl/libcxl.h       | 27 ++++++++++++++++
 cxl/json.c         | 13 ++++++++
 cxl/lib/libcxl.sym |  2 ++
 5 files changed, 147 insertions(+)

diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 590d719..95e0c43 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -20,6 +20,15 @@ struct cxl_pmem {
 	char *dev_path;
 };
 
+struct cxl_fw_loader {
+	char *dev_path;
+	char *loading;
+	char *data;
+	char *remaining;
+	char *cancel;
+	char *status;
+};
+
 struct cxl_endpoint;
 struct cxl_memdev {
 	int id, major, minor;
@@ -39,6 +48,7 @@ struct cxl_memdev {
 	struct cxl_pmem *pmem;
 	unsigned long long serial;
 	struct cxl_endpoint *endpoint;
+	struct cxl_fw_loader *fwl;
 };
 
 struct cxl_dport {
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 90dce22..5f74138 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -63,12 +63,25 @@ static void free_pmem(struct cxl_pmem *pmem)
 	}
 }
 
+static void free_fwl(struct cxl_fw_loader *fwl)
+{
+	if (fwl) {
+		free(fwl->loading);
+		free(fwl->data);
+		free(fwl->remaining);
+		free(fwl->cancel);
+		free(fwl->status);
+		free(fwl);
+	}
+}
+
 static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 {
 	if (head)
 		list_del_from(head, &memdev->list);
 	kmod_module_unref(memdev->module);
 	free_pmem(memdev->pmem);
+	free_fwl(memdev->fwl);
 	free(memdev->firmware_version);
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
@@ -1174,6 +1187,40 @@ static void *add_cxl_pmem(void *parent, int id, const char *br_base)
 	return NULL;
 }
 
+static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
+			      const char *cxlmem_base)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_fw_loader *fwl;
+
+	fwl = calloc(1, sizeof(*fwl));
+	if (!fwl)
+		return -ENOMEM;
+
+	if (asprintf(&fwl->loading, "%s/firmware/%s/loading", cxlmem_base,
+		     devname) < 0)
+		goto err_read;
+	if (asprintf(&fwl->data, "%s/firmware/%s/data", cxlmem_base, devname) <
+	    0)
+		goto err_read;
+	if (asprintf(&fwl->remaining, "%s/firmware/%s/remaining_size",
+		     cxlmem_base, devname) < 0)
+		goto err_read;
+	if (asprintf(&fwl->cancel, "%s/firmware/%s/cancel", cxlmem_base,
+		     devname) < 0)
+		goto err_read;
+	if (asprintf(&fwl->status, "%s/firmware/%s/status", cxlmem_base,
+		     devname) < 0)
+		goto err_read;
+
+	memdev->fwl = fwl;
+	return 0;
+
+ err_read:
+	free_fwl(fwl);
+	return -ENOMEM;
+}
+
 static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 {
 	const char *devname = devpath_to_devname(cxlmem_base);
@@ -1263,6 +1310,9 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 
 	device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_pmem);
 
+	if (add_cxl_memdev_fwl(memdev, cxlmem_base))
+		goto err_read;
+
 	cxl_memdev_foreach(ctx, memdev_dup)
 		if (memdev_dup->id == memdev->id) {
 			free_memdev(memdev, NULL);
@@ -1373,6 +1423,51 @@ CXL_EXPORT const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev
 	return memdev->firmware_version;
 }
 
+static enum cxl_fwl_status cxl_fwl_get_status(struct cxl_memdev *memdev)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_fw_loader *fwl = memdev->fwl;
+	char buf[SYSFS_ATTR_SIZE];
+	int rc;
+
+	rc = sysfs_read_attr(ctx, fwl->status, buf);
+	if (rc < 0) {
+		err(ctx, "%s: failed to get fw loader status (%s)\n", devname,
+		    strerror(-rc));
+		return CXL_FWL_STATUS_UNKNOWN;
+	}
+
+	return cxl_fwl_status_from_ident(buf);
+}
+
+CXL_EXPORT bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev)
+{
+	int status = cxl_fwl_get_status(memdev);
+
+	if (status == CXL_FWL_STATUS_IDLE)
+		return false;
+	return true;
+}
+
+CXL_EXPORT size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_fw_loader *fwl = memdev->fwl;
+	char buf[SYSFS_ATTR_SIZE];
+	int rc;
+
+	rc = sysfs_read_attr(ctx, fwl->remaining, buf);
+	if (rc < 0) {
+		err(ctx, "%s: failed to get fw loader remaining size (%s)\n",
+		    devname, strerror(-rc));
+		return 0;
+	}
+
+	return strtoull(buf, NULL, 0);
+}
+
 static void bus_invalidate(struct cxl_bus *bus)
 {
 	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 99e1b76..7509abe 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -33,6 +33,31 @@ void *cxl_get_userdata(struct cxl_ctx *ctx);
 void cxl_set_private_data(struct cxl_ctx *ctx, void *data);
 void *cxl_get_private_data(struct cxl_ctx *ctx);
 
+enum cxl_fwl_status {
+	CXL_FWL_STATUS_UNKNOWN,
+	CXL_FWL_STATUS_IDLE,
+	CXL_FWL_STATUS_RECEIVING,
+	CXL_FWL_STATUS_PREPARING,
+	CXL_FWL_STATUS_TRANSFERRING,
+	CXL_FWL_STATUS_PROGRAMMING,
+};
+
+static inline enum cxl_fwl_status cxl_fwl_status_from_ident(char *status)
+{
+	if (strcmp(status, "idle") == 0)
+		return CXL_FWL_STATUS_IDLE;
+	if (strcmp(status, "receiving") == 0)
+		return CXL_FWL_STATUS_RECEIVING;
+	if (strcmp(status, "preparing") == 0)
+		return CXL_FWL_STATUS_PREPARING;
+	if (strcmp(status, "transferring") == 0)
+		return CXL_FWL_STATUS_TRANSFERRING;
+	if (strcmp(status, "programming") == 0)
+		return CXL_FWL_STATUS_PROGRAMMING;
+
+	return CXL_FWL_STATUS_UNKNOWN;
+}
+
 struct cxl_memdev;
 struct cxl_memdev *cxl_memdev_get_first(struct cxl_ctx *ctx);
 struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
@@ -48,6 +73,8 @@ struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
+bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
+size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
 
 /* ABI spelling mistakes are forever */
 static inline const char *cxl_memdev_get_firmware_version(
diff --git a/cxl/json.c b/cxl/json.c
index e6bb061..5dc0bd3 100644
--- a/cxl/json.c
+++ b/cxl/json.c
@@ -22,6 +22,7 @@ static struct json_object *util_cxl_memdev_fw_to_json(
 	struct json_object *jfw;
 	u32 field, num_slots;
 	struct cxl_cmd *cmd;
+	size_t remaining;
 	int rc, i;
 
 	jfw = json_object_new_object();
@@ -79,6 +80,18 @@ static struct json_object *util_cxl_memdev_fw_to_json(
 			json_object_object_add(jfw, jkey, jobj);
 	}
 
+	rc = cxl_memdev_fw_update_in_progress(memdev);
+	jobj = json_object_new_boolean(rc);
+	if (jobj)
+		json_object_object_add(jfw, "fw_update_in_progress", jobj);
+
+	if (rc == true) {
+		remaining = cxl_memdev_fw_update_get_remaining(memdev);
+		jobj = util_json_object_size(remaining, flags);
+		if (jobj)
+			json_object_object_add(jfw, "remaining_size", jobj);
+	}
+
 	cxl_cmd_unref(cmd);
 	return jfw;
 
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 16a8671..9438877 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -254,4 +254,6 @@ global:
 	cxl_cmd_fw_info_get_staged_slot;
 	cxl_cmd_fw_info_get_online_activate_capable;
 	cxl_cmd_fw_info_get_fw_ver;
+	cxl_memdev_fw_update_in_progress;
+	cxl_memdev_fw_update_get_remaining;
 } LIBCXL_4;

-- 
2.40.1

