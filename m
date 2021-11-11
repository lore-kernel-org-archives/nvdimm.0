Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35F0B2CAB
	for <nvdimm@lists.linux.dev>; Thu, 11 Nov 2021 20:45:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10165"; a="233253840"
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="233253840"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:56 -0800
X-IronPort-AV: E=Sophos;i="5.87,226,1631602800"; 
   d="scan'208";a="504579087"
Received: from dmamols-mobl1.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.255.92.53])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Nov 2021 12:44:56 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Ben Widawsky <ben.widawsky@intel.com>,
	<nvdimm@lists.linux.dev>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH v5 12/16] cxl: add commands to read, write, and zero labels
Date: Thu, 11 Nov 2021 13:44:32 -0700
Message-Id: <20211111204436.1560365-13-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211111204436.1560365-1-vishal.l.verma@intel.com>
References: <20211111204436.1560365-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=15302; h=from:subject; bh=bRnUw0usCORw4TCC8hp/iyVOeeno+PDeryfJ3YOvRG0=; b=owGbwMvMwCHGf25diOft7jLG02pJDIm9DZsf++6+drnzq1VJyhaBmbH3jn3/OFuly2jX/5vMpr/3 7mVq7ChlYRDjYJAVU2T5u+cj4zG57fk8gQmOMHNYmUCGMHBxCsBEBN8z/He/7qa+36jk+5/1WWsPTe f+khOgXLA/yrhZJVghNOrIbBmG/yEhD5JqkswqQxqWLkur07O9M9/y6spZxdPmSHG5ZZdvZQQA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add the following cxl-cli commands: read-labels, write-labels,
zero-labels. They operate on a CXL memdev, or a set of memdevs, and
allow interacting with the label storage area (LSA) on the device.

Add man pages for the above cxl-cli commands.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-read-labels.txt    |  33 +++
 Documentation/cxl/cxl-write-labels.txt   |  32 +++
 Documentation/cxl/cxl-zero-labels.txt    |  29 ++
 Documentation/cxl/labels-description.txt |   8 +
 Documentation/cxl/labels-options.txt     |  17 ++
 Documentation/cxl/memdev-option.txt      |   4 +
 cxl/builtin.h                            |   5 +
 cxl/cxl.c                                |   3 +
 cxl/memdev.c                             | 324 +++++++++++++++++++++++
 Documentation/cxl/Makefile.am            |   5 +-
 cxl/Makefile.am                          |   1 +
 11 files changed, 460 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/cxl/cxl-read-labels.txt
 create mode 100644 Documentation/cxl/cxl-write-labels.txt
 create mode 100644 Documentation/cxl/cxl-zero-labels.txt
 create mode 100644 Documentation/cxl/labels-description.txt
 create mode 100644 Documentation/cxl/labels-options.txt
 create mode 100644 Documentation/cxl/memdev-option.txt
 create mode 100644 cxl/memdev.c

