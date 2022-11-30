Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ABC79C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836177; x=1701372177;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jDNoPbC6Wl6EN1w/wz7DUIsLnIyd244so1oDEmhRMjA=;
  b=OGLPo7uMIunRzBBKxBhWwYGt/2jW3AAkyqWvjESdnche02YMtm8T+HhP
   fuLWwwdZqclWFMLxmKyaWueWvW2dbJ6z2alAtVYHorK/6ktPSiM3fY5yK
   ASreREhYH854C+urNWJrp5Kp4YCrEwAQycfenap6XAS1ya4c8EZolsi8g
   Q8kDBPNJ1TaO6oF8tc6FulbSZw2NmsxLKDZu01Kl88cice+FRy+pX9OXd
   tDItQU3dxMfSuXxK+4FRnlU066rLXwRAgqe8HT8NktV5/u8KipCA7OvBz
   EUM95Io8HS3qzMwFySI0wabJJUoJuHxXyZGu/09eru0z3AOrtkJSCO+Y9
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="401765397"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="401765397"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818747059"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818747059"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:56 -0800
Subject: [PATCH v7 15/20] tools/testing/cxl: add mechanism to lock mem device
 for testing
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:22:56 -0700
Message-ID: 
 <166983617602.2734609.7042497620931694717.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166983606451.2734609.4050644229630259452.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The mock cxl mem devs needs a way to go into "locked" status to simulate
when the platform is rebooted. Add a sysfs mechanism so the device security
state is set to "locked" and the frozen state bits are cleared.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863355259.80269.11806404186408786011.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mem.c |   48 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 1008ee2e1e31..35d9ad04e0d6 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -245,7 +245,7 @@ static int mock_set_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
 
 static int mock_disable_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
-	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
 	struct cxl_disable_pass *dis_pass;
 
 	if (cmd->size_in != sizeof(*dis_pass))
@@ -316,7 +316,7 @@ static int mock_disable_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_
 
 static int mock_freeze_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
-	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
 
 	if (cmd->size_in != 0)
 		return -EINVAL;
@@ -333,7 +333,7 @@ static int mock_freeze_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
 
 static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
-	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
 
 	if (cmd->size_in != NVDIMM_PASSPHRASE_LEN)
 		return -EINVAL;
@@ -376,7 +376,7 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
 static int mock_passphrase_secure_erase(struct cxl_dev_state *cxlds,
 					struct cxl_mbox_cmd *cmd)
 {
-	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
 	struct cxl_pass_erase *erase;
 
 	if (cmd->size_in != sizeof(*erase))
@@ -650,6 +650,45 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	return 0;
 }
 
+static ssize_t security_lock_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+
+	return sysfs_emit(buf, "%u\n",
+			  !!(mdata->security_state & CXL_PMEM_SEC_STATE_LOCKED));
+}
+
+static ssize_t security_lock_store(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(dev);
+	u32 mask = CXL_PMEM_SEC_STATE_FROZEN | CXL_PMEM_SEC_STATE_USER_PLIMIT |
+		   CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
+	int val;
+
+	if (kstrtoint(buf, 0, &val) < 0)
+		return -EINVAL;
+
+	if (val == 1) {
+		if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET))
+			return -ENXIO;
+		mdata->security_state |= CXL_PMEM_SEC_STATE_LOCKED;
+		mdata->security_state &= ~mask;
+	} else {
+		return -EINVAL;
+	}
+	return count;
+}
+
+static DEVICE_ATTR_RW(security_lock);
+
+static struct attribute *cxl_mock_mem_attrs[] = {
+	&dev_attr_security_lock.attr,
+	NULL
+};
+ATTRIBUTE_GROUPS(cxl_mock_mem);
+
 static const struct platform_device_id cxl_mock_mem_ids[] = {
 	{ .name = "cxl_mem", },
 	{ },
@@ -661,6 +700,7 @@ static struct platform_driver cxl_mock_mem_driver = {
 	.id_table = cxl_mock_mem_ids,
 	.driver = {
 		.name = KBUILD_MODNAME,
+		.dev_groups = cxl_mock_mem_groups,
 	},
 };
 


