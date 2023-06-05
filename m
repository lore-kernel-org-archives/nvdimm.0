Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E17E261D4
	for <nvdimm@lists.linux.dev>; Mon,  5 Jun 2023 20:21:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685996474; x=1717532474;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=3erz4vNorrE9D3nURvJ2i5Dl9zxYwU7cP6Q27FVxDF0=;
  b=KzbnlZvI0TCScBOozypC3HRtXQs1PqZMCsCJnn3pPwOWpMq18X3ZnzPF
   UXX/Bn7MceZCD3/j/3kn+j6Aj2uDw5UQYcSm9C/jllk564fT1/KUuf3MP
   f1+8RdQkZjWsZ/G3OB05j8QcpZEkDjIKobtbjb+TKCTzKjNoD7jH+RQkz
   QWHZlO0wKDvccCJFWK3VV7YaSxPDmLRJF3qFacuIIKbyyOlAwEaQIt0QB
   T134nVNNTBqGZ5k5vSt29oF980RAyY58/+33uAkJ5Tz8Qj2KiDwm9SPC3
   vqmMUfah1CFDA80ZiZR7SjCUO5/4z1zyF6blO8cVC3ztZPRj/3D5oGXGs
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="336093182"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="336093182"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:12 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="832934317"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="832934317"
Received: from kmsalzbe-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.209.52.9])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 13:21:11 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Mon, 05 Jun 2023 14:21:06 -0600
Subject: [PATCH ndctl v2 4/5] cxl: add an update-firmware command
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230405-vv-fw_update-v2-4-a778a15e860b@intel.com>
References: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
In-Reply-To: <20230405-vv-fw_update-v2-0-a778a15e860b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, Alison Schofield <alison.schofield@intel.com>, 
 Ira Weiny <ira.weiny@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-02a79
X-Developer-Signature: v=1; a=openpgp-sha256; l=13427;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=3erz4vNorrE9D3nURvJ2i5Dl9zxYwU7cP6Q27FVxDF0=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCl1ztv+xD3I5Y2cLcqg7Pww239VO2PTxxdtmwrWXN1zZ
 d++4L5JHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZiIwTqGf9ZiWxN2Nz1fpN0h
 vqs2fPP+vW+eeUt/9JspaMZwTmXGAn6Gf7oiuTpNVt+/u67+d15W+3qjSfHXjpRlp6em/2jesm0
 uJz8A
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Add a new cxl-update-firmware command to initiate a firmware update on a
given memdev. This allows using a specified file to pass in as the
firmware binary for one or more memdevs, allows for a blocking mode,
where the command only exits after the update is complete for every
specified memdev, and includes an option to cancel an in-progress
update. Add the supporting libcxl APIs for the above functions as well.

Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-update-firmware.txt |  85 ++++++++++++++++++++++
 cxl/lib/private.h                         |   5 ++
 cxl/lib/libcxl.c                          | 114 ++++++++++++++++++++++++++++++
 cxl/builtin.h                             |   1 +
 cxl/libcxl.h                              |   2 +
 cxl/cxl.c                                 |   1 +
 cxl/memdev.c                              |  73 ++++++++++++++++++-
 Documentation/cxl/meson.build             |   1 +
 cxl/lib/libcxl.sym                        |   2 +
 9 files changed, 283 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-update-firmware.txt b/Documentation/cxl/cxl-update-firmware.txt
