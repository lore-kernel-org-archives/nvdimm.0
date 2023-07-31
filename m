Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EDA18000
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 11:30:22 +0000 (UTC)
Received: from dggpeml500025.china.huawei.com (unknown [172.30.72.57])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4RDwxQ0Czyz1GDJw
	for <nvdimm@lists.linux.dev>; Mon, 31 Jul 2023 19:29:14 +0800 (CST)
Received: from ubuntu1804.huawei.com (10.67.174.202) by
 dggpeml500025.china.huawei.com (7.185.36.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.27; Mon, 31 Jul 2023 19:30:13 +0800
From: Zhu Wang <wangzhu9@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>, <nvdimm@lists.linux.dev>
CC: <wangzhu9@huawei.com>
Subject: [PATCH -next] libnvdimm: remove kernel-doc warnings:
Date: Mon, 31 Jul 2023 19:29:42 +0800
Message-ID: <20230731112942.215135-1-wangzhu9@huawei.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.174.202]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpeml500025.china.huawei.com (7.185.36.35)
X-CFilter-Loop: Reflected

Remove kernel-doc warnings:

drivers/nvdimm/badrange.c:271: warning: Function parameter or member
'nd_region' not described in 'nvdimm_badblocks_populate'
drivers/nvdimm/badrange.c:271: warning: Function parameter or member
'range' not described in 'nvdimm_badblocks_populate'
drivers/nvdimm/badrange.c:271: warning: Excess function parameter 'region'
description in 'nvdimm_badblocks_populate'
drivers/nvdimm/badrange.c:271: warning: Excess function parameter 'res'
description in 'nvdimm_badblocks_populate'

Signed-off-by: Zhu Wang <wangzhu9@huawei.com>
---
 drivers/nvdimm/badrange.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/badrange.c b/drivers/nvdimm/badrange.c
index aaf6e215a8c6..a002ea6fdd84 100644
--- a/drivers/nvdimm/badrange.c
+++ b/drivers/nvdimm/badrange.c
@@ -257,9 +257,9 @@ static void badblocks_populate(struct badrange *badrange,
 
 /**
  * nvdimm_badblocks_populate() - Convert a list of badranges to badblocks
- * @region: parent region of the range to interrogate
+ * @nd_region: parent region of the range to interrogate
  * @bb: badblocks instance to populate
- * @res: resource range to consider
+ * @range: resource range to consider
  *
  * The badrange list generated during bus initialization may contain
  * multiple, possibly overlapping physical address ranges.  Compare each
-- 
2.17.1

