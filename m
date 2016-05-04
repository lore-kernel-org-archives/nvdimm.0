Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3426.houston.hp.com (g4t3426.houston.hp.com [15.201.208.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 60BE81A1F4D
 for <linux-nvdimm@lists.01.org>; Wed,  4 May 2016 08:54:57 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2-UPDATE 3/3] xfs: Add alignment check for DAX mount
Date: Wed,  4 May 2016 09:46:01 -0600
Message-Id: <1462376761-15584-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, david@fromorbit.com
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, micah.parrish@hpe.com, hch@infradead.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu
List-ID: <linux-nvdimm@lists.01.org>

When a partition is not aligned by 4KB, mount -o dax succeeds,
but any read/write access to the filesystem fails, except for
metadata update.

Call bdev_direct_access to check the alignment when -o dax is
specified.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Reviewed-by: Boaz Harrosh <boaz@plexistor.com>
Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <boaz@plexistor.com>
---
v2-UPDATE
 - Add a period and fix a typo in error messages (Ross Zwisler)
---
 fs/xfs/xfs_super.c |   25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 187e14b..ac18fae 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1557,15 +1557,30 @@ xfs_fs_fill_super(
 		sb->s_flags |= MS_I_VERSION;
 
 	if (mp->m_flags & XFS_MOUNT_DAX) {
+		struct blk_dax_ctl dax = {
+			.sector = 0,
+			.size = PAGE_SIZE,
+		};
 		xfs_warn(mp,
-	"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
+		"DAX enabled. Warning: EXPERIMENTAL, use at your own risk");
 		if (sb->s_blocksize != PAGE_SIZE) {
 			xfs_alert(mp,
-		"Filesystem block size invalid for DAX Turning DAX off.");
+		"Filesystem block size invalid for DAX. Turning DAX off.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
-		} else if (!sb->s_bdev->bd_disk->fops->direct_access) {
-			xfs_alert(mp,
-		"Block device does not support DAX Turning DAX off.");
+		} else if ((error = bdev_direct_access(sb->s_bdev, &dax)) < 0) {
+			switch (error) {
+			case -EOPNOTSUPP:
+				xfs_alert(mp,
+			"Block device does not support DAX. Turning DAX off.");
+				break;
+			case -EINVAL:
+				xfs_alert(mp,
+			"Partition alignment invalid for DAX. Turning DAX off.");
+				break;
+			default:
+				xfs_alert(mp,
+			"DAX access failed (%d). Turning DAX off.", error);
+			}
 			mp->m_flags &= ~XFS_MOUNT_DAX;
 		}
 	}
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
