Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0DE3E82221
 for <linux-nvdimm@lists.01.org>; Tue, 20 Dec 2016 14:23:16 -0800 (PST)
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: [PATCH 0/2] Write protect DAX PMDs in *sync path
Date: Tue, 20 Dec 2016 15:23:04 -0700
Message-Id: <1482272586-21177-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: linux-kernel@vger.kernel.org
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-nvdimm@lists.01.org, Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@lst.de>, linux-mm@kvack.org, Dave Hansen <dave.hansen@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

Currently dax_mapping_entry_mkclean() fails to clean and write protect the
pmd_t of a DAX PMD entry during an *sync operation.  This can result in
data loss, as detailed in patch 2.

This series is based on Dan's "libnvdimm-pending" branch, which is the
current home for Jan's "dax: Page invalidation fixes" series.  You can find
a working tree here:

https://git.kernel.org/cgit/linux/kernel/git/zwisler/linux.git/log/?h=dax_pmd_clean

Ross Zwisler (2):
  mm: add follow_pte_pmd()
  dax: wrprotect pmd_t in dax_mapping_entry_mkclean

 fs/dax.c           | 51 ++++++++++++++++++++++++++++++++++++---------------
 include/linux/mm.h |  4 ++--
 mm/memory.c        | 41 ++++++++++++++++++++++++++++++++---------
 3 files changed, 70 insertions(+), 26 deletions(-)

-- 
2.7.4

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
