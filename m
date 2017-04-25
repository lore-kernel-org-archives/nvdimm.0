Return-Path: <owner-linux-mm@kvack.org>
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH v2 1/2] xfs: fix incorrect argument count check
Date: Tue, 25 Apr 2017 14:51:05 -0600
Message-Id: <20170425205106.20576-1-ross.zwisler@linux.intel.com>
Sender: owner-linux-mm@kvack.org
To: fstests@vger.kernel.org, Xiong Zhou <xzhou@redhat.com>, jmoyer@redhat.com, eguan@redhat.com
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Christoph Hellwig <hch@lst.de>, Dan Williams <dan.j.williams@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

t_mmap_dio.c actually requires 4 arguments, not 3 as the current check
enforces:

	# ./src/t_mmap_dio
	usage: t_mmap_dio <src file> <dest file> <size> <msg>
	# ./src/t_mmap_dio  one two three
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
