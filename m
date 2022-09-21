Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D87E2613B
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774372; x=1695310372;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3sfabnyCq/W32rfILytku+2qPi+d9KEPAAeuKvNfCA8=;
  b=YAWgE7l7uXiGm9vxcnmOZeRUeaF6tbnT93LQzKMcdtQ42etQkH6ZBfOw
   2Nl4sjZdK9zy0rFByWEIKRfFEI4o+7YJ5kZiawu+ymVLaTBcXOmClrL87
   hTcRbqxTjjC7PN2o6DrArcjuohG4bthruRl7GCwDxuJqizTDKmUl1EuSi
   L38rzokY0aa6dsoQXbxFvLl6MK51gxf99gxf3Ms+qRoRZFRvgLFo0soFb
   zmAmHee3ypeUdnd+y2yPap//UQ/tojSZTthoSNX2iEQyFz4YrvBKU3X7h
   ZUPBvPGR1NeTYknFz9fsRxLuR+uMFYiwyd5/C/1cdyV7TQjEOu0K/kHcN
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="301438365"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="301438365"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:32:52 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="597034815"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:32:52 -0700
Subject: [PATCH v2 14/19] nvdimm/cxl/pmem: Add support for master passphrase
 disable security command
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:32:51 -0700
Message-ID: 
 <166377437176.430546.17764703604719662576.stgit@djiang5-desk3.ch.intel.com>
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

The original nvdimm_security_ops ->disable() only supports user passphrase
for security disable. The CXL spec introduced the disabling of master
passphrase. Add a ->disable_master() callback to support this new operation
and leaving the old ->disable() mechanism alone. A "disable_master" command
is added for the sysfs attribute in order to allow command to be issued
from userspace. ndctl will need enabling in order to utilize this new
operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 drivers/cxl/security.c    |   20 ++++++++++++++++++--
 drivers/nvdimm/security.c |   33 ++++++++++++++++++++++++++-------
 include/linux/libnvdimm.h |    2 ++
 3 files changed, 46 insertions(+), 9 deletions(-)

diff --git a/drivers/cxl/security.c b/drivers/cxl/security.c
index df4cf26e366a..f0edcbfeb1e0 100644
--- a/drivers/cxl/security.c
+++ b/drivers/cxl/security.c
@@ -71,8 +71,9 @@ static int cxl_pmem_security_change_key(struct nvdimm *nvdimm,
 	return rc;
 }
 
-static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
-				     const struct nvdimm_key_data *key_data)
+static int __cxl_pmem_security_disable(struct nvdimm *nvdimm,
+				       const struct nvdimm_key_data *key_data,
+				       enum nvdimm_passphrase_type ptype)
 {
 	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
 	struct cxl_memdev *cxlmd = cxl_nvd->cxlmd;
@@ -88,6 +89,8 @@ static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
 	 * will only support disable of user passphrase. The disable master passphrase
 	 * ability will need to be added as a new callback.
 	 */
+	dis_pass.type = ptype == NVDIMM_MASTER ?
+		CXL_PMEM_SEC_PASS_MASTER : CXL_PMEM_SEC_PASS_USER;
 	dis_pass.type = CXL_PMEM_SEC_PASS_USER;
 	memcpy(dis_pass.pass, key_data->data, NVDIMM_PASSPHRASE_LEN);
 
@@ -96,6 +99,18 @@ static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
 	return rc;
 }
 
+static int cxl_pmem_security_disable(struct nvdimm *nvdimm,
+				     const struct nvdimm_key_data *key_data)
+{
+	return __cxl_pmem_security_disable(nvdimm, key_data, NVDIMM_USER);
+}
+
+static int cxl_pmem_security_disable_master(struct nvdimm *nvdimm,
+					    const struct nvdimm_key_data *key_data)
+{
+	return __cxl_pmem_security_disable(nvdimm, key_data, NVDIMM_MASTER);
+}
+
 static int cxl_pmem_security_freeze(struct nvdimm *nvdimm)
 {
 	struct cxl_nvdimm *cxl_nvd = nvdimm_provider_data(nvdimm);
@@ -163,6 +178,7 @@ static const struct nvdimm_security_ops __cxl_security_ops = {
 	.freeze = cxl_pmem_security_freeze,
 	.unlock = cxl_pmem_security_unlock,
 	.erase = cxl_pmem_security_passphrase_erase,
+	.disable_master = cxl_pmem_security_disable_master,
 };
 
 const struct nvdimm_security_ops *cxl_security_ops = &__cxl_security_ops;
diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index b5aa55c61461..c1c9d0feae9d 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -239,7 +239,8 @@ static int check_security_state(struct nvdimm *nvdimm)
 	return 0;
 }
 
