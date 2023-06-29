Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8891D63C8
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 08:19:19 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10755"; a="123869662"
X-IronPort-AV: E=Sophos;i="6.01,168,1684767600"; 
   d="scan'208";a="123869662"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2023 17:18:09 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id 88DD8DE640
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 17:18:06 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id B2C16D8BBA
	for <nvdimm@lists.linux.dev>; Thu, 29 Jun 2023 17:18:05 +0900 (JST)
Received: from irides.g08.fujitsu.local (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id E94226C9C4;
	Thu, 29 Jun 2023 17:17:59 +0900 (JST)
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Cc: dan.j.williams@intel.com,
	willy@infradead.org,
	jack@suse.cz,
	akpm@linux-foundation.org,
	djwong@kernel.org,
	mcgrof@kernel.org
Subject: [PATCH v12 0/2] mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind
Date: Thu, 29 Jun 2023 16:16:49 +0800
Message-Id: <20230629081651.253626-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27720.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27720.005
X-TMASE-Result: 10--9.126200-10.000000
X-TMASE-MatchedRID: hVaMx/vKxVQoSt6MGxonhwrcxrzwsv5usnK72MaPSqdujEcOZiInj57V
	Ny7+UW/9bDnaZmit5bheZNY97UagkJpOjqlsrZgYKsurITpSv+MQhNjZQYyI3Jsoi2XrUn/Js98
	n9dYnJNNQSFbL1bvQASAHAopEd76vRWXiIgS5n2V4xdTY+QAKe3yk+v4CROBMf8DjiQCwSeDQ86
	vbNAcB2g==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

This patchset is to add gracefully unbind support for pmem.
Patch1 corrects the calculation of length and end of a given range.
Patch2 introduces a new flag call MF_MEM_REMOVE, to let dax holder know
it is a remove event.  With the help of notify_failure mechanism, we are
able to shutdown the filesystem on the pmem gracefully.

Changes since v11:
 Patch1:
  1. correct the count calculation in xfs_failure_pgcnt().
      (was a wrong fix in v11)
 Patch2:
  1. use new exclusive freeze_super/thaw_super API, to make sure the unbind
      progress won't be disturbed by any other freezer.

Shiyang Ruan (2):
  xfs: fix the calculation for "end" and "length"
  mm, pmem, xfs: Introduce MF_MEM_REMOVE for unbind

 drivers/dax/super.c         |  3 +-
 fs/xfs/xfs_notify_failure.c | 95 +++++++++++++++++++++++++++++++++----
 include/linux/mm.h          |  1 +
 mm/memory-failure.c         | 17 +++++--
 4 files changed, 101 insertions(+), 15 deletions(-)

-- 
2.40.1

