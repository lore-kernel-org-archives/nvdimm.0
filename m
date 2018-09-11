Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2353.austin.hpe.com (g2t2353.austin.hpe.com [15.233.44.26])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B42EA21106C68
 for <linux-nvdimm@lists.01.org>; Tue, 11 Sep 2018 09:03:27 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/2] ext4, dax: set ext4_dax_aops for dax files
Date: Tue, 11 Sep 2018 09:42:46 -0600
Message-Id: <20180911154246.6844-3-toshi.kani@hpe.com>
In-Reply-To: <20180911154246.6844-1-toshi.kani@hpe.com>
References: <20180911154246.6844-1-toshi.kani@hpe.com>
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
Cc: tytso@mit.edu, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, adilger.kernel@dilger.ca, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Sync syscall to an existing DAX file needs to flush processor cache,
but it does not currently.  This is because 'ext4_da_aops' is set to
address_space_operations of existing DAX files, instead of 'ext4_dax_aops',
since S_DAX flag is set after ext4_set_aops() in the open path.

  New file
  --------
  lookup_open
    ext4_create
      __ext4_new_inode
        ext4_set_inode_flags   // Set S_DAX flag
      ext4_set_aops            // Set aops to ext4_dax_aops

  Existing file
  -------------
  lookup_open
    ext4_lookup
      ext4_iget
        ext4_set_aops          // Set aops to ext4_da_aops
        ext4_set_inode_flags   // Set S_DAX flag

Change ext4_iget() to call ext4_set_inode_flags() before ext4_set_aops().

Fixes: 5f0663bb4a64f588f0a2dd6d1be68d40f9af0086
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Andreas Dilger <adilger.kernel@dilger.ca>
---
 fs/ext4/inode.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ext4/inode.c b/fs/ext4/inode.c
index 775cd9b4af55..93cbbb859c40 100644
--- a/fs/ext4/inode.c
+++ b/fs/ext4/inode.c
@@ -4998,6 +4998,8 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 	if (ret)
 		goto bad_inode;
 
+	ext4_set_inode_flags(inode);
+
 	if (S_ISREG(inode->i_mode)) {
 		inode->i_op = &ext4_file_inode_operations;
 		inode->i_fop = &ext4_file_operations;
@@ -5043,7 +5045,6 @@ struct inode *ext4_iget(struct super_block *sb, unsigned long ino)
 		goto bad_inode;
 	}
 	brelse(iloc.bh);
-	ext4_set_inode_flags(inode);
 
 	unlock_new_inode(inode);
 	return inode;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
