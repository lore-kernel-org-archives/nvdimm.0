Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F78621E3EA73
 for <linux-nvdimm@lists.01.org>; Tue,  5 Sep 2017 15:33:29 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 8/9] ext4: add sanity check for encryption + DAX
Date: Tue,  5 Sep 2017 16:35:40 -0600
Message-Id: <20170905223541.20594-9-ross.zwisler@linux.intel.com>
In-Reply-To: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
References: <20170905223541.20594-1-ross.zwisler@linux.intel.com>
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
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, "Darrick J. Wong" <darrick.wong@oracle.com>, Dave Chinner <david@fromorbit.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org, Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>, linux-ext4@vger.kernel.org, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

We prevent DAX from being used on inodes which are using ext4's built in
encryption via a check in ext4_should_use_dax().  We do have what appears
to be an unsafe transition of S_DAX in ext4_set_context(), though, where
S_DAX can get disabled without us doing a proper writeback + invalidate.

I actually think we are safe in this case because of the following:

1) You can't encrypt an existing file.  Encryption can only be set on an
empty directory, with new inodes in that directory being created with
encryption turned on, so I don't think it's possible to turn encryption on
for a file that has open DAX mmaps or outstanding I/Os.

2) There is no way to turn encryption off on a given file.  Once an inode
is encrypted, it stays encrypted for the life of that inode, so we don't
have to worry about the case where we turn encryption off and S_DAX
suddenly turns on.

3) The only way we end up in ext4_set_context() to turn on encryption is
when we are creating a new file in the encrypted directory.  This happens
as part of ext4_create() before the inode has been allowed to do any I/O.
Here's the call tree:

 ext4_create()
   __ext4_new_inode()
	 ext4_set_inode_flags() // sets S_DAX
	 fscrypt_inherit_context()
		fscrypt_get_encryption_info();
		ext4_set_context() // sets EXT4_INODE_ENCRYPT, clears S_DAX

So, I actually think it's safe to transition S_DAX in ext4_set_context()
without any locking, writebacks or invalidations.  I've added a
WARN_ON_ONCE() sanity check to make sure that we are notified if we ever
encounter a case where we are encrypting an inode that already has data,
in which case we need to add code to safely transition S_DAX.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
CC: stable@vger.kernel.org
---
 fs/ext4/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index d549dfb..6604a18 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1159,6 +1159,9 @@ static int ext4_set_context(struct inode *inode, const void *ctx, size_t len,
 	if (inode->i_ino == EXT4_ROOT_INO)
 		return -EPERM;
 
+	if (WARN_ON_ONCE(IS_DAX(inode) && i_size_read(inode)))
+		return -EINVAL;
+
 	res = ext4_convert_inline_data(inode);
 	if (res)
 		return res;
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
