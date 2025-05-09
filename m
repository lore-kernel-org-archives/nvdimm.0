Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1EFF2367D8;
	Fri,  9 May 2025 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746808813; cv=none; b=cZxyoModbm34BAKTubPzDKSjrTwerBMaChUryXXedaf7O43CTLDA5xJ9NiIh79iyBUQVqw3SuBzaYdqU1927bJ97uJ9t57dO35mKNwZ/rLjfetUBtVVbqjyn2Rf8QvO+kJ6iPKds/hY7HQJnmrzoompas3DoWKh2eUq/qialurk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746808813; c=relaxed/simple;
	bh=hsmKfE0PzZQOfkeVk/T7wiFYSRoF2b3dnz5RTMtAwFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iQrADdNE5S8bvp0VojqWkEw6gGPz1SbHRd/on137bEiusfON1j7daxQ0F529uJGL+AR8q5HgvFt+Ahodarx1tGe+M5FJmkP0w6gBCwsa0os3BVX3qNGPyY035cK2Sy3cq1HYNW7Ik6WT0Ln1mrgu3GhScRd1hSKtxY0Ibf9w7yQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51019C4CEE4;
	Fri,  9 May 2025 16:40:12 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: [NDCTL PATCH v6 2/4] cxl: Enumerate major/minor of FWCTL char device
Date: Fri,  9 May 2025 09:39:13 -0700
Message-ID: <20250509164006.687873-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250509164006.687873-1-dave.jiang@intel.com>
References: <20250509164006.687873-1-dave.jiang@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add major/minor discovery for the FWCTL character device that is associated
with supprting CXL Features under 'struct cxl_fwctl'. A 'struct cxl_fwctl'
may be installed under cxl_memdev if CXL Features are supported and FWCTL
is enabled. Add libcxl API functions to retrieve the major and minor of the
FWCTL character device.

Acked-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
v6:
- Fixup documentation. (Dan)
- Remove CXL_PATH_MAX and temp buffer usages. (Dan)
	- Move to after memdev->dev_buf has been allocated.
---
 Documentation/cxl/lib/libcxl.txt | 22 +++++++++
 cxl/lib/libcxl.c                 | 79 ++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  3 ++
 cxl/lib/private.h                |  6 +++
 cxl/libcxl.h                     |  5 ++
 5 files changed, 115 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 25ff406c2920..75edf0859376 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -42,6 +42,7 @@ struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_host(struct cxl_memdev *memdev)
 struct cxl_memdev *cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint);
+struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
@@ -59,6 +60,9 @@ specific memdev.
 The host of a memdev is the PCIe Endpoint device that registered its CXL
 capabilities with the Linux CXL core.
 
+A memdev may host a 'struct cxl_fwctl' if CXL Features are supported,
+CONFIG_CXL_FEATURES is enabled, and Firmware Control (FWCTL) is also enabled.
+
 === MEMDEV: Attributes
 ----
 int cxl_memdev_get_id(struct cxl_memdev *memdev);
@@ -185,6 +189,24 @@ device is in use. When CXL_SETPART_NEXTBOOT mode is set, the change
 in partitioning shall become the “next” configuration, to become
 active on the next device reset.
 
+FWCTL
+-----
+The object representing a Firmware Control (FWCTL) device is 'struct cxl_fwctl'.
+Library interfaces related to these devices have the prefix 'cxl_fwctl_'.
+These interfaces are associated with interacting with the FWCTL aspect of the
+memdev. And currently specifically with the CXL FWCTL character device that is
+a child of the memdev.
+
+=== FWCTL: Attributes
+----
+int cxl_fwctl_get_major(struct cxl_memdev *memdev);
+int cxl_fwctl_get_minor(struct cxl_memdev *memdev);
+----
+
+The character device node for Feature (firmware) control can be found by
+default at /dev/fwctl/fwctl%d, or created with a major / minor returned
+from cxl_memdev_get_fwctl_{major,minor}().
+
 BUSES
 -----
 The CXL Memory space is CPU and Device coherent. The address ranges that
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index bab7343e8a4a..19c463c968f3 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -88,6 +88,7 @@ static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
 	free(memdev->host_path);
+	free(memdev->fwctl);
 	free(memdev);
 }
 
@@ -1253,6 +1254,65 @@ static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
 	return -ENOMEM;
 }
 
