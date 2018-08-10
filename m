Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D6ABB210ED0EB
 for <linux-nvdimm@lists.01.org>; Fri, 10 Aug 2018 15:56:31 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 4/5] ndctl,
 test: fix a potential null pointer dereference in 'ndctl test'
Date: Fri, 10 Aug 2018 16:56:23 -0600
Message-Id: <20180810225624.32383-5-vishal.l.verma@intel.com>
In-Reply-To: <20180810225624.32383-1-vishal.l.verma@intel.com>
References: <20180810225624.32383-1-vishal.l.verma@intel.com>
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

Static analysis reports that we can potentially dereference a null
pointer in the above function. Fix by checking the return value from the
allocation.

Cc: Dan Williams <dan.j.williams@intel.com>
Fixes: 8229da8d73a3 ("ndctl: ship the unit test as 'ndctl test'")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/test.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/test.c b/ndctl/test.c
index 285594f..25ec61c 100644
--- a/ndctl/test.c
+++ b/ndctl/test.c
@@ -55,6 +55,8 @@ int cmd_test(int argc, const char **argv, void *ctx)
 		test = ndctl_test_new(UINT_MAX);
 	else
 		test = ndctl_test_new(0);
+	if (!test)
+		return EXIT_FAILURE;
 
 	rc = test_libndctl(loglevel, test, ctx);
 	fprintf(stderr, "test-libndctl: %s\n", result(rc));
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
