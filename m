Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g2t2352.austin.hpe.com (g2t2352.austin.hpe.com [15.233.44.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 033511A1DFF
 for <linux-nvdimm@lists.01.org>; Fri,  9 Sep 2016 15:25:27 -0700 (PDT)
From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 1/2] shmem: fix tmpfs to handle the huge= option properly
Date: Fri,  9 Sep 2016 16:24:22 -0600
Message-Id: <1473459863-11287-2-git-send-email-toshi.kani@hpe.com>
In-Reply-To: <1473459863-11287-1-git-send-email-toshi.kani@hpe.com>
References: <1473459863-11287-1-git-send-email-toshi.kani@hpe.com>
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
To: akpm@linux-foundation.org
Cc: linux-nvdimm@lists.01.org, mawilcox@microsoft.com, hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kirill.shutemov@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

shmem_get_unmapped_area() checks SHMEM_SB(sb)->huge incorrectly,
which leads to a reversed effect of "huge=" mount option.

Fix the check in shmem_get_unmapped_area().

Note, the default value of SHMEM_SB(sb)->huge remains as
SHMEM_HUGE_NEVER.  User will need to specify "huge=" option to
enable huge page mappings.

Reported-by: Hillf Danton <hillf.zj@alibaba-inc.com>
Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
---
 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index fd8b2b5..aec5b49 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1980,7 +1980,7 @@ unsigned long shmem_get_unmapped_area(struct file *file,
 				return addr;
 			sb = shm_mnt->mnt_sb;
 		}
-		if (SHMEM_SB(sb)->huge != SHMEM_HUGE_NEVER)
+		if (SHMEM_SB(sb)->huge == SHMEM_HUGE_NEVER)
 			return addr;
 	}
 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