+static const char fwctl_prefix[] = "fwctl";
+static int get_feature_chardev(struct cxl_memdev *memdev, const char *base,
+			       char *chardev_path)
+{
+	char *path = memdev->dev_buf;
+	struct dirent *entry;
+	bool found = false;
+	int rc = 0;
+	DIR *dir;
+
+	sprintf(path, "%s/fwctl/", base);
+	dir = opendir(path);
+	if (!dir)
+		return -errno;
+
+	while ((entry = readdir(dir)) != NULL) {
+		if (strncmp(entry->d_name, fwctl_prefix, strlen(fwctl_prefix)) == 0) {
+			found = true;
+			break;
+		}
+	}
+
+	if (!entry || !found) {
+		rc = -ENOENT;
+		goto read_err;
+	}
+
+	sprintf(chardev_path, "/dev/fwctl/%s", entry->d_name);
+
+read_err:
+	closedir(dir);
+	return rc;
+}
+
+static int memdev_add_fwctl(struct cxl_memdev *memdev, const char *cxlmem_base)
+{
+	char *path = memdev->dev_buf;
+	struct cxl_fwctl *fwctl;
+	struct stat st;
+	int rc;
+
+	rc = get_feature_chardev(memdev, cxlmem_base, path);
+	if (rc)
+		return rc;
+
+	if (stat(path, &st) < 0)
+		return -errno;
+
+	fwctl = calloc(1, sizeof(*fwctl));
+	if (!fwctl)
+		return -ENOMEM;
+
+	fwctl->major = major(st.st_rdev);
+	fwctl->minor = minor(st.st_rdev);
+	memdev->fwctl = fwctl;
+
+	return 0;
+}
+
 static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 {
 	const char *devname = devpath_to_devname(cxlmem_base);
@@ -1353,6 +1413,10 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->buf_len = strlen(cxlmem_base) + 50;
 
+	/* If this fails, no Features support. */
+	if (memdev_add_fwctl(memdev, cxlmem_base))
+		dbg(ctx, "%s: no Features support.\n", devname);
+
 	device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_pmem);
 
 	if (add_cxl_memdev_fwl(memdev, cxlmem_base))
@@ -1515,6 +1579,21 @@ CXL_EXPORT int cxl_memdev_get_minor(struct cxl_memdev *memdev)
 	return memdev->minor;
 }
 
+CXL_EXPORT struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev)
+{
+	return memdev->fwctl;
+}
+
+CXL_EXPORT int cxl_fwctl_get_major(struct cxl_fwctl *fwctl)
+{
+	return fwctl->major;
+}
+
+CXL_EXPORT int cxl_fwctl_get_minor(struct cxl_fwctl *fwctl)
+{
+	return fwctl->minor;
+}
+
 CXL_EXPORT unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev)
 {
 	return memdev->pmem_size;
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 4c9760f377e6..3ad0cd06e25a 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -291,4 +291,7 @@ global:
 LIBCXL_9 {
 global:
 	cxl_bus_get_by_provider;
+	cxl_memdev_get_fwctl;
+	cxl_fwctl_get_major;
+	cxl_fwctl_get_minor;
 } LIBECXL_8;
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index b6cd910e9335..7d5a1bcc14ac 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -34,6 +34,11 @@ enum cxl_fwl_loading {
 	CXL_FWL_LOADING_START,
 };
 
+struct cxl_fwctl {
+	int major;
+	int minor;
+};
+
 struct cxl_endpoint;
 struct cxl_memdev {
 	int id, major, minor;
@@ -56,6 +61,7 @@ struct cxl_memdev {
 	unsigned long long serial;
 	struct cxl_endpoint *endpoint;
 	struct cxl_fw_loader *fwl;
+	struct cxl_fwctl *fwctl;
 };
 
 struct cxl_dport {
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 7a32b9b65736..54d97d7bb501 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -59,6 +59,7 @@ static inline enum cxl_fwl_status cxl_fwl_status_from_ident(char *status)
 }
 
 struct cxl_memdev;
+struct cxl_fwctl;
 struct cxl_memdev *cxl_memdev_get_first(struct cxl_ctx *ctx);
 struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
 int cxl_memdev_get_id(struct cxl_memdev *memdev);
@@ -69,6 +70,7 @@ const char *cxl_memdev_get_host(struct cxl_memdev *memdev);
 struct cxl_bus *cxl_memdev_get_bus(struct cxl_memdev *memdev);
 int cxl_memdev_get_major(struct cxl_memdev *memdev);
 int cxl_memdev_get_minor(struct cxl_memdev *memdev);
+struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_pmem_size(struct cxl_memdev *memdev);
 unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
@@ -81,6 +83,9 @@ int cxl_memdev_update_fw(struct cxl_memdev *memdev, const char *fw_path);
 int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev);
 int cxl_memdev_wait_sanitize(struct cxl_memdev *memdev, int timeout_ms);
 
+int cxl_fwctl_get_major(struct cxl_fwctl *fwctl);
+int cxl_fwctl_get_minor(struct cxl_fwctl *fwctl);
+
 /* ABI spelling mistakes are forever */
 static inline const char *cxl_memdev_get_firmware_version(
 		struct cxl_memdev *memdev)
-- 
2.49.0

