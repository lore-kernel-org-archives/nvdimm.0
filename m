Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C824401
	for <nvdimm@lists.linux.dev>; Fri, 26 Aug 2022 17:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661534270; x=1693070270;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KwjNfQYAzpFvaPY/cJlUEOzalTxntNE7gB2sV8ipr7o=;
  b=lchMF85z9FkNJAh+b0l7Px1xIEQXtZIYk6gvknN+xPKDZ/gnkc0dd9C0
   m2xuAQHbTW7rDU7c73Jmb/UDN4KV4rPS3v0xUiYTg9Fh+SlD0083FqEoJ
   oQ1vjUK/xh3xuh3IL0qJH4Pq85oY82hXt6lfMuu0PPOE+6ZNHSfq3Wmv7
   X0ob4q9lesD2FNTsCdEyhMTzyMWIw0iyUjKWSbb7DaDHSw1L24zi87Sby
   w+r56U1cKNNMHS0c77gl17ibU4Te+ePDzW4c2DQOfRykyhxAx6vAebet3
   gkGkDf5LCbhGPnWrGgJ1x/xLrd5JYeLzZlGutGpvmiwRUWNgguaJ/r+mK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="320659722"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="320659722"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 10:17:49 -0700
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="856078731"
Received: from jodirobx-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.108.22])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 10:17:48 -0700
Subject: [PATCH 0/4] mm, xfs, dax: Fixes for memory_failure() handling
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org, djwong@kernel.org
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>, Jane Chu <jane.chu@oracle.com>,
 Shiyang Ruan <ruansy.fnst@fujitsu.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
 Matthew Wilcox <willy@infradead.org>, Ritesh Harjani <riteshh@linux.ibm.com>,
 Naoya Horiguchi <naoya.horiguchi@nec.com>, Al Viro <viro@zeniv.linux.org.uk>,
 nvdimm@lists.linux.dev, linux-xfs@vger.kernel.org, linux-mm@kvack.org,
 linux-fsdevel@vger.kernel.org
Date: Fri, 26 Aug 2022 10:17:48 -0700
Message-ID: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

I failed to run the memory error injection section of the ndctl test
suite on linux-next prior to the merge window and as a result some bugs
were missed. While the new enabling targeted reflink enabled XFS
filesystems the bugs cropped up in the surrounding cases of DAX error
injection on ext4-fsdax and device-dax.

One new assumption / clarification in this set is the notion that if a
filesystem's ->notify_failure() handler returns -EOPNOTSUPP, then it
must be the case that the fsdax usage of page->index and page->mapping
are valid. I am fairly certain this is true for
xfs_dax_notify_failure(), but would appreciate another set of eyes.

The bulk of the change is in mm/memory-failure.c, so perhaps this set
should go through Andrew's tree.

---

Dan Williams (4):
      xfs: Quiet notify_failure EOPNOTSUPP cases
      xfs: Fix SB_BORN check in xfs_dax_notify_failure()
      mm/memory-failure: Fix detection of memory_failure() handlers
      mm/memory-failure: Fall back to vma_address() when ->notify_failure() fails


 fs/xfs/xfs_notify_failure.c |    6 +++---
 include/linux/memremap.h    |    5 +++++
 mm/memory-failure.c         |   24 +++++++++++++-----------
 3 files changed, 21 insertions(+), 14 deletions(-)

base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
