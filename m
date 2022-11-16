Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C258312290
	for <nvdimm@lists.linux.dev>; Wed, 16 Nov 2022 21:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668633567; x=1700169567;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aT/N4vJYhzqu7GWpD+8er9SbNffP59hfQbIFnoGY+l4=;
  b=Cu4vmsniDIry3rUFGQSWFHdyiR4kJUN2ovhPP8P0Kpy7s9c4Ihv2d8KD
   NxnFDnQg/04NxwGxscWdYLtNfuQSkROMKRVRxlpv2dPjk+d9TdfN5lyd7
   VpttD+eODXi+8rNOM8HTBZSp29EcNyNKo8cgKM0t8MKiglyw3ZoE42WH7
   8jtVQMqoUsegvHthxNPAsQM+FDSneKuM33ILv39ajTj30j7zz7cp2twOq
   ovLDSqVif4Kf8TP8gaQOG+t5b2s22lxdH+mYmj7Bvuo620T4eKtpeyfHE
   2+BLeu6KYDDAQTdeyAeuqv2Uc7raliO4u4j+w/dCN7VbpWyETOsIi3hUi
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="311377064"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="311377064"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:19:13 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10533"; a="617330426"
X-IronPort-AV: E=Sophos;i="5.96,169,1665471600"; 
   d="scan'208";a="617330426"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2022 13:19:12 -0800
Subject: [PATCH v5 15/18] tools/testing/cxl: add mechanism to lock mem device
 for testing
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net,
 benjamin.cheatham@amd.com
Date: Wed, 16 Nov 2022 14:19:12 -0700
Message-ID: 
 <166863355259.80269.11806404186408786011.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
References: 
 <166863336073.80269.10366236775799773727.stgit@djiang5-desk3.ch.intel.com>
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
---
 tools/testing/cxl/test/cxl.c |   40 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index 6dd286a52839..7384573e8b12 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -628,6 +628,45 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
 #define SZ_512G (SZ_64G * 8)
 #endif
 
+static ssize_t security_lock_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(dev);
+
+	return sysfs_emit(buf, "%u\n",
+			  !!(mdata->security_state & CXL_PMEM_SEC_STATE_LOCKED));
+}
+
+static ssize_t security_lock_store(struct device *dev, struct device_attribute *attr,
+				   const char *buf, size_t count)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(dev);
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
 static __init int cxl_test_init(void)
 {
 	struct cxl_mock_mem_pdata *mem_pdata;
@@ -752,6 +791,7 @@ static __init int cxl_test_init(void)
 			goto err_mem;
 		}
 
+		pdev->dev.groups = cxl_mock_mem_groups;
 		rc = platform_device_add(pdev);
 		if (rc) {
 			platform_device_put(pdev);


