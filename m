Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D38E920349DA7
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 15:54:11 -0800 (PST)
Subject: [PATCH v3 2/2] ndctl: make mmap start at the offset
From: Dave Jiang <dave.jiang@intel.com>
Date: Mon, 13 Nov 2017 16:58:17 -0700
Message-ID: <151061749775.21517.11511124096761628152.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <151061749216.21517.4323136981641383849.stgit@djiang5-desk3.ch.intel.com>
References: <151061749216.21517.4323136981641383849.stgit@djiang5-desk3.ch.intel.com>
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

Instead of mmap at the beginning of the DAX region, map at the offset
that is aligned down. This reduces the mmap size we need to create.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 daxctl/io.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/daxctl/io.c b/daxctl/io.c
index 6e07b52..551e831 100644
--- a/daxctl/io.c
+++ b/daxctl/io.c
@@ -46,6 +46,7 @@ struct io_dev {
 	const char *parm_path;
 	char *real_path;
 	uint64_t offset;
+	uint64_t offset_diff;
 	enum io_direction direction;
 	bool is_dax;
 	bool is_char;
@@ -84,7 +85,7 @@ static bool is_stdinout(struct io_dev *io_dev)
 static int setup_device(struct io_dev *io_dev, size_t size)
 {
 	int flags, rc;
-	uint64_t align;
+	uint64_t align, offset;
 
 	if (is_stdinout(io_dev))
 		return 0;
@@ -112,8 +113,11 @@ static int setup_device(struct io_dev *io_dev, size_t size)
 
 	io_dev->mmap_size = ALIGN(size, align);
 	flags = (io_dev->direction == IO_READ) ? PROT_READ : PROT_WRITE;
+	offset = ALIGN_DOWN(io_dev->offset, align);
+	io_dev->offset_diff = io_dev->offset - offset;
+
 	io_dev->mmap = mmap(NULL, io_dev->mmap_size, flags,
-			MAP_SHARED, io_dev->fd, 0);
+			MAP_SHARED, io_dev->fd, offset);
 	if (io_dev->mmap == MAP_FAILED) {
 		rc = -errno;
 		perror("mmap");
@@ -372,17 +376,17 @@ static int64_t __do_io(struct io_dev *dst_dev, struct io_dev *src_dev,
 	ssize_t rc, count = 0;
 
 	if (zero && dst_dev->is_dax) {
-		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset;
+		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset_diff;
 		memset(dst, 0, len);
 		pmem_persist(dst, len);
 		rc = len;
 	} else if (dst_dev->is_dax && src_dev->is_dax) {
-		src = (uint8_t *)src_dev->mmap + src_dev->offset;
-		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset;
+		src = (uint8_t *)src_dev->mmap + src_dev->offset_diff;
+		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset_diff;
 		pmem_memcpy_persist(dst, src, len);
 		rc = len;
 	} else if (src_dev->is_dax) {
-		src = (uint8_t *)src_dev->mmap + src_dev->offset;
+		src = (uint8_t *)src_dev->mmap + src_dev->offset_diff;
 		if (dst_dev->offset) {
 			rc = lseek(dst_dev->fd, dst_dev->offset, SEEK_SET);
 			if (rc < 0) {
@@ -407,7 +411,7 @@ static int64_t __do_io(struct io_dev *dst_dev, struct io_dev *src_dev,
 			printf("Requested size %lu larger than source.\n",
 					len);
 	} else if (dst_dev->is_dax) {
-		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset;
+		dst = (uint8_t *)dst_dev->mmap + dst_dev->offset_diff;
 		if (src_dev->offset) {
 			rc = lseek(src_dev->fd, src_dev->offset, SEEK_SET);
 			if (rc < 0) {

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