-static int security_disable(struct nvdimm *nvdimm, unsigned int keyid)
+static int security_disable(struct nvdimm *nvdimm, unsigned int keyid,
+			    enum nvdimm_passphrase_type pass_type)
 {
 	struct device *dev = &nvdimm->dev;
 	struct nvdimm_bus *nvdimm_bus = walk_to_nvdimm_bus(dev);
@@ -250,8 +251,13 @@ static int security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	/* The bus lock should be held at the top level of the call stack */
 	lockdep_assert_held(&nvdimm_bus->reconfig_mutex);
 
-	if (!nvdimm->sec.ops || !nvdimm->sec.ops->disable
-			|| !nvdimm->sec.flags)
+	if (!nvdimm->sec.ops || !nvdimm->sec.flags)
+		return -EOPNOTSUPP;
+
+	if (pass_type == NVDIMM_USER && !nvdimm->sec.ops->disable)
+		return -EOPNOTSUPP;
+
+	if (pass_type == NVDIMM_MASTER && !nvdimm->sec.ops->disable_master)
 		return -EOPNOTSUPP;
 
 	rc = check_security_state(nvdimm);
@@ -263,12 +269,21 @@ static int security_disable(struct nvdimm *nvdimm, unsigned int keyid)
 	if (!data)
 		return -ENOKEY;
 
-	rc = nvdimm->sec.ops->disable(nvdimm, data);
-	dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
+	if (pass_type == NVDIMM_MASTER) {
+		rc = nvdimm->sec.ops->disable_master(nvdimm, data);
+		dev_dbg(dev, "key: %d disable_master: %s\n", key_serial(key),
 			rc == 0 ? "success" : "fail");
+	} else {
+		rc = nvdimm->sec.ops->disable(nvdimm, data);
+		dev_dbg(dev, "key: %d disable: %s\n", key_serial(key),
+			rc == 0 ? "success" : "fail");
+	}
 
 	nvdimm_put_key(key);
-	nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
+	if (pass_type == NVDIMM_MASTER)
+		nvdimm->sec.ext_flags = nvdimm_security_flags(nvdimm, NVDIMM_MASTER);
+	else
+		nvdimm->sec.flags = nvdimm_security_flags(nvdimm, NVDIMM_USER);
 	return rc;
 }
 
@@ -473,6 +488,7 @@ void nvdimm_security_overwrite_query(struct work_struct *work)
 #define OPS							\
 	C( OP_FREEZE,		"freeze",		1),	\
 	C( OP_DISABLE,		"disable",		2),	\
+	C( OP_DISABLE_MASTER,	"disable_master",	2),	\
 	C( OP_UPDATE,		"update",		3),	\
 	C( OP_ERASE,		"erase",		2),	\
 	C( OP_OVERWRITE,	"overwrite",		2),	\
@@ -524,7 +540,10 @@ ssize_t nvdimm_security_store(struct device *dev, const char *buf, size_t len)
 		rc = nvdimm_security_freeze(nvdimm);
 	} else if (i == OP_DISABLE) {
 		dev_dbg(dev, "disable %u\n", key);
-		rc = security_disable(nvdimm, key);
+		rc = security_disable(nvdimm, key, NVDIMM_USER);
+	} else if (i == OP_DISABLE_MASTER) {
+		dev_dbg(dev, "disable_master %u\n", key);
+		rc = security_disable(nvdimm, key, NVDIMM_MASTER);
 	} else if (i == OP_UPDATE || i == OP_MASTER_UPDATE) {
 		dev_dbg(dev, "%s %u %u\n", ops[i].name, key, newkey);
 		rc = security_update(nvdimm, key, newkey, i == OP_UPDATE
diff --git a/include/linux/libnvdimm.h b/include/linux/libnvdimm.h
index c74acfa1a3fe..3bf658a74ccb 100644
--- a/include/linux/libnvdimm.h
+++ b/include/linux/libnvdimm.h
@@ -183,6 +183,8 @@ struct nvdimm_security_ops {
 	int (*overwrite)(struct nvdimm *nvdimm,
 			const struct nvdimm_key_data *key_data);
 	int (*query_overwrite)(struct nvdimm *nvdimm);
+	int (*disable_master)(struct nvdimm *nvdimm,
+			      const struct nvdimm_key_data *key_data);
 };
 
 enum nvdimm_fwa_state {


