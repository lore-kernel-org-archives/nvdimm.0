Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from bombadil.infradead.org (bombadil.infradead.org [65.50.211.133])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 615B82095A58F
 for <linux-nvdimm@lists.01.org>; Wed, 31 May 2017 09:19:45 -0700 (PDT)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 23/24] tmpfs: generate random sb->s_uuid
Date: Wed, 31 May 2017 18:18:25 +0200
Message-Id: <20170531161826.23243-24-hch@lst.de>
In-Reply-To: <20170531161826.23243-1-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
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
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Amir Goldstein <amir73il@gmail.com>, linux-fsdevel@vger.kernel.org
Cc: linux-xfs@vger.kernel.org, linux-raid@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, linux-nvdimm@lists.01.org, Shaohua Li <shli@kernel.org>, Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-block@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, Steven Whitehouse <swhiteho@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

From: Amir Goldstein <amir73il@gmail.com>

This is used by overlayfs to encode intrasystem unique file handles.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 mm/shmem.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/shmem.c b/mm/shmem.c
index e67d6ba4e98e..391f2dcca727 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -75,6 +75,7 @@ static struct vfsmount *shm_mnt;
 #include <uapi/linux/memfd.h>
 #include <linux/userfaultfd_k.h>
 #include <linux/rmap.h>
+#include <linux/uuid.h>
 
 #include <linux/uaccess.h>
 #include <asm/pgtable.h>
@@ -3761,6 +3762,7 @@ int shmem_fill_super(struct super_block *sb, void *data, int silent)
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	sb->s_flags |= MS_POSIXACL;
 #endif
+	uuid_gen(&sb->s_uuid);
 
 	inode = shmem_get_inode(sb, NULL, S_IFDIR | sbinfo->mode, 0, VM_NORESERVE);
 	if (!inode)
-- 
2.11.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
