Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A8D111A1E6E
 for <linux-nvdimm@lists.01.org>; Wed, 19 Oct 2016 20:45:35 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: revert glob support for dimm commands
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Oct 2016 20:42:33 -0700
Message-ID: <147693495320.36426.9347832920609902979.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Eric Blake <eblake@redhat.com>, qemu-devel@nongnu.org
List-ID: <linux-nvdimm@lists.01.org>

As pointed out by Eric, files in the local directory with names of the
form 'nmemX' can break the recently added glob support by filtering
otherwise valid dimm names in a glob like 'nmem[X-Y]'.  For robustness,
the glob argument would always need to be shell escaped, but at that
point it is less characters to simply rely on shell expansion of the
form nmem{X..Y}, if available.

Reported-by: Eric Blake <eblake@redhat.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-dimm.c |   70 +++++++++-----------------------------------------
 1 file changed, 13 insertions(+), 57 deletions(-)

diff --git a/ndctl/builtin-dimm.c b/ndctl/builtin-dimm.c
index 304bd83a33da..19036fd38b46 100644
--- a/ndctl/builtin-dimm.c
+++ b/ndctl/builtin-dimm.c
@@ -10,7 +10,6 @@
  * FOR A PARTICULAR PURPOSE.  See the GNU Lesser General Public License for
  * more details.
  */
-#include <glob.h>
 #include <stdio.h>
 #include <errno.h>
 #include <stdlib.h>
@@ -774,72 +773,35 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		int (*action)(struct ndctl_dimm *dimm, struct action_context *actx),
 		const struct option *options, const char *usage)
 {
-	int rc = 0, count, err = 0, glob_cnt = 0;
 	struct action_context actx = { NULL, NULL };
+	int i, rc = 0, count, err = 0;
 	const char * const u[] = {
 		usage,
 		NULL
 	};
-	char *all[] = { "all " };
-	glob_t glob_buf;
-	size_t i;
+	unsigned long id;
 
         argc = parse_options(argc, argv, options, u, 0);
 
 	if (argc == 0)
 		usage_with_options(u, options);
-	for (i = 0; i < (size_t) argc; i++) {
-		char *path;
-
+	for (i = 0; i < argc; i++) {
 		if (strcmp(argv[i], "all") == 0) {
 			argv[0] = "all";
 			argc = 1;
-			glob_cnt = 0;
 			break;
 		}
-		rc = asprintf(&path, "/sys/bus/nd/devices/%s", argv[i]);
-		if (rc < 0) {
-			fprintf(stderr, "failed to parse %s\n", argv[i]);
-			usage_with_options(u, options);
-		}
 
-		rc = glob(path, glob_cnt++ ? GLOB_APPEND : 0, NULL, &glob_buf);
-		switch (rc) {
-		case GLOB_NOSPACE:
-		case GLOB_ABORTED:
-			fprintf(stderr, "failed to parse %s\n", argv[i]);
-			usage_with_options(u, options);
-			break;
-		case GLOB_NOMATCH:
-		case 0:
-			break;
+		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
+			fprintf(stderr, "'%s' is not a valid dimm name\n",
+					argv[i]);
+			err++;
 		}
-		free(path);
-	}
-
-	if (!glob_cnt)
-		glob_buf.gl_pathc = 0;
-	count = 0;
-	for (i = 0; i < glob_buf.gl_pathc; i++) {
-		char *dimm_name	= strrchr(glob_buf.gl_pathv[i], '/');
-		unsigned long id;
-
-		if (!dimm_name++)
-			continue;
-		if (sscanf(dimm_name, "nmem%lu", &id) == 1)
-			count++;
 	}
 
-	if (strcmp(argv[0], "all") == 0) {
-		glob_buf.gl_pathc = ARRAY_SIZE(all);
-		glob_buf.gl_pathv = all;
-	} else if (!count) {
-		fprintf(stderr, "Error: ' ");
-		for (i = 0; i < (size_t) argc; i++)
-			fprintf(stderr, "%s ", argv[i]);
-		fprintf(stderr, "' does not specify any present devices\n");
-		fprintf(stderr, "See 'ndctl list -D'\n");
+	if (err == argc) {
 		usage_with_options(u, options);
+		return -EINVAL;
 	}
 
 	if (param.json) {
@@ -864,23 +826,20 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		ndctl_set_log_priority(ctx, LOG_DEBUG);
 
 	rc = 0;
+	err = 0;
 	count = 0;
-	for (i = 0; i < glob_buf.gl_pathc; i++) {
-		char *dimm_name = strrchr(glob_buf.gl_pathv[i], '/');
+	for (i = 0; i < argc; i++) {
 		struct ndctl_dimm *dimm;
 		struct ndctl_bus *bus;
-		unsigned long id;
 
-		if (!dimm_name++)
-			continue;
-		if (sscanf(dimm_name, "nmem%lu", &id) != 1)
+		if (sscanf(argv[i], "nmem%lu", &id) != 1)
 			continue;
 
 		ndctl_bus_foreach(ctx, bus) {
 			if (!util_bus_filter(bus, param.bus))
 				continue;
 			ndctl_dimm_foreach(bus, dimm) {
-				if (!util_dimm_filter(dimm, dimm_name))
+				if (!util_dimm_filter(dimm, argv[i]))
 					continue;
 				rc = action(dimm, &actx);
 				if (rc == 0)
@@ -902,9 +861,6 @@ static int dimm_action(int argc, const char **argv, struct ndctl_ctx *ctx,
 		fclose(actx.f_out);
 
  out:
-	if (glob_cnt)
-		globfree(&glob_buf);
-
 	/*
 	 * count if some actions succeeded, 0 if none were attempted,
 	 * negative error code otherwise.

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
