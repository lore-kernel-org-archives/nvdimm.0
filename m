Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F38BA70
	for <nvdimm@lists.linux.dev>; Fri,  2 Jul 2021 09:24:04 +0000 (UTC)
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AeMQE6alsgIiAHYZk9i/DZsknAlTpDfIQ3DAb?=
 =?us-ascii?q?v31ZSRFFG/Fw9vre+MjzsCWYtN9/Yh8dcK+7UpVoLUm8yXcX2/h1AV7BZniEhI?=
 =?us-ascii?q?LAFugLgrcKqAeQeREWmNQ86Y5QN4B6CPDVSWNxlNvG5mCDeOoI8Z2q97+JiI7l?=
 =?us-ascii?q?o0tQcQ=3D=3D?=
X-IronPort-AV: E=Sophos;i="5.83,316,1616428800"; 
   d="scan'208";a="110542290"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 02 Jul 2021 17:23:59 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
	by cn.fujitsu.com (Postfix) with ESMTP id 3D90E4C36A19;
	Fri,  2 Jul 2021 17:23:59 +0800 (CST)
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.2; Fri, 2 Jul 2021 17:24:01 +0800
Received: from irides.mr.mr.mr (10.167.225.141) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.2 via Frontend Transport; Fri, 2 Jul 2021 17:23:59 +0800
From: Shiyang Ruan <ruansy.fnst@fujitsu.com>
To: <linux-kernel@vger.kernel.org>, <nvdimm@lists.linux.dev>,
	<linux-fsdevel@vger.kernel.org>
CC: <djwong@kernel.org>, <dan.j.williams@intel.com>, <willy@infradead.org>,
	<jack@suse.cz>, <viro@zeniv.linux.org.uk>, <hch@lst.de>,
	<riteshh@linux.ibm.com>
Subject: [RESEND PATCH v3 0/3] fsdax: Factor helper functions to simplify the code
Date: Fri, 2 Jul 2021 17:23:54 +0800
Message-ID: <20210702092357.262744-1-ruansy.fnst@fujitsu.com>
X-Mailer: git-send-email 2.32.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-yoursite-MailScanner-ID: 3D90E4C36A19.A0C5B
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: ruansy.fnst@fujitsu.com
X-Spam-Status: No

The page fault part of fsdax code is little complex. In order to add CoW
feature and make it easy to understand, I was suggested to factor some
helper functions to simplify the current dax code.

This is separated from the previous patchset called "V3 fsdax,xfs: Add
reflink&dedupe support for fsdax" as suggested[1].

[1]: https://lore.kernel.org/linux-xfs/20210402074936.GB7057@lst.de/


Changes from previous V3:
 - Rebased on v5.13
 - Add Darrick's Reviewed-by

Changes from V2:
 - fix the type of 'major' in patch 2
 - Rebased on v5.12-rc8

Changes from V1:
 - fix Ritesh's email address
 - simplify return logic in dax_fault_cow_page()

(Rebased on v5.13)
==


Shiyang Ruan (3):
  fsdax: Factor helpers to simplify dax fault code
  fsdax: Factor helper: dax_fault_actor()
  fsdax: Output address in dax_iomap_pfn() and rename it

 fs/dax.c | 443 +++++++++++++++++++++++++++++--------------------------
 1 file changed, 234 insertions(+), 209 deletions(-)

-- 
2.32.0



