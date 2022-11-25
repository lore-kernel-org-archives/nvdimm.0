Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A3352570
	for <nvdimm@lists.linux.dev>; Fri, 25 Nov 2022 09:29:21 +0000 (UTC)
Received: from dggpemm500020.china.huawei.com (unknown [172.30.72.54])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4NJTwr4CsJzbncT;
	Fri, 25 Nov 2022 17:25:16 +0800 (CST)
Received: from dggpemm500007.china.huawei.com (7.185.36.183) by
 dggpemm500020.china.huawei.com (7.185.36.49) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 25 Nov 2022 17:29:13 +0800
Received: from huawei.com (10.175.103.91) by dggpemm500007.china.huawei.com
 (7.185.36.183) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.31; Fri, 25 Nov
 2022 17:29:13 +0800
From: Yang Yingliang <yangyingliang@huawei.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <santosh@fossix.org>
CC: <nvdimm@lists.linux.dev>, <yangyingliang@huawei.com>
Subject: [PATCH 0/2] tools/testing/nvdimm: fix return value check
Date: Fri, 25 Nov 2022 17:27:19 +0800
Message-ID: <20221125092721.9433-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpemm500007.china.huawei.com (7.185.36.183)
X-CFilter-Loop: Reflected

This patchset fixes two return value check problems when
device_create_with_groups fails.

Yang Yingliang (2):
  nfit_test: fix return value check in nfit_test_dimm_init()
  ndtest: fix return value check in ndtest_dimm_register()

 tools/testing/nvdimm/test/ndtest.c | 4 ++--
 tools/testing/nvdimm/test/nfit.c   | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

-- 
2.25.1

