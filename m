Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F6970
	for <nvdimm@lists.linux.dev>; Fri, 18 Jun 2021 14:04:47 +0000 (UTC)
DKIM-Signature: a=rsa-sha256;
	b=cY7Mz3FRd6eGg0YxeZuqLV5muX26Nb2UmqKlgnauglosn39hHRzD8Wko6wiw0lLaGK+n5dllB0nD6xwCp242o/QgDrXGa1JZot4CvTLRRP3MTv9pwQhtpRPUZ6Jh1YOCeX7DnKYhLWwixxV0eZWpoB2wSEvk40nefUIpyAHFx80=;
	c=relaxed/relaxed; s=default; d=vivo.com; v=1;
	bh=V4XkhEktEARrowjgB/PIZYXcF+CUS9Lv1BxfzObWSBY=;
	h=date:mime-version:subject:message-id:from;
Received: from ubuntu.localdomain (unknown [36.152.145.182])
	by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 3D81E8001CC;
	Fri, 18 Jun 2021 22:04:42 +0800 (CST)
From: zhouchuangao <zhouchuangao@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] drivers/nvdimm: Use kobj_to_dev() API
Date: Fri, 18 Jun 2021 07:04:29 -0700
Message-Id: <1624025070-56253-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZGhhNS1ZKTB4YS01NS0tMHkNVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
	hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OhQ6LAw5Cz8WTkIBViw#FQxR
	HAIwCypVSlVKTUlPS0lOS0NJTE9PVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
	WUhNVUpOSVVKT05VSkNJWVdZCAFZQUlJT083Bg++
X-HM-Tid: 0a7a1f702a4ab03akuuu3d81e8001cc
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Use kobj_to_dev() API instead of container_of().

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 drivers/nvdimm/namespace_devs.c | 2 +-
 drivers/nvdimm/region_devs.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/nvdimm/namespace_devs.c b/drivers/nvdimm/namespace_devs.c
index 2403b71..c74dcd2 100644
--- a/drivers/nvdimm/namespace_devs.c
+++ b/drivers/nvdimm/namespace_devs.c
@@ -1623,7 +1623,7 @@ static struct attribute *nd_namespace_attributes[] = {
 static umode_t namespace_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 
 	if (a == &dev_attr_resource.attr && is_namespace_blk(dev))
 		return 0;
diff --git a/drivers/nvdimm/region_devs.c b/drivers/nvdimm/region_devs.c
index 9ccf3d6..3db3195 100644
--- a/drivers/nvdimm/region_devs.c
+++ b/drivers/nvdimm/region_devs.c
@@ -766,7 +766,7 @@ REGION_MAPPING(31);
 
 static umode_t mapping_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nd_region *nd_region = to_nd_region(dev);
 
 	if (n < nd_region->ndr_mappings)
-- 
2.7.4

