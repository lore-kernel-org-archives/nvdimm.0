Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id F36DE222F4E28
 for <linux-nvdimm@lists.01.org>; Sat, 23 Dec 2017 16:59:39 -0800 (PST)
Subject: [PATCH v4 03/18] ext2: auto disable dax instead of failing mount
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 23 Dec 2017 16:56:17 -0800
Message-ID: <151407697703.38751.2935252018151032360.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151407695916.38751.2866053440557472361.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: akpm@linux-foundation.org
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>

Bring the ext2 filesystem in line with xfs that only warns and continues
when the "-o dax" option is specified to mount and the backing device
does not support dax. This is in preparation for removing dax support
from devices that do not enable get_user_pages() operations on dax
mappings. In other words 'gup' support is required and configurations
that were using so called 'page-less' dax will be converted back to
using the page cache.

Removing the broken 'page-less' dax support is a pre-requisite for
removing the "EXPERIMENTAL" warning when mounting a filesystem in dax
mode.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/ext2/super.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/ext2/super.c b/fs/ext2/super.c
index 7646818ab266..38f9222606ee 100644
--- a/fs/ext2/super.c
+++ b/fs/ext2/super.c
@@ -959,8 +959,11 @@ static int ext2_fill_super(struct super_block *sb, void *data, int silent)
 
 	if (sbi->s_mount_opt & EXT2_MOUNT_DAX) {
 		err = bdev_dax_supported(sb, blocksize);
-		if (err)
-			goto failed_mount;
+		if (err) {
+			ext2_msg(sb, KERN_ERR,
+				"DAX unsupported by block device. Turning off DAX.");
+			sbi->s_mount_opt &= ~EXT2_MOUNT_DAX;
+		}
 	}
 
 	/* If the blocksize doesn't match, re-read the thing.. */

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
