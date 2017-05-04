Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B46521959D21
 for <linux-nvdimm@lists.01.org>; Thu,  4 May 2017 14:49:07 -0700 (PDT)
Subject: [PATCH v6 2/3] ndctl: add list-errors support
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 04 May 2017 14:49:06 -0700
Message-ID: <149393454673.2642.10490569511477839936.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
References: <149393422747.2642.5136375594842641153.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Adding list-errors command to support displaying of all badblocks in
relation to the device rather than the region. This allows the user to
know what badblocks to pass in when doing clear-error calls.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 Documentation/ndctl-list-errors.txt |   26 +++++++
 builtin.h                           |    1 
 ndctl/clear-error.c                 |  133 ++++++++++++++++++++++++++++++++---
 ndctl/ndctl.c                       |    1 
 4 files changed, 151 insertions(+), 10 deletions(-)
 create mode 100644 Documentation/ndctl-list-errors.txt

diff --git a/Documentation/ndctl-list-errors.txt b/Documentation/ndctl-list-errors.txt
new file mode 100644
index 0000000..f831ba0
--- /dev/null
+++ b/Documentation/ndctl-list-errors.txt
@@ -0,0 +1,26 @@
+ndctl-list-errors(1)
+====================
+
+NAME
+----
+ndctl-list-errors - list badblocks specifically in relation to a device
+
+SYNOPSIS
+--------
+[verse]
+'ndctl list-errors' [<options>]
+
+EXAMPLES
+--------
+
+List bad blocks for the provided device
+[verse]
+ndctl list-errors -f /dev/dax0.0
+
+List all badblocks for device /dev/dax0.0.
+
+OPTIONS
+-------
+-f::
+--file::
+	The device/file to show the badblocks.
diff --git a/builtin.h b/builtin.h
index f522d00..655904f 100644
--- a/builtin.h
+++ b/builtin.h
@@ -31,4 +31,5 @@ int cmd_test(int argc, const char **argv, void *ctx);
 int cmd_bat(int argc, const char **argv, void *ctx);
 #endif
 int cmd_clear_error(int argc, const char **argv, void *ctx);
+int cmd_list_errors(int argc, const char **argv, void *ctx);
 #endif /* _NDCTL_BUILTIN_H_ */
diff --git a/ndctl/clear-error.c b/ndctl/clear-error.c
index 29cd471..e15e821 100644
--- a/ndctl/clear-error.c
+++ b/ndctl/clear-error.c
@@ -131,29 +131,37 @@ static int check_user_input_range(struct ndctl_dax *dax,
 	return 0;
 }
 
-static int clear_error(struct clear_err *ce)
+static int check_dax_dev(const char *dev_name)
 {
-	struct stat stats;
 	int rc;
-	char dev_name[256];
-	uint64_t dev_base;
-	unsigned long long start;
-	unsigned int len;
-
-	strncpy(dev_name, ce->dev_name, 256);
+	struct stat stats;
 
 	rc = stat(dev_name, &stats);
 	if (rc < 0) {
+		rc = -errno;
 		perror("stat failed");
 		error("Unable to stat %s\n", dev_name);
-		return -1;
+		return rc;
 	}
 
 	if (!S_ISCHR(stats.st_mode)) {
 		error("%s not DAX device\n", dev_name);
-		return -1;
+		return -ENODEV;
 	}
 
+	return 0;
+}
+
+static int clear_error(struct clear_err *ce)
+{
+	int rc;
+	char dev_name[256];
+	uint64_t dev_base;
+	unsigned long long start;
+	unsigned int len;
+
+	strncpy(dev_name, ce->dev_name, 256);
+
 	rc = ndctl_new(&ce->ctx);
 	if (rc)
 		return rc;
@@ -231,9 +239,114 @@ int cmd_clear_error(int argc, const char **argv, void *ctx)
 		return -EINVAL;
 	}
 
+	if ((rc = check_dax_dev(clear_err.dev_name)) < 0)
+		return rc;
+
 	rc = clear_error(&clear_err);
 	if (rc)
 		return rc;
 
 	return 0;
 }
+
+static int print_dax_badblocks(struct ndctl_dax *dax)
+{
+	struct ndctl_region *region = ndctl_dax_get_region(dax);
+	struct badblock *bb;
+	uint64_t region_begin;
+	uint64_t dax_begin, dax_end;
+
+	region_begin = ndctl_region_get_resource(region);
+	dax_begin = ndctl_dax_get_resource(dax);
+	dax_end = dax_begin + ndctl_dax_get_size(dax) - 1;
+
+	/* check region */
+	ndctl_region_badblock_foreach(region, bb) {
+		uint64_t bb_begin, bb_end;
+		uint64_t begin, end;
+
+		bb_begin = region_begin + (bb->offset << 9);
+		bb_end = bb_begin + (bb->len << 9) - 1;
+
+		if (bb_begin <= dax_begin)
+			begin = dax_begin;
+		else if (bb_begin < dax_end)
+			begin = bb_begin;
+		else
+			begin = 0;
+
+		if (begin) {
+			if (bb_end <= dax_end)
+				end = bb_end;
+			else
+				end = dax_end;
+		} else
+			continue;
+
+		printf("%llu %u\n",
+			(unsigned long long)(begin - dax_begin) >> 9,
+			(unsigned int)(end - begin + 1) >> 9);
+	}
+
+	return 0;
+}
+
+static int list_errors(struct clear_err *ce)
+{
+	int rc;
+	char dev_name[256];
+
+	strncpy(dev_name, ce->dev_name, 256);
+
+	rc = ndctl_new(&ce->ctx);
+	if (rc)
+		return rc;
+
+	if ((rc = match_dev(ce, dev_name)) < 0)
+		goto cleanup;
+
+	if ((rc = print_dax_badblocks(ce->dax)) < 0)
+		goto cleanup;
+
+	rc = 0;
+
+cleanup:
+	ndctl_unref(ce->ctx);
+	return rc;
+}
+
+int cmd_list_errors(int argc, const char **argv, void *ctx)
+{
+	int i, rc;
+	const char * const u[] = {
+		"ndctl clear-error [<options>]",
+		NULL
+	};
+	const struct option options[] = {
+		OPT_STRING('f', "file", &clear_err.dev_name, "device-name",
+			"device/file name to be operated on"),
+		OPT_END(),
+	};
+
+	argc = parse_options(argc, argv, options, u, 0);
+
+	for (i = 0; i < argc; i++)
+		error("Unknown parameter \"%s\"\n", argv[i]);
+
+	if (argc)
+		usage_with_options(u, options);
+
+	if (!clear_err.dev_name) {
+		error("Missing device/file name passed in\n");
+		usage_with_options(u, options);
+		return -EINVAL;
+	}
+
+	if ((rc = check_dax_dev(clear_err.dev_name)) < 0)
+		return rc;
+
+	if ((rc = list_errors(&clear_err)) < 0)
+		return rc;
+
+	return 0;
+}
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 144dc23..a698096 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -68,6 +68,7 @@ static struct cmd_struct commands[] = {
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
 	{ "clear-error", cmd_clear_error },
+	{ "list-errors", cmd_list_errors },
 	{ "list", cmd_list },
 	{ "help", cmd_help },
 	#ifdef ENABLE_TEST

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
