Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 13F43203B9928
 for <linux-nvdimm@lists.01.org>; Thu, 17 May 2018 09:20:25 -0700 (PDT)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: fix libtool versioning
Date: Thu, 17 May 2018 10:20:12 -0600
Message-Id: <20180517162012.25694-1-vishal.l.verma@intel.com>
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

Commit fdd4f06 ("libndctl, ars: add an API to retrieve clear_err_unit")
incremented the libtool versioning 'vurrent', but neglected to increment
the 'age', resulting in an soname bump.

Fixes: commit fdd4f06 ("libndctl, ars: add an API to retrieve clear_err_unit")
Reported-by: Arjan van de Ven <arjan@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Makefile.am.in | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am.in b/Makefile.am.in
index b23b175..479d4a5 100644
--- a/Makefile.am.in
+++ b/Makefile.am.in
@@ -37,7 +37,7 @@ SED_PROCESS = \
 
 LIBNDCTL_CURRENT=16
 LIBNDCTL_REVISION=0
-LIBNDCTL_AGE=9
+LIBNDCTL_AGE=10
 
 LIBDAXCTL_CURRENT=3
 LIBDAXCTL_REVISION=0
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
