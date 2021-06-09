Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D03C29CA
	for <nvdimm@lists.linux.dev>; Wed,  9 Jun 2021 04:37:11 +0000 (UTC)
IronPort-SDR: 1fQ8utpYbVs4h2/L5/CkTN1pIirVFH4cjJeN536ZmolA+Aryb0IZizPYru1B0gS6x2pkMiN6kg
 WoUZQpkZe0Kw==
X-IronPort-AV: E=McAfee;i="6200,9189,10009"; a="185375251"
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="185375251"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 21:37:09 -0700
IronPort-SDR: GtTIlozdkUHp57XpVKcomFMjONL4/eMcCqkCfAzw6RbY8Bcc56JI4KZYq20LgX6dQc3hzUheyv
 MnYUONbLL8Lw==
X-IronPort-AV: E=Sophos;i="5.83,260,1616482800"; 
   d="scan'208";a="552542206"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jun 2021 21:37:09 -0700
Subject: [PATCH] libnvdimm/pmem: Fix pmem_pagemap_cleanup compile warning
From: Dan Williams <dan.j.williams@intel.com>
To: axboe@kernel.dk
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-block@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org
Date: Tue, 08 Jun 2021 21:37:09 -0700
Message-ID: <162321342919.2151549.7438715629081965798.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <20210609135237.22bde319@canb.auug.org.au>
References: <20210609135237.22bde319@canb.auug.org.au>
User-Agent: StGit/0.18-3-g996c
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The recent fix to pmem_pagemap_cleanup() to solve a NULL pointer
dereference with the queue_to_disk() helper neglected to remove the @q
variable when queue_to_disk() was replaced.

Drop the conversion of @pgmap to its containing 'struct request_queue'
since pgmap->owner supersedes the need to reference @q.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Fixes: 80b58f4e9f4a ("libnvdimm/pmem: Fix blk_cleanup_disk() usage")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/pmem.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index fc6b78dd2d24..1e0615b8565e 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -335,8 +335,6 @@ static const struct attribute_group *pmem_attribute_groups[] = {
 
 static void pmem_pagemap_cleanup(struct dev_pagemap *pgmap)
 {
-	struct request_queue *q =
-		container_of(pgmap->ref, struct request_queue, q_usage_counter);
 	struct pmem_device *pmem = pgmap->owner;
 
 	blk_cleanup_disk(pmem->disk);

