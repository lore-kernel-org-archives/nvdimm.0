Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C263BA492
	for <nvdimm@lists.linux.dev>; Fri, 18 Nov 2022 22:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668809227; x=1700345227;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mWQZ3PVAGchY87Zz3Kb5JxiQou2wQeFBeO8vWJo/3fc=;
  b=ACMLPCtMunRrRbfzU0fVgjPDzTHGpdiWV3GNSBW2KxoaLf/lPD4+on/0
   eUwYVMcOsZx8bG7METWjUtYfndCS8Zw9lgoYqgIhSW6Fyb5l7XlMUDrk3
   2B7PbptSlQzmn3MCwYMstXna23olUtfXuftP5KBXmtiSwyB3fPt/Xo4g0
   v8oCSzwDJvZBV1myi9Uk6PEg8NkcdCAbgrHX9kY+dJl23W40qeLh/Dvpy
   YVG1/pr1qQL6dfhVVzVKb8WfpCFH/JyTJ9A9ckmJRJYNCr8ni89YZ9b8x
   nHqPF5mDNBxpDFdjIRhmYmw67F3HkP+BGrb3M2gSfOKY1dl18bI2DrqSt
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="311949778"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="311949778"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:07:07 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="671467163"
X-IronPort-AV: E=Sophos;i="5.96,175,1665471600"; 
   d="scan'208";a="671467163"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 14:07:06 -0800
Subject: [PATCH v6] tools/testing/cxl: Add "passphrase secure erase" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com
Date: Fri, 18 Nov 2022 15:07:05 -0700
Message-ID: 
 <166880914520.808133.4307384879965818528.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: <20221117135738.00005557@Huawei.com>
References: <20221117135738.00005557@Huawei.com>
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

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---

v6:
- Change behavior for no master set while issue secure erase per spec.
- Add spec references in comments (Jonathan)
- Add Jonathan review tag.

 tools/testing/cxl/test/mem.c |  102 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 90607597b9a4..fbd033afb7af 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -362,6 +362,105 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
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
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_FROZEN) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PLIMIT &&
+	    erase->type == CXL_PMEM_SEC_PASS_USER) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PLIMIT &&
+	    erase->type == CXL_PMEM_SEC_PASS_MASTER) {
+		cmd->return_code = CXL_MBOX_CMD_RC_SECURITY;
+		return -ENXIO;
+	}
+
+	switch (erase->type) {
+	case CXL_PMEM_SEC_PASS_MASTER:
+		/*
+		 * The spec does not clearly define the behavior of the scenario
+		 * where a master passphrase is passed in while the master
+		 * passphrase is not set and user passphrase is not set. The
+		 * code will take the assumption that it will behave the same
+		 * as a CXL secure erase command without passphrase (0x4401).
+		 */
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_MASTER_PASS_SET) {
+			if (memcmp(mdata->master_pass, erase->pass,
+				   NVDIMM_PASSPHRASE_LEN)) {
+				master_plimit_check(mdata);
+				cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+				return -ENXIO;
+			}
+			mdata->master_limit = 0;
+			mdata->user_limit = 0;
+			mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
+			memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
+			mdata->security_state &= ~CXL_PMEM_SEC_STATE_LOCKED;
+		} else {
+			/*
+			 * CXL rev3 8.2.9.8.6.3 Disable Passphrase
+			 * When master passphrase is disabled, the device shall
+			 * return Invalid Input for the Passphrase Secure Erase
+			 * command with master passphrase.
+			 */
+			return -EINVAL;
+		}
+		/* Scramble encryption keys so that data is effectively erased */
+		break;
+	case CXL_PMEM_SEC_PASS_USER:
+		/*
+		 * The spec does not clearly define the behavior of the scenario
+		 * where a user passphrase is passed in while the user
+		 * passphrase is not set. The code will take the assumption that
+		 * it will behave the same as a CXL secure erase command without
+		 * passphrase (0x4401).
+		 */
+		if (mdata->security_state & CXL_PMEM_SEC_STATE_USER_PASS_SET) {
+			if (memcmp(mdata->user_pass, erase->pass,
+				   NVDIMM_PASSPHRASE_LEN)) {
+				user_plimit_check(mdata);
+				cmd->return_code = CXL_MBOX_CMD_RC_PASSPHRASE;
+				return -ENXIO;
+			}
+			mdata->user_limit = 0;
+			mdata->security_state &= ~CXL_PMEM_SEC_STATE_USER_PASS_SET;
+			memset(mdata->user_pass, 0, NVDIMM_PASSPHRASE_LEN);
+		}
+
+		/*
+		 * CXL rev3 Table 8-118
+		 * If user passphrase is not set or supported by device, current
+		 * passphrase value is ignored. Will make the assumption that
+		 * the operation will proceed as secure erase w/o passphrase
+		 * since spec is not explicit.
+		 */
+
+		/* Scramble encryption keys so that data is effectively erased */
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -470,6 +569,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_UNLOCK:
 		rc = mock_unlock_security(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
+		rc = mock_passphrase_secure_erase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


