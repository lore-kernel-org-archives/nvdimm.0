Received: from mail-m121145.qiye.163.com (mail-m121145.qiye.163.com [115.236.121.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B532870
	for <nvdimm@lists.linux.dev>; Fri, 18 Jun 2021 07:54:10 +0000 (UTC)
DKIM-Signature: a=rsa-sha256;
	b=DBC+1xK7d8R6tFyM0VHdG9HLnjV6G3pvnOEZbPgJc6pQ+QJ9gjFHgp1SL/1RaUI4O+ichR0pXfygZgL3e012qA9g+gZE3ylZ81Nls/bbe7jQo0nNNb5j0tRx+GZPelEX006AsGUw0Fvjsv/ow2IAYZGGkSWZu2oxvxAJ5LNcFFw=;
	c=relaxed/relaxed; s=default; d=vivo.com; v=1;
	bh=kkbFumgv8OhyX4fIXHw3ZvzYgE9XzT1qiGKrOM6lV1o=;
	h=date:mime-version:subject:message-id:from;
Received: from ubuntu.localdomain (unknown [36.152.145.182])
	by mail-m121145.qiye.163.com (Hmail) with ESMTPA id AC678800139;
	Fri, 18 Jun 2021 15:46:59 +0800 (CST)
From: zhouchuangao <zhouchuangao@vivo.com>
To: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Santosh Sivaraj <santosh@fossix.org>,
	zhouchuangao <zhouchuangao@vivo.com>,
	nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH] tools/testing/nvdimm: Use kobj_to_dev() API
Date: Fri, 18 Jun 2021 00:46:50 -0700
Message-Id: <1624002415-5439-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
	oVCBIfWUFZGkhKGFYeGRoYQk1PT0pNHUlVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
	hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6N1E6Pyo*Ij8SCUMQGU4tHSFC
	NzlPChBVSlVKTUlPS0tJT0lLSUhIVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
	WUhNVUpOSVVKT05VSkNJWVdZCAFZQUpDSks3Bg++
X-HM-Tid: 0a7a1e165ca5b03akuuuac678800139
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>

Use kobj_to_dev() API instead of container_of().

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 tools/testing/nvdimm/test/ndtest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/nvdimm/test/ndtest.c b/tools/testing/nvdimm/test/ndtest.c
index 6862915..004a36f 100644
--- a/tools/testing/nvdimm/test/ndtest.c
+++ b/tools/testing/nvdimm/test/ndtest.c
@@ -782,7 +782,7 @@ static DEVICE_ATTR_RO(format1);
 static umode_t ndtest_nvdimm_attr_visible(struct kobject *kobj,
 					struct attribute *a, int n)
 {
-	struct device *dev = container_of(kobj, struct device, kobj);
+	struct device *dev = kobj_to_dev(kobj);
 	struct nvdimm *nvdimm = to_nvdimm(dev);
 	struct ndtest_dimm *dimm = nvdimm_provider_data(nvdimm);
 
-- 
2.7.4

