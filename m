Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C561C29992E;
	Thu, 22 May 2025 15:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747929418; cv=none; b=SKUsPKRTQjRcwwiue8N0ujr7jYXiWs7sVYr2pdOBT8+jxdV8IdypgKsa3PI4U1dAi3PhbDBPNY2rAjhfGUuhQYKqC+FD6359kdYp7Xl3eHH5MJJ20/cw3kkLE9BJUog4s98rhsp0uriBCpkhUOFBKbCaxMOBkjE95xLA/tj+aRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747929418; c=relaxed/simple;
	bh=6u3hPYFwUEipsIMp2jk3wXmP9/oXs6OXJKEWbN5EzD4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HjtZhwnE4JfCgn98ZSNk18oepmytMgy78GVgBdmpcsWDdu2bkDElBSs28O4gVf6hxC8Py+/a2m/Qo7kjMofch87AmJvVpZXk+FhhsDB41e26zeykT1qEZPwbwC+ModZoAKNA15txKfGh6FNGQE2ZR0JEOf94sR17yIHgbIjvd0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 217E2C4CEE4;
	Thu, 22 May 2025 15:56:58 +0000 (UTC)
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Cc: alison.schofield@intel.com,
	Dan Williams <dan.j.williams@intel.com>
Subject: [NDCTL PATCH v8 2/4] cxl: Enumerate major/minor of FWCTL char device
Date: Thu, 22 May 2025 08:56:50 -0700
Message-ID: <20250522155653.1346768-3-dave.jiang@intel.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250522155653.1346768-1-dave.jiang@intel.com>
References: <20250522155653.1346768-1-dave.jiang@intel.com>
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
v8:
- Put helper functions behind ifdef when fwctl is disabled
---
 Documentation/cxl/lib/libcxl.txt | 24 +++++++++
 config.h.meson                   |  3 ++
 cxl/lib/libcxl.c                 | 83 ++++++++++++++++++++++++++++++++
 cxl/lib/libcxl.sym               |  3 ++
 cxl/lib/private.h                |  6 +++
 cxl/libcxl.h                     |  5 ++
 meson.build                      |  1 +
 meson_options.txt                |  2 +
 8 files changed, 127 insertions(+)

diff --git a/Documentation/cxl/lib/libcxl.txt b/Documentation/cxl/lib/libcxl.txt
index 25ff406c2920..2a512fd9d276 100644
--- a/Documentation/cxl/lib/libcxl.txt
+++ b/Documentation/cxl/lib/libcxl.txt
@@ -42,6 +42,7 @@ struct cxl_memdev *cxl_memdev_get_next(struct cxl_memdev *memdev);
 struct cxl_ctx *cxl_memdev_get_ctx(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_host(struct cxl_memdev *memdev)
 struct cxl_memdev *cxl_endpoint_get_memdev(struct cxl_endpoint *endpoint);
+struct cxl_fwctl *cxl_memdev_get_fwctl(struct cxl_memdev *memdev);
 
 #define cxl_memdev_foreach(ctx, memdev) \
         for (memdev = cxl_memdev_get_first(ctx); \
@@ -59,6 +60,11 @@ specific memdev.
 The host of a memdev is the PCIe Endpoint device that registered its CXL
 capabilities with the Linux CXL core.
 
+A memdev may host a 'struct cxl_fwctl' if CXL Features are supported,
+CONFIG_CXL_FEATURES is enabled, and Firmware Control (FWCTL) is also enabled.
+By default the 'fwctl' option is enabled for CXL CLI. The discovery can
+be disabled by meson build option.
+
 === MEMDEV: Attributes
 ----
 int cxl_memdev_get_id(struct cxl_memdev *memdev);
@@ -185,6 +191,24 @@ device is in use. When CXL_SETPART_NEXTBOOT mode is set, the change
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
diff --git a/config.h.meson b/config.h.meson
index 5441dff9fce7..f75db3e6360f 100644
--- a/config.h.meson
+++ b/config.h.meson
@@ -155,3 +155,6 @@
 #mesondefine DAXCTL_MODPROBE_DATA
 #mesondefine DAXCTL_MODPROBE_INSTALL
 #mesondefine PREFIX
+
+/* cxl fwctl support */
+#mesondefine ENABLE_FWCTL
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index bab7343e8a4a..af28f976bdc8 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -88,6 +88,7 @@ static void free_memdev(struct cxl_memdev *memdev, struct list_head *head)
 	free(memdev->dev_buf);
 	free(memdev->dev_path);
 	free(memdev->host_path);
+	free(memdev->fwctl);
 	free(memdev);
 }
 
@@ -1253,6 +1254,67 @@ static int add_cxl_memdev_fwl(struct cxl_memdev *memdev,
 	return -ENOMEM;
 }
 
+#ifdef ENABLE_FWCTL
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
+#endif
+
 static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 {
 	const char *devname = devpath_to_devname(cxlmem_base);
@@ -1353,6 +1415,12 @@ static void *add_cxl_memdev(void *parent, int id, const char *cxlmem_base)
 		goto err_read;
 	memdev->buf_len = strlen(cxlmem_base) + 50;
 
+#ifdef ENABLE_FWCTL
+	/* If this fails, no Features support. */
+	if (memdev_add_fwctl(memdev, cxlmem_base))
+		dbg(ctx, "%s: no Features support.\n", devname);
+#endif
+
 	device_parse(ctx, cxlmem_base, "pmem", memdev, add_cxl_pmem);
 
 	if (add_cxl_memdev_fwl(memdev, cxlmem_base))
@@ -1515,6 +1583,21 @@ CXL_EXPORT int cxl_memdev_get_minor(struct cxl_memdev *memdev)
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
diff --git a/meson.build b/meson.build
index 3171ef1024ea..7bc40c7df12a 100644
--- a/meson.build
+++ b/meson.build
@@ -237,6 +237,7 @@ conf.set('ENABLE_DESTRUCTIVE', get_option('destructive').enabled())
 conf.set('ENABLE_LOGGING', get_option('logging').enabled())
 conf.set('ENABLE_DEBUG', get_option('dbg').enabled())
 conf.set('ENABLE_LIBTRACEFS', get_option('libtracefs').enabled())
+conf.set('ENABLE_FWCTL', get_option('fwctl').enabled())
 
 typeof_code = '''
   void func() {
diff --git a/meson_options.txt b/meson_options.txt
index 5c41b1abe1f1..acc19be4ff0a 100644
--- a/meson_options.txt
+++ b/meson_options.txt
@@ -28,3 +28,5 @@ option('iniparserdir', type : 'string',
        description : 'Path containing the iniparser header files')
 option('modprobedatadir', type : 'string',
        description : '''${sysconfdir}/modprobe.d/''')
+option('fwctl', type : 'feature', value : 'enabled',
+  description : 'enable firmware control')
-- 
2.49.0

