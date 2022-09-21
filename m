Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 959C366E0
	for <nvdimm@lists.linux.dev>; Wed, 21 Sep 2022 15:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663774321; x=1695310321;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=4wv5a/tyuDgn4HEb0fGr/xRG1zKb2K8sXezWY10+beg=;
  b=N0ZnjUKc8F7eQxuuU3Dlx51fUyXPupUZeoGDa9AH4/WXRDDfxzZ/qMIN
   0tmICyAN219f4qQwWeossg9+sr5i8B5o6xKuQLbWwFc4dj5+joluGQJTy
   AmawyZxEhHoZkdnpSwWRcZzNt32RLxfWACae4e0I51a80OFg4Ju3BhJm4
   Fy63VMwTvFM5nZZgBzcWZnhx9zSUHmcI/FQUsyYqhONiAcLm/t2P7v9Hn
   K+pntHHdmkWGHWpnkMkUgvltEWZ2FbGQcHyiSImb5JtB+L6LTtGIoUKmO
   dpD96dvNxzvhSjCdrBOF/R7IPAFgAjplLGCzO8KVNwUVZZ46GQVX8J0dD
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10477"; a="361796088"
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="361796088"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:32:00 -0700
X-IronPort-AV: E=Sophos;i="5.93,333,1654585200"; 
   d="scan'208";a="652579078"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Sep 2022 08:31:58 -0700
Subject: [PATCH v2 05/19] tools/testing/cxl: Add "Set Passphrase" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org
Cc: nvdimm@lists.linux.dev, dan.j.williams@intel.com, bwidawsk@kernel.org,
 ira.weiny@intel.com, vishal.l.verma@intel.com, alison.schofield@intel.com,
 dave@stgolabs.net, Jonathan.Cameron@huawei.com
Date: Wed, 21 Sep 2022 08:31:58 -0700
Message-ID: 
 <166377431828.430546.12996556155261310755.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device supporting the "Set Passphrase"
operation. The operation supports setting of either a user or a master
passphrase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c       |   66 ++++++++++++++++++++++++++++++++++++
 tools/testing/cxl/test/mem_pdata.h |    6 +++
 2 files changed, 72 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 9002a3ae3ea5..86be5e183b5c 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -154,6 +154,69 @@ static int mock_get_security_state(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static int mock_set_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_set_pass *set_pass;
+
+	if (cmd->size_in != sizeof(*set_pass))
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
+	set_pass = cmd->payload_in;
+	switch (set_pass->type) {
+	case CXL_PMEM_SEC_PASS_MASTER:
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		/*
+		 * CXL spec v2.0 8.2.9.5.6.2, The master pasphrase shall only be set in
+		 * the security disabled state when the user passphrase is not set.
+		 */
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		if (memcmp(mdata->master_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			if (++mdata->master_limit == PASS_TRY_LIMIT)
+				mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->master_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PASS_SET;
+		return 0;
+
+	case CXL_PMEM_SEC_PASS_USER:
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		if (memcmp(mdata->user_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			if (++mdata->user_limit == PASS_TRY_LIMIT)
+				mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->user_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PASS_SET;
+		return 0;
+
+	default:
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+		return -EINVAL;
+	}
+	return 0;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -250,6 +313,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_SECURITY_STATE:
 		rc = mock_get_security_state(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_SET_PASSPHRASE:
+		rc = mock_set_passphrase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}
diff --git a/tools/testing/cxl/test/mem_pdata.h b/tools/testing/cxl/test/mem_pdata.h
index 6a7b111147eb..8eb2dffc9156 100644
--- a/tools/testing/cxl/test/mem_pdata.h
+++ b/tools/testing/cxl/test/mem_pdata.h
@@ -5,6 +5,12 @@
 
 struct cxl_mock_mem_pdata {
 	u32 security_state;
+	u8 user_pass[NVDIMM_PASSPHRASE_LEN];
+	u8 master_pass[NVDIMM_PASSPHRASE_LEN];
+	int user_limit;
+	int master_limit;
 };
 
+#define PASS_TRY_LIMIT 3
+
 #endif


