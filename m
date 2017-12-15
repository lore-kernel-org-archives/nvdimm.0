Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9E21022119BCA
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 15:19:23 -0800 (PST)
Subject: [PATCH v3 1/4] ndctl: add support to alloc_intel_cmd for variable
 payload
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 15 Dec 2017 16:24:05 -0700
Message-ID: <151338024529.4485.13215296258978105688.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151338007905.4485.4189717376304274611.stgit@djiang5-desk3.ch.intel.com>
References: <151338007905.4485.4189717376304274611.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Certain payloads have variable size. The existing alloc_intel_cmd()
does not take into account of that. Adding additional size for allocation.
We do waste a little bit of the space because of the smart payload.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/lib/intel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/intel.c b/ndctl/lib/intel.c
index 3e4260f..b85a682 100644
--- a/ndctl/lib/intel.c
+++ b/ndctl/lib/intel.c
@@ -33,7 +33,7 @@ static struct ndctl_cmd *alloc_intel_cmd(struct ndctl_dimm *dimm,
 		return NULL;
 	}
 
-	size = sizeof(*cmd) + sizeof(struct nd_pkg_intel);
+	size = sizeof(*cmd) + sizeof(struct nd_pkg_intel) + in_size + out_size;
 	cmd = calloc(1, size);
 	if (!cmd)
 		return NULL;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
