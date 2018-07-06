Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A895D211F8868
 for <linux-nvdimm@lists.01.org>; Fri,  6 Jul 2018 11:28:50 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] libndctl: fix the uninject-error API actually injecting
 errors
Date: Fri,  6 Jul 2018 12:28:41 -0600
Message-Id: <20180706182841.16869-1-vishal.l.verma@intel.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
Cc: Tomasz Rochumski <tomasz.rochumski@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

The addition of the v2 APIs introduced a bug when they rerouted the
old APIs to call the new v2 ones. ndctl_namespace_uninject_error()
called ndctl_namespace_inject_error2() instead of
ndctl_namespace_uninject_error2().

Reported-by: Tomasz Rochumski <tomasz.rochumski@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/inject.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/ndctl/lib/inject.c b/ndctl/lib/inject.c
index 848f8a9..f9da02d 100644
--- a/ndctl/lib/inject.c
+++ b/ndctl/lib/inject.c
@@ -271,7 +271,7 @@ NDCTL_EXPORT int ndctl_namespace_uninject_error2(struct ndctl_namespace *ndns,
 NDCTL_EXPORT int ndctl_namespace_uninject_error(struct ndctl_namespace *ndns,
 		unsigned long long block, unsigned long long count)
 {
-	return ndctl_namespace_inject_error2(ndns, block, count, 0);
+	return ndctl_namespace_uninject_error2(ndns, block, count, 0);
 }
 
 static int bb_add_record(struct list_head *h, u64 block, u64 count)
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
