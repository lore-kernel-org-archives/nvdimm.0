Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8E1D32034A8A8
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jan 2018 14:08:06 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl, test: fix stale json in btt-pad-compat.sh
Date: Wed, 17 Jan 2018 15:13:24 -0700
Message-Id: <20180117221324.16588-1-vishal.l.verma@intel.com>
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

We weren't using the updated results of any but the first of the ndctl
create-namespace commands. This could potentially result in the test
being unreliable.

Use the json being emitted by the create-namespace commands to get the
device etc. for future operations. Also do a 'reset' before attempting
the old format restoration test.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/btt-pad-compat.sh | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Dan - If it is easier, I can send a patch for just adding the final
version of this test as a standalone patch. So far there have been three
patches (including this) that touch this test. This one if a minor
bugfix, so it could also be squashed with the first patch where this is
introduced.

diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index d10efe3..129401b 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -144,14 +144,14 @@ copy_xxd_img()
 create_oldfmt_ns()
 {
 	# create null-uuid namespace
-	$ndctl create-namespace -b "$bus" -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000
+	json=$($ndctl create-namespace -b "$bus" -t pmem -m raw -l 4096 -u 00000000-0000-0000-0000-000000000000)
 	eval "$(echo "$json" | sed -e "$json2var")"
 	[ -n "$dev" ] || err "$LINENO" 2
 	[ -n "$size" ] || err "$LINENO" 2
 	[ $size -gt 0 ] || err "$LINENO" 2
 
 	# reconfig it to sector mode
-	$ndctl create-namespace -b "$bus" -e $dev -m sector --force
+	json=$($ndctl create-namespace -b "$bus" -e $dev -m sector --force)
 	eval "$(echo "$json" | sed -e "$json2var")"
 	[ -n "$dev" ] || err "$LINENO" 2
 	[ -n "$size" ] || err "$LINENO" 2
@@ -185,6 +185,7 @@ do_tests()
 	verify_idx 0 1
 
 	# do the same with an old format namespace
+	reset
 	create_oldfmt_ns
 	verify_idx 0 2
 
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
