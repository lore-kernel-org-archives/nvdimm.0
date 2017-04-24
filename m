Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2E50621A0480F
 for <linux-nvdimm@lists.01.org>; Mon, 24 Apr 2017 10:49:37 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 1/2] xfs: fix incorrect argument count check
Date: Mon, 24 Apr 2017 11:49:31 -0600
Message-Id: <20170424174932.15613-1-ross.zwisler@linux.intel.com>
In-Reply-To: <20170421034437.4359-1-ross.zwisler@linux.intel.com>
References: <20170421034437.4359-1-ross.zwisler@linux.intel.com>
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
To: fstests@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>, jmoyer@redhat.com, eguan@redhat.com
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-nvdimm@lists.01.org, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

t_mmap_dio.c actually requires 4 arguments, not 3 as the current check
enforces:

usage: t_mmap_dio <src file> <dest file> <size> <msg>
open src(No such file or directory) len 0 (null)

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Fixes: 456581661b4d ("xfs: test per-inode DAX flag by IO")
---
 src/t_mmap_dio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/t_mmap_dio.c b/src/t_mmap_dio.c
index 69b9ca8..6c8ca1a 100644
--- a/src/t_mmap_dio.c
+++ b/src/t_mmap_dio.c
@@ -39,7 +39,7 @@ int main(int argc, char **argv)
 	char *dfile;
 	unsigned long len, opt;
 
-	if (argc < 4)
+	if (argc < 5)
 		usage(basename(argv[0]));
 
 	while ((opt = getopt(argc, argv, "b")) != -1)
-- 
2.9.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
