Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6D43C21FD73D9
 for <linux-nvdimm@lists.01.org>; Thu, 22 Feb 2018 23:02:21 -0800 (PST)
Subject: [ndctl PATCH] ndctl,
 test: skip btt-pad compat test on pre-4K capable kernels
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Feb 2018 22:59:17 -0800
Message-ID: <151936915701.18166.11705045442243684598.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Prior to the introduction of v1.2 namespace labels it was not possible
to specify a pmem namespace with a 4K sector size. Skip this test when
that namespace creation attempt fails.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/btt-pad-compat.sh |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index a157c589460e..b2e395de2297 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -136,8 +136,12 @@ copy_xxd_img()
 
 create_oldfmt_ns()
 {
-	# create null-uuid namespace
+	# create null-uuid namespace, note that this requires a kernel
+	# that supports a raw namespace with a 4K sector size, prior to
+	# v4.13 raw namespaces are limited to 512-byte sector size.
+	rc=77
 	json=$($ndctl create-namespace -b "$bus" -s 64M -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
+	rc=1
 	eval "$(echo "$json" | sed -e "$json2var")"
 	[ -n "$dev" ] || err "$LINENO" 2
 	[ -n "$size" ] || err "$LINENO" 2

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
