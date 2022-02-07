Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EA62F30
	for <nvdimm@lists.linux.dev>; Mon,  7 Feb 2022 23:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644275183; x=1675811183;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=sjFriqt6/5te5WE9hr9ZVHMe9Go9+l16UAJ0+U7gaXI=;
  b=nh9gCjbI8FVioe4tMDEZNEvxmcLaipq0+kvP9R2gxR2od11aHq1jdF9L
   Hn6ra+jajywo3slggTIR4IwvIQ3n5pQUIkW1n54klmWeRlPnMEmYThTxf
   BlWgQ5RTdGeJpAhgC4CiXlHLQKOsyTQtSOsYmhB+hiRQrSKA+OBoXWWIr
   eBY/s34xj+4tZBGx23fMtOOS4nayPujTdGO9J+Iv71UOcEvmLRfsSPinF
   j5UOnRv11sjs4gSEwvRVcBB4Chp7VqfOzLSjKxuPhyWTHBIwX4+hH3ZJ0
   5wiTUgAkJIHKywaOzYw7t4EZz2Pe6mKA76f0WXBlw8mq7SGPpeipvMTFD
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10251"; a="273351899"
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="273351899"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:06:15 -0800
X-IronPort-AV: E=Sophos;i="5.88,351,1635231600"; 
   d="scan'208";a="632639212"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2022 15:06:14 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v4 6/6] cxl: add command set-partition
Date: Mon,  7 Feb 2022 15:10:20 -0800
Message-Id: <bc2efdbb83c4320ea97c75409ea8bb812e476ed6.1644271559.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1644271559.git.alison.schofield@intel.com>
References: <cover.1644271559.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

CXL devices may support both volatile and persistent memory capacity.
The amount of device capacity set aside for each type is typically
established at the factory, but some devices also allow for dynamic
re-partitioning, add a command for this purpose.

Synopsis:

cxl set-partition <mem0> [<mem1>..<memN>] [<options>]

-t, --type=<type>	'pmem' or 'volatile' (Default: 'pmem')
-s, --size=<size>	size in bytes (Default: all partitionable capacity)
-a, --align      	allow alignment correction
-v, --verbose    	turn on debug

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-set-partition.txt |  60 ++++++++
 Documentation/cxl/meson.build           |   1 +
 cxl/builtin.h                           |   1 +
 cxl/cxl.c                               |   1 +
 cxl/memdev.c                            | 196 ++++++++++++++++++++++++
 5 files changed, 259 insertions(+)
 create mode 100644 Documentation/cxl/cxl-set-partition.txt

