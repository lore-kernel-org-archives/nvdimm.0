Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 by ml01.01.org (Postfix) with ESMTP id C453E1A2148
 for <linux-nvdimm@lists.01.org>; Fri, 22 Apr 2016 12:48:22 -0700 (PDT)
Subject: [ndctl PATCH 6/8] ndctl,
 create-namespace: fix memmap location reconfiguration
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 22 Apr 2016 12:47:33 -0700
Message-ID: <146135445365.4228.4660592942992248223.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <146135442234.4228.904225076597683142.stgit@dwillia2-desk3.amr.corp.intel.com>
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

Fix segfault resulting from:

    ndctl create-namespace -M map -e namespace0.0 -f

...when 'memory' mode is implied by the source namespace.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 builtin-xaction-namespace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/builtin-xaction-namespace.c b/builtin-xaction-namespace.c
index 23b38ad0b73b..7d555a7d14a1 100644
--- a/builtin-xaction-namespace.c
+++ b/builtin-xaction-namespace.c
@@ -165,7 +165,8 @@ static int set_defaults(enum namespace_action mode)
 			rc = -EINVAL;
 		}
 
-		if (!param.reconfig && strcmp(param.mode, "memory") != 0) {
+		if (!param.reconfig && param.mode
+				&& strcmp(param.mode, "memory") != 0) {
 			error("--map only valid for a memory mode pmem namespace\n");
 			rc = -EINVAL;
 		}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
