Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C84720979D2D
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 13:28:59 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, test: fix timeouts in device-dax
Date: Wed, 11 Jul 2018 14:28:54 -0600
Message-Id: <20180711202854.27767-1-vishal.l.verma@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>

The device-dax test used heuristic timeouts for distinction between
cached and uncached accesses. The timeout was too short for emulated
e820 on a virtual machine. Increased the cached timeout to ~30ms, which
still keeps it significantly far from the cached time of 200ms.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/device-dax.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/device-dax.c b/test/device-dax.c
index dd92f9a..46580fc 100644
--- a/test/device-dax.c
+++ b/test/device-dax.c
@@ -97,7 +97,7 @@ static void sigbus(int sig, siginfo_t *siginfo, void *d)
  * 3.00GHz where the loop, for the align == 2M case, completes in 7500us
  * when cached and 200ms when uncached.
  */
-#define VERIFY_TIME(x) (suseconds_t) ((ALIGN(x, SZ_2M) / SZ_4K) * 30)
+#define VERIFY_TIME(x) (suseconds_t) ((ALIGN(x, SZ_2M) / SZ_4K) * 60)
 
 static int verify_data(struct daxctl_dev *dev, char *dax_buf,
 		unsigned long align, int salt, struct ndctl_test *test)
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