diff --git a/Documentation/cxl/cxl-set-partition.txt b/Documentation/cxl/cxl-set-partition.txt
new file mode 100644
index 0000000..e20afba
--- /dev/null
+++ b/Documentation/cxl/cxl-set-partition.txt
@@ -0,0 +1,60 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-set-partition(1)
+====================
+
+NAME
+----
+cxl-set-partition - set the partitioning between volatile and persistent capacity on a CXL memdev
+
+SYNOPSIS
+--------
+[verse]
+'cxl set-partition <mem> [ [<mem1>..<memN>] [<options>]'
+
+DESCRIPTION
+-----------
+Partition the device into volatile and persistent capacity. The change
+in partitioning will become the “next” configuration, to become active
+on the next device reset.
+
+Use "cxl list -m <memdev> -I" to examine the partitioning capabilities
+of a device. A partition_alignment_bytes value of zero means there are
+no partitionable bytes available and therefore the partitions cannot be
+changed.
+
+Using this command to change the size of the persistent capacity shall
+result in the loss of data stored.
+
+OPTIONS
+-------
+<memory device(s)>::
+include::memdev-option.txt[]
+
+-t::
+--type=::
+	Type of partition, 'pmem' or 'volatile', to create.
+	Default: 'pmem'
+
+-s::
+--size=::
+	Size of the <type> partition in bytes. Size must align to the
+	devices alignment size. Use 'cxl list -m <memdev> -I' to find
+	the 'partition_alignment_size', or, use the 'align' option.
+	Default: All partitionable capacity is assigned to <type>.
+
+-a::
+--align::
+	This option allows the size of the partition to be increased to
+	meet device alignment requirements.
+
+-v::
+        Turn on verbose debug messages in the library (if libcxl was built with
+        logging and debug enabled).
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-list[1],
+CXL-2.0 8.2.9.5.2
diff --git a/Documentation/cxl/meson.build b/Documentation/cxl/meson.build
index 96f4666..e927644 100644
--- a/Documentation/cxl/meson.build
+++ b/Documentation/cxl/meson.build
@@ -34,6 +34,7 @@ cxl_manpages = [
   'cxl-disable-memdev.txt',
   'cxl-enable-port.txt',
   'cxl-disable-port.txt',
+  'cxl-set-partition.txt',
 ]
 
 foreach man : cxl_manpages
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 3123d5e..7bbad98 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -14,4 +14,5 @@ int cmd_disable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_disable_port(int argc, const char **argv, struct cxl_ctx *ctx);
 int cmd_enable_port(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/cxl.c b/cxl/cxl.c
index c20c569..ab4bbec 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -68,6 +68,7 @@ static struct cmd_struct commands[] = {
 	{ "enable-memdev", .c_fn = cmd_enable_memdev },
 	{ "disable-port", .c_fn = cmd_disable_port },
 	{ "enable-port", .c_fn = cmd_enable_port },
+	{ "set-partition", .c_fn = cmd_set_partition },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/memdev.c b/cxl/memdev.c
index 90b33e1..5d97610 100644
--- a/cxl/memdev.c
+++ b/cxl/memdev.c
@@ -6,11 +6,14 @@
 #include <unistd.h>
 #include <limits.h>
 #include <util/log.h>
+#include <util/json.h>
+#include <util/size.h>
 #include <cxl/libcxl.h>
 #include <util/parse-options.h>
 #include <ccan/minmax/minmax.h>
 #include <ccan/array_size/array_size.h>
 
+#include "json.h"
 #include "filter.h"
 
 struct action_context {
@@ -26,6 +29,9 @@ static struct parameters {
 	bool verbose;
 	bool serial;
 	bool force;
+	bool align;
+	const char *type;
+	const char *size;
 } param;
 
 static struct log_ctx ml;
@@ -51,6 +57,14 @@ OPT_UINTEGER('O', "offset", &param.offset, \
 OPT_BOOLEAN('f', "force", &param.force,                                \
 	    "DANGEROUS: override active memdev safety checks")
 
+#define SET_PARTITION_OPTIONS() \
+OPT_STRING('t', "type",  &param.type, "type",			\
+	"'pmem' or 'volatile' (Default: 'pmem')"),		\
+OPT_STRING('s', "size",  &param.size, "size",			\
+	"size in bytes (Default: all partitionable capacity)"),	\
+OPT_BOOLEAN('a', "align",  &param.align,			\
+	"allow alignment correction")
+
 static const struct option read_options[] = {
 	BASE_OPTIONS(),
 	LABEL_OPTIONS(),
@@ -82,6 +96,12 @@ static const struct option enable_options[] = {
 	OPT_END(),
 };
 
+static const struct option set_partition_options[] = {
+	BASE_OPTIONS(),
+	SET_PARTITION_OPTIONS(),
+	OPT_END(),
+};
+
 static int action_disable(struct cxl_memdev *memdev, struct action_context *actx)
 {
 	if (!cxl_memdev_is_enabled(memdev))
@@ -209,6 +229,171 @@ out:
 	return rc;
 }
 
+static unsigned long long
+partition_align(const char *devname, unsigned long long volatile_size,
+		unsigned long long alignment, unsigned long long partitionable)
+{
+	if (IS_ALIGNED(volatile_size, alignment))
+		return volatile_size;
+
+	if (!param.align) {
+		log_err(&ml, "%s: size %lld is not partition aligned %lld\n",
+			devname, volatile_size, alignment);
+		return ULLONG_MAX;
+	}
+
+	/* Align based on partition type to fulfill users size request */
+	if (strcmp(param.type, "pmem") == 0)
+		volatile_size = ALIGN_DOWN(volatile_size, alignment);
+	else
+		volatile_size = ALIGN(volatile_size, alignment);
+
+	/* Fail if the align pushes size over the partitionable limit. */
+	if (volatile_size > partitionable) {
+		log_err(&ml, "%s: aligned partition size %lld exceeds partitionable size %lld\n",
+			devname, volatile_size, partitionable);
+		volatile_size = ULLONG_MAX;
+	}
+
+	return volatile_size;
+}
+
+static unsigned long long
+param_size_to_volatile_size(const char *devname, unsigned long long size,
+		unsigned long long partitionable)
+{
+	/* User omits size option. Apply all partitionable capacity to type. */
+	if (size == ULLONG_MAX)
+		return (strcmp(param.type, "pmem") == 0) ? 0 : partitionable;
+
+	/* User includes a size option. Apply it to type */
+	if (size > partitionable) {
+		log_err(&ml, "%s: %lld exceeds partitionable capacity %lld\n",
+			devname, size, partitionable);
+			return ULLONG_MAX;
+	}
+	return (strcmp(param.type, "pmem") == 0) ? partitionable - size : size;
+}
+
+/*
+ * Return the volatile_size to use in the CXL set paritition
+ * command, or ULLONG_MAX if unable to validate the partition
+ * request.
+ */
+static unsigned long long
+validate_partition(struct cxl_memdev *memdev, unsigned long long size)
+{
+	unsigned long long total_cap, volatile_only, persistent_only;
+	const char *devname = cxl_memdev_get_devname(memdev);
+	unsigned long long volatile_size = ULLONG_MAX;
+	unsigned long long partitionable, alignment;
+	struct cxl_cmd *cmd;
+	int rc;
+
+	cmd = cxl_cmd_new_identify(memdev);
+	if (!cmd)
+		return ULLONG_MAX;
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0)
+		goto out;
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0)
+		goto out;
+
+	alignment = cxl_cmd_identify_get_partition_align(cmd);
+	if (alignment == 0) {
+		log_err(&ml, "%s: no partitionable capacity\n", devname);
+		goto out;
+	}
+
+	/* Calculate the actual partitionable capacity */
+	total_cap = cxl_cmd_identify_get_total_size(cmd);
+	volatile_only = cxl_cmd_identify_get_volatile_only_size(cmd);
+	persistent_only = cxl_cmd_identify_get_persistent_only_size(cmd);
+	partitionable = total_cap - volatile_only - persistent_only;
+
+	/* Translate the users size request into an aligned volatile_size */
+	volatile_size = param_size_to_volatile_size(devname, size,
+				partitionable);
+	if (volatile_size == ULLONG_MAX)
+		goto out;
+
+	volatile_size = partition_align(devname, volatile_size, alignment,
+				partitionable);
+
+out:
+	cxl_cmd_unref(cmd);
+	return volatile_size;
+}
+
+static int action_setpartition(struct cxl_memdev *memdev,
+		struct action_context *actx)
+{
+	const char *devname = cxl_memdev_get_devname(memdev);
+	unsigned long long size = ULLONG_MAX;
+	struct json_object *jmemdev;
+	struct cxl_cmd *cmd;
+	int rc;
+
+	if (param.type) {
+		if (strcmp(param.type, "pmem") == 0)
+			/* pass */;
+		else if (strcmp(param.type, "volatile") == 0)
+			/* pass */;
+		else {
+			log_err(&ml, "invalid type '%s'\n", param.type);
+			return -EINVAL;
+		}
+	} else {
+		/* Default type is PMEM */
+		param.type = "pmem";
+	}
+
+	if (param.size) {
+		size = parse_size64(param.size);
+		if (size == ULLONG_MAX) {
+			log_err(&ml, "%s: failed to parse size option '%s'\n",
+			devname, param.size);
+			return -EINVAL;
+		}
+	}
+
+	size = validate_partition(memdev, size);
+	if (size == ULLONG_MAX)
+		return -EINVAL;
+
+	cmd = cxl_cmd_new_set_partition(memdev, size);
+	if (!cmd) {
+		rc = -ENXIO;
+		goto out_err;
+	}
+
+	rc = cxl_cmd_submit(cmd);
+	if (rc < 0) {
+		log_err(&ml, "cmd submission failed: %s\n", strerror(-rc));
+		goto out_cmd;
+	}
+
+	rc = cxl_cmd_get_mbox_status(cmd);
+	if (rc != 0) {
+		log_err(&ml, "%s: mbox status: %d\n", __func__, rc);
+		rc = -ENXIO;
+	}
+
+out_cmd:
+	cxl_cmd_unref(cmd);
+out_err:
+	if (rc)
+		log_err(&ml, "%s error: %s\n", devname, strerror(-rc));
+
+	jmemdev = util_cxl_memdev_to_json(memdev, UTIL_JSON_PARTITION);
+	if (jmemdev)
+		printf("%s\n", json_object_to_json_string_ext(jmemdev,
+		       JSON_C_TO_STRING_PRETTY));
+
+	return rc;
+}
+
 static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
 			 int (*action)(struct cxl_memdev *memdev,
 				       struct action_context *actx),
@@ -398,3 +583,14 @@ int cmd_enable_memdev(int argc, const char **argv, struct cxl_ctx *ctx)
 		 count > 1 ? "s" : "");
 	return count >= 0 ? 0 : EXIT_FAILURE;
 }
+
+int cmd_set_partition(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(argc, argv, ctx, action_setpartition,
+			set_partition_options,
+			"cxl set-partition <mem0> [<mem1>..<memN>] [<options>]");
+	log_info(&ml, "set_partition %d mem%s\n", count >= 0 ? count : 0,
+		 count > 1 ? "s" : "");
+
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
-- 
2.31.1

