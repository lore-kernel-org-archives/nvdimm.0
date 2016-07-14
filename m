Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 by ml01.01.org (Postfix) with ESMTP id 67EC61A1E10
 for <linux-nvdimm@lists.01.org>; Thu, 14 Jul 2016 14:41:54 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] dax: some small updates to dax.txt documentation
Date: Thu, 14 Jul 2016 15:40:48 -0600
Message-Id: <20160714214049.20075-1-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-nvdimm@lists.01.org, Andreas Dilger <adilger.kernel@dilger.ca>, Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

These are originally from Matthew Wilcox and were part of his huge
"mm,fs,dax: Change ->pmd_fault to ->huge_fault" patch that was part of PUD
support.

I'm breaking these small changes out as they stand on their own and add
useful information to Documentation/filesystems/dax.txt.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 Documentation/filesystems/dax.txt | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/dax.txt b/Documentation/filesystems/dax.txt
index ce4587d..0c16a22 100644
--- a/Documentation/filesystems/dax.txt
+++ b/Documentation/filesystems/dax.txt
@@ -49,6 +49,7 @@ These block devices may be used for inspiration:
 - axonram: Axon DDR2 device driver
 - brd: RAM backed block device driver
 - dcssblk: s390 dcss block device driver
+- pmem: NVDIMM persistent memory driver
 
 
 Implementation Tips for Filesystem Writers
@@ -75,8 +76,9 @@ calls to get_block() (for example by a page-fault racing with a read()
 or a write()) work correctly.
 
 These filesystems may be used for inspiration:
-- ext2: the second extended filesystem, see Documentation/filesystems/ext2.txt
-- ext4: the fourth extended filesystem, see Documentation/filesystems/ext4.txt
+- ext2: see Documentation/filesystems/ext2.txt
+- ext4: see Documentation/filesystems/ext4.txt
+- xfs:  see Documentation/filesystems/xfs.txt
 
 
 Handling Media Errors
-- 
2.9.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