diff --git a/Documentation/cxl/cxl-read-labels.txt b/Documentation/cxl/cxl-read-labels.txt
new file mode 100644
index 0000000..143f296
--- /dev/null
+++ b/Documentation/cxl/cxl-read-labels.txt
@@ -0,0 +1,33 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-read-labels(1)
+==================
+
+NAME
+----
+cxl-read-labels - read out the label area on a CXL memdev
+
+SYNOPSIS
+--------
+[verse]
+'cxl read-labels' <mem0> [<mem1>..<memN>] [<options>]
+
+include::labels-description.txt[]
+This command dumps the raw binary data in a memdev's label area to stdout or a
+file.  In the multi-memdev case the data is concatenated.
+
+OPTIONS
+-------
+include::labels-options.txt[]
+
+-o::
+--output::
+	output file
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-write-labels[1],
+linkcxl:cxl-zero-labels[1],
+CXL-2.0 9.13.2
diff --git a/Documentation/cxl/cxl-write-labels.txt b/Documentation/cxl/cxl-write-labels.txt
new file mode 100644
index 0000000..75f42a5
--- /dev/null
+++ b/Documentation/cxl/cxl-write-labels.txt
@@ -0,0 +1,32 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-write-labels(1)
+===================
+
+NAME
+----
+cxl-write-labels - write data to the label area on a memdev
+
+SYNOPSIS
+--------
+[verse]
+'cxl write-labels <mem> [-i <filename>]'
+
+include::labels-description.txt[]
+Read data from the input filename, or stdin, and write it to the given
+<mem> device. Note that the device must not be active in any region, or
+actively registered with the nvdimm subsystem. If it is, the kernel will
+not allow write access to the device's label data area.
+
+OPTIONS
+-------
+include::labels-options.txt[]
+-i::
+--input::
+	input file
+
+SEE ALSO
+--------
+linkcxl:cxl-read-labels[1],
+linkcxl:cxl-zero-labels[1],
+CXL-2.0 9.13.2
diff --git a/Documentation/cxl/cxl-zero-labels.txt b/Documentation/cxl/cxl-zero-labels.txt
new file mode 100644
index 0000000..bf95b24
--- /dev/null
+++ b/Documentation/cxl/cxl-zero-labels.txt
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+
+cxl-zero-labels(1)
+==================
+
+NAME
+----
+cxl-zero-labels - zero out the label area on a set of memdevs
+
+SYNOPSIS
+--------
+[verse]
+'cxl zero-labels' <mem0> [<mem1>..<memN>] [<options>]
+
+include::labels-description.txt[]
+This command resets the device to its default state by
+deleting all labels.
+
+OPTIONS
+-------
+include::labels-options.txt[]
+
+include::../copyright.txt[]
+
+SEE ALSO
+--------
+linkcxl:cxl-read-labels[1],
+linkcxl:cxl-write-labels[1],
+CXL-2.0 9.13.2
diff --git a/Documentation/cxl/labels-description.txt b/Documentation/cxl/labels-description.txt
new file mode 100644
index 0000000..f60bd5d
--- /dev/null
+++ b/Documentation/cxl/labels-description.txt
@@ -0,0 +1,8 @@
+// SPDX-License-Identifier: GPL-2.0
+
+DESCRIPTION
+-----------
+The region label area is a small persistent partition of capacity
+available on some CXL memory devices. The label area is used to
+and configure or determine the set of memory devices participating
+in different interleave sets.
diff --git a/Documentation/cxl/labels-options.txt b/Documentation/cxl/labels-options.txt
new file mode 100644
index 0000000..06fbac3
--- /dev/null
+++ b/Documentation/cxl/labels-options.txt
@@ -0,0 +1,17 @@
+// SPDX-License-Identifier: GPL-2.0
+
+<memory device(s)>::
+include::memdev-option.txt[]
+
+-s::
+--size=::
+	Limit the operation to the given number of bytes. A size of 0
+	indicates to operate over the entire label capacity.
+
+-O::
+--offset=::
+	Begin the operation at the given offset into the label area.
+
+-v::
+	Turn on verbose debug messages in the library (if libcxl was built with
+	logging and debug enabled).
diff --git a/Documentation/cxl/memdev-option.txt b/Documentation/cxl/memdev-option.txt
new file mode 100644
index 0000000..e778582
--- /dev/null
+++ b/Documentation/cxl/memdev-option.txt
@@ -0,0 +1,4 @@
+// SPDX-License-Identifier: GPL-2.0
+A 'memX' device name, or a memdev id number. Restrict the operation to
+the specified memdev(s). The keyword 'all' can be specified to indicate
+the lack of any restriction.
diff --git a/cxl/builtin.h b/cxl/builtin.h
index 3797f98..78eca6e 100644
--- a/cxl/builtin.h
+++ b/cxl/builtin.h
@@ -5,4 +5,9 @@
 
 struct cxl_ctx;
 int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_write_labels(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_read_labels(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_zero_labels(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_init_labels(int argc, const char **argv, struct cxl_ctx *ctx);
+int cmd_check_labels(int argc, const char **argv, struct cxl_ctx *ctx);
 #endif /* _CXL_BUILTIN_H_ */
diff --git a/cxl/cxl.c b/cxl/cxl.c
index a7725f8..4b1661d 100644
--- a/cxl/cxl.c
+++ b/cxl/cxl.c
@@ -61,6 +61,9 @@ static struct cmd_struct commands[] = {
 	{ "version", .c_fn = cmd_version },
 	{ "list", .c_fn = cmd_list },
 	{ "help", .c_fn = cmd_help },
+	{ "zero-labels", .c_fn = cmd_zero_labels },
+	{ "read-labels", .c_fn = cmd_read_labels },
+	{ "write-labels", .c_fn = cmd_write_labels },
 };
 
 int main(int argc, const char **argv)
diff --git a/cxl/memdev.c b/cxl/memdev.c
new file mode 100644
index 0000000..5ee38e5
--- /dev/null
+++ b/cxl/memdev.c
@@ -0,0 +1,324 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright (C) 2020-2021 Intel Corporation. All rights reserved. */
+#include <stdio.h>
+#include <errno.h>
+#include <stdlib.h>
+#include <unistd.h>
+#include <limits.h>
+#include <util/log.h>
+#include <util/filter.h>
+#include <cxl/libcxl.h>
+#include <util/parse-options.h>
+#include <ccan/minmax/minmax.h>
+#include <ccan/array_size/array_size.h>
+
+struct action_context {
+	FILE *f_out;
+	FILE *f_in;
+};
+
+static struct parameters {
+	const char *outfile;
+	const char *infile;
+	unsigned len;
+	unsigned offset;
+	bool verbose;
+} param;
+
+#define fail(fmt, ...) \
+do { \
+	fprintf(stderr, "cxl-%s:%s:%d: " fmt, \
+			VERSION, __func__, __LINE__, ##__VA_ARGS__); \
+} while (0)
+
+#define BASE_OPTIONS() \
+OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
+
+#define READ_OPTIONS() \
+OPT_STRING('o', "output", &param.outfile, "output-file", \
+	"filename to write label area contents")
+
+#define WRITE_OPTIONS() \
+OPT_STRING('i', "input", &param.infile, "input-file", \
+	"filename to read label area data")
+
+#define LABEL_OPTIONS() \
+OPT_UINTEGER('s', "size", &param.len, "number of label bytes to operate"), \
+OPT_UINTEGER('O', "offset", &param.offset, \
+	"offset into the label area to start operation")
+
+static const struct option read_options[] = {
+	BASE_OPTIONS(),
+	LABEL_OPTIONS(),
+	READ_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option write_options[] = {
+	BASE_OPTIONS(),
+	LABEL_OPTIONS(),
+	WRITE_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option zero_options[] = {
+	BASE_OPTIONS(),
+	LABEL_OPTIONS(),
+	OPT_END(),
+};
+
+static int action_zero(struct cxl_memdev *memdev, struct action_context *actx)
+{
+	size_t size;
+	int rc;
+
+	if (param.len)
+		size = param.len;
+	else
+		size = cxl_memdev_get_label_size(memdev);
+
+	if (cxl_memdev_nvdimm_bridge_active(memdev)) {
+		fprintf(stderr,
+			"%s: has active nvdimm bridge, abort label write\n",
+			cxl_memdev_get_devname(memdev));
+		return -EBUSY;
+	}
+
+	rc = cxl_memdev_zero_label(memdev, size, param.offset);
+	if (rc < 0)
+		fprintf(stderr, "%s: label zeroing failed: %s\n",
+			cxl_memdev_get_devname(memdev), strerror(-rc));
+
+	return rc;
+}
+
+static int action_write(struct cxl_memdev *memdev, struct action_context *actx)
+{
+	size_t size = param.len, read_len;
+	unsigned char *buf;
+	int rc;
+
+	if (cxl_memdev_nvdimm_bridge_active(memdev)) {
+		fprintf(stderr,
+			"%s: has active nvdimm bridge, abort label write\n",
+			cxl_memdev_get_devname(memdev));
+		return -EBUSY;
+	}
+
+	if (!size) {
+		size_t label_size = cxl_memdev_get_label_size(memdev);
+
+		fseek(actx->f_in, 0L, SEEK_END);
+		size = ftell(actx->f_in);
+		fseek(actx->f_in, 0L, SEEK_SET);
+
+		if (size > label_size) {
+			fprintf(stderr,
+				"File size (%zu) greater than label area size (%zu), aborting\n",
+				size, label_size);
+			return -EINVAL;
+		}
+	}
+
+	buf = calloc(1, size);
+	if (!buf)
+		return -ENOMEM;
+
+	read_len = fread(buf, 1, size, actx->f_in);
+	if (read_len != size) {
+		rc = -ENXIO;
+		goto out;
+	}
+
+	rc = cxl_memdev_write_label(memdev, buf, size, param.offset);
+	if (rc < 0)
+		fprintf(stderr, "%s: label write failed: %s\n",
+			cxl_memdev_get_devname(memdev), strerror(-rc));
+
+out:
+	free(buf);
+	return rc;
+}
+
+static int action_read(struct cxl_memdev *memdev, struct action_context *actx)
+{
+	size_t size, write_len;
+	char *buf;
+	int rc;
+
+	if (param.len)
+		size = param.len;
+	else
+		size = cxl_memdev_get_label_size(memdev);
+
+	buf = calloc(1, size);
+	if (!buf)
+		return -ENOMEM;
+
+	rc = cxl_memdev_read_label(memdev, buf, size, param.offset);
+	if (rc < 0) {
+		fprintf(stderr, "%s: label read failed: %s\n",
+			cxl_memdev_get_devname(memdev), strerror(-rc));
+		goto out;
+	}
+
+	write_len = fwrite(buf, 1, size, actx->f_out);
+	if (write_len != size) {
+		rc = -ENXIO;
+		goto out;
+	}
+	fflush(actx->f_out);
+
+out:
+	free(buf);
+	return rc;
+}
+
+static int memdev_action(int argc, const char **argv, struct cxl_ctx *ctx,
+		int (*action)(struct cxl_memdev *memdev, struct action_context *actx),
+		const struct option *options, const char *usage)
+{
+	struct cxl_memdev *memdev, *single = NULL;
+	struct action_context actx = { 0 };
+	int i, rc = 0, count = 0, err = 0;
+	const char * const u[] = {
+		usage,
+		NULL
+	};
+	unsigned long id;
+
+	argc = parse_options(argc, argv, options, u, 0);
+
+	if (argc == 0)
+		usage_with_options(u, options);
+	for (i = 0; i < argc; i++) {
+		if (strcmp(argv[i], "all") == 0) {
+			argv[0] = "all";
+			argc = 1;
+			break;
+		}
+
+		if (sscanf(argv[i], "mem%lu", &id) != 1) {
+			fprintf(stderr, "'%s' is not a valid memdev name\n",
+					argv[i]);
+			err++;
+		}
+	}
+
+	if (err == argc) {
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
+	if (!param.outfile)
+		actx.f_out = stdout;
+	else {
+		actx.f_out = fopen(param.outfile, "w+");
+		if (!actx.f_out) {
+			fprintf(stderr, "failed to open: %s: (%s)\n",
+					param.outfile, strerror(errno));
+			rc = -errno;
+			goto out;
+		}
+	}
+
+	if (!param.infile) {
+		actx.f_in = stdin;
+	} else {
+		actx.f_in = fopen(param.infile, "r");
+		if (!actx.f_in) {
+			fprintf(stderr, "failed to open: %s: (%s)\n",
+					param.infile, strerror(errno));
+			rc = -errno;
+			goto out_close_fout;
+		}
+	}
+
+	if (param.verbose)
+		cxl_set_log_priority(ctx, LOG_DEBUG);
+
+	rc = 0;
+	err = 0;
+	count = 0;
+
+	for (i = 0; i < argc; i++) {
+		if (sscanf(argv[i], "mem%lu", &id) != 1
+				&& strcmp(argv[i], "all") != 0)
+			continue;
+
+		cxl_memdev_foreach (ctx, memdev) {
+			if (!util_cxl_memdev_filter(memdev, argv[i]))
+				continue;
+
+			if (action == action_write) {
+				single = memdev;
+				rc = 0;
+			} else
+				rc = action(memdev, &actx);
+
+			if (rc == 0)
+				count++;
+			else if (rc && !err)
+				err = rc;
+		}
+	}
+	rc = err;
+
+	if (action == action_write) {
+		if (count > 1) {
+			error("write-labels only supports writing a single memdev\n");
+			usage_with_options(u, options);
+			return -EINVAL;
+		} else if (single) {
+			rc = action(single, &actx);
+			if (rc)
+				count = 0;
+		}
+	}
+
+	if (actx.f_in != stdin)
+		fclose(actx.f_in);
+
+ out_close_fout:
+	if (actx.f_out != stdout)
+		fclose(actx.f_out);
+
+ out:
+	/*
+	 * count if some actions succeeded, 0 if none were attempted,
+	 * negative error code otherwise.
+	 */
+	if (count > 0)
+		return count;
+	return rc;
+}
+
+int cmd_write_labels(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(argc, argv, ctx, action_write, write_options,
+			"cxl write-labels <memdev> [-i <filename>]");
+
+	fprintf(stderr, "wrote %d mem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_read_labels(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(argc, argv, ctx, action_read, read_options,
+			"cxl read-labels <mem0> [<mem1>..<memN>] [-o <filename>]");
+
+	fprintf(stderr, "read %d mem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_zero_labels(int argc, const char **argv, struct cxl_ctx *ctx)
+{
+	int count = memdev_action(argc, argv, ctx, action_zero, zero_options,
+			"cxl zero-labels <mem0> [<mem1>..<memN>] [<options>]");
+
+	fprintf(stderr, "zeroed %d mem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
diff --git a/Documentation/cxl/Makefile.am b/Documentation/cxl/Makefile.am
index db98dd7..efabaa3 100644
--- a/Documentation/cxl/Makefile.am
+++ b/Documentation/cxl/Makefile.am
@@ -19,7 +19,10 @@ endif
 
 man1_MANS = \
 	cxl.1 \
-	cxl-list.1
+	cxl-list.1 \
+	cxl-read-labels.1 \
+	cxl-write-labels.1 \
+	cxl-zero-labels.1
 
 EXTRA_DIST = $(man1_MANS)
 
diff --git a/cxl/Makefile.am b/cxl/Makefile.am
index 98606b9..da9f91d 100644
--- a/cxl/Makefile.am
+++ b/cxl/Makefile.am
@@ -10,6 +10,7 @@ config.h: $(srcdir)/Makefile.am
 cxl_SOURCES =\
 		cxl.c \
 		list.c \
+		memdev.c \
 		../util/json.c \
 		builtin.h
 
-- 
2.31.1

