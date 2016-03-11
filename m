Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 78F161A1F7F
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:13:23 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 3/3] pfn_t: New functions pfn_t_add and pfn_t_cmp
Date: Fri, 11 Mar 2016 16:13:04 -0500
Message-Id: <1457730784-9890-4-git-send-email-matthew.r.wilcox@intel.com>
In-Reply-To: <1457730784-9890-1-git-send-email-matthew.r.wilcox@intel.com>
References: <1457730784-9890-1-git-send-email-matthew.r.wilcox@intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, Matthew Wilcox <matthew.r.wilcox@intel.com>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

When we find a huge PFN in the radix tree, we need to add the low
bits of the index to it in order to find the PFN we are looking for.
Since we want the result to stay in pfn_t form, create pfn_t_add().

We also need to compare PFNs, for example to determine if the PFN
represents a zero page.  At the moment, we only have use for comparing
equality, but a general compare operation is no more code and may prove
useful in the future.

Signed-off-by: Matthew Wilcox <matthew.r.wilcox@intel.com>
---
 include/linux/pfn_t.h | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/include/linux/pfn_t.h b/include/linux/pfn_t.h
index 0ff4c4e..c3bb5fe 100644
--- a/include/linux/pfn_t.h
+++ b/include/linux/pfn_t.h
@@ -67,6 +67,22 @@ static inline unsigned long pfn_t_to_pfn(pfn_t pfn)
 	return v >> PFN_FLAG_BITS;
 }
 
+static inline __must_check pfn_t pfn_t_add(const pfn_t pfn, int val)
+{
+	pfn_t tmp = pfn;
+	if (tmp.val & PFN_HUGE)
+		tmp.val &= ~PFN_SIZE_MASK;
+	tmp.val &= ~PFN_SG_MASK;
+	tmp.val += val << PFN_FLAG_BITS;
+	return tmp;
+}
+
+/* Like memcmp, returns <0 if a<b, 0 if a=b and >0 if b>a */
+static inline int pfn_t_cmp(pfn_t a, pfn_t b)
+{
+	return pfn_t_to_pfn(b) - pfn_t_to_pfn(a);
+}
+
 extern pfn_t phys_to_pfn_t(phys_addr_t addr, u64 flags);
 
 static inline bool pfn_t_has_page(pfn_t pfn)
-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
