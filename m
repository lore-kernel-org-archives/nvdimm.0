Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
 by ml01.01.org (Postfix) with ESMTP id 45B2A1A1F7F
 for <linux-nvdimm@lists.01.org>; Fri, 11 Mar 2016 13:13:23 -0800 (PST)
From: Matthew Wilcox <matthew.r.wilcox@intel.com>
Subject: [PATCH 0/3] Make pfn_t suitable for placing in the radix tree
Date: Fri, 11 Mar 2016 16:13:01 -0500
Message-Id: <1457730784-9890-1-git-send-email-matthew.r.wilcox@intel.com>
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

I did some experimenting with converting the DAX radix tree from storing
sector numbers to storing pfn_t.  While we're not ready to do that
conversion yet, these pieces make sense to at least get reviewed now,
and maybe get upstream.

I think the first patch is worthwhile all by itself as a stepping stone to
making SG lists contain PFNs instead of pages.

Matthew Wilcox (3):
  pfn_t: Change the encoding
  pfn_t: Support for huge PFNs
  pfn_t: New functions pfn_t_add and pfn_t_cmp

 include/linux/pfn_t.h | 72 +++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 11 deletions(-)

-- 
2.7.0

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
