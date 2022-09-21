Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EF984C72
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774391; x=1695310391;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H1IkV4mJ7QzoLK2yUqSaO7cBp/erS0OV1wCnr6ymy6g=;
  b=m0pjS6jycwSTGoL5zvQv/oS59wx8xk54oqO+nunPv+YvOxHNWV13tWIe
   8zb5Y0q46K4IRzx1Is29EP3xPzv0oxa3uosZO5iyIu1WmmQfsyOCBdZI1
   9r6DyfIAeNaRUJh26PzEY0Fw+xcx/JT3Io68JoiS2HojfxAT9BODWwYHm
   5VgHwN9nq9Mfj6IYsP6xuuyk22WLev8vGjHdrxS28tuwPBZ48f6f/t6MR
   u9yGT/KxOE5sU9YaancEM1K5sGPpujLbNOPFPgJisQ6msfnX35mZkkE8x
   izVclJlgxqH02nu2iKr3jSBu3eIU0hqPIi99q1sAR5I0YRS2D5TR7Zr6I
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="280407774"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="280407774"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:33:10 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="597034939"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:33:09 -0700
Subject: [PATCH v2 17/19] cxl/pmem: add provider name to cxl pmem dimm
 attribute group
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:33:09 -0700
Message-ID: 
 <166377438921.430546.5550361331475412529.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166377414787.430546.3863229455285366312.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add provider name in order to associate cxl test dimm from cxl_test to the
cxl pmem device when going through sysfs for security testing.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/pmem.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/cxl/pmem.c b/drivers/cxl/pmem.c
index 9f34f8701b57..cb303edb925d 100644
--- a/drivers/cxl/pmem.c
+++ b/drivers/cxl/pmem.c
@@ -48,6 +48,15 @@ static void unregister_nvdimm(void *nvdimm)
 	cxl_nvd->bridge = NULL;
 }
 
+static ssize_t provider_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct nvdimm *nvdimm = to_nvdimm(dev);
+	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
+
+	return sysfs_emit(buf, "%s\n", dev_name(&cxl_nvd->dev));
+}
+static DEVICE_ATTR_RO(provider);
+
 static ssize_t id_show(struct device *dev, struct device_attribute *attr, char *buf)
 {
 	struct nvdimm *nvdimm = to_nvdimm(dev);
@@ -61,6 +70,7 @@ static DEVICE_ATTR_RO(id);
 
 static struct attribute *cxl_dimm_attributes[] = {
 	&dev_attr_id.attr,
+	&dev_attr_provider.attr,
 	NULL
 };
 


