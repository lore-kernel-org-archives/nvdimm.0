Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946FF70
	for <nvdimm@lists.linux.dev>; Wed,  7 Jul 2021 01:01:07 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6200,9189,10037"; a="209262167"
X-IronPort-AV: E=Sophos;i="5.83,330,1616482800"; 
   d="scan'208";a="209262167"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 18:01:06 -0700
X-IronPort-AV: E=Sophos;i="5.83,330,1616482800"; 
   d="scan'208";a="481776697"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2021 18:01:05 -0700
Subject: [RFT PATCH] x86/pat: Fix set_mce_nospec() for pmem
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Jane Chu <jane.chu@oracle.com>, Luis Chamberlain <mcgrof@suse.com>,
 Borislav Petkov <bp@alien8.de>, Tony Luck <tony.luck@intel.com>
Date: Tue, 06 Jul 2021 18:01:05 -0700
Message-ID: <162561960776.1149519.9267511644788011712.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

When poison is discovered and triggers memory_failure() the physical
page is unmapped from all process address space. However, it is not
unmapped from kernel address space. Unlike a typical memory page that
can be retired from use in the page allocator and marked 'not present',
pmem needs to remain accessible given it can not be physically remapped
or retired. set_memory_uc() tries to maintain consistent nominal memtype
mappings for a given pfn, but memory_failure() is an exceptional
condition.

For the same reason that set_memory_np() bypasses memtype checks
because they do not apply in the memory failure case, memtype validation
is not applicable for marking the pmem pfn uncacheable. Use
_set_memory_uc().

Reported-by: Jane Chu <jane.chu@oracle.com>
Fixes: 284ce4011ba6 ("x86/memory_failure: Introduce {set,clear}_mce_nospec()")
Cc: Luis Chamberlain <mcgrof@suse.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
Jane, can you give this a try and see if it cleans up the error you are
seeing?

Thanks for the help.

 arch/x86/include/asm/set_memory.h |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/set_memory.h b/arch/x86/include/asm/set_memory.h
index 43fa081a1adb..0bf2274c5186 100644
--- a/arch/x86/include/asm/set_memory.h
+++ b/arch/x86/include/asm/set_memory.h
@@ -114,8 +114,13 @@ static inline int set_mce_nospec(unsigned long pfn, bool unmap)
 
 	if (unmap)
 		rc = set_memory_np(decoy_addr, 1);
-	else
-		rc = set_memory_uc(decoy_addr, 1);
+	else {
+		/*
+		 * Bypass memtype checks since memory-failure has shot
+		 * down mappings.
+		 */
+		rc = _set_memory_uc(decoy_addr, 1);
+	}
 	if (rc)
 		pr_warn("Could not invalidate pfn=0x%lx from 1:1 map\n", pfn);
 	return rc;

