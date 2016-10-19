Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C2CD01A1E82
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 09:51:06 -0700 (PDT)
Subject: [ndctl PATCH 3/8] ndctl: glob support for label commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 09:48:04 -0700
Message-ID: <147689568454.11015.6221876938428012366.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <147689566876.11015.13898062253087685236.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Permit a shell glob of dimm names to be passed to {read,zero}-labels.

For example:

	ndctl zero-labels nmem[0-3]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-labels.c |  329 +++++++++++++++++++++++++-----------------------
 1 file changed, 170 insertions(+), 159 deletions(-)

diff --git a/ndctl/builtin-labels.c b/ndctl/builtin-labels.c
index c85069d97655..ddd3eb578341 100644
--- a/ndctl/builtin-labels.c
+++ b/ndctl/builtin-labels.c
@@ -10,6 +10,7 @@
  * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
  * more details.
  */
+#include <glob.h>
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
@@ -25,6 +26,7 @@
 #include <ccan/minmax/minmax.h>
 #define CCAN_SHORT_TYPES_H
 #include <ccan/endian/endian.h>
+#include <ccan/array_size/array_size.h>
 
 enum {
 	NSINDEX_SIG_LEN = 16,
@@ -63,87 +65,14 @@ struct namespace_label {
 	le32 unused;
 };
 
-static int do_zero_dimm(struct ndctl_dimm *dimm, const char **argv, int argc,
-		bool verbose)
-{
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
-	int i, rc, log;
-
-	for (i = 0; i < argc; i++)
-		if (util_dimm_filter(dimm, argv[i]))
-			break;
-	if (i >= argc)
-		return -ENODEV;
-
-	log = ndctl_get_log_priority(ctx);
-	if (verbose)
-		ndctl_set_log_priority(ctx, LOG_DEBUG);
-	rc = ndctl_dimm_zero_labels(dimm);
-	ndctl_set_log_priority(ctx, log);
-
-	return rc;
-}
+struct action_context {
+	struct json_object *jdimms;
+	FILE *f_out;
+};
 
-int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+static int action_zero(struct ndctl_dimm *dimm, struct action_context *actx)
 {
-	const char *nmem_bus = NULL;
-	bool verbose = false;
-	const struct option nmem_options[] = {
-		OPT_STRING('b', "bus", &nmem_bus, "bus-id",
-				"<nmem> must be on a bus with an id/provider of <bus-id>"),
-		OPT_BOOLEAN('v',"verbose", &verbose, "turn on debug"),
-		OPT_END(),
-	};
-	const char * const u[] = {
-		"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]",
-		NULL
-	};
-	struct ndctl_dimm *dimm;
-	struct ndctl_bus *bus;
-	int i, rc, count, err = 0;
-
-        argc = parse_options(argc, argv, nmem_options, u, 0);
-
-	if (argc == 0)
-		usage_with_options(u, nmem_options);
-	for (i = 0; i < argc; i++) {
-		unsigned long id;
-
-		if (strcmp(argv[i], "all") == 0)
-			continue;
-		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
-			fprintf(stderr, "unknown extra parameter \"%s\"\n",
-					argv[i]);
-			usage_with_options(u, nmem_options);
-		}
-	}
-
-	count = 0;
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, nmem_bus))
-			continue;
-
-		ndctl_dimm_foreach(bus, dimm) {
-			rc = do_zero_dimm(dimm, argv, argc, verbose);
-			if (rc == 0)
-				count++;
-			else if (rc && !err)
-				err = rc;
-		}
-	}
-	rc = err;
-
-	fprintf(stderr, "zeroed %d nmem%s\n", count, count > 1 ? "s" : "");
-
-	/*
-	 * 0 if all dimms zeroed, count if at least 1 dimm zeroed, < 0
-	 * if all errors
-	 */
-	if (rc == 0)
-		return 0;
-	if (count)
-		return count;
-	return rc;
+	return ndctl_dimm_zero_labels(dimm);
 }
 
 static struct json_object *dump_label_json(struct ndctl_cmd *cmd_read, ssize_t size)
@@ -339,28 +268,16 @@ static int dump_bin(FILE *f_out, struct ndctl_cmd *cmd_read, ssize_t size)
 	return 0;
 }
 
