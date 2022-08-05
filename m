Received: from ssh248.corpemail.net (ssh248.corpemail.net [210.51.61.248])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7866A3D
	for <nvdimm@lists.linux.dev>; Fri,  5 Aug 2022 05:35:33 +0000 (UTC)
Received: from ([60.208.111.195])
        by ssh248.corpemail.net ((D)) with ASMTP (SSL) id ZDM00019;
        Fri, 05 Aug 2022 13:33:19 +0800
Received: from localhost.localdomain (10.200.104.97) by
 jtjnmail201605.home.langchao.com (10.100.2.5) with Microsoft SMTP Server id
 15.1.2507.9; Fri, 5 Aug 2022 13:33:20 +0800
From: Bo Liu <liubo03@inspur.com>
To: <dan.j.williams@intel.com>, <vishal.l.verma@intel.com>,
	<dave.jiang@intel.com>
CC: <nvdimm@lists.linux.dev>, <linux-kernel@vger.kernel.org>, Bo Liu
	<liubo03@inspur.com>
Subject: [PATCH] dax: Check dev_set_name() return value
Date: Fri, 5 Aug 2022 01:33:19 -0400
Message-ID: <20220805053319.3865-1-liubo03@inspur.com>
X-Mailer: git-send-email 2.18.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.200.104.97]
tUid: 2022805133319b82b3ecbb11bc9c5f2588e7020cc85a0
X-Abuse-Reports-To: service@corp-email.com
Abuse-Reports-To: service@corp-email.com
X-Complaints-To: service@corp-email.com
X-Report-Abuse-To: service@corp-email.com

It's possible that dev_set_name() returns -ENOMEM, catch and handle this.

Signed-off-by: Bo Liu <liubo03@inspur.com>
---
 drivers/dax/bus.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 1dad813ee4a6..36cf245ee467 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -765,7 +765,12 @@ static int devm_register_dax_mapping(struct dev_dax *dev_dax, int range_id)
 	device_initialize(dev);
 	dev->parent = &dev_dax->dev;
 	dev->type = &dax_mapping_type;
-	dev_set_name(dev, "mapping%d", mapping->id);
+	rc = dev_set_name(dev, "mapping%d", mapping->id);
+	if (rc) {
+		kfree(mapping);
+		return rc;
+	}
+
 	rc = device_add(dev);
 	if (rc) {
 		put_device(dev);
@@ -1334,7 +1339,9 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
 	dev_dax->region = dax_region;
 	dev = &dev_dax->dev;
 	device_initialize(dev);
-	dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
+	rc = dev_set_name(dev, "dax%d.%d", dax_region->id, dev_dax->id);
+	if (rc)
+		goto err_range;
 
 	rc = alloc_dev_dax_range(dev_dax, dax_region->res.start, data->size);
 	if (rc)
-- 
2.27.0

