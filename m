Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBF9A21B00DC0
 for <linux-nvdimm@lists.01.org>; Thu,  9 Nov 2017 23:27:04 -0800 (PST)
Subject: [RFC PATCH] mm: fix device-dax pud write-faults triggered by
 get_user_pages()
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 09 Nov 2017 23:22:52 -0800
Message-ID: <151029856297.1840.13140526760496306393.stgit@dwillia2-desk3.amr.corp.intel.com>
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
To: linux-mm@kvack.org
Cc: Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Currently only get_user_pages_fast() can safely handle the writable gup
case due to its use of pud_access_permitted() to check whether the pud
entry is writable. In the gup slow path pud_write() is used instead of
pud_access_permitted() and to date it has been unimplemented, just calls
BUG_ON().

    kernel BUG at ./include/linux/hugetlb.h:244!
    [..]
    RIP: 0010:follow_devmap_pud+0x482/0x490
    [..]
    Call Trace:
     follow_page_mask+0x28c/0x6e0
     __get_user_pages+0xe4/0x6c0
     get_user_pages_unlocked+0x130/0x1b0
     get_user_pages_fast+0x89/0xb0
     iov_iter_get_pages_alloc+0x114/0x4a0
     nfs_direct_read_schedule_iovec+0xd2/0x350
     ? nfs_start_io_direct+0x63/0x70
     nfs_file_direct_read+0x1e0/0x250
     nfs_file_read+0x90/0xc0

Use pud_access_permitted() to implement pud_write(), a later cleanup can
remove {pte,pmd,pud}_write and replace them with
{pte,pmd,pud}_access_permitted() drectly so that we only have one set of
helpers these kinds of checks. For now, implementing pud_write()
simplifies -stable backports.

Cc: <stable@vger.kernel.org>
Cc: Dave Hansen <dave.hansen@intel.com>
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

Sending this as RFC for opinion on whether this should just be a
pud_flags() & _PAGE_RW check, like pmd_write, or pud_access_permitted()
that also takes protection keys into account.

 include/linux/hugetlb.h |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index fbf5b31d47ee..6a142b240ef7 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -242,8 +242,7 @@ static inline int pgd_write(pgd_t pgd)
 #ifndef pud_write
 static inline int pud_write(pud_t pud)
 {
-	BUG();
-	return 0;
+	return pud_access_permitted(pud, WRITE);
 }
 #endif
 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
