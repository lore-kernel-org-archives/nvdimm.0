Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327AA79C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:22:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836148; x=1701372148;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mC8MTnXlFgZaWBGK/TGF4NKGlJK3l0FxzrWpN2PGRYY=;
  b=KAwhcbmKgVcsfDg/MKepaOz9K+ifgA+qUxilBM4C2mrXkp/e03WF19K/
   DLxWHT9IkcZMALKf31i0+3lU3MU5Xg5XOhdKzmUsDnK3h8xNByLVs4rFB
   UiDZ3CkMr4hGcJwYVePPEBgC/TQozxiS8S0MAbeYrV1aMngXSFjrlGBJk
   Zv08FkwmhoCqLsZiJUKOYPVC1u87aUI+r4wyVDmdhNglv8iNczWgoKV0F
   XbtFfSyj8HPaiqwwNWeks3EUvHGFCPR6J7pWENkTiO69VzcvhsoxcfgJr
   6vjzeqsLcW6ogyfsGmCVtz8O3zGYsUhjPrP1TPgzYo3V5lNtBCfbf3w3f
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="295853980"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="295853980"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="707769012"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="707769012"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:27 -0800
Subject: [PATCH v7 10/20] tools/testing/cxl: Add "Unlock" security opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:22:27 -0700
Message-ID: 
 <166983614730.2734609.2280484207184754073.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device support the "Unlock" operation.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863352285.80269.6269349640365319098.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mem.c |   45 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 45c6e6d3cfbb..ddd4a17e5564 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -331,6 +331,48 @@ static int mock_freeze_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
 	return 0;
 }
 
+static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+
+	if (cmd->size_in != NVDIMM_PASSPHRASE_LEN)
+		return -EINVAL;
+
+	if (cmd->size_out != 0)
+		return -EINVAL;
+
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (!(mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET)) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (!(mdata->security_state & CXL_PMEM_SEC_STATE_LOCKED)) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (memcmp(cmd->payload_in, mdata->user_pass, NVDIMM_PASSPHRASE_LEN)) {
+		if (++mdata->user_limit == PASS_TRY_LIMIT)
+			mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
+		cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+		return -ENXIO;
+	}
+
+	mdata->user_limit = 0;
+	mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
+	return 0;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -438,6 +480,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_FREEZE_SECURITY:
 		rc = mock_freeze_security(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_UNLOCK:
+		rc = mock_unlock_security(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


