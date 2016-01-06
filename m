Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v7 1/9] dax: fix NULL pointer dereference in __dax_dbg()
Date: Wed,  6 Jan 2016 11:00:55 -0700
Message-Id: <1452103263-1592-2-git-send-email-ross.zwisler@linux.intel.com>
In-Reply-To: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
References: <1452103263-1592-1-git-send-email-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: linux-kernel@vger.kernel.org
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, "H. Peter Anvin" <hpa@zytor.com>, "J. Bruce Fields" <bfields@fieldses.org>, Theodore Ts'o <tytso@mit.edu>, Alexander Viro <viro@zeniv.linux.org.uk>, Andreas Dilger <adilger.kernel@dilger.ca>, Andrew Morton <akpm@linux-foundation.org>, Dan Williams <dan.j.williams@intel.com>, Dave Chinner <david@fromorbit.com>, Dave Hansen <dave.hansen@linux.intel.com>, Ingo Molnar <mingo@redhat.com>, Jan Kara <jack@suse.com>, Jeff Layton <jlayton@poochiereds.net>, Matthew Wilcox <matthew.r.wilcox@intel.com>, Matthew Wilcox <willy@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, x86@kernel.org, xfs@oss.sgi.com
List-ID: <linux-nvdimm@lists.01.org>

__dax_dbg() currently assumes that bh->b_bdev is non-NULL, passing it into
bdevname() where is is dereferenced.  This assumption isn't always true -
when called for reads of holes, ext4_dax_mmap_get_block() returns a buffer
head where bh->b_bdev is never set.  I hit this BUG while testing the DAX
PMD fault path.

Instead, verify that we have a valid bh->b_bdev, else just say "unknown"
for the block device.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7af8797..03cc4a3 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -563,7 +563,12 @@ static void __dax_dbg(struct buffer_head *bh, unsigned long address,
 {
 	if (bh) {
 		char bname[BDEVNAME_SIZE];
-		bdevname(bh->b_bdev, bname);
+
+		if (bh->b_bdev)
+			bdevname(bh->b_bdev, bname);
+		else
+			snprintf(bname, BDEVNAME_SIZE, "unknown");
+
 		pr_debug("%s: %s addr: %lx dev %s state %lx start %lld "
 			"length %zd fallback: %s\n", fn, current->comm,
 			address, bname, bh->b_state, (u64)bh->b_blocknr,
-- 
2.5.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
