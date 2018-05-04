Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DDDB62063E2E8
 for <linux-nvdimm@lists.01.org>; Thu,  3 May 2018 17:16:38 -0700 (PDT)
Subject: [PATCH v3 7/9] dax: report bytes remaining in dax_iomap_actor()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 03 May 2018 17:06:42 -0700
Message-ID: <152539240242.31796.4162676712193177396.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <152539236455.31796.7516599166555186700.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <152539236455.31796.7516599166555186700.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-nvdimm@lists.01.org
Cc: tony.luck@intel.com, Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org, x86@kernel.org, hch@lst.de, Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

In preparation for protecting the dax read(2) path from media errors
with copy_to_iter_mcsafe() (via dax_copy_to_iter()), convert the
implementation to report the bytes successfully transferred.

Cc: <x86@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Andy Lutomirski <luto@amacapital.net>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/dax.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index a64afdf7ec0d..34a2d435ae4b 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -991,6 +991,7 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 	struct iov_iter *iter = data;
 	loff_t end = pos + length, done = 0;
 	ssize_t ret = 0;
+	size_t xfer;
 	int id;
 
 	if (iov_iter_rw(iter) == READ) {
@@ -1054,19 +1055,20 @@ dax_iomap_actor(struct inode *inode, loff_t pos, loff_t length, void *data,
 		 * vfs_write(), depending on which operation we are doing.
 		 */
 		if (iov_iter_rw(iter) == WRITE)
-			map_len = dax_copy_from_iter(dax_dev, pgoff, kaddr,
+			xfer = dax_copy_from_iter(dax_dev, pgoff, kaddr,
 					map_len, iter);
 		else
-			map_len = dax_copy_to_iter(dax_dev, pgoff, kaddr,
+			xfer = dax_copy_to_iter(dax_dev, pgoff, kaddr,
 					map_len, iter);
-		if (map_len <= 0) {
-			ret = map_len ? map_len : -EFAULT;
-			break;
-		}
 
-		pos += map_len;
-		length -= map_len;
-		done += map_len;
+		pos += xfer;
+		length -= xfer;
+		done += xfer;
+
+		if (xfer == 0)
+			ret = -EFAULT;
+		if (xfer < map_len)
+			break;
 	}
 	dax_read_unlock(id);
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
