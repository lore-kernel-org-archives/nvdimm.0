Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9DF8BF5
	for <nvdimm@lists.linux.dev>; Tue,  8 Nov 2022 17:26:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667928392; x=1699464392;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cPIE4LC7mms4p8LW6nwgmVCNIo/V1BCOypYTc71yoBw=;
  b=cE+7vUu5eXyd6V9cX/tFQ4HncqknQN2XI78WloZ2Jdlr2SIUjH+4zIlA
   ObJZdH7q0OVMEvN3VC+44hDNTQnzuTGnNgGG6cWcNsBmykF1Ak5xIdUyi
   nU/wc7BmvSyzzbPHNVbVRajVBjkTJ4dWq/CHAgNqKdzth14fQv3U9qIzI
   PVuNTrLg5wwsBlFOiGTaQfw4DglN7S5IxiFrOPVkISQ9SlGxw5aPXzUZi
   fceYzQ3mbc8/dU4n1aiF5yy9cjuT6++98WuOAeds2veUQI5s3rqUVlKDd
   /aknq+an/XHMrd4oCT6IY8O9P70N4cMBkOlb3I1xSb62LX0/82hfvdNWi
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="337488691"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="337488691"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:31 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10525"; a="669629837"
X-IronPort-AV: E=Sophos;i="5.96,148,1665471600"; 
   d="scan'208";a="669629837"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga001-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Nov 2022 09:26:31 -0800
Subject: [PATCH v3 12/18] tools/testing/cxl: Add "passphrase secure erase"
 opcode support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Tue, 08 Nov 2022 10:26:30 -0700
Message-ID: 
 <166792839079.3767969.17718924625264191957.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device support the "passphrase secure
erase" operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c |   59 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 90607597b9a4..aa6dda21bc5f 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -362,6 +362,62 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
 	return 0;
 }
 
+static int mock_passphrase_secure_erase(struct cxl_dev_state *cxlds,
+					struct cxl_mbox_cmd *cmd)
+{
+	struct cxl_mock_mem_pdata *mdata = dev_get_platdata(cxlds->dev);
+	struct cxl_pass_erase *erase;
+
+	if (cmd->size_in != sizeof(*erase))
+		return -EINVAL;
+
+	if (cmd->size_out != 0)
+		return -EINVAL;
+
+	erase = cmd->payload_in;
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN &&
+	    erase->type != CXL_PMEM_SEC_PASS_MASTER) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (erase->type == CXL_PMEM_SEC_PASS_MASTER &&
+	    mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET) {
+		if (memcmp(mdata->master_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
+			master_plimit_check(mdata);
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+		mdata->master_limit = 0;
+		mdata->user_limit = 0;
+		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
+		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
+		mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
+		return 0;
+	}
+
+	if (erase->type == CXL_PMEM_SEC_PASS_USER &&
+	    mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+		if (memcmp(mdata->user_pass, erase->pass, NVDIMM_PASSPHRASE_LEN)) {
+			user_plimit_check(mdata);
+			cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+			return -ENXIO;
+		}
+
+		mdata->user_limit = 0;
+		mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
+		memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
+		return 0;
+	}
+
+	return 0;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -470,6 +526,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_UNLOCK:
 		rc = mock_unlock_security(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
+		rc = mock_passphrase_secure_erase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


