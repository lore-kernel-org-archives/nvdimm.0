Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CCEA8BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928334; x=1699464334;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HIzLYkSJOaz2vYcR0Jw7JJ1mMfwUqK5vzf+nNcTzjZM=;
  b=ApgbA3w9LxRhxogD6EI+cMZpjMhVQpHASwdIwQuIPdJqJM9Ae8XEy2pW
   ToIKejT3mpCzBMAwKT5Y/3vcKXz/P52k7/rBw8LYYsaKpBBu4Mds66+jM
   amdEdxdNqt3ktjOOJSr3SolZfCfPEGXJetpk+WoI30y5MYW+Xd34uyOmh
   Ub+QXzNy0fL8n54T+Ve9cso0HsrI1EFk/gbaFv6ZJECS/Z4+e6oyO3Zoi
   o0Snskd0PryRlqxacMce7/7EadM9/Gnqdnik9ftxiVSyl/M2r0TZvK6dm
   155J1zStJn2SX+GkZLSZNYxwNZp5XYBktXPJnRI/CyhoyVX2+tuCBlLYk
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="291144207"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="291144207"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:25:33 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="742038782"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="742038782"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:25:33 -0800
Subject: [PATCH v3 02/18] tools/testing/cxl: Add "Get Security State" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:25:32 -0700
Message-ID: 
 <166792833292.3767969.13949713086525232999.stgit@djiang5-desk3.ch.intel.com>
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

Add the emulation support for handling "Get Security State" opcode for a
CXL memory device for the cxl_test. The function will copy back device
security state bitmask to the output payload.

The security state data is added as platform_data for the mock mem device.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/cxl.c       |   18 ++++++++++++++++++
 tools/testing/cxl/test/mem.c       |   20 ++++++++++++++++++++
 tools/testing/cxl/test/mem_pdata.h |   10 ++++++++++
 3 files changed, 48 insertions(+)
 create mode 100644 tools/testing/cxl/test/mem_pdata.h

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index a072b2d3e726..6dd286a52839 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -10,6 +10,7 @@
 #include <linux/mm.h>
 #include <cxlmem.h>
 #include "mock.h"
+#include "mem_pdata.h"
 
 #define NR_CXL_HOST_BRIDGES 2
 #define NR_CXL_ROOT_PORTS 2
@@ -629,8 +630,18 @@ static void mock_companion(struct acpi_device *adev, struct device *dev)
 
 static __init int cxl_test_init(void)
 {
+	struct cxl_mock_mem_pdata *mem_pdata;
 	int rc, i;
 
+	/*
+	 * Only a zeroed copy of this data structure is needed since no
+	 * additional initialization is needed for initial state.
+	 * platform_device_add_data() will make a copy of this data.
+	 */
+	mem_pdata = kzalloc(sizeof(*mem_pdata), GFP_KERNEL);
+	if (!mem_pdata)
+		return -ENOMEM;
+
 	register_cxl_mock_ops(&cxl_mock_ops);
 
 	cxl_mock_pool = gen_pool_create(ilog2(SZ_2M), NUMA_NO_NODE);
@@ -735,6 +746,12 @@ static __init int cxl_test_init(void)
 		pdev->dev.parent = &dport->dev;
 		set_dev_node(&pdev->dev, i % 2);
 
+		rc = platform_device_add_data(pdev, mem_pdata, sizeof(*mem_pdata));
+		if (rc) {
+			platform_device_put(pdev);
+			goto err_mem;
+		}
+
 		rc = platform_device_add(pdev);
 		if (rc) {
 			platform_device_put(pdev);
@@ -785,6 +802,7 @@ static __init int cxl_test_init(void)
 	gen_pool_destroy(cxl_mock_pool);
 err_gen_pool_create:
 	unregister_cxl_mock_ops(&cxl_mock_ops);
+	kfree(mem_pdata);
 	return rc;
 }
 
diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index aa2df3a15051..9002a3ae3ea5 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -8,6 +8,7 @@
 #include <linux/sizes.h>
 #include <linux/bits.h>
 #include <cxlmem.h>
+#include "mem_pdata.h"
 
 #define LSA_SIZE SZ_128K
 #define DEV_SIZE SZ_2G
@@ -137,6 +138,22 @@ static int mock_partition_info(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static int mock_get_security_state(struct cxl_dev_state *cxlds,
+				   struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+
+	if (cmd->size_in)
+		return -EINVAL;
+
+	if (cmd->size_out != sizeof(u32))
+		return -EINVAL;
+
+	memcpy(cmd->payload_out, &mdata->security_state, sizeof(u32));
+
+	return 0;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -230,6 +247,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_HEALTH_INFO:
 		rc = mock_health_info(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_GET_SECURITY_STATE:
+		rc = mock_get_security_state(cxlds, cmd);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/cxl/test/mem_pdata.h b/tools/testing/cxl/test/mem_pdata.h
new file mode 100644
index 000000000000..6a7b111147eb
--- /dev/null
+++ b/tools/testing/cxl/test/mem_pdata.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+
+#ifndef _MEM_PDATA_H_
+#define _MEM_PDATA_H_
+
+struct cxl_mock_mem_pdata {
+	u32 security_state;
+};
+
+#endif


