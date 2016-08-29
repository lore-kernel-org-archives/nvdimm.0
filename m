Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CA1481A1E34
 for <linux-nvdimm@lists.01.org>; Mon, 29 Aug 2016 12:12:11 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v4 RESEND 2/2] ext2/4,
 xfs: call thp_get_unmapped_area() for pmd mappings
Date: Mon, 29 Aug 2016 13:11:21 -0600
Message-Id: <1472497881-9323-3-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
References: <1472497881-9323-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org
Cc: jack@suse.cz, mawilcox@microsoft.com, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, adilger.kernel@dilger.ca, linux-fsdevel@vger.kernel.org, tytso@mit.edu, kirill.shutemov@linux.intel.com, mike.kravetz@oracle.com
List-ID: <linux-nvdimm@lists.01.org>

To support DAX pmd mappings with unmodified applications,
filesystems need to align an mmap address by the pmd size.

Call thp_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <mawilcox@microsoft.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Theodore Ts'o <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
---
 fs/ext2/file.c    |    1 +
 fs/ext4/file.c    |    1 +
 fs/xfs/xfs_file.c |    1 +
 3 files changed, 3 insertions(+)

diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index 5efeefe..d86831c 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -172,6 +172,7 @@ const struct file_operations ext2_file_operations = {
 	.open		= dquot_file_open,
 	.release	= ext2_release_file,
 	.fsync		= ext2_fsync,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 };
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 261ac37..28f542b 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -703,6 +703,7 @@ const struct file_operations ext4_file_operations = {
 	.open		= ext4_file_open,
 	.release	= ext4_release_file,
 	.fsync		= ext4_sync_file,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.splice_read	= generic_file_splice_read,
 	.splice_write	= iter_file_splice_write,
 	.fallocate	= ext4_fallocate,
diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index e612a02..7f71bb8 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1662,6 +1662,7 @@ const struct file_operations xfs_file_operations = {
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
+	.get_unmapped_area = thp_get_unmapped_area,
 	.fallocate	= xfs_file_fallocate,
 };
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
