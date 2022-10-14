Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E084694
	for <nvdimm@lists.linux.dev>; Fri, 14 Oct 2022 23:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1665791919; x=1697327919;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=utXjDwHtVMO/W0wdDgPICi14CmGCX+3qR5RCZ+LxUbs=;
  b=CN1exouODQ56gkddXNez2wWLCygc1RSCA6pHh6eRypcULbrNqLl5bCPR
   UhUh3amHntSYL6SvOiidjyUUvjj2+XBRBDH0bsYqwJST1NRu37UIvCurQ
   GVOQLcEtGdjOT+jsrl2tm/c7Qd42MLrVKRZzQiQH2K6Wmm8+qEmoixjBs
   pvUZRiyyivXzyzPEHqslcdIxL5J457fMfDIWCQKVsGXnHzfC61bk10h71
   24Ar8oy60TEWT0Ur0Kl2aHFnkePqufpUeI87Wn0ndpLqv7lhcR1bokHwu
   2R1dreUlBliBUXWtALL0Ertp3QzlXmKv8E7vphq1oxkgbBr2zxjemArCj
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="303112479"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="303112479"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:38 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10500"; a="802798941"
X-IronPort-AV: E=Sophos;i="5.95,185,1661842800"; 
   d="scan'208";a="802798941"
Received: from uyoon-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.90.112])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Oct 2022 16:58:38 -0700
Subject: [PATCH v3 17/25] devdax: Sparse fixes for xarray locking
From: Dan Williams <dan.j.williams@intel.com>
To: linux-mm@kvack.org
Cc: kernel test robot <lkp@intel.com>, david@fromorbit.com, hch@lst.de,
 nvdimm@lists.linux.dev, akpm@linux-foundation.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 14 Oct 2022 16:58:38 -0700
Message-ID: <166579191803.2236710.11651241811946564050.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
References: <166579181584.2236710.17813547487183983273.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Now that the dax-mapping-entry code has moved to a common location take
the opportunity to fixup some long standing sparse warnings. In this
case annotate the manipulations of the Xarray lock:

Fixes:
drivers/dax/mapping.c:216:13: sparse: warning: context imbalance in 'wait_entry_unlocked' - unexpected unlock
drivers/dax/mapping.c:953:9: sparse: warning: context imbalance in 'dax_writeback_one' - unexpected unlock

Reported-by: Reported-by: kernel test robot <lkp@intel.com>
Link: http://lore.kernel.org/r/202210091141.cHaQEuCs-lkp@intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/dax/mapping.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/mapping.c b/drivers/dax/mapping.c
index 19121b7421fb..803ae64c13d4 100644
--- a/drivers/dax/mapping.c
+++ b/drivers/dax/mapping.c
@@ -213,7 +213,7 @@ static void *get_unlocked_entry(struct xa_state *xas, unsigned int order)
  * (it's cycled in clear_inode() after removing the entries from i_pages)
  * After we call xas_unlock_irq(), we cannot touch xas->xa.
  */
-static void wait_entry_unlocked(struct xa_state *xas, void *entry)
+static void wait_entry_unlocked(struct xa_state *xas, void *entry) __releases(xas)
 {
 	struct wait_exceptional_entry_queue ewait;
 	wait_queue_head_t *wq;
@@ -910,7 +910,7 @@ vm_fault_t dax_insert_entry(struct xa_state *xas, struct vm_fault *vmf,
 }
 
 int dax_writeback_one(struct xa_state *xas, struct dax_device *dax_dev,
-		      struct address_space *mapping, void *entry)
+		      struct address_space *mapping, void *entry) __must_hold(xas)
 {
 	unsigned long pfn, index, count, end;
 	long ret = 0;

