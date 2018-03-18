Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B00F4220C2A40
 for <linux-nvdimm@lists.01.org>; Sat, 17 Mar 2018 20:56:38 -0700 (PDT)
Date: Sun, 18 Mar 2018 12:02:17 +0800
From: kbuild test robot <lkp@intel.com>
Subject: [RFC PATCH] ext2, dax: ext2_dax_aops can be static
Message-ID: <20180318040217.GA87179@cairo>
References: <152112911591.24669.7494781212673308769.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <152112911591.24669.7494781212673308769.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: jack@suse.cz, linux-nvdimm@lists.01.org, david@fromorbit.com, linux-kernel@vger.kernel.org, linux-xfs@vger.kernel.org, kbuild-all@01.org, Jan Kara <jack@suse.com>, linux-fsdevel@vger.kernel.org, hch@lst.de
List-ID: <linux-nvdimm@lists.01.org>


Fixes: 97affa6a9d1c ("ext2, dax: introduce ext2_dax_aops")
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
---
 inode.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ext2/inode.c b/fs/ext2/inode.c
index 9590712..8ea394c8 100644
--- a/fs/ext2/inode.c
+++ b/fs/ext2/inode.c
@@ -989,7 +989,7 @@ const struct address_space_operations ext2_nobh_aops = {
 	.error_remove_page	= generic_error_remove_page,
 };
 
-const struct address_space_operations ext2_dax_aops = {
+static const struct address_space_operations ext2_dax_aops = {
 	.direct_IO		= ext2_direct_IO,
 	.writepages		= ext2_dax_writepages,
 	.set_page_dirty		= noop_set_page_dirty,
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
