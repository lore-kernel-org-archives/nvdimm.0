Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 10AEF1A1E8F
 for <linux-nvdimm@lists.01.org>; Sat,  9 Apr 2016 12:40:32 -0700 (PDT)
Subject: [ndctl PATCH 2/4] ndctl: use filter utility routines zero-labels
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 09 Apr 2016 12:39:41 -0700
Message-ID: <20160409193941.2002.26602.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
References: <20160409193930.2002.71855.stgit@dwillia2-desk3.jf.intel.com>
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

Use the common routines for filtering a bus or a dimm by name/id.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-zero-labels.c |   27 +++++++--------------------
 1 file changed, 7 insertions(+), 20 deletions(-)

diff --git a/builtin-zero-labels.c b/builtin-zero-labels.c
index ae2bb3a8fdb0..649bd9eb9c08 100644
--- a/builtin-zero-labels.c
+++ b/builtin-zero-labels.c
@@ -4,6 +4,7 @@
 #include <unistd.h>
 #include <limits.h>
 #include <syslog.h>
+#include <util/filter.h>
 #include <util/parse-options.h>
 #include <ndctl/libndctl.h>
 
@@ -11,11 +12,10 @@ static int do_zero_dimm(struct ndctl_dimm *dimm, const char **argv, int argc,
 		bool verbose)
 {
 	struct ndctl_ctx *ctx = ndctl_dimm_get_ctx(dimm);
-	const char *name = ndctl_dimm_get_devname(dimm);
 	int i, rc, log;
 
 	for (i = 0; i < argc; i++)
-		if (strcmp(argv[i], "all") == 0 || strcmp(argv[i], name) == 0)
+		if (util_dimm_filter(dimm, argv[i]))
 			break;
 	if (i >= argc)
 		return -ENODEV;
@@ -31,7 +31,7 @@ static int do_zero_dimm(struct ndctl_dimm *dimm, const char **argv, int argc,
 
 int cmd_zero_labels(int argc, const char **argv)
 {
-	const char *nmem_bus = NULL, *provider;
+	const char *nmem_bus = NULL;
 	bool verbose = false;
 	const struct option nmem_options[] = {
 		OPT_STRING('b', "bus", &nmem_bus, "bus-id",
@@ -39,7 +39,6 @@ int cmd_zero_labels(int argc, const char **argv)
 		OPT_BOOLEAN('v',"verbose", &verbose, "turn on debug"),
 		OPT_END(),
 	};
-	unsigned long bus_id = ULONG_MAX, dimm_id;
 	const char * const u[] = {
 		"ndctl zero-labels <nmem0> [<nmem1>..<nmemN>] [<options>]",
 		NULL
@@ -54,9 +53,11 @@ int cmd_zero_labels(int argc, const char **argv)
 	if (argc == 0)
 		usage_with_options(u, nmem_options);
 	for (i = 0; i < argc; i++) {
+		unsigned long id;
+
 		if (strcmp(argv[i], "all") == 0)
 			continue;
-		if (sscanf(argv[i], "nmem%lu", &dimm_id) != 1) {
+		if (sscanf(argv[i], "nmem%lu", &id) != 1) {
 			fprintf(stderr, "unknown extra parameter \"%s\"\n",
 					argv[i]);
 			usage_with_options(u, nmem_options);
@@ -67,23 +68,9 @@ int cmd_zero_labels(int argc, const char **argv)
 	if (rc < 0)
 		return rc;
 
-	if (nmem_bus) {
-		char *end = NULL;
-
-		bus_id = strtoul(nmem_bus, &end, 0);
-		if (end)
-			bus_id = ULONG_MAX;
-	}
-
 	count = 0;
         ndctl_bus_foreach(ctx, bus) {
-		unsigned int id = ndctl_bus_get_id(bus);
-
-		provider = ndctl_bus_get_provider(bus);
-		if (bus_id < ULONG_MAX && bus_id != id)
-			continue;
-		else if (bus_id == ULONG_MAX && nmem_bus
-				&& strcmp(nmem_bus, provider) != 0)
+		if (!util_bus_filter(bus, nmem_bus))
 			continue;
 
 		ndctl_dimm_foreach(bus, dimm) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
