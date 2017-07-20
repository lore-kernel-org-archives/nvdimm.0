Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 69B4621D1B2B4
 for <linux-nvdimm@lists.01.org>; Wed, 19 Jul 2017 21:55:21 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: allow bus device names as a filter option
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 19 Jul 2017 21:50:51 -0700
Message-ID: <150052625182.6153.8007089681147602446.stgit@dwillia2-desk3.amr.corp.intel.com>
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

For example, allow:

    ndctl list -b ndbus0

...in addition to the existing provider based method:

    ndctl list -b ACPI.NFIT

...or the id based method:

    ndctl list -b 0

Cc: Vishal Verma <vishal.l.verma@intel.com>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 util/filter.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/util/filter.c b/util/filter.c
index 74ab3535c98e..93d56928a3dc 100644
--- a/util/filter.c
+++ b/util/filter.c
@@ -21,8 +21,8 @@
 struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident)
 {
 	char *end = NULL;
-	const char *provider;
 	unsigned long bus_id, id;
+	const char *provider, *devname;
 
 	if (!ident || strcmp(ident, "all") == 0)
 		return bus;
@@ -32,12 +32,14 @@ struct ndctl_bus *util_bus_filter(struct ndctl_bus *bus, const char *ident)
 		bus_id = ULONG_MAX;
 
 	provider = ndctl_bus_get_provider(bus);
+	devname = ndctl_bus_get_devname(bus);
 	id = ndctl_bus_get_id(bus);
 
 	if (bus_id < ULONG_MAX && bus_id == id)
 		return bus;
 
-	if (bus_id == ULONG_MAX && strcmp(ident, provider) == 0)
+	if (bus_id == ULONG_MAX && (strcmp(ident, provider) == 0
+				|| strcmp(ident, devname) == 0))
 		return bus;
 
 	return NULL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
