Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED8755381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919326; x=1689455326;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5RHeJXI/DSKBOwxq0dyffmzXTzBt+vgqLxC2bhkenCQ=;
  b=GkqvSDolcawHpelXx96ABpTYXL0FTyUK3/Af6YUKjSdNXN8w4hW4c1BP
   EvOgc26FM32rEydNx+uf4irhUTq55e2tEsUzvioPzcEPtHLL1fIihd2WO
   25mhCoHzgssEJLK5cW9AKcXeels5sJ1WAFGJTh7HJC7+BxFDbk3B6KKwL
   ybbBI3novznUxjSigqIP4z0/DGqA34Aukjlw+e48QnkbutVMC7I0SHNKp
   +O+XxFDtPrCo94OXM6gZsCDsqtLMh91e/Fj+NJz1uMXpA6gHdkfHF95PQ
   n1W5b1HBk0LUFBe3TJylVbwGwGzPdO/6lQ+65LlC0oIbUPABmCu8E32dH
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="285927292"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="285927292"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:46 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="923658642"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:44 -0700
Subject: [PATCH RFC 02/15] tools/testing/cxl: Create context for cxl mock
 device
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:08:44 -0700
Message-ID: 
 <165791932409.2491387.9065856569307593223.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
References: 
 <165791918718.2491387.4203738301057301285.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Add context struct for mock device and move lsa under the context. This
allows additional information such as security status and other persistent
security data such as passphrase to be added for the emulated test device.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 6b9239b2afd4..723378248321 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -9,6 +9,10 @@
 #include <linux/bits.h>
 #include <cxlmem.h>
 
+struct mock_mdev_data {
+	void *lsa;
+};
+
 #define LSA_SIZE SZ_128K
 #define EFFECT(x) (1U << x)
 
@@ -140,7 +144,8 @@ static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
-	void *lsa = dev_get_drvdata(cxlds->dev);
+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
+	void *lsa = mdata->lsa;
 	u32 offset, length;
 
 	if (sizeof(*get_lsa) > cmd->size_in)
@@ -159,7 +164,8 @@ static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 static int mock_set_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_set_lsa *set_lsa = cmd->payload_in;
-	void *lsa = dev_get_drvdata(cxlds->dev);
+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
+	void *lsa = mdata->lsa;
 	u32 offset, length;
 
 	if (sizeof(*set_lsa) > cmd->size_in)
@@ -237,9 +243,12 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	return rc;
 }
 
-static void label_area_release(void *lsa)
+static void cxl_mock_drvdata_release(void *data)
 {
-	vfree(lsa);
+	struct mock_mdev_data *mdata = data;
+
+	vfree(mdata->lsa);
+	vfree(mdata);
 }
 
 static int cxl_mock_mem_probe(struct platform_device *pdev)
@@ -247,13 +256,21 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct cxl_memdev *cxlmd;
 	struct cxl_dev_state *cxlds;
+	struct mock_mdev_data *mdata;
 	void *lsa;
 	int rc;
 
+	mdata = vmalloc(sizeof(*mdata));
+	if (!mdata)
+		return -ENOMEM;
+
 	lsa = vmalloc(LSA_SIZE);
-	if (!lsa)
+	if (!lsa) {
+		vfree(mdata);
 		return -ENOMEM;
-	rc = devm_add_action_or_reset(dev, label_area_release, lsa);
+	}
+
+	rc = devm_add_action_or_reset(dev, cxl_mock_drvdata_release, mdata);
 	if (rc)
 		return rc;
 	dev_set_drvdata(dev, lsa);


