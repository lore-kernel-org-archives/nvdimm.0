Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7D8551A1F8A
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 13:48:30 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 3/3] xfs: Add alignment check for DAX mount
Date: Fri, 29 Apr 2016 14:39:35 -0600
Message-Id: <1461962375-3720-4-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1461962375-3720-1-git-send-email-toshi.kani@hpe.com>
References: <1461962375-3720-1-git-send-email-toshi.kani@hpe.com>
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
To: dan.j.williams@intel.com, david@fromorbit.com, jack@suse.cz
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

When a partition is not aligned by 4KB, mount -o dax succeeds,
but any read/write access to the filesystem fails, except for
metadata update.

Add alignment check to xfs_fs_fill_super() when -o dax is
specified.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dave Chinner <david@fromorbit.com> (supporter:XFS FILESYSTEM)
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/xfs/xfs_super.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index 187e14b..a17aebc 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -1563,6 +1563,11 @@ xfs_fs_fill_super(
 			xfs_alert(mp,
 		"Filesystem block size invalid for DAX Turning DAX off.");
 			mp->m_flags &= ~XFS_MOUNT_DAX;
+		} else if (sb->s_bdev->bd_part->start_sect % (PAGE_SIZE / 512)
+		   || sb->s_bdev->bd_part->nr_sects % (PAGE_SIZE / 512)) {
+			xfs_alert(mp,
+		"Partition alignment invalid for DAX Turning DAX off.");
+			mp->m_flags &= ~XFS_MOUNT_DAX;
 		} else if (!sb->s_bdev->bd_disk->fops->direct_access) {
 			xfs_alert(mp,
 		"Block device does not support DAX Turning DAX off.");
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
