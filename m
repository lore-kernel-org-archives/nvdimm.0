Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 by ml01.01.org (Postfix) with ESMTP id 97EF31A1E25
 for <linux-nvdimm@lists.01.org>; Tue, 19 Jul 2016 16:03:10 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: permit NULL as a parameter to ndctl_cmd_unref
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 19 Jul 2016 16:00:09 -0700
Message-ID: <146896920956.18759.7000784801515467749.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Tiffany Kasanicky <tiffany.j.kasanicky@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

Similar to libc free() allow NULL as a valid parameter to this freeing
routine.  This mirrors the behavior of the other *_unref() routines in
the library.

Cc: Tiffany Kasanicky <tiffany.j.kasanicky@intel.com>
Reported-by: Linda Knippers <linda.knippers@hpe.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/lib/libndctl.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 0722f79470c3..4b1247678a08 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2122,6 +2122,8 @@ NDCTL_EXPORT int ndctl_dimm_zero_labels(struct ndctl_dimm *dimm)
 
 NDCTL_EXPORT void ndctl_cmd_unref(struct ndctl_cmd *cmd)
 {
+	if (!cmd)
+		return;
 	if (--cmd->refcount == 0) {
 		if (cmd->source)
 			ndctl_cmd_unref(cmd->source);

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
