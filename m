Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g9t5008.houston.hpe.com (g9t5008.houston.hpe.com [15.241.48.72])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A5BCA21130E4A
 for <linux-nvdimm@lists.01.org>; Fri, 14 Sep 2018 07:51:18 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH v2 1/3] ext4, dax: add ext4_bmap to ext4_dax_aops
Date: Fri, 14 Sep 2018 08:51:12 -0600
Message-Id: <20180914145114.11122-2-toshi.kani@hpe.com>
In-Reply-To: <20180914145114.11122-1-toshi.kani@hpe.com>
References: <20180914145114.11122-1-toshi.kani@hpe.com>
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
To: jack@suse.cz, dan.j.williams@intel.com
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Ext4 mount path calls .bmap to the journal inode. This currently
works for the DAX mount case because ext4_iget() always set
'ext4_da_aops' to any regular files.

In preparation to fix ext4_iget() to set 'ext4_dax_aops' for ext4
DAX files, add ext4_bmap() to 'ext4_dax_aops'. .bmap works for
DAX inodes. [1]

[1]: https://lkml.org/lkml/2018/9/12/803
Fixes: 5f0663bb4a64 ("ext4, dax: introduce ext4_dax_aops")
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Suggested-by: Jan Kara <jack@suse.cz>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: <stable@vger.kernel.org>
---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index d0dd585add6a..e4acaa980467 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -3948,6 +3948,7 @@ static const struct address_space_operations ext4_dax_aops = {
 	.writepages		= ext4_dax_writepages,
 	.direct_IO		= noop_direct_IO,
 	.set_page_dirty		= noop_set_page_dirty,
+	.bmap			= ext4_bmap,
 	.invalidatepage		= noop_invalidatepage,
 };
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
