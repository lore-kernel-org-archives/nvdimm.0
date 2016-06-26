Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 496081A1E10
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:21 -0700 (PDT)
Subject: [ndctl PATCH 7/9] ndctl, create-namespace: fix device-dax vs --map=
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:25:04 -0700
Message-ID: <146698350487.40541.7666344068449948979.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146698346627.40541.14661847967712551305.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Teach validate_namespace_options() about the valid device-dax scenario
of specifying a map location.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 7bf3320473ff..24a8d08c58f2 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -442,7 +442,8 @@ static int validate_namespace_options(struct ndctl_region *region,
 		else
 			p->loc = NDCTL_PFN_LOC_PMEM;
 
-		if (ndns && p->mode != NDCTL_NS_MODE_MEMORY) {
+		if (ndns && p->mode != NDCTL_NS_MODE_MEMORY
+			&& p->mode != NDCTL_NS_MODE_DAX) {
 			debug("%s: --map= only valid for memory mode namespace\n",
 				ndctl_namespace_get_devname(ndns));
 			return -EINVAL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
