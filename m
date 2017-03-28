Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D569B21DFA7BD
 for <linux-nvdimm@lists.01.org>; Tue, 28 Mar 2017 16:19:22 -0700 (PDT)
Subject: [ndctl PATCH 4/6] ndctl, dimm: add 'write-labels' command
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 28 Mar 2017 16:14:12 -0700
Message-ID: <149074285260.18735.5356626399131336742.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <149074283171.18735.16381597942269607973.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Given that read-labels can take a binary image of a dimm's labels,
provide a way for that image to be written back. The motivation for this
change is the ability to unit test compatibility with legacy namespace
formats like Linux "memcmp order isetcookie" namespaces.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin.h     |    1 
 ndctl/dimm.c  |  132 ++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 ndctl/ndctl.c |    1 
 3 files changed, 122 insertions(+), 12 deletions(-)

diff --git a/builtin.h b/builtin.h
index 200bd8ebbdc9..a8bc848614f2 100644
--- a/builtin.h
+++ b/builtin.h
@@ -20,6 +20,7 @@ int cmd_enable_dimm(int argc, const char **argv, void *ctx);
 int cmd_disable_dimm(int argc, const char **argv, void *ctx);
 int cmd_zero_labels(int argc, const char **argv, void *ctx);
 int cmd_read_labels(int argc, const char **argv, void *ctx);
+int cmd_write_labels(int argc, const char **argv, void *ctx);
 int cmd_init_labels(int argc, const char **argv, void *ctx);
 int cmd_check_labels(int argc, const char **argv, void *ctx);
 int cmd_list(int argc, const char **argv, void *ctx);
diff --git a/ndctl/dimm.c b/ndctl/dimm.c
index 93f95308bd1e..b20a84911489 100644
--- a/ndctl/dimm.c
+++ b/ndctl/dimm.c
@@ -72,6 +72,7 @@ static const char NSINDEX_SIGNATURE[] = "NAMESPACE_INDEX\0";
 struct action_context {
 	struct json_object *jdimms;
 	FILE *f_out;
+	FILE *f_in;
 };
 
 static int action_disable(struct ndctl_dimm *dimm, struct action_context *actx)
@@ -268,23 +269,36 @@ static struct json_object *dump_json(struct ndctl_dimm *dimm,
 	return NULL;
 }
 
-static int dump_bin(FILE *f_out, struct ndctl_cmd *cmd_read, ssize_t size)
+static int rw_bin(FILE *f, struct ndctl_cmd *cmd, ssize_t size, int rw)
 {
 	char buf[4096];
-	ssize_t offset;
+	ssize_t offset, write = 0;
 
 	for (offset = 0; offset < size; offset += sizeof(buf)) {
 		ssize_t len = min_t(ssize_t, sizeof(buf), size - offset), rc;
 
-		len = ndctl_cmd_cfg_read_get_data(cmd_read, buf, len, offset);
-		if (len < 0)
-			return len;
-		rc = fwrite(buf, 1, len, f_out);
-		if (rc != len)
-			return -ENXIO;
-		fflush(f_out);
+		if (rw) {
+			len = fread(buf, 1, len, f);
+			if (len == 0)
+				break;
+			rc = ndctl_cmd_cfg_write_set_data(cmd, buf, len, offset);
+			if (rc < 0)
+				return -ENXIO;
+			write += len;
+		} else {
+			len = ndctl_cmd_cfg_read_get_data(cmd, buf, len, offset);
+			if (len < 0)
+				return len;
+			rc = fwrite(buf, 1, len, f);
+			if (rc != len)
+				return -ENXIO;
+			fflush(f);
+		}
 	}
 
+	if (write)
+		return ndctl_cmd_submit(cmd);
+
 	return 0;
 }
 
@@ -322,6 +336,49 @@ static struct ndctl_cmd *read_labels(struct ndctl_dimm *dimm)
 	return NULL;
 }
 
+static int action_write(struct ndctl_dimm *dimm, struct action_context *actx)
+{
+	struct ndctl_cmd *cmd_read, *cmd_write;
+	ssize_t size;
+	int rc = 0;
+
+	if (ndctl_dimm_is_active(dimm)) {
+		fprintf(stderr, "dimm is active, abort label write\n");
+		return -EBUSY;
+	}
+
+	cmd_read = read_labels(dimm);
+	if (!cmd_read)
+		return -ENXIO;
+
+	cmd_write = ndctl_dimm_cmd_new_cfg_write(cmd_read);
+	if (!cmd_write) {
+		ndctl_cmd_unref(cmd_read);
+		return -ENXIO;
+	}
+
+	size = ndctl_cmd_cfg_read_get_size(cmd_read);
+	rc = rw_bin(actx->f_in, cmd_write, size, 1);
+
+	/*
+	 * If the dimm is already disabled the kernel is not holding a cached
+	 * copy of the label space.
+	 */
+	if (!ndctl_dimm_is_enabled(dimm))
+		goto out;
+
+	rc = ndctl_dimm_disable(dimm);
+	if (rc)
+		goto out;
+	rc = ndctl_dimm_enable(dimm);
+
+ out:
+	ndctl_cmd_unref(cmd_read);
+	ndctl_cmd_unref(cmd_write);
+
+	return rc;
+}
+
 static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 {
 	struct ndctl_cmd *cmd_read;
@@ -341,7 +398,7 @@ static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 		else
 			rc = -ENOMEM;
 	} else
