Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A51278BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928398; x=1699464398;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=coukaoCU87O7YVRUMkxCAQsEX7v0d9jAGSUAmMFLQtw=;
  b=ll1CaI/jjILy6HvqacM9Pzd65S7q5cMgQqBt0GI84BptVyzxzAuGYZ0I
   NLqLkFcflKdfHWbvW9BDUMTVs38rndQmlQEMa6W010U8RH6SnCOIhAoDU
   CMqTDS2/wWeQmkkcXv1eDT0PDEBxfJHljDthGYBqq1JoZcwOfOyshA4zq
   foDGeE/6tAqUonX/Y60AhroB3U+eKwhLiU6dEy5a1HIg8s4Z3MeNnlATV
   3oneXuvNlozX+FGqXOyHwnU6z0yaYYQ7fHJuPhn9zbQGH2BzjtFwrUCFy
   DOk4l+xM2ttYHKDG7ELdL10e7Sos3Q/uWL9GwnzQM1JIwndop6ubILHZ+
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="375029949"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="375029949"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:37 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="669629886"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="669629886"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:37 -0800
Subject: [PATCH v3 13/18] nvdimm/cxl/pmem: Add support for master passphrase
 disable security command
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:26:36 -0700
Message-ID: 
 <166792839666.3767969.6449782585863358095.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166792815961.3767969.2621677491424623673.stgit@djiang5-desk3.ch.intel.com>
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
index 631a474939d6..f4df7d38e4cd 100644
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
index 8aefb60c42ff..92af4c3ca0d3 100644
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


