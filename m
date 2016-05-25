Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 225741A1E70
 for <linux-nvdimm@lists.01.org>; Wed, 25 May 2016 16:27:38 -0700 (PDT)
Subject: [ndctl PATCH] ndctl, list: display named devices by default
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 25 May 2016 16:26:41 -0700
Message-ID: <146421880119.1718.16999953314573964681.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Instead of being silent when no list options are specified, default to
list the device if it is the only parameter specified.  For example,
before:

    # ndctl list -d nmem0
    #

...after:

    # ndctl list -d nmem0
    {
      "dev":"nmem0",
      "id":"cdab-ffffffff"
    }
    #

...in other words omit the need for --dimms to be specified for this
case.

Reported-by: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-list.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/ndctl/builtin-list.c b/ndctl/builtin-list.c
index 2080337252c8..5c5dc5a5db5b 100644
--- a/ndctl/builtin-list.c
+++ b/ndctl/builtin-list.c
@@ -179,6 +179,11 @@ static struct json_object *region_to_json(struct ndctl_region *region)
 	return NULL;
 }
 
+static int num_list_flags(void)
+{
+	return list.buses + list.dimms + list.regions + list.namespaces;
+}
+
 int cmd_list(int argc, const char **argv)
 {
 	const struct option options[] = {
@@ -212,9 +217,6 @@ int cmd_list(int argc, const char **argv)
 	unsigned int type = 0;
 	int i, rc;
 
-	if (argc == 1)
-		list.namespaces = true;
-
         argc = parse_options(argc, argv, options, u, 0);
 	for (i = 0; i < argc; i++)
 		error("unknown parameter \"%s\"\n", argv[i]);
@@ -228,6 +230,15 @@ int cmd_list(int argc, const char **argv)
 	if (argc)
 		usage_with_options(u, options);
 
+	if (num_list_flags() == 0) {
+		list.buses = !!param.bus;
+		list.regions = !!param.region;
+		list.dimms = !!param.dimm;
+	}
+
+	if (num_list_flags() == 0)
+		list.namespaces = true;
+
 	if (param.type) {
 		if (strcmp(param.type, "pmem") == 0)
 			type = ND_DEVICE_REGION_PMEM;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
