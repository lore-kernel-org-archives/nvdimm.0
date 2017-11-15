Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E6C421A134A8
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 17:33:20 -0800 (PST)
From: Jeff Moyer <jmoyer@redhat.com>
Subject: [patch] dax: fix PMD faults on zero-length files
Date: Tue, 14 Nov 2017 20:37:27 -0500
Message-ID: <x49y3n8s4o8.fsf@segfault.boston.devel.redhat.com>
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
To: linux-nvdimm@lists.01.org, ross.zwisler@intel.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

PMD faults on a zero length file on a file system mounted with -o dax
will not generate SIGBUS as expected.

	fd = open(...O_TRUNC);
	addr = mmap(NULL, 2*1024*1024, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
	*addr = 'a';
        <expect SIGBUS>

The problem is this code in dax_iomap_pmd_fault:

	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;

If the inode size is zero, we end up with a max_pgoff that is way larger
than 0.  :)  Fix it by using DIV_ROUND_UP, as is done elsewhere in the
kernel.

I tested this with some simple test code that ensured that SIGBUS was
received where expected.

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/fs/dax.c b/fs/dax.c
index f001d8c7..191306c 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1327,7 +1327,7 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	 * this is a reliable test.
 	 */
 	pgoff = linear_page_index(vma, pmd_addr);
-	max_pgoff = (i_size_read(inode) - 1) >> PAGE_SHIFT;
+	max_pgoff = DIV_ROUND_UP(i_size_read(inode), PAGE_SIZE);
 
 	trace_dax_pmd_fault(inode, vmf, max_pgoff, 0);
 
@@ -1351,13 +1351,13 @@ static int dax_iomap_pmd_fault(struct vm_fault *vmf,
 	if ((pmd_addr + PMD_SIZE) > vma->vm_end)
 		goto fallback;
 
-	if (pgoff > max_pgoff) {
+	if (pgoff >= max_pgoff) {
 		result = VM_FAULT_SIGBUS;
 		goto out;
 	}
 
 	/* If the PMD would extend beyond the file size */
-	if ((pgoff | PG_PMD_COLOUR) > max_pgoff)
+	if ((pgoff | PG_PMD_COLOUR) >= max_pgoff)
 		goto fallback;
 
 	/*
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
