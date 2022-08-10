Received: from unicom145.biz-email.net (unicom145.biz-email.net [210.51.26.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401CD17CA
	for <nvdimm@lists.linux.dev>; Wed, 10 Aug 2022 06:09:53 +0000 (UTC)
Received: from ([60.208.111.195])
        by unicom145.biz-email.net ((D)) with ASMTP (SSL) id EER00042;
        Wed, 10 Aug 2022 14:07:42 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201603.home.langchao.com (10.100.2.3) with Microsoft SMTP Server id
 15.1.2507.9; Wed, 10 Aug 2022 14:07:41 +0800
From: Bo Liu <liubo03@inspur.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>, <ira.weiny@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Bo Liu
	<liubo03@inspur.com>
Subject: [PATCH] nvdimm: Call ida_simple_remove() when failed
Date: Wed, 10 Aug 2022 02:07:37 -0400
Message-ID: <20220810060737.5087-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid: 20228101407423e730e450a495fa8ac99b446cb56c639
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

In function nvdimm_bus_register(), when code execution fails, we should
call ida_simple_remove() to free ida.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/nvdimm/bus.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvdimm/bus.c b/drivers/nvdimm/bus.c
index b38d0355b0ac..3415dc62632b 100644
--- a/drivers/nvdimm/bus.c
+++ b/drivers/nvdimm/bus.c
@@ -371,6 +371,7 @@ struct nvdimm_bus *nvdimm_bus_register(struct device *parent,
 	return nvdimm_bus;
  err:
 	put_device(&nvdimm_bus->dev);
+	ida_simple_remove(&nd_ida, nvdimm_bus->id);
 	return NULL;
 }
 EXPORT_SYMBOL_GPL(nvdimm_bus_register);
-- 
2.27.0

