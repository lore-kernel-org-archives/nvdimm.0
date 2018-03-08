Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA2FB21ED1C77
 for <linux-nvdimm@lists.01.org>; Thu,  8 Mar 2018 08:49:14 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] radix tree test suite: fix mapshift build target
Date: Thu,  8 Mar 2018 09:55:24 -0700
Message-Id: <20180308165524.17427-1-ross.zwisler@linux.intel.com>
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
To: Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

The following commit

  commit c6ce3e2fe3da ("radix tree test suite: Add config option for map
  shift")

Introduced a phony makefile target called 'mapshift' that ends up
generating the file generated/map-shift.h.  This phony target was then
added as a dependency of the top level 'targets' build target, which is
what is run when you go to tools/testing/radix-tree and just type 'make'.

Unfortunately, this phony target doesn't actually work as a dependency, so
you end up getting:

$ make
make: *** No rule to make target 'generated/map-shift.h', needed by 'main.o'.  Stop.
make: *** Waiting for unfinished jobs....

Fix this by making the file generated/map-shift.h our real makefile target,
and add this a dependency of the top level build target.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tools/testing/radix-tree/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/tools/testing/radix-tree/Makefile b/tools/testing/radix-tree/Makefile
index fa7ee369b3c9..db66f8a0d4be 100644
--- a/tools/testing/radix-tree/Makefile
+++ b/tools/testing/radix-tree/Makefile
@@ -17,7 +17,7 @@ ifeq ($(BUILD), 32)
 	LDFLAGS += -m32
 endif
 
-targets: mapshift $(TARGETS)
+targets: generated/map-shift.h $(TARGETS)
 
 main:	$(OFILES)
 
@@ -42,9 +42,7 @@ radix-tree.c: ../../../lib/radix-tree.c
 idr.c: ../../../lib/idr.c
 	sed -e 's/^static //' -e 's/__always_inline //' -e 's/inline //' < $< > $@
 
-.PHONY: mapshift
-
-mapshift:
+generated/map-shift.h:
 	@if ! grep -qws $(SHIFT) generated/map-shift.h; then		\
 		echo "#define RADIX_TREE_MAP_SHIFT $(SHIFT)" >		\
 				generated/map-shift.h;			\
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
