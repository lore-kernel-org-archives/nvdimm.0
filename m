Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01134610D
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774307; x=1695310307;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=kldGzN2oeJ5eOYTeA77bCFuL1F9ndfSRRHY47jbc2gE=;
  b=J3NrlVI1Vt46x/CJ58/p4WpXBk62JljQGHmC/UVCfjE7xWYKLpocLsk2
   PS3F702E+F+gHuHYm0qhw+zlChpTRVmlOq8mGCV+xVjDHU8k2AYLZ/BsK
   mW8erkhc269TM9k9OkmC7/JIggV0yN6fTk3tniKLbDfYBVhi+16/wkwzt
   h/T/UAoTAIlbRnt19Sw0A8BtjM24kn/WNHg6QfouzL/2u9kobRfGmSHcr
   eeKpTzE/kCr9Lkr3PsUQ6NiFHAf1g6Fu91zM3QsbCi48DuqviokEUy4Na
   yZk1p3hUSckw7XiD4rp+9JYpkMTI4RUY0Q0F1k9HafVCDBm6lOTWzEqoV
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="386322670"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="386322670"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:46 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="652579011"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:45 -0700
Subject: [PATCH v2 03/19] tools/testing/cxl: Add "Get Security State" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:31:45 -0700
Message-ID: 
 <166377430503.430546.4463791056925632016.stgit@djiang5-desk3.ch.intel.com>
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

Add the emulation support for handling "Get Security State" opcode for a
CXL memory device for the cxl_test. The function will copy back device
security state bitmask to the output payload.

The security state data is added as platform_data for the mock mem device.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
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


