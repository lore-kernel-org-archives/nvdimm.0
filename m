Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F42570
	for <nvdimm@lists.linux.dev>; Thu,  3 Jun 2021 09:28:48 +0000 (UTC)
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.55])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4FwgVY65cZz6trs;
	Thu,  3 Jun 2021 17:25:41 +0800 (CST)
Received: from dggpemm500006.china.huawei.com (7.185.36.236) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 17:28:36 +0800
Received: from thunder-town.china.huawei.com (10.174.177.72) by
 dggpemm500006.china.huawei.com (7.185.36.236) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 17:28:36 +0800
From: Zhen Lei <thunder.leizhen@huawei.com>
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma
	<vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, nvdimm
	<nvdimm@lists.linux.dev>, linux-kernel <linux-kernel@vger.kernel.org>
CC: Zhen Lei <thunder.leizhen@huawei.com>
Subject: [PATCH 1/1] device-dax: use DEVICE_ATTR_ADMIN_RO() helper macro
Date: Thu, 3 Jun 2021 17:24:05 +0800
Message-ID: <20210603092405.11824-1-thunder.leizhen@huawei.com>
X-Mailer: git-send-email 2.26.0.windows.1
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.174.177.72]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 dggpemm500006.china.huawei.com (7.185.36.236)
X-CFilter-Loop: Reflected

Use DEVICE_ATTR_ADMIN_RO() helper macro instead of plain DEVICE_ATTR(),
which makes the code a bit shorter and easier to read.

Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
---
 drivers/dax/bus.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 5aee26e1bbd6dba..a8a26398a313cd9 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -655,7 +655,7 @@ static ssize_t start_show(struct device *dev,
 
 	return rc;
 }
-static DEVICE_ATTR(start, 0400, start_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(start);
 
 static ssize_t end_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
@@ -671,9 +671,9 @@ static ssize_t end_show(struct device *dev,
 
 	return rc;
 }
-static DEVICE_ATTR(end, 0400, end_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(end);
 
-static ssize_t pgoff_show(struct device *dev,
+static ssize_t page_offset_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct dev_dax_range *dax_range;
@@ -687,7 +687,7 @@ static ssize_t pgoff_show(struct device *dev,
 
 	return rc;
 }
-static DEVICE_ATTR(page_offset, 0400, pgoff_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(page_offset);
 
 static struct attribute *dax_mapping_attributes[] = {
 	&dev_attr_start.attr,
@@ -1191,7 +1191,7 @@ static ssize_t resource_show(struct device *dev,
 
 	return sprintf(buf, "%#llx\n", start);
 }
-static DEVICE_ATTR(resource, 0400, resource_show, NULL);
+static DEVICE_ATTR_ADMIN_RO(resource);
 
 static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
 		char *buf)
-- 
2.26.0.106.g9fadedd


