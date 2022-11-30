Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB0079C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836114; x=1701372114;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=0VWsca8/tbCNf03hWIzVlcWyNXbZ6OeyJkne5/vXG4c=;
  b=csk6ouXaOsdkaqhiZoBEME2Dji1gF941RzkpuekiDzmmwZfq36zU+fZU
   0ufTyX2nHjC0PvQbDzqr0l7Mvvk0wYBb1AgT6taaMzwDcmBzCrlyA9vcZ
   NyzdXwwhCM/VKDVDGuQpDVy6RizbLYaSJZ+1rFH8yVv2Rkq+kNu/PORzT
   46JIdmg+Ed8CNlYqQ8A9VsiJqKsp4s6hRxHPh4sZZ4X6u0sHeVS57faBB
   UOKe4HwFjoPRIblVcH7A1zYuWG4mh06rcHpmXgyI7mHGMV7s9mtmSHA30
   jQH4UBlo+6Xstr+0ciGhCR6+SJAAiTa8jaAd8LjwIojvaHK2naYeTeujO
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="303092457"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="303092457"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="712932868"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="712932868"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:21:53 -0800
Subject: [PATCH v7 04/20] tools/testing/cxl: Add "Set Passphrase" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:21:53 -0700
Message-ID: 
 <166983611314.2734609.12996309794483934484.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device supporting the "Set Passphrase"
operation. The operation supports setting of either a user or a master
passphrase.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166863348691.80269.7361954266795277528.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mem.c |   88 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index d67fc04bf0cf..33ae7953f3f1 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -65,9 +65,16 @@ static struct {
 	},
 };
 
+#define PASS_TRY_LIMIT 3
+
 struct cxl_mockmem_data {
 	void *lsa;
 	u32 security_state;
+	u8 user_pass[NVDIMM_PASSPHRASE_LEN];
+	u8 master_pass[NVDIMM_PASSPHRASE_LEN];
+	int user_limit;
+	int master_limit;
+
 };
 
 static int mock_gsl(struct cxl_mbox_cmd *cmd)
@@ -158,6 +165,84 @@ static int mock_get_security_state(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static void master_plimit_check(struct cxl_mockmem_data *mdata)
+{
+	if (mdata->master_limit == PASS_TRY_LIMIT)
+		return;
+	mdata->master_limit++;
+	if (mdata->master_limit == PASS_TRY_LIMIT)
+		mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
+}
+
+static void user_plimit_check(struct cxl_mockmem_data *mdata)
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
+	struct cxl_mockmem_data *mdata = dev_get_drvdata(cxlds->dev);
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
@@ -256,6 +341,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_SECURITY_STATE:
 		rc = mock_get_security_state(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_SET_PASSPHRASE:
+		rc = mock_set_passphrase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


