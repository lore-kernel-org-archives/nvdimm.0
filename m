Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 251D51A1DF0
 for <linux-nvdimm@lists.01.org>; Wed, 16 Mar 2016 17:55:26 -0700 (PDT)
Subject: [ndctl PATCH 2/5] ndctl: fix blk-ns test cleanup
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 16 Mar 2016 17:54:40 -0700
Message-ID: <20160317005440.3025.71496.stgit@dwillia2-desk3.jf.intel.com>
In-Reply-To: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
References: <20160317005429.3025.395.stgit@dwillia2-desk3.jf.intel.com>
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

ndctl_namespace_foreach_safe() needs to be used when a namespace is
deleted while iterating.  Otherwise, we can walk off into uninitialized
memory and segfault.

Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/blk_namespaces.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/blk_namespaces.c b/test/blk_namespaces.c
index 968af2797feb..41c5ce0b1bd7 100644
--- a/test/blk_namespaces.c
+++ b/test/blk_namespaces.c
@@ -214,7 +214,7 @@ int test_blk_namespaces(int log_level)
 	char bdev[50];
 	struct ndctl_ctx *ctx;
 	struct ndctl_bus *bus;
-	struct ndctl_namespace *ndns[2];
+	struct ndctl_namespace *ndns[2], *_n;
 	struct ndctl_region *region, *blk_region = NULL;
 	struct ndctl_dimm *dimm;
 
@@ -307,7 +307,7 @@ int test_blk_namespaces(int log_level)
 
  err_cleanup:
 	if (blk_region) {
-		ndctl_namespace_foreach(blk_region, ndns[0])
+		ndctl_namespace_foreach_safe(blk_region, ndns[0], _n)
 			if (ndctl_namespace_get_size(ndns[0]) != 0)
 				disable_blk_namespace(ndns[0]);
 	}

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