new file mode 100644
index 0000000..b7342aa
--- /dev/null
+++ b/Documentation/cxl/cxl-update-firmware.txt
@@ -0,0 +1,85 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-update-firmware(1)
+======================
+
+NAME
+----
+cxl-update-firmware - update the firmware on a CXL memdev
+
+SYNOPSIS
+--------
+[verse]
+'cxl update-firmware <mem0> [<mem1>..<memN>] [<options>]'
+
+DESCRIPTION
+-----------
+
+Update the firmware on one or more CXL mem devices. The mem devices
+must support the set of firmware related mailbox commands.
+
+This command doesn't directly issue the transfer / activate firmware
+mailbox commands. Instead, the kernel's firmware loader facility is
+used to provide the kernel with the data, and the kernel handles
+performing the actual update while also managing time slicing the
+transfer w.r.t. other background commands.
+
+EXAMPLE
+-------
+----
+# cxl update-firmware mem0 -F firmware.bin -w
+[
+  {
+    "memdev":"mem0",
+    "pmem_size":1073741824,
+    "ram_size":1073741824,
+    "serial":0,
+    "numa_node":0,
+    "host":"cxl_mem.0",
+    "firmware":{
+      "num_slots":3,
+      "active_slot":2,
+      "online_activate_capable":false,
+      "slot_1_version":"cxl_test_fw_001",
+      "slot_2_version":"cxl_test_fw_002",
+      "slot_3_version":"cxl_test_new_fw",
+      "fw_update_in_progress":false
+    }
+  }
+]
+firmware update completed on 1 mem device
+----
+
+OPTIONS
+-------
+
+include::bus-option.txt[]
+
+-F::
+--firmware-file::
+	Firmware image file to use for the update.
+
+-c::
+--cancel::
+	Attempt to abort an in-progress firmware update. This may
+	fail depending on what stage the update process is in.
+
+-w::
+--wait::
+	By default, the update-firmware command only initiates the
+	firmware update, and returns, while the update operation
+	happens asynchronously in the background. This option makes
+	the firmware update command synchronous by waiting for it to
+	complete before returning.
+
+	If --wait is passed in without an accompanying firmware-file,
+	it will initiate a wait on any current in-progress firmware
+	updates, and then return.
+
+include::verbose-option.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1],
diff --git a/cxl/lib/private.h b/cxl/lib/private.h
index 95e0c43..6388534 100644
--- a/cxl/lib/private.h
+++ b/cxl/lib/private.h
@@ -29,6 +29,11 @@ struct cxl_fw_loader {
 	char *status;
 };
 
+enum cxl_fwl_loading {
+	CXL_FWL_LOADING_END = 0,
+	CXL_FWL_LOADING_START,
+};
+
 struct cxl_endpoint;
 struct cxl_memdev {
 	int id, major, minor;
diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 5f74138..8094cf8 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -7,6 +7,7 @@
 #include <stdlib.h>
 #include <dirent.h>
 #include <unistd.h>
+#include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/ioctl.h>
@@ -1468,6 +1469,119 @@ CXL_EXPORT size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev)
 	return strtoull(buf, NULL, 0);
 }
 
