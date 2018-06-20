Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7FE6211BFCDA
 for <linux-nvdimm@lists.01.org>; Wed, 20 Jun 2018 15:51:51 -0700 (PDT)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [fstests PATCH 1/2] src/: fix up mmap() error checking
Date: Wed, 20 Jun 2018 16:51:46 -0600
Message-Id: <20180620225147.12151-1-ross.zwisler@linux.intel.com>
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
To: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

I noticed that in some of my C tests in src/ I was incorrectly checking for
mmap() failure by looking for NULL instead of MAP_FAILED.  Fix those and
clean up some places where we were testing against -1 (the actual value of
MAP_FAILED) which was manually being cast to a pointer.

Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
---
 src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c | 2 +-
 src/fstest.c                                                        | 2 +-
 src/t_ext4_dax_inline_corruption.c                                  | 4 ++--
 src/t_ext4_dax_journal_corruption.c                                 | 4 ++--
 src/t_mmap_stale_pmd.c                                              | 2 ++
 src/t_mmap_writev.c                                                 | 2 +-
 6 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c b/src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c
index 092cbb42..af381177 100644
--- a/src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c
+++ b/src/aio-dio-regress/aio-io-setup-with-nonwritable-context-pointer.c
@@ -40,7 +40,7 @@ main(int __attribute__((unused)) argc, char **argv)
 	void *addr;
 
 	addr = mmap(NULL, 4096, PROT_READ, MAP_SHARED|MAP_ANONYMOUS, 0, 0);
-	if (!addr) {
+	if (addr == MAP_FAILED) {
 		perror("mmap");
 		exit(1);
 	}
diff --git a/src/fstest.c b/src/fstest.c
index f7e2d3eb..e4b9e081 100644
--- a/src/fstest.c
+++ b/src/fstest.c
@@ -138,7 +138,7 @@ bozo!
 			exit(1);
 		}
 		p = mmap(NULL, file_size, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-		if (p == (char *)-1) {
+		if (p == MAP_FAILED) {
 			perror("mmap");
 			exit(1);
 		}
diff --git a/src/t_ext4_dax_inline_corruption.c b/src/t_ext4_dax_inline_corruption.c
index 4b7d8938..b52bcc0d 100644
--- a/src/t_ext4_dax_inline_corruption.c
+++ b/src/t_ext4_dax_inline_corruption.c
@@ -37,14 +37,14 @@ int main(int argc, char *argv[])
 		err_exit("fd");
 
 	data = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-	if (!data)
+	if (data == MAP_FAILED)
 		err_exit("mmap data");
 
 	/* this fallocate turns off inline data and turns on DAX */
 	fallocate(fd, 0, 0, PAGE(2));
 
 	dax_data = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
-	if (!dax_data)
+	if (dax_data == MAP_FAILED)
 		err_exit("mmap dax_data");
 
 	/*
diff --git a/src/t_ext4_dax_journal_corruption.c b/src/t_ext4_dax_journal_corruption.c
index 18a2acdc..fccef8f5 100644
--- a/src/t_ext4_dax_journal_corruption.c
+++ b/src/t_ext4_dax_journal_corruption.c
@@ -60,7 +60,7 @@ int main(int argc, char *argv[])
 	fallocate(fd, 0, 0, len);
 
 	dax_data = mmap(NULL, len, PROT_READ, MAP_SHARED, fd, 0);
-	if (!dax_data)
+	if (dax_data == MAP_FAILED)
 		err_exit("mmap dax_data");
 
 	/*
@@ -76,7 +76,7 @@ int main(int argc, char *argv[])
 	chattr_cmd(chattr, "+j", file);
 
 	data = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
-	if (!data)
+	if (data == MAP_FAILED)
 		err_exit("mmap data");
 
 	/*
diff --git a/src/t_mmap_stale_pmd.c b/src/t_mmap_stale_pmd.c
index b4472227..6a52201c 100644
--- a/src/t_mmap_stale_pmd.c
+++ b/src/t_mmap_stale_pmd.c
@@ -41,6 +41,8 @@ int main(int argc, char *argv[])
 	ftruncate(fd, MiB(4));
 
 	data = mmap(NULL, MiB(2), PROT_READ, MAP_SHARED, fd, MiB(2));
+	if (data == MAP_FAILED)
+		err_exit("mmap");
 
 	/*
 	 * This faults in a 2MiB zero page to satisfy the read.
diff --git a/src/t_mmap_writev.c b/src/t_mmap_writev.c
index e5ca08ab..43acc15f 100644
--- a/src/t_mmap_writev.c
+++ b/src/t_mmap_writev.c
@@ -51,7 +51,7 @@ int main(int argc, char **argv)
 	if (fd==-1) {perror("open");exit(1);}
 
 	base = mmap(NULL,16384,PROT_READ,MAP_SHARED,fd,0);
-	if  (base == (void *)-1) { perror("mmap");exit(1); }
+	if  (base == MAP_FAILED) { perror("mmap");exit(1); }
 
 	unlink(new_file);
 
-- 
2.14.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
