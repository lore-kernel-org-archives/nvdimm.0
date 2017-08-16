Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5EE5B21DFC886
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 10:34:10 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH] dax: explain how read(2)/write(2) addresses are validated
Date: Wed, 16 Aug 2017 11:36:15 -0600
Message-Id: <20170816173615.10098-1-ross.zwisler@linux.intel.com>
In-Reply-To: <CAGXu5jJqoegDg07vR0iRRV1U_qOpZx5eLbywEwD_sm-D7sQmdA@mail.gmail.com>
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
Cc: Mark Rutland <mark.rutland@arm.com>, Jan Kara <jack@suse.cz>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <mawilcox@microsoft.com>, Will Deacon <will.deacon@arm.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, Alexander Viro <viro@zeniv.linux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux-fsdevel@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>
List-ID: <linux-nvdimm@lists.01.org>

Add a comment explaining how the user addresses provided to read(2) and
write(2) are validated in the DAX I/O path.  We call dax_copy_from_iter()
or copy_to_iter() on these without calling access_ok() first in the DAX
code, and there was a concern that the user might be able to read/write to
arbitrary kernel addresses with this path.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---

Adding a comment instead of adding redundant access_ok() calls in the DAX
code.  If this is the wrong path to take, please let me know.

 fs/dax.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/dax.c b/fs/dax.c
index 8c67517..2d50f32 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1060,6 +1060,11 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		if (map_len > end - pos)
 			map_len = end - pos;
 
+		/*
+		 * The userspace address for the memory copy has already been
+		 * validated via access_ok() in either vfs_read() or
+		 * vfs_write(), depending on which operation we are doing.
+		 */
 		if (iov_iter_rw(iter) == WRITE)
 			map_len = dax_copy_from_iter(dax_dev, pgoff, kaddr,
 					map_len, iter);
-- 
2.9.5

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