-static int do_read_dimm(FILE *f_out, struct ndctl_dimm *dimm, const char **argv,
-		int argc, bool verbose, struct json_object *jdimms)
+static int action_read(struct ndctl_dimm *dimm, struct action_context *actx)
 {
-	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
 	struct ndctl_bus *bus = ndctl_dimm_get_bus(dimm);
 	struct ndctl_cmd *cmd_size, *cmd_read;
 	ssize_t size;
-	int i, rc, log;
-
-	for (i = 0; i < argc; i++)
-		if (util_dimm_filter(dimm, argv[i]))
-			break;
-	if (i >= argc)
-		return -ENODEV;
-
-	log = ndctl_get_log_priority(ctx);
-	if (verbose)
-		ndctl_set_log_priority(ctx, LOG_DEBUG);
+	int rc;
 
 	rc = ndctl_bus_wait_probe(bus);
 	if (rc < 0)
-		goto out;
+		return rc;
 
 	cmd_size = ndctl_dimm_cmd_new_cfg_size(dimm);
 	if (!cmd_size)
@@ -379,116 +296,210 @@ static int do_read_dimm(FILE *f_out, struct ndctl_dimm *dimm, const char **argv,
 		goto out_read;
 
 	size = ndctl_cmd_cfg_size_get_size(cmd_size);
-	if (jdimms) {
+	if (actx->jdimms) {
 		struct json_object *jdimm = dump_json(dimm, cmd_read, size);
 		if (!jdimm)
 			return -ENOMEM;
-		json_object_array_add(jdimms, jdimm);
+		json_object_array_add(actx->jdimms, jdimm);
 	} else
-		rc = dump_bin(f_out, cmd_read, size);
+		rc = dump_bin(actx->f_out, cmd_read, size);
 
  out_read:
 	ndctl_cmd_unref(cmd_read);
  out_size:
 	ndctl_cmd_unref(cmd_size);
- out:
-	ndctl_set_log_priority(ctx, log);
 
 	return rc;
 }
 
-int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+static struct parameters {
+	const char *bus;
+	const char *outfile;
+	bool json;
+	bool verbose;
+} param;
+
+#define BASE_OPTIONS() \
+OPT_STRING('b', "bus", &param.bus, "bus-id", \
+	"<nmem> must be on a bus with an id/provider of <bus-id>"), \
+OPT_BOOLEAN('v',"verbose", &param.verbose, "turn on debug")
+
+#define READ_OPTIONS() \
+OPT_STRING('o', NULL, &param.outfile, "output-file", \
+	"filename to write label area contents"), \
+OPT_BOOLEAN('j', "json", &param.json, "parse label data into json")
+
+static const struct option read_options[] = {
+	BASE_OPTIONS(),
+	READ_OPTIONS(),
+	OPT_END(),
+};
+
+static const struct option zero_options[] = {
+	BASE_OPTIONS(),
+	OPT_END(),
+};
+
+static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
+		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
+		const struct option *options, const char *usage)
 {
-	const char *nmem_bus = NULL, *output = NULL;
-	bool verbose = false, json = false;
-	const struct option nmem_options[] = {
-		OPT_STRING('b', "bus", &nmem_bus, "bus-id",
-				"<nmem> must be on a bus with an id/provider of <bus-id>"),
-		OPT_STRING('o', NULL, &output, "output-file",
-				"filename to write label area contents"),
-		OPT_BOOLEAN('j', "json", &json, "parse label data into json"),
-		OPT_BOOLEAN('v',"verbose", &verbose, "turn on debug"),
-		OPT_END(),
-	};
+	int rc = 0, count, err = 0, glob_cnt = 0;
+	struct action_context actx = { NULL, NULL };
 	const char * const u[] = {
-		"ndctl read-labels <nmem0> [<nmem1>..<nmemN>] [-o <filename>]",
+		usage,
 		NULL
 	};
-	struct json_object *jdimms = NULL;
-	struct ndctl_dimm *dimm;
-	struct ndctl_bus *bus;
-	int i, rc, count = 0, err = 0;
-	FILE *f_out = NULL;
+	char *all[] = { "all " };
+	glob_t glob_buf;
+	size_t i;
 
-        argc = parse_options(argc, argv, nmem_options, u, 0);
+        argc = parse_options(argc, argv, options, u, 0);
 
 	if (argc == 0)
-		usage_with_options(u, nmem_options);
-	for (i = 0; i < argc; i++) {
+		usage_with_options(u, options);
+	for (i = 0; i < (size_t) argc; i++) {
+		char *path;
+
+		if (strcmp(argv[i], "all") == 0) {
+			argv[0] = "all";
+			argc = 1;
+			glob_cnt = 0;
+			break;
+		}
+		rc = asprintf(&path, "/sys/bus/nd/devices/%s", argv[i]);
+		if (rc < 0) {
+			fprintf(stderr, "failed to parse %s\n", argv[i]);
+			usage_with_options(u, options);
+		}
+
+		rc = glob(path, glob_cnt++ ? GLOB_APPEND : 0, NULL, &glob_buf);
+		switch (rc) {
+		case GLOB_NOSPACE:
+		case GLOB_ABORTED:
+			fprintf(stderr, "failed to parse %s\n", argv[i]);
+			usage_with_options(u, options);
+			break;
+		case GLOB_NOMATCH:
+		case 0:
+			break;
+		}
+		free(path);
+	}
+
+	if (!glob_cnt)
+		glob_buf.gl_pathc = 0;
+	count = 0;
+	for (i = 0; i < glob_buf.gl_pathc; i++) {
+		char *dimm_name	= strrchr(glob_buf.gl_pathv[i], '/');
 		unsigned long id;
 
-		if (strcmp(argv[i], "all") == 0)
+		if (!dimm_name++)
 			continue;
-		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
-			fprintf(stderr, "unknown extra parameter \"%s\"\n",
-					argv[i]);
-			usage_with_options(u, nmem_options);
-		}
+		if (sscanf(dimm_name, "nmem%lu", &id) == 1)
+			count++;
+	}
+
+	if (strcmp(argv[0], "all") == 0) {
+		glob_buf.gl_pathc = ARRAY_SIZE(all);
+		glob_buf.gl_pathv = all;
+	} else if (!count) {
+		fprintf(stderr, "Error: ' ");
+		for (i = 0; i < (size_t) argc; i++)
+			fprintf(stderr, "%s ", argv[i]);
+		fprintf(stderr, "' does not specify any present devices\n");
+		fprintf(stderr, "See 'ndctl list -D'\n");
+		usage_with_options(u, options);
 	}
 
-	if (json) {
-		jdimms = json_object_new_array();
-		if (!jdimms)
+	if (param.json) {
+		actx.jdimms = json_object_new_array();
+		if (!actx.jdimms)
 			return -ENOMEM;
 	}
 
-	if (!output)
-		f_out = stdout;
+	if (!param.outfile)
+		actx.f_out = stdout;
 	else {
-		f_out = fopen(output, "w+");
-		if (!f_out) {
+		actx.f_out = fopen(param.outfile, "w+");
+		if (!actx.f_out) {
 			fprintf(stderr, "failed to open: %s: (%s)\n",
-					output, strerror(errno));
+					param.outfile, strerror(errno));
 			rc = -errno;
 			goto out;
 		}
 	}
 
-        ndctl_bus_foreach(ctx, bus) {
-		if (!util_bus_filter(bus, nmem_bus))
+	if (param.verbose)
+		ndctl_set_log_priority(ctx, LOG_DEBUG);
+
+	rc = 0;
+	count = 0;
+	for (i = 0; i < glob_buf.gl_pathc; i++) {
+		char *dimm_name = strrchr(glob_buf.gl_pathv[i], '/');
+		struct ndctl_dimm *dimm;
+		struct ndctl_bus *bus;
+		unsigned long id;
+
+		if (!dimm_name++)
+			continue;
+		if (sscanf(dimm_name, "nmem%lu", &id) != 1)
 			continue;
 
-		ndctl_dimm_foreach(bus, dimm) {
-			rc = do_read_dimm(f_out, dimm, argv, argc, verbose,
-					jdimms);
-			if (rc == 0)
-				count++;
-			else if (rc && !err)
-				err = rc;
+		ndctl_bus_foreach(ctx, bus) {
+			if (!util_bus_filter(bus, param.bus))
+				continue;
+			ndctl_dimm_foreach(bus, dimm) {
+				if (!util_dimm_filter(dimm, dimm_name))
+					continue;
+				rc = action(dimm, &actx);
+				if (rc == 0)
+					count++;
+				else if (rc && !err)
+					err = rc;
+			}
 		}
 	}
 	rc = err;
 
-	if (jdimms)
+	if (actx.jdimms) {
+		util_display_json_array(actx.f_out, actx.jdimms,
+				JSON_C_TO_STRING_PRETTY);
+		json_object_put(actx.jdimms);
+	}
 
-	fprintf(stderr, "read %d nmem%s\n", count, count > 1 ? "s" : "");
+	if (actx.f_out != stdout)
+		fclose(actx.f_out);
 
  out:
-	if (jdimms) {
-		util_display_json_array(f_out, jdimms, JSON_C_TO_STRING_PRETTY);
-		json_object_put(jdimms);
-	}
-
-	if (f_out != stdout)
-		fclose(f_out);
+	if (glob_cnt)
+		globfree(&glob_buf);
 
 	/*
-	 * 0 if all dimms zeroed, count if at least 1 dimm zeroed, < 0
-	 * if all errors
+	 * count if some actions succeeded, 0 if none were attempted,
+	 * negative error code otherwise.
 	 */
-	if (rc == 0)
-		return 0;
-	if (count)
-		return count;
-	return rc;
+	if (rc < 0)
+		return rc;
+	return count;
+}
+
+int cmd_read_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_read, read_options,
+			"ndctl read-labels <nmem0> [<nmem1>..<nmemN>] [-o <filename>]");
+
+	fprintf(stderr, "read %d nmem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
+}
+
+int cmd_zero_labels(int argc, const char **argv, struct ndctl_ctx *ctx)
+{
+	int count = dimm_action(argc, argv, ctx, action_zero, zero_options,
+			"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]");
+
+	fprintf(stderr, "zeroed %d nmem%s\n", count >= 0 ? count : 0,
+			count > 1 ? "s" : "");
+	return count >= 0 ? 0 : EXIT_FAILURE;
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
