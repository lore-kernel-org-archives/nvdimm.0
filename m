Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 by ml01.01.org (Postfix) with ESMTP id 184BE1A1E18
 for <linux-nvdimm@lists.01.org>; Mon,  8 Aug 2016 11:57:58 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 3/3] radix-tree tests: properly initialize mutex
Date: Mon,  8 Aug 2016 12:57:47 -0600
Message-Id: <20160808185747.21028-3-ross.zwisler@linux.intel.com>
In-Reply-To: <20160808185747.21028-1-ross.zwisler@linux.intel.com>
References: <20160808185747.21028-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org, Konstantin Khlebnikov <koct9i@gmail.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <linux-nvdimm@lists.01.org>

The pthread_mutex_t in regression1.c wasn't being initialized properly.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/radix-tree/regression1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/radix-tree/regression1.c b/tools/testing/radix-tree/regression1.c
index 2d03a63..0d6813a 100644
--- a/tools/testing/radix-tree/regression1.c
+++ b/tools/testing/radix-tree/regression1.c
@@ -43,7 +43,7 @@
 #include "regression.h"
 
 static RADIX_TREE(mt_tree, GFP_KERNEL);
-static pthread_mutex_t mt_lock;
+static pthread_mutex_t mt_lock = PTHREAD_MUTEX_INITIALIZER;
 
 struct page {
 	pthread_mutex_t lock;
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
