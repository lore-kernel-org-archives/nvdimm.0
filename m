Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50AC75381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:09:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919389; x=1689455389;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ALbb4cXTY9+mqVlkMTirRejxV8Px6TRXuQbpHZxnCkw=;
  b=in9UhsvQp1SQUA1d9Kfjc0imOff040ZlnfWd03VS+VvxZVTmtoMEkGs2
   xmZ1Gg6BCVGbHkshdcZeOxHZHQ8VXJMrpfmvChk/LbAj0Dx+KJ7us+mkf
   TI4ZdrPNNvUsnrkymgqz/teV3P9AqFll7gv+qMxIN9BYfOrcd1YtXiKsy
   fQxhWjurGZO2ajA/I9h2luUPlxUaDHQStVr4CLSekc8fQf8sf7tEB0yqZ
   SKnRYLusNT0FmdaZeO6bL4rELf8pSaQnB01RIRfT3yFQhEtE5RsXKNLgg
   NZckSdogfndj7E+k0x/EHx/tIpBQamhErOZyG+NdTdVR8owj9XwaHhJ59
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="372215221"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="372215221"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:43 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="546797763"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:09:42 -0700
Subject: [PATCH RFC 12/15] tools/testing/cxl: Add "Unlock" security opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:09:42 -0700
Message-ID: 
 <165791938203.2491387.12136394174353676616.stgit@djiang5-desk3.ch.intel.com>
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

Add support to emulate a CXL mem device support the "Unlock" operation.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c |   49 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index d8d08a89ec0c..55a83896ccb8 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -340,6 +340,52 @@ static int mock_freeze_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd
 	return 0;
 }
 
+static int mock_unlock_security(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
+{
+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
+
+	if (cmd->size_in != NVDIMM_PASSPHRASE_LEN) {
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
@@ -444,6 +490,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_FREEZE_SECURITY:
 		rc = mock_freeze_security(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_UNLOCK:
+		rc = mock_unlock_security(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


