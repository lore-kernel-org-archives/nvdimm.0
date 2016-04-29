Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5424.austin.hp.com (g1t5424.austin.hp.com [15.216.225.54])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 086091A1F61
 for <linux-nvdimm@lists.01.org>; Fri, 29 Apr 2016 13:48:27 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/3] ext4: Add alignment check for DAX mount
Date: Fri, 29 Apr 2016 14:39:33 -0600
Message-Id: <1461962375-3720-2-git-send-email-toshi.kani@hpe.com>
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

Add alignment check to ext4_fill_super() when -o dax is specified.

Reported-by: Micah Parrish <micah.parrish@hpe.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 fs/ext4/super.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 304c712..90a8670 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3421,6 +3421,12 @@ static int ext4_fill_super(struct super_block *sb, void *data, int silent)
 					"error: unsupported blocksize for dax");
 			goto failed_mount;
 		}
+		if (sb->s_bdev->bd_part->start_sect % (PAGE_SIZE / 512) ||
+		    sb->s_bdev->bd_part->nr_sects % (PAGE_SIZE / 512)) {
+			ext4_msg(sb, KERN_ERR,
+					"error: unaligned partition for dax");
+			goto failed_mount;
+		}
 		if (!sb->s_bdev->bd_disk->fops->direct_access) {
 			ext4_msg(sb, KERN_ERR,
 					"error: device does not support dax");
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
