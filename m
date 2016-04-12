Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g1t5425.austin.hp.com (g1t5425.austin.hp.com [15.216.225.55])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 65FD81A2174
 for <linux-nvdimm@lists.01.org>; Tue, 12 Apr 2016 13:48:10 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 3/5] xfs: call dax_get_unmapped_area() for DAX pmd mappings
Date: Tue, 12 Apr 2016 14:39:30 -0600
Message-Id: <1460493572-31667-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
References: <1460493572-31667-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org, dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

To support DAX pmd mappings with unmodified applications,
filesystems need to align an mmap address by the pmd size.

Call dax_get_unmapped_area() from f_op->get_unmapped_area.

Note, there is no change in behavior for a non-DAX file.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <xfs@oss.sgi.com>
---
 fs/xfs/xfs_file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 569938a..51c554b 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -1708,6 +1708,9 @@ const struct file_operations xfs_file_operations = {
 	.open		= xfs_file_open,
 	.release	= xfs_file_release,
 	.fsync		= xfs_file_fsync,
+#ifdef CONFIG_FS_DAX
+	.get_unmapped_area = dax_get_unmapped_area,
+#endif
 	.fallocate	= xfs_file_fallocate,
 };
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
