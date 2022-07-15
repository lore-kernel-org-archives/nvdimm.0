Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4435381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919342; x=1689455342;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=x/w4rjZNzfd3oOdRpIA4+Gm9z+kuyHAk+EzXG7r/RqQ=;
  b=CBsCRgHl0R5dN4BUlv1hRvEn4beouhwb5shYnNGZXpFgW1MsXKj242LA
   6XR7EleVy27kMJzk9bhDwTwHN3//5g74Cxp2sFQsNA7LMmc+0o7aziXMX
   UkvtZnIj6FY5IN5BRONhqjUlxd3IAVFjLE2Ms7upV90cR9kBBkkg/okLs
   E7kzJBOMBAzUuUygGga1/XdpIRZncGOaot+rHZeaqnVx++NuGKgAC/ycZ
   uBWZGFlLlMDSBSyMLoS5ihcQGMhvtkkgnlT6JBpCZBU4jDayQom36RH5h
   QXxvDclLsdgKycMcmVlYl9oTIFz0VcKxaiHcGFsdVUioJnd66Ob3wM6tf
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="283458360"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="283458360"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:02 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="654501327"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:01 -0700
Subject: [PATCH RFC 05/15] tools/testing/cxl: Add "Set Passphrase" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:09:01 -0700
Message-ID: 
 <165791934143.2491387.18407792819271591669.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device supporting the "Set Passphrase"
operation. The operation supports setting of either a user or a master
passphrase.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c |   76 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 337e5a099d31..796f4f7b5e3d 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -12,8 +12,14 @@
 struct mock_mdev_data {
 	void *lsa;
 	u32 security_state;
+	u8 user_pass[NVDIMM_PASSPHRASE_LEN];
+	u8 master_pass[NVDIMM_PASSPHRASE_LEN];
+	int user_limit;
+	int master_limit;
 };
 
+#define PASS_TRY_LIMIT 3
+
 #define LSA_SIZE SZ_128K
 #define EFFECT(x) (1U << x)
 
@@ -162,6 +168,73 @@ static int mock_get_security_state(struct cxl_dev_state *cxlds,
 	return 0;
 }
 
+static int mock_set_passphrase(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
+{
+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
+	struct cxl_set_pass *set_pass;
+
+	if (cmd->size_in != sizeof(*set_pass)) {
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+		return -EINVAL;
+	}
+
+	if (cmd->size_out != 0) {
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+		return -EINVAL;
+	}
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
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET &&
+		    memcmp(mdata->master_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			if (++mdata->master_limit == PASS_TRY_LIMIT)
+				mdata->security_state |= CXL_PMEM_SEC_STATE_MASTER_PLIMIT;
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->master_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		break;
+
+	case CXL_PMEM_SEC_PASS_USER:
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
+			cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+			return -ENXIO;
+		}
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET &&
+		    memcmp(mdata->user_pass, set_pass->old_pass, NVDIMM_PASSPHRASE_LEN)) {
+			if (++mdata->user_limit == PASS_TRY_LIMIT)
+				mdata->security_state |= CXL_PMEM_SEC_STATE_USER_PLIMIT;
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		memcpy(mdata->user_pass, set_pass->new_pass, NVDIMM_PASSPHRASE_LEN);
+		break;
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
@@ -257,6 +330,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_SECURITY_STATE:
 		rc = mock_get_security_state(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_SET_PASSPHRASE:
+		rc = mock_set_passphrase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


