Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1841B7F4;
	Thu, 29 May 2025 19:06:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748545581; cv=none; b=l2oTBzEGeCT5ItawvEBH3ob+qRVpgb6pi3WdLIgs/FpBB1aGngCGOzPgqCro/HgP4UEjAddZtm12DMDxQX88+uopplAMlBHg8ZJjjfzcmquUyvAIzRgwjMcDkrLRxiZzA/ihyPunLBqnUKPeW3A2WULykHS8/YuXDqScG5h9vr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748545581; c=relaxed/simple;
	bh=jNIb8cNTXxGNxNRBEs159SToGVPbrXH5tKl1EB60Hjo=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=CoZGnHu1gr8/iyqgjjRptsxUWXg63gePg62tC5Se+PfBmbQ1p08KNAEPFhWUhPMGFZrLZI+XUdBilTxNECmjeisfgaXEZqCLKBp96AibHe4OZxhR8FRYX6+ELywFgmumlx+FxlSHMZ7dpr9+kMXuu4x67sq8kRdZthrwIYH14Vc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF5FC4CEE7;
	Thu, 29 May 2025 19:06:20 +0000 (UTC)
Date: Thu, 29 May 2025 15:07:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, Linux Trace Kernel
 <linux-trace-kernel@vger.kernel.org>, nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>, Shiyang Ruan
 <ruansy.fnst@fujitsu.com>, "Darrick J. Wong" <djwong@kernel.org>, Ross
 Zwisler <zwisler@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] fsdax: Remove unused trace event dax_pmd_insert_mapping
Message-ID: <20250529150722.19e04332@gandalf.local.home>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

From: Steven Rostedt <rostedt@goodmis.org>

When the dax_fault_actor() helper was factored out, it removed the calls
to the dax_pmd_insert_mapping event but never removed the event itself. As
events created do take up memory (roughly 5K), this is a waste as it is
never used.

Remove the unused dax_pmd_insert_mapping trace event.

Link: https://lore.kernel.org/all/20250529130138.544ffec4@gandalf.local.home/

Fixes: c2436190e492 ("fsdax: factor out a dax_fault_actor() helper")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
---
 include/trace/events/fs_dax.h | 48 -----------------------------------
 1 file changed, 48 deletions(-)

diff --git a/include/trace/events/fs_dax.h b/include/trace/events/fs_dax.h
index 86fe6aecff1e..4d99ee3b62ea 100644
--- a/include/trace/events/fs_dax.h
+++ b/include/trace/events/fs_dax.h
@@ -102,54 +102,6 @@ DEFINE_EVENT(dax_pmd_load_hole_class, name, \
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole);
 DEFINE_PMD_LOAD_HOLE_EVENT(dax_pmd_load_hole_fallback);
 
-DECLARE_EVENT_CLASS(dax_pmd_insert_mapping_class,
-	TP_PROTO(struct inode *inode, struct vm_fault *vmf,
-		long length, pfn_t pfn, void *radix_entry),
-	TP_ARGS(inode, vmf, length, pfn, radix_entry),
-	TP_STRUCT__entry(
-		__field(unsigned long, ino)
-		__field(unsigned long, vm_flags)
-		__field(unsigned long, address)
-		__field(long, length)
-		__field(u64, pfn_val)
-		__field(void *, radix_entry)
-		__field(dev_t, dev)
-		__field(int, write)
-	),
-	TP_fast_assign(
-		__entry->dev = inode->i_sb->s_dev;
-		__entry->ino = inode->i_ino;
-		__entry->vm_flags = vmf->vma->vm_flags;
-		__entry->address = vmf->address;
-		__entry->write = vmf->flags & FAULT_FLAG_WRITE;
-		__entry->length = length;
-		__entry->pfn_val = pfn.val;
-		__entry->radix_entry = radix_entry;
-	),
-	TP_printk("dev %d:%d ino %#lx %s %s address %#lx length %#lx "
-			"pfn %#llx %s radix_entry %#lx",
-		MAJOR(__entry->dev),
-		MINOR(__entry->dev),
-		__entry->ino,
-		__entry->vm_flags & VM_SHARED ? "shared" : "private",
-		__entry->write ? "write" : "read",
-		__entry->address,
-		__entry->length,
-		__entry->pfn_val & ~PFN_FLAGS_MASK,
-		__print_flags_u64(__entry->pfn_val & PFN_FLAGS_MASK, "|",
-			PFN_FLAGS_TRACE),
-		(unsigned long)__entry->radix_entry
-	)
-)
-
-#define DEFINE_PMD_INSERT_MAPPING_EVENT(name) \
-DEFINE_EVENT(dax_pmd_insert_mapping_class, name, \
-	TP_PROTO(struct inode *inode, struct vm_fault *vmf, \
-		long length, pfn_t pfn, void *radix_entry), \
-	TP_ARGS(inode, vmf, length, pfn, radix_entry))
-
-DEFINE_PMD_INSERT_MAPPING_EVENT(dax_pmd_insert_mapping);
-
 DECLARE_EVENT_CLASS(dax_pte_fault_class,
 	TP_PROTO(struct inode *inode, struct vm_fault *vmf, int result),
 	TP_ARGS(inode, vmf, result),
-- 
2.47.2

