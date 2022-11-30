Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10F0E79C0
	for <nvdimm@lists.linux.dev>; Wed, 30 Nov 2022 19:22:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669836160; x=1701372160;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8Y0iy6dL81pHg0zHHKTnYGS6OcGmr2mVUzVKbecfgRk=;
  b=NhPIhWvfypN1+XeflwJx8+E7b4SedTBobcurEM01f2JXk6cW8ouX7RaG
   2ZbKgWjg/CKG7ZUTvJiyrD97hEnCzVS4rTffilYrbkZQr+dwMV2t/xf+X
   z9HtQX2RbevpdgZwJqGn/WSfZYPpZU/Q5iIOWogiIkyodu9+P+p5pHVWJ
   MW3XRLgdcZHVO9MvmxWwdI1I4cymx0lN7AXADQAU8OEseK+wqUK0ULvXZ
   dwz3ZCd2oqr4OSM5ZAvBxcs7OzKY15+t4p4UqVs/iO++1Qqj+LnkRwH61
   x7F1nIIpCATdAsYD9oXMMLUcxuoLMhGrq0aKryR5tlcdr3N/kVkHf/XBR
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="401765320"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="401765320"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10547"; a="818746957"
X-IronPort-AV: E=Sophos;i="5.96,207,1665471600"; 
   d="scan'208";a="818746957"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Nov 2022 11:22:39 -0800
Subject: [PATCH v7 12/20] tools/testing/cxl: Add "passphrase secure erase"
 opcode support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, ira.weiny@intel.com, vishal.l.verma@intel.com,
 alison.schofield@intel.com, Jonathan.Cameron@huawei.com, dave@stgolabs.net
Date: Wed, 30 Nov 2022 12:22:38 -0700
Message-ID: 
 <166983615879.2734609.5177049043677443736.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device support the "passphrase secure
erase" operation.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/166880914520.808133.4307384879965818528.stgit@djiang5-desk3.ch.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/mem.c |  102 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 102 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index ddd4a17e5564..1008ee2e1e31 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -373,6 +373,105 @@ static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
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
@@ -483,6 +582,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_UNLOCK:
 		rc = mock_unlock_security(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_PASSPHRASE_SECURE_ERASE:
+		rc = mock_passphrase_secure_erase(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


