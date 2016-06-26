Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 2BF961A1E05
 for <linux-nvdimm@lists.01.org>; Sun, 26 Jun 2016 16:26:16 -0700 (PDT)
Subject: [ndctl PATCH 6/9] ndctl,
 create-namespace: fix blk-namepsaces vs device-dax
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 26 Jun 2016 16:24:59 -0700
Message-ID: <146698349971.40541.523525969582933339.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Emit a usable error message when on attempts to place a blk-namespace
into device-dax mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/builtin-xaction-namespace.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/ndctl/builtin-xaction-namespace.c b/ndctl/builtin-xaction-namespace.c
index 8ce7c3e55216..7bf3320473ff 100644
--- a/ndctl/builtin-xaction-namespace.c
+++ b/ndctl/builtin-xaction-namespace.c
@@ -403,9 +403,12 @@ static int validate_namespace_options(struct ndctl_region *region,
 
 		if (ndns && ndctl_namespace_get_type(ndns)
 				== ND_DEVICE_NAMESPACE_BLK
-				&& p->mode == NDCTL_NS_MODE_MEMORY) {
-			debug("%s: blk namespace do not support memory mode\n",
-					ndctl_namespace_get_devname(ndns));
+				&& (p->mode == NDCTL_NS_MODE_MEMORY
+					|| p->mode == NDCTL_NS_MODE_DAX)) {
+			debug("%s: blk namespace do not support %s mode\n",
+					ndctl_namespace_get_devname(ndns),
+					p->mode == NDCTL_NS_MODE_MEMORY
+					? "memory" : "dax");
 				return -EINVAL;
 		}
 	} else if (ndns)

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
