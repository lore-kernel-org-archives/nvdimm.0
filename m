Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4A49207DF285
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 13:42:46 -0700 (PDT)
Subject: [ndctl PATCH] ndctl: Remove dependency on linker garbage collection
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Jul 2018 13:32:37 -0700
Message-ID: <153134115702.9810.1930499932946582440.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: vishal.l.verma@intel.com
Cc: Nick Clifton <nickc@redhat.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

A sub-set of the unit tests are optionally included in the build when
"--enable-test" is specified to the configure script. However, the "ndctl
test" command support code should not be included in the build when
"--enable-test" is not specified. The linker was being helpful and
throwing away the error, because cmd_test() is never called, but we
should not have wasted time compiling and throwing away that file in the
first place.

Reported-by: Nick Clifton <nickc@redhat.com>
Link: https://bugzilla.redhat.com/show_bug.cgi?id=1598961
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 ndctl/Makefile.am |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index 9d008d52c964..087ddc52418c 100644
--- a/ndctl/Makefile.am
+++ b/ndctl/Makefile.am
@@ -11,7 +11,6 @@ ndctl_SOURCES = ndctl.c \
 		dimm.c \
 		 ../util/log.c \
 		list.c \
-		test.c \
 		../util/json.c \
 		util/json-smart.c \
 		util/json-firmware.c \
@@ -40,7 +39,8 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/dpa-alloc.c \
 		 ../test/parent-uuid.c \
 		 ../test/multi-pmem.c \
-		 ../test/core.c
+		 ../test/core.c \
+		 test.c
 endif
 
 monitor_config_file = monitor.conf

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
