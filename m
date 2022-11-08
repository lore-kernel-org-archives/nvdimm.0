Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDA748BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928409; x=1699464409;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VzbUPoB2aEKRXKYmIkZpw14gKni3GztCwc4m7Z9aTKM=;
  b=bDWDgM+q9Mfey+VHyICsl7mf/LF0TPdkHQ2iCX7HAEk8Ncl56gBEGPsC
   9zNv5zTrO41TCakPUXfEXEnGzpZvJTC51syus3NVr64NF1uCQnyeYriiO
   1Rz4iUZsx2YQ+32zxeI0SjuU6QPo+MoEQY+d6Qch15TSwXg0aA4sxvpct
   riSOQHV28XPDPOxyWkMNo4yywEfHtSPM1v4ferHTNupnAonii1wr/AahY
   4+xB5RnALDBTQmlSKzlPkyBaA5roli9y5/qmyKTFWGFvyzOUNRXmP7U4Z
   WSlw5Jtnb7lMyt4x5BiJvcZ4Bb+Ik7eUfcOGuyJTN+Vc6V1ygHIihBbN2
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="309465431"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="309465431"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:49 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="705378631"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="705378631"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:48 -0800
Subject: [PATCH v3 15/18] tools/testing/cxl: add mechanism to lock mem device
 for testing
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:26:48 -0700
Message-ID: 
 <166792840837.3767969.8013121990529095896.stgit@djiang5-desk3.ch.intel.com>
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

The mock cxl mem devs needs a way to go into "locked" status to simulate
when the platform is rebooted. Add a sysfs mechanism so the device security
state is set to "locked" and the frozen state bits are cleared.

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


