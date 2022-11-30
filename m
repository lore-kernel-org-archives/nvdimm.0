Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB1379C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836102; x=1701372102;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zTVJRAZfPqrqkUqLdCVilgtamMxYp40XNptRIKoiecs=;
  b=Ny4lxe4MqMs97OA0LrvZhqfNcukMSMfGFPHsQ8Z/r2n3AiuWtqux2Hox
   yH+1lHfmOD9k9Nb6Q/OXkm+6BmGmKuaOMY5M0Nu1e2S3tu2LvzFY1bn1x
   N6TpBtICARPnyUWena0YY8liAad2d63V8+K+ieXHKAD/yM0g52nKYBhIx
   v791lzFRPv7SKOcNk66cYx09CArnT9e7R9/EqKab7hXHCErCJtSXLYQwW
   njWnAwBuwXk3b/dL6+W2YumIMcwbuqCTTdWRL/OjuIowjLNaZ6zcKpeRn
   xpJMtCtVUzA3mi1AIMSmd0sF4v8CC9Se3CVKi2cZYQZ6o0IqK0H0wPRNh
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303092398"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303092398"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="712932766"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="712932766"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:42 -0800
Subject: [PATCH v7 02/20] tools/testing/cxl: Add "Get Security State" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:21:41 -0700
Message-ID: 
 <166983610177.2734609.4953959949148428755.stgit@djiang5-desk3.ch.intel.com>
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

Add the emulation support for handling "Get Security State" opcode for a
CXL memory device for the cxl_test. The function will copy back device
security state bitmask to the output payload.

The security state data is added as platform_data for the mock mem device.

Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863347508.80269.7206107994577858520.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mem.c |   44 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index aa2df3a15051..d67fc04bf0cf 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -65,6 +65,11 @@ static struct {
 	},
 };
 
+struct cxl_mockmem_data {
+	void *lsa;
+	u32 security_state;
+};
+
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
 {
 	if (cmd->size_out < sizeof(mock_gsl_payload))
@@ -137,10 +142,27 @@ static int mock_partition_info(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static int mock_get_security_state(struct cxl_dev_state *cxlds,
+				   struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
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
-	void *lsa = dev_get_drvdata(cxlds->dev);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
+	void *lsa = mdata->lsa;
 	u32 offset, length;
 
 	if (sizeof(*get_lsa) > cmd->size_in)
@@ -159,7 +181,8 @@ static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 static int mock_set_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_set_lsa *set_lsa = cmd->payload_in;
-	void *lsa = dev_get_drvdata(cxlds->dev);
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
+	void *lsa = mdata->lsa;
 	u32 offset, length;
 
 	if (sizeof(*set_lsa) > cmd->size_in)
@@ -230,6 +253,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_HEALTH_INFO:
 		rc = mock_health_info(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_GET_SECURITY_STATE:
+		rc = mock_get_security_state(cxlds, cmd);
+		break;
 	default:
 		break;
 	}
@@ -250,16 +276,20 @@ static int cxl_mock_mem_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct cxl_memdev *cxlmd;
 	struct cxl_dev_state *cxlds;
-	void *lsa;
+	struct cxl_mockmem_data *mdata;
 	int rc;
 
-	lsa = vmalloc(LSA_SIZE);
-	if (!lsa)
+	mdata = devm_kzalloc(dev, sizeof(*mdata), GFP_KERNEL);
+	if (!mdata)
+		return -ENOMEM;
+	dev_set_drvdata(dev, mdata);
+
+	mdata->lsa = vmalloc(LSA_SIZE);
+	if (!mdata->lsa)
 		return -ENOMEM;
-	rc = devm_add_action_or_reset(dev, label_area_release, lsa);
+	rc = devm_add_action_or_reset(dev, label_area_release, mdata->lsa);
 	if (rc)
 		return rc;
-	dev_set_drvdata(dev, lsa);
 
 	cxlds = cxl_dev_state_create(dev);
 	if (IS_ERR(cxlds))


