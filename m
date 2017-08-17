Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx1.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 752A921E2DA42
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 09:06:02 -0700 (PDT)
From: Jan Kara <jack@suse.cz>
Subject: [PATCH 06/13] dax: Inline dax_insert_mapping() into the callsite
Date: Thu, 17 Aug 2017 18:08:08 +0200
Message-Id: <20170817160815.30466-7-jack@suse.cz>
In-Reply-To: <20170817160815.30466-1-jack@suse.cz>
References: <20170817160815.30466-1-jack@suse.cz>
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
To: linux-fsdevel@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, Boaz Harrosh <boazh@netapp.com>, Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-xfs@vger.kernel.org, Andy Lutomirski <luto@kernel.org>, linux-ext4@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

dax_insert_mapping() has only one callsite and we will need to further
fine tune what it does for synchronous faults. Just inline it into the
callsite so that we don't have to pass awkward bools around.

Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/dax.c | 46 +++++++++++++++++++---------------------------
 1 file changed, 19 insertions(+), 27 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index 7c150eddc01a..766cb840c276 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -852,32 +852,6 @@ static int dax_iomap_pfn(struct iomap *iomap, loff_t pos, size_t size,
 	return rc;
 }
 
-static int dax_insert_mapping(struct vm_fault *vmf, struct iomap *iomap,
-			      loff_t pos, void *entry)
-{
-	const sector_t sector = dax_iomap_sector(iomap, pos);
-	struct vm_area_struct *vma = vmf->vma;
-	struct address_space *mapping = vma->vm_file->f_mapping;
-	unsigned long vaddr = vmf->address;
-	void *ret;
-	int rc;
-	pfn_t pfn;
-
-	rc = dax_iomap_pfn(iomap, pos, PAGE_SIZE, &pfn);
-	if (rc < 0)
-		return rc;
-
-	ret = dax_insert_mapping_entry(mapping, vmf, entry, sector, 0);
-	if (IS_ERR(ret))
-		return PTR_ERR(ret);
-
-	trace_dax_insert_mapping(mapping->host, vmf, ret);
-	if (vmf->flags & FAULT_FLAG_WRITE)
-		return vm_insert_mixed_mkwrite(vma, vaddr, pfn);
-	else
-		return vm_insert_mixed(vma, vaddr, pfn);
-}
-
 /*
  * The user has performed a load from a hole in the file.  Allocating a new
  * page in the file would cause excessive storage usage for workloads with
@@ -1108,6 +1082,7 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 	bool write = vmf->flags & FAULT_FLAG_WRITE;
 	int vmf_ret = 0;
 	void *entry;
+	pfn_t pfn;
 
 	trace_dax_pte_fault(inode, vmf, vmf_ret);
 	/*
@@ -1190,7 +1165,24 @@ static int dax_iomap_pte_fault(struct vm_fault *vmf,
 			count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
 			major = VM_FAULT_MAJOR;
 		}
-		error = dax_insert_mapping(vmf, &iomap, pos, entry);
+		error = dax_iomap_pfn(&iomap, pos, PAGE_SIZE, &pfn);
+		if (error < 0)
+			goto error_finish_iomap;
+
+		entry = dax_insert_mapping_entry(mapping, vmf, entry,
+						 dax_iomap_sector(&iomap, pos),
+						 0);
+		if (IS_ERR(entry)) {
+			error = PTR_ERR(entry);
+			goto error_finish_iomap;
+		}
+
+		trace_dax_insert_mapping(inode, vmf, entry);
+		if (write)
+			error = vm_insert_mixed_mkwrite(vma, vaddr, pfn);
+		else
+			error = vm_insert_mixed(vma, vaddr, pfn);
+
 		/* -EBUSY is fine, somebody else faulted on the same PTE */
 		if (error == -EBUSY)
 			error = 0;
-- 
2.12.3

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
