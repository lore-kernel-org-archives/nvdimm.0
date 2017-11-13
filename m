Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C5DE2203D618
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 10:15:34 -0800 (PST)
Subject: [PATCH v2 1/2] ndctl: daxctl: fix mmap size
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 13 Nov 2017 11:19:39 -0700
Message-ID: <151059717963.29832.3262165776997767425.stgit@djiang5-desk3.ch.intel.com>
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
To: dan.j.williams@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

The size for mmap needs to be aligned to the region alignment. Fix the
mapping size so that it satisfy the alignment requirement.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 daxctl/io.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/daxctl/io.c b/daxctl/io.c
index 2f8cb4a..e739d0e 100644
--- a/daxctl/io.c
+++ b/daxctl/io.c
@@ -55,6 +55,7 @@ struct io_dev {
 	struct ndctl_region *region;
 	struct ndctl_dax *dax;
 	uint64_t size;
+	uint64_t mmap_size;
 };
 
 static struct {
@@ -83,6 +84,7 @@ static bool is_stdinout(struct io_dev *io_dev)
 static int setup_device(struct io_dev *io_dev, size_t size)
 {
 	int flags, rc;
+	unsigned long align;
 
 	if (is_stdinout(io_dev))
 		return 0;
@@ -104,8 +106,14 @@ static int setup_device(struct io_dev *io_dev, size_t size)
 	if (!io_dev->is_dax)
 		return 0;
 
+	align = ndctl_dax_get_align(io_dev->dax);
+	if (align == ULLONG_MAX)
+		return -ERANGE;
+
+	io_dev->mmap_size = ALIGN(size, align);
 	flags = (io_dev->direction == IO_READ) ? PROT_READ : PROT_WRITE;
-	io_dev->mmap = mmap(NULL, size, flags, MAP_SHARED, io_dev->fd, 0);
+	io_dev->mmap = mmap(NULL, io_dev->mmap_size, flags,
+			MAP_SHARED, io_dev->fd, 0);
 	if (io_dev->mmap == MAP_FAILED) {
 		rc = -errno;
 		perror("mmap");
@@ -501,6 +509,8 @@ static void cleanup(void)
 	for (i = 0; i < 2; i++) {
 		if (is_stdinout(&io.dev[i]))
 			continue;
+		if (io.dev[i].mmap_size)
+			munmap(io.dev[i].mmap, io.dev[i].mmap_size);
 		close(io.dev[i].fd);
 	}
 }

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
