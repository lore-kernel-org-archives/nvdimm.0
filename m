Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5370721194D49
 for <linux-nvdimm@lists.01.org>; Wed, 13 Jun 2018 14:07:45 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH] generic/223: skip when using DAX
Date: Wed, 13 Jun 2018 15:07:42 -0600
Message-Id: <20180613210742.28148-1-ross.zwisler@linux.intel.com>
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
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

As of these upstream kernel commits:

commit 6e2608dfd934 ("xfs, dax: introduce xfs_dax_aops")
commit 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")

generic/223 fails on XFS and ext4 because filesystems mounted with DAX no
longer support bmap.  This is desired behavior and will not be fixed,
according to:

https://lists.01.org/pipermail/linux-nvdimm/2018-April/015383.html

So, just skip over generic/223 when using DAX so we don't throw false
positive test failures.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 tests/generic/223 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/223 b/tests/generic/223
index dfd8c41b..1a7cf269 100755
--- a/tests/generic/223
+++ b/tests/generic/223
@@ -31,6 +31,7 @@ _supported_os Linux
 
 _require_scratch
 _require_xfs_io_command "falloc"
+_exclude_scratch_mount_option dax
 
 rm -f $seqres.full
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
