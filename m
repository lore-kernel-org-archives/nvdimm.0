Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1 with cipher CAMELLIA256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 824991A1F07
 for <linux-nvdimm@lists.01.org>; Thu, 15 Sep 2016 14:09:21 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: fix create-namespace on disabled region fault
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 15 Sep 2016 14:06:00 -0700
Message-ID: <147397356046.20903.14396222458912708482.stgit@dwillia2-desk3.amr.corp.intel.com>
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

We call is_namespace_active() to check that the namespace is not active
before we clobber it, but we were failing to check if we have a
namespace at all.  Without this check we segfault when attempting to
create a namespace on a disabled region.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 13811ea22da1..9b1702d2feeb 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -552,7 +552,7 @@ static int namespace_create(struct ndctl_region *region)
 		p.size = available;
 
 	ndns = ndctl_region_get_namespace_seed(region);
-	if (is_namespace_active(ndns)) {
+	if (!ndns || is_namespace_active(ndns)) {
 		debug("%s: no %s namespace seed\n", devname,
 				ndns ? "idle" : "available");
 		return -ENODEV;
@@ -685,7 +685,7 @@ static int namespace_reconfig(struct ndctl_region *region,
 		return rc;
 
 	ndns = ndctl_region_get_namespace_seed(region);
-	if (is_namespace_active(ndns)) {
+	if (!ndns || is_namespace_active(ndns)) {
 		debug("%s: no %s namespace seed\n",
 				ndctl_region_get_devname(region),
 				ndns ? "idle" : "available");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
