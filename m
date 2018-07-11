Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 285CA209688E3
 for <linux-nvdimm@lists.01.org>; Wed, 11 Jul 2018 13:57:25 -0700 (PDT)
Subject: [ndctl PATCH v2] ndctl: Remove dependency on linker garbage collection
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 11 Jul 2018 13:47:27 -0700
Message-ID: <153134203155.10007.126148551207679453.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Changes in v2, rebased on latest master.

 ndctl/Makefile.am |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ndctl/Makefile.am b/ndctl/Makefile.am
index d22a37951537..0f568719f7a6 100644
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
@@ -39,5 +38,6 @@ ndctl_SOURCES += ../test/libndctl.c \
 		 ../test/dpa-alloc.c \
 		 ../test/parent-uuid.c \
 		 ../test/multi-pmem.c \
-		 ../test/core.c
+		 ../test/core.c \
+		 test.c
 endif

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
