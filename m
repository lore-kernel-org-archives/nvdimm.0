Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4C17E1A1F7E
 for <linux-nvdimm@lists.01.org>; Thu,  5 May 2016 17:39:03 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v3 5/5] xfs: Add alignment check for DAX mount
Date: Thu,  5 May 2016 18:29:56 -0600
Message-Id: <1462494596-20938-6-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
References: <1462494596-20938-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, jack@suse.cz, david@fromorbit.com, viro@zeniv.linux.org.uk
Cc: hch@infradead.org, tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, axboe@fb.com, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When a partition is not aligned by 4KB, mount -o dax succeeds,
but any read/write access to the filesystem fails, except for
metadata update.

Call bdev_supports_dax() to perform proper precondition checks
which includes this partition alignment check.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
---
 fs/xfs/xfs_super.c |   12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 187e14b..cc177da 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1558,14 +1558,12 @@ xfs_fs_fill_super(
 
 	if (mp->m_flags & XFS_MOUNT_DAX) {
 		xfs_warn(mp,
-	"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
-		if (sb->s_blocksize != PAGE_SIZE) {
-			xfs_alert(mp,
-		"Filesystem block size invalid for DAX Turning DAX off.");
-			mp->m_flags &= ~XFS_MOUNT_DAX;
-		} else if (!sb->s_bdev->bd_disk->fops->direct_access) {
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+
+		error = bdev_supports_dax(sb, sb->s_blocksize);
+		if (error) {
 			xfs_alert(mp,
-		"Block device does not support DAX Turning DAX off.");
+			"DAX unsupported by block device. Turning off DAX.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
 	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
