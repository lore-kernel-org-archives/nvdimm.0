Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id CC4CA1A1F3A
 for <linux-nvdimm@lists.01.org>; Tue,  8 Mar 2016 15:37:53 -0800 (PST)
Subject: [ndctl PATCH 7/8] ndctl: add filter-by-type to the 'list' command
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 08 Mar 2016 15:37:04 -0800
Message-ID: <20160308233704.18628.58923.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
References: <20160308233628.18628.13786.stgit@dwillia2-desk3.jf.intel.com>
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

Limit region, and subsequently namespace, scanning by interface type
('pmem' or 'blk').

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 Documentation/ndctl-list.txt |    4 ++++
 builtin-list.c               |   21 +++++++++++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/Documentation/ndctl-list.txt b/Documentation/ndctl-list.txt
index 53847c56236e..abf3ff07cfa9 100644
--- a/Documentation/ndctl-list.txt
+++ b/Documentation/ndctl-list.txt
@@ -60,6 +60,10 @@ OPTIONS
 --region=::
 include::xable-region-options.txt[]
 
+-t::
+--type=::
+	Filter listing by region type ('pmem' or 'blk')
+
 -B::
 --buses::
 	Include bus info in the listing
diff --git a/builtin-list.c b/builtin-list.c
index 12a6d32b124a..413b36ac0208 100644
--- a/builtin-list.c
+++ b/builtin-list.c
@@ -29,6 +29,7 @@ static struct {
 static struct {
 	const char *bus;
 	const char *region;
+	const char *type;
 } param;
 
 static int did_fail;
@@ -197,6 +198,8 @@ int cmd_list(int argc, const char **argv)
 		OPT_STRING('b', "bus", &param.bus, "bus-id", "filter by bus"),
 		OPT_STRING('r', "region", &param.region, "region-id",
 				"filter by region"),
+		OPT_STRING('t', "type", &param.type, "region-type",
+				"filter by region-type"),
 		OPT_BOOLEAN('B', "buses", &list.buses, "include bus info"),
 		OPT_BOOLEAN('D', "dimms", &list.dimms, "include dimm info"),
 		OPT_BOOLEAN('R', "regions", &list.regions,
@@ -216,14 +219,29 @@ int cmd_list(int argc, const char **argv)
 	struct json_object *jbuses = NULL;
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
+	unsigned int type = 0;
 	int i, rc;
 
         argc = parse_options(argc, argv, options, u, 0);
 	for (i = 0; i < argc; i++)
 		error("unknown parameter \"%s\"\n", argv[i]);
+	if (param.type && (strcmp(param.type, "pmem") != 0
+				&& strcmp(param.type, "blk") != 0)) {
+		error("unknown type \"%s\" must be \"pmem\" or \"blk\"\n",
+				param.type);
+		argc++;
+	}
+
 	if (argc)
 		usage_with_options(u, options);
 
+	if (param.type) {
+		if (strcmp(param.type, "pmem") == 0)
+			type = ND_DEVICE_REGION_PMEM;
+		else
+			type = ND_DEVICE_REGION_BLK;
+	}
+
 	rc = ndctl_new(&ctx);
 	if (rc < 0)
 		return rc;
@@ -293,6 +311,9 @@ int cmd_list(int argc, const char **argv)
 			if (!util_region_filter(region, param.region))
 				continue;
 
+			if (type && ndctl_region_get_type(region) != type)
+				continue;
+
 			if (!list.regions) {
 				jnamespaces = list_namespaces(region, jbus,
 						jnamespaces, true);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