-		rc = dump_bin(actx->f_out, cmd_read, size);
+		rc = rw_bin(actx->f_out, cmd_read, size, 0);
 
 	ndctl_cmd_unref(cmd_read);
 
@@ -631,6 +688,7 @@ static int label_write_index(struct nvdimm_data *ndd, int index, u32 seq)
 static struct parameters {
 	const char *bus;
 	const char *outfile;
+	const char *infile;
 	bool force;
 	bool json;
 	bool verbose;
@@ -736,6 +794,10 @@ OPT_STRING('o', NULL, &param.outfile, "output-file", \
 	"filename to write label area contents"), \
 OPT_BOOLEAN('j', "json", &param.json, "parse label data into json")
 
+#define WRITE_OPTIONS() \
+OPT_STRING('i', NULL, &param.infile, "input-file", \
+	"filename to read label area data")
+
 #define INIT_OPTIONS() \
 OPT_BOOLEAN('f', "force", &param.force, \
 		"force initialization even if existing index-block present")
@@ -746,6 +808,12 @@ static const struct option read_options[] = {
 	OPT_END(),
 };
 
+static const struct option write_options[] = {
+	BASE_OPTIONS(),
+	WRITE_OPTIONS(),
+	OPT_END(),
+};
+
 static const struct option base_options[] = {
 	BASE_OPTIONS(),
 	OPT_END(),
@@ -761,8 +829,9 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
 {
-	struct action_context actx = { NULL, NULL };
+	struct action_context actx = { 0 };
 	int i, rc = 0, count = 0, err = 0;
+	struct ndctl_dimm *single = NULL;
 	const char * const u[] = {
 		usage,
 		NULL
@@ -810,6 +879,18 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 		}
 	}
 
+	if (!param.infile)
+		actx.f_in = stdin;
+	else {
+		actx.f_in = fopen(param.infile, "r");
+		if (!actx.f_in) {
+			fprintf(stderr, "failed to open: %s: (%s)\n",
+					param.infile, strerror(errno));
+			rc = -errno;
+			goto out;
+		}
+	}
+
 	if (param.verbose)
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
@@ -830,7 +911,12 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 			ndctl_dimm_foreach(bus, dimm) {
 				if (!util_dimm_filter(dimm, argv[i]))
 					continue;
-				rc = action(dimm, &actx);
+				if (action == action_write) {
+					single = dimm;
+					rc = 0;
+				} else
+					rc = action(dimm, &actx);
+
 				if (rc == 0)
 					count++;
 				else if (rc && !err)
@@ -840,6 +926,15 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	}
 	rc = err;
 
+	if (action == action_write) {
+		if (count > 1) {
+			error("write-labels only supports writing a single dimm\n");
+			usage_with_options(u, options);
+			return -EINVAL;
+		} else if (single)
+			rc = action(single, &actx);
+	}
+
 	if (actx.jdimms) {
 		util_display_json_array(actx.f_out, actx.jdimms,
 				JSON_C_TO_STRING_PRETTY);
@@ -849,6 +944,9 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	if (actx.f_out != stdout)
 		fclose(actx.f_out);
 
+	if (actx.f_in != stdin)
+		fclose(actx.f_in);
+
  out:
 	/*
 	 * count if some actions succeeded, 0 if none were attempted,
@@ -859,6 +957,16 @@ static int dimm_action(int argc, const char **argv, void *ctx,
 	return count;
 }
 
+int cmd_write_labels(int argc, const char **argv, void *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_write, write_options,
+			"ndctl write-labels <nmem> [-i <filename>]");
+
+	fprintf(stderr, "wrote %d nmem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
 int cmd_read_labels(int argc, const char **argv, void *ctx)
 {
 	int count = dimm_action(argc, argv, ctx, action_read, read_options,
diff --git a/ndctl/ndctl.c b/ndctl/ndctl.c
index 0678a9a29bfb..4b08c9b2a8ff 100644
--- a/ndctl/ndctl.c
+++ b/ndctl/ndctl.c
@@ -64,6 +64,7 @@ static struct cmd_struct commands[] = {
 	{ "disable-dimm", cmd_disable_dimm },
 	{ "zero-labels", cmd_zero_labels },
 	{ "read-labels", cmd_read_labels },
+	{ "write-labels", cmd_write_labels },
 	{ "init-labels", cmd_init_labels },
 	{ "check-labels", cmd_check_labels },
 	{ "list", cmd_list },

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