+static int cxl_memdev_fwl_set_loading(struct cxl_memdev *memdev,
+				      enum cxl_fwl_loading loadval)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_fw_loader *fwl = memdev->fwl;
+	char buf[SYSFS_ATTR_SIZE];
+	int rc;
+
+	sprintf(buf, "%d\n", loadval);
+	rc = sysfs_write_attr(ctx, fwl->loading, buf);
+	if (rc < 0) {
+		err(ctx, "%s: failed to trigger fw loading to %d (%s)\n",
+		    devname, loadval, strerror(-rc));
+		return rc;
+	}
+
+	return 0;
+}
+
+static int cxl_memdev_fwl_copy_data(struct cxl_memdev *memdev, void *fw_buf,
+				    size_t size)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_fw_loader *fwl = memdev->fwl;
+	FILE *fwl_data;
+	size_t rw_len;
+	int rc = 0;
+
+	fwl_data = fopen(fwl->data, "w");
+	if (!fwl_data) {
+		err(ctx, "failed to open: %s: (%s)\n", fwl->data,
+		    strerror(errno));
+		return -errno;
+	}
+
+	rw_len = fwrite(fw_buf, 1, size, fwl_data);
+	if (rw_len != size) {
+		rc = -ENXIO;
+		goto out_close;
+	}
+	fflush(fwl_data);
+
+out_close:
+	fclose(fwl_data);
+	return rc;
+}
+
+CXL_EXPORT int cxl_memdev_update_fw(struct cxl_memdev *memdev,
+				    const char *fw_path)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct stat s;
+	int f_in, rc;
+	void *fw_buf;
+
+	f_in = open(fw_path, O_RDONLY);
+	if (f_in < 0) {
+		err(ctx, "failed to open: %s: (%s)\n", fw_path,
+		    strerror(errno));
+		return -errno;
+	}
+
+	rc = fstat(f_in, &s);
+	if (rc < 0) {
+		err(ctx, "failed to stat: %s: (%s)\n", fw_path,
+		    strerror(errno));
+		rc = -errno;
+		goto out_close;
+	}
+
+	fw_buf = mmap(NULL, s.st_size, PROT_READ, MAP_PRIVATE, f_in, 0);
+	if (fw_buf == MAP_FAILED) {
+		err(ctx, "failed to map: %s: (%s)\n", fw_path,
+		    strerror(errno));
+		rc = -errno;
+		goto out_close;
+	}
+
+	rc = cxl_memdev_fwl_set_loading(memdev, CXL_FWL_LOADING_START);
+	if (rc)
+		goto out_unmap;
+
+	rc = cxl_memdev_fwl_copy_data(memdev, fw_buf, s.st_size);
+	if (rc)
+		goto out_unmap;
+
+	rc = cxl_memdev_fwl_set_loading(memdev, CXL_FWL_LOADING_END);
+
+out_unmap:
+	munmap(fw_buf, s.st_size);
+out_close:
+	close(f_in);
+	return rc;
+}
+
+CXL_EXPORT int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev)
+{
+	struct cxl_ctx *ctx = cxl_memdev_get_ctx(memdev);
+	struct cxl_fw_loader *fwl = memdev->fwl;
+	int rc;
+
+	if (!cxl_memdev_fw_update_in_progress(memdev) &&
+	    cxl_memdev_fw_update_get_remaining(memdev) == 0)
+		return -ENXIO;
+
+	rc = sysfs_write_attr(ctx, fwl->cancel, "1\n");
+	if (rc < 0)
+		return rc;
+
+	return 0;
+}
+
 static void bus_invalidate(struct cxl_bus *bus)
 {
 	struct cxl_ctx *ctx = cxl_bus_get_ctx(bus);
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 9baa43b..3ec6c6c 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -14,6 +14,7 @@ int cmd_disable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_reserve_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
diff --git a/cxl/libcxl.h b/cxl/libcxl.h
index 7509abe..2ffb39c 100644
--- a/cxl/libcxl.h
+++ b/cxl/libcxl.h
@@ -75,6 +75,8 @@ unsigned long long cxl_memdev_get_ram_size(struct cxl_memdev *memdev);
 const char *cxl_memdev_get_firmware_verison(struct cxl_memdev *memdev);
 bool cxl_memdev_fw_update_in_progress(struct cxl_memdev *memdev);
 size_t cxl_memdev_fw_update_get_remaining(struct cxl_memdev *memdev);
+int cxl_memdev_update_fw(struct cxl_memdev *memdev, const char *fw_path);
+int cxl_memdev_cancel_fw_update(struct cxl_memdev *memdev);
 
 /* ABI spelling mistakes are forever */
 static inline const char *cxl_memdev_get_firmware_version(
diff --git a/cxl/cxl.c b/cxl/cxl.c
index 3be7026..e1524b8 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -68,6 +68,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-memdev", .c_fn = cmd_enable_memdev },
 	{ "reserve-dpa", .c_fn = cmd_reserve_dpa },
 	{ "free-dpa", .c_fn = cmd_free_dpa },
+	{ "update-firmware", .c_fn = cmd_update_fw },
 	{ "disable-port", .c_fn = cmd_disable_port },
 	{ "enable-port", .c_fn = cmd_enable_port },
 	{ "set-partition", .c_fn = cmd_set_partition },
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 807e859..1ad871a 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -23,14 +23,18 @@ struct action_context {
 };
 
 static struct parameters {
+	const char *bus;
 	const char *outfile;
 	const char *infile;
+	const char *fw_file;
 	unsigned len;
 	unsigned offset;
 	bool verbose;
 	bool serial;
 	bool force;
 	bool align;
+	bool cancel;
+	bool wait;
 	const char *type;
 	const char *size;
 	const char *decoder_filter;
@@ -87,6 +91,14 @@ OPT_STRING('t', "type", &param.type, "type",                   \
 OPT_BOOLEAN('f', "force", &param.force,                        \
 	    "Attempt 'expected to fail' operations")
 
+#define FW_OPTIONS()                                                 \
+OPT_STRING('F', "firmware-file", &param.fw_file, "firmware-file",     \
+	   "firmware image file to use for the update"),             \
+OPT_BOOLEAN('c', "cancel", &param.cancel,                            \
+	    "attempt to abort an in-progress firmware update"),      \
+OPT_BOOLEAN('w', "wait", &param.wait,                                \
+	    "wait for firmware update to complete before returning")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	LABEL_OPTIONS(),
@@ -137,6 +149,12 @@ static const struct option free_dpa_options[] = {
 	OPT_END(),
 };
 
+static const struct option update_fw_options[] = {
+	BASE_OPTIONS(),
+	FW_OPTIONS(),
+	OPT_END(),
+};
+
 enum reserve_dpa_mode {
 	DPA_ALLOC,
 	DPA_FREE,
@@ -655,6 +673,39 @@ out_err:
 	return rc;
 }
 
+static int action_update_fw(struct cxl_memdev *memdev,
+			    struct action_context *actx)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	struct json_object *jmemdev;
+	unsigned long flags;
+	int rc;
+
+	if (param.cancel)
+		return cxl_memdev_cancel_fw_update(memdev);
+
+	if (param.fw_file) {
+		rc = cxl_memdev_update_fw(memdev, param.fw_file);
+		if (rc)
+			log_err(&ml, "%s error: %s\n", devname, strerror(-rc));
+	}
+
+	if (param.wait) {
+		while (cxl_memdev_fw_update_in_progress(memdev) ||
+		       cxl_memdev_fw_update_get_remaining(memdev) > 0)
+			sleep(1);
+	}
+
+	flags = UTIL_JSON_FIRMWARE;
+	if (actx->f_out == stdout && isatty(1))
+		flags |= UTIL_JSON_HUMAN;
+	jmemdev = util_cxl_memdev_to_json(memdev, flags);
+	if (actx->jdevs && jmemdev)
+		json_object_array_add(actx->jdevs, jmemdev);
+
+	return rc;
+}
+
 static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			 int (*action)(struct cxl_memdev *memdev,
 				       struct action_context *actx),
@@ -698,7 +749,7 @@ static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 	}
 
 	if (action == action_setpartition || action == action_reserve_dpa ||
-	    action == action_free_dpa)
+	    action == action_free_dpa || action == action_update_fw)
 		actx.jdevs = json_object_new_array();
 
 	if (err == argc) {
@@ -897,3 +948,23 @@ int cmd_free_dpa(int argc, const char **argv, struct cxl_ctx *ctx)
 
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_update_fw(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(
+		argc, argv, ctx, action_update_fw, update_fw_options,
+		"cxl update-firmware <mem0> [<mem1>..<memn>] [<options>]");
+	const char *op_string;
+
+	if (param.cancel)
+		op_string = "cancelled";
+	else if (param.wait)
+		op_string = "completed";
+	else
+		op_string = "started";
+
+	log_info(&ml, "firmware update %s on %d mem device%s\n", op_string,
+		 count >= 0 ? count : 0, count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index a6d77ab..c553357 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -46,6 +46,7 @@ cxl_manpages = [
   'cxl-enable-region.txt',
   'cxl-destroy-region.txt',
   'cxl-monitor.txt',
+  'cxl-update-firmware.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/lib/libcxl.sym b/cxl/lib/libcxl.sym
index 9438877..ce0cb7f 100644
--- a/cxl/lib/libcxl.sym
+++ b/cxl/lib/libcxl.sym
@@ -256,4 +256,6 @@ global:
 	cxl_cmd_fw_info_get_fw_ver;
 	cxl_memdev_fw_update_in_progress;
 	cxl_memdev_fw_update_get_remaining;
+	cxl_memdev_update_fw;
+	cxl_memdev_cancel_fw_update;
 } LIBCXL_4;

-- 
2.40.1

