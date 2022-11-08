Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896AF8BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928345; x=1699464345;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=f5YG+uIWnLHJyHDG0GXZgolJd39mYA+YNYTqCRa+xMU=;
  b=nnuV0AibBMzjVpgU9ERx8+2xEw2DzPnacORu0ot11uKKykC8yu91kN6U
   aUdt2OhwRnsf25JUdTBr4s6ZovGm+6MAm5+cSBoIN+AQv09Z+1WCFfn++
   W/RlckLveEsLoa6t2UpH72q1jUj6qMYa6TVoR03U8l1YU802nRWTfvxIM
   oT/j552eFCEjTKvVMiSyFYJ+o4IPvt/kQRru57Zw/EAHhLFyOPa8zWbxr
   Mz115BPgmvykuzU4hFGFf7eMkd6e1fSLHR0spk+3IdCBDqwQSY7eJg2yO
   sVVaWCvJf5nFDoOc8rF8IXH27bF3jUYDeHu4241kRsOWcn7ni/ejyL7A0
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="337488462"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="337488462"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:25:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="742038814"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="742038814"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:25:44 -0800
Subject: [PATCH v3 04/18] tools/testing/cxl: Add "Set Passphrase" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:25:44 -0700
Message-ID: 
 <166792834432.3767969.4537105791663118664.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device supporting the "Set Passphrase"
operation. The operation supports setting of either a user or a master
passphrase.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c       |   81 ++++++++++++++++++++++++++++++++++++
 tools/testing/cxl/test/mem_pdata.h |    6 +++
 2 files changed, 87 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 9002a3ae3ea5..0fac0ca81290 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -154,6 +154,84 @@ static int mock_get_security_state(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static void master_plimit_check(struct cxl_mock_mem_pdata *mdata)
+{
+	if (mdata->master_limit == PASS_TRY_LIMIT)
+		return;
+	mdata->master_limit++;
+	if (mdata->master_limit == PASS_TRY_LIMIT)
+		mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
+}
+
+static void user_plimit_check(struct cxl_mock_mem_pdata *mdata)
+{
+	if (mdata->user_limit == PASS_TRY_LIMIT)
+		return;
+	mdata->user_limit++;
+	if (mdata->user_limit == PASS_TRY_LIMIT)
+		mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
+}
+
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
+		 * CXL spec rev3.0 8.2.9.8.6.2, The master pasphrase shall only be set in
+		 * the security disabled state when the user passphrase is not set.
+		 */
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		if (memcmp(mdata->master_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			master_plimit_check(mdata);
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
+			user_plimit_check(mdata);
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->user_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PASS_SET;
+		return 0;
+
+	default:
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+	}
+	return -EINVAL;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -250,6 +328,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
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


