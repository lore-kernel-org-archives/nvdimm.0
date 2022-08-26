Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BC84411
	for <nvdimm@lists.linux.dev>; Fri, 26 Aug 2022 17:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661534298; x=1693070298;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eytTo9jR/taEQMRxBFsY1ZsO/Az6sn3vkXQeKBBLxVw=;
  b=G13jmoXE/gyRtBT6RrJMVF0R4OHWQa3fumKlJxTAzbrvyXjn2l28IBCj
   Pmo6rDYRM6lVoTsYNvA93nYUfGA5E572lbSNhsbrLdbc6wfotrIUdFUjI
   tOBlXGsRkJJy2wKhUpVQK1ZT5iHwQGR/aMr6/X9qYbz2KEVy48cR3OSUd
   eAAR7w8qlZRgW726eYMcSbv4Ujtdix+mdWsigjtsASUbsszP3XLYPX9rf
   k8/GyhXWCHcmXoIeg2K2yrQ+q4mCWS/GxX+YhpuegPIgpS9MkXHFNHBLb
   QDBJjEPcga5DIHsx9Dft5V1fpkXwdDULLuKdQZ1mYpu1t98IzOFvfNY4A
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10451"; a="277570312"
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="277570312"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 10:17:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,265,1654585200"; 
   d="scan'208";a="714035729"
Received: from jodirobx-mobl2.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.108.22])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Aug 2022 10:17:55 -0700
Subject: [PATCH 1/4] xfs: Quiet notify_failure EOPNOTSUPP cases
From: Dan Williams <dan.j.williams@intel.com>
To: akpm@linux-foundation.org, djwong@kernel.org
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, Christoph Hellwig <hch@lst.de>,
 Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>,
 Goldwyn Rodrigues <rgoldwyn@suse.de>, Jane Chu <jane.chu@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <naoya.horiguchi@nec.com>,
 Ritesh Harjani <riteshh@linux.ibm.com>, nvdimm@lists.linux.dev,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Date: Fri, 26 Aug 2022 10:17:54 -0700
Message-ID: <166153427440.2758201.6709480562966161512.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com>
References: <166153426798.2758201.15108211981034512993.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

XFS always registers dax_holder_operations regardless of whether the
filesystem is capable of handling the notifications. The expectation is
that if the notify_failure handler cannot run then there are no
scenarios where it needs to run. In other words the expected semantic is
that page->index and page->mapping are valid for memory_failure() when
the conditions that cause -EOPNOTSUPP in xfs_dax_notify_failure() are
present.

A fallback to the generic memory_failure() path is expected so do not
warn when that happens.

Fixes: 6f643c57d57c ("xfs: implement ->notify_failure() for XFS")
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Darrick J. Wong <djwong@kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Chinner <david@fromorbit.com>
Cc: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <naoya.horiguchi@nec.com>
Cc: Ritesh Harjani <riteshh@linux.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 fs/xfs/xfs_notify_failure.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_notify_failure.c b/fs/xfs/xfs_notify_failure.c
index 69d9c83ea4b2..01e2721589c4 100644
--- a/fs/xfs/xfs_notify_failure.c
+++ b/fs/xfs/xfs_notify_failure.c
@@ -181,7 +181,7 @@ xfs_dax_notify_failure(
 	}
 
 	if (mp->m_rtdev_targp && mp->m_rtdev_targp->bt_daxdev == dax_dev) {
-		xfs_warn(mp,
+		xfs_debug(mp,
 			 "notify_failure() not supported on realtime device!");
 		return -EOPNOTSUPP;
 	}
@@ -194,7 +194,7 @@ xfs_dax_notify_failure(
 	}
 
 	if (!xfs_has_rmapbt(mp)) {
-		xfs_warn(mp, "notify_failure() needs rmapbt enabled!");
+		xfs_debug(mp, "notify_failure() needs rmapbt enabled!");
 		return -EOPNOTSUPP;
 	}
 

