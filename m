Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 486332034D8C9
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:00:14 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] ndctl, test: explicitly request namespace size
Date: Wed, 21 Feb 2018 16:06:11 -0700
Message-Id: <20180221230611.9640-1-ross.zwisler@linux.intel.com>
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
To: vishal.l.verma@intel.com, dan.j.williams@intel.com, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The btt-pad-compat.sh test was failing for me because the namespace it was
creating was 32 MiB in size, but it was trying to do 64 MiB worth of I/O
using xxd.  This happened because when we created the namespace we didn't
specify a size, and in nfit_test we could have hit either a 64 MiB or a 32
MiB region.  Vishal happened to be getting the 64 MiB region, and I
happened to get the 32 MiB.

Fix this by explicitly requesting a namespace size of 64 MiB.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 test/btt-pad-compat.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index 4dfe8b0..a157c58 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -137,7 +137,7 @@ copy_xxd_img()
 create_oldfmt_ns()
 {
 	# create null-uuid namespace
-	json=$($ndctl create-namespace -b "$bus" -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
+	json=$($ndctl create-namespace -b "$bus" -s 64M -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
 	eval "$(echo "$json" | sed -e "$json2var")"
 	[ -n "$dev" ] || err "$LINENO" 2
 	[ -n "$size" ] || err "$LINENO" 2
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
