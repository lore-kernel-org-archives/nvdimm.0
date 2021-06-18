Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE39D70
	for <nvdimm@lists.linux.dev>; Fri, 18 Jun 2021 14:13:06 +0000 (UTC)
DKIM-Signature: a=rsa-sha256;
	b=eCbb7bXHW4dzc7UW/H4rrPgLOXjqjP6HWpY1y035t+La0wJcYnTdBpjcK4QIx2SHE2pwSUYPJGu+FijapSUHqt/SgmLYPrJ0LPP25iU+CXCff825NsM3EogB0+8sN+5mnU1r0KNyVzbmcLP0S9vNu0ZP4lxujF63/P363JFisZc=;
	c=relaxed/relaxed; s=default; d=vivo.com; v=1;
	bh=GGvAF/Qe8GQuaJkuBh4NoVPUQNoWRTjdQlcqF+cYVMI=;
	h=date:mime-version:subject:message-id:from;
Received: from ubuntu.localdomain (unknown [36.152.145.182])
	by mail-m121145.qiye.163.com (Hmail) with ESMTPA id 8FB7E8001EF;
	Fri, 18 Jun 2021 22:13:04 +0800 (CST)
From: zhouchuangao <zhouchuangao@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Cc: zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] drivers/dax: Use kobj_to_dev() API
Date: Fri, 18 Jun 2021 07:12:57 -0700
Message-Id: <1624025577-56565-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZQh4fS1ZNTR1LTB8aSUtDS01VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
	hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NU06Njo6SD8NEUJDVi0ZCzM*
	FRQwCQNVSlVKTUlPS0lOTkNOS0xPVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
	WUhNVUpOSVVKT05VSkNJWVdZCAFZQUpDQk43Bg++
X-HM-Tid: 0a7a1f77d46fb03akuuu8fb7e8001ef
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Use kobj_to_dev() API instead of container_of().

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 drivers/dax/bus.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dax/bus.c b/drivers/dax/bus.c
index 5aee26e..eb7260a 100644
--- a/drivers/dax/bus.c
+++ b/drivers/dax/bus.c
@@ -484,7 +484,7 @@ static DEVICE_ATTR_WO(delete);
 static umode_t dax_region_visible(struct kobject *kobj, struct attribute *a,
 		int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dax_region *dax_region = dev_get_drvdata(dev);
 
 	if (is_static(dax_region))
@@ -1213,7 +1213,7 @@ static DEVICE_ATTR_RO(numa_node);
 
 static umode_t dev_dax_visible(struct kobject *kobj, struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct dev_dax *dev_dax = to_dev_dax(dev);
 	struct dax_region *dax_region = dev_dax->region;
 
-- 
2.7.4

