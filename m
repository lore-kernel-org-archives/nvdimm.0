Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 481751A1DF7
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jul 2016 15:03:05 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] ndctl: fix --enable-destructive build failure
Date: Fri, 29 Jul 2016 16:02:52 -0600
Message-Id: <20160729220252.32641-1-ross.zwisler@linux.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This commit:

commit 0d119368385a ("ndctl: reorganize file structure, use per sub-directory makefiles")

reorganized the file structure & makefiles in ndctl, but broke builds that
used the --enable-destructive option.  Here are some of the failure
messages:

  ../test/blk_namespaces.o: In function `test_blk_namespaces':
  /root/project/ndctl/ndctl/../test/blk_namespaces.c:222: undefined reference to `__ndctl_test_attempt'
  /root/project/ndctl/ndctl/../test/blk_namespaces.c:250: undefined reference to `__ndctl_test_skip'

The root cause of this build failure was that when --enable-destructive was
being set, test/core.c wasn't being compiled and included in the build,
hence the undefined references.

Fix the makefile to include test/core.c.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 ndctl/Makefile.am | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 56cd929..47e0044 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -53,7 +53,8 @@ endif
 if ENABLE_DESTRUCTIVE
 ndctl_SOURCES += ../test/blk_namespaces.c \
 		 ../test/pmem_namespaces.c \
-		 ../test/pcommit.c
+		 ../test/pcommit.c \
+		 ../test/core.c
 ndctl_SOURCES += builtin-bat.c
 endif
 
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
