Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1536221B00DFC
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 13:11:01 -0800 (PST)
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] test/btt-errors.sh: unmount the namespace before
 disabling
Date: Mon,  4 Dec 2017 14:15:29 -0700
Message-Id: <20171204211529.5944-1-vishal.l.verma@intel.com>
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

When cleaning up after the first part of the test, the disable-region
and subsequent zero-labels would fail if the namespace was mounted. Fix
this by unmounting the namespace before trying to disable it.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/btt-errors.sh | 1 +
 1 file changed, 1 insertion(+)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index d3a4694..68e3652 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -146,6 +146,7 @@ dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1
 ## ensure we get an EIO for errors in namespace metadata
 
 # reset everything to get a clean log
+if grep -q "$MNT" /proc/mounts; then umount $MNT; fi
 $NDCTL disable-region -b "$BUS" all
 $NDCTL zero-labels -b "$BUS" all
 $NDCTL enable-region -b "$BUS" all
-- 
2.14.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
