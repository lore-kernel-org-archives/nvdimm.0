Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D23FD21E11D26
 for <linux-nvdimm@lists.01.org>; Thu, 10 May 2018 16:47:44 -0700 (PDT)
Subject: [PATCH] ndctl: remove warning caused by -D_FORTIFY_SOURCE=2 and -O0
 compile flags
From: Dave Jiang <dave.jiang@intel.com>
Date: Thu, 10 May 2018 16:47:42 -0700
Message-ID: <152599606288.49950.18061098495140664365.stgit@djiang5-desk3.ch.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Compiler spits out warning with -D_FORTIFY_SOURCE=2 and -O0. Moving to -O2
to remove warnings.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 README.md  |    2 +-
 autogen.sh |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/README.md b/README.md
index 899dcbb8..e0bc5b7b 100644
--- a/README.md
+++ b/README.md
@@ -6,7 +6,7 @@ sub-system in the Linux kernel
 Build
 =====
 `./autogen.sh`  
-`./configure CFLAGS='-g -O0' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64`  
+`./configure CFLAGS='-g -O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib64`  
 `make`  
 `make check`  
 `sudo make install`  
diff --git a/autogen.sh b/autogen.sh
index a23cf53c..2a52688b 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -24,5 +24,5 @@ echo "----------------------------------------------------------------"
 echo "Initialized build system. For a common configuration please run:"
 echo "----------------------------------------------------------------"
 echo
-echo "./configure CFLAGS='-g -O0' $args"
+echo "./configure CFLAGS='-g -O2' $args"
 echo

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
