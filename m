Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C9A1721B00DC4
 for <linux-nvdimm@lists.01.org>; Fri, 10 Nov 2017 11:41:12 -0800 (PST)
Subject: [PATCH] ndctl: daxctl: fix mmap size
From: Dave Jiang <dave.jiang@intel.com>
Date: Fri, 10 Nov 2017 12:45:11 -0700
Message-ID: <151034311187.59853.17265892705257743788.stgit@djiang5-desk3.ch.intel.com>
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

The size for mmap needs to be aligned to the region alignment. Add helper
funciton to determine the actual size to be mmap'd.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 daxctl/io.c |   23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/daxctl/io.c b/daxctl/io.c
index 2f8cb4a..97a4169 100644
--- a/daxctl/io.c
+++ b/daxctl/io.c
@@ -80,9 +80,26 @@ static bool is_stdinout(struct io_dev *io_dev)
 			io_dev->fd == STDOUT_FILENO) ? true : false;
 }
 
+static int get_mmap_size(struct io_dev *io_dev, size_t size, size_t *map_size)
+{
+	unsigned long align;
+
+	align = ndctl_dax_get_align(io_dev->dax);
+	if (align == ULLONG_MAX)
+		return -ERANGE;
+
+	if (size <= align)
+		*map_size = align;
+	else
+		*map_size = (size / align) * align;
+
+	return 0;
+}
+
 static int setup_device(struct io_dev *io_dev, size_t size)
 {
 	int flags, rc;
+	size_t map_size;
 
 	if (is_stdinout(io_dev))
 		return 0;
@@ -104,8 +121,12 @@ static int setup_device(struct io_dev *io_dev, size_t size)
 	if (!io_dev->is_dax)
 		return 0;
 
+	rc = get_mmap_size(io_dev, size, &map_size);
+	if (rc < 0)
+		return rc;
+
 	flags = (io_dev->direction == IO_READ) ? PROT_READ : PROT_WRITE;
-	io_dev->mmap = mmap(NULL, size, flags, MAP_SHARED, io_dev->fd, 0);
+	io_dev->mmap = mmap(NULL, map_size, flags, MAP_SHARED, io_dev->fd, 0);
 	if (io_dev->mmap == MAP_FAILED) {
 		rc = -errno;
 		perror("mmap");

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
