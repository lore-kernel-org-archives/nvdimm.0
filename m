Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAD465381
	for <nvdimm@lists.linux.dev>; Fri, 15 Jul 2022 21:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657919330; x=1689455330;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=fZzS0dNQqzNeoZ9itlm7J1mbGFqBsFU+AxSoJ/hpTPw=;
  b=EWnnpKqpJoSk0aWmszZ5KwBes4c0STY4ISSLQwsRQNZnfAG1QNdByGph
   L0UkR1G/xPzlj6hV5zLDMu3vW796sGIMApDoi66+XFx+7ec8Khr49PMWZ
   MrB6n9MENNoJkfx5PFpp2feALVQAct6e9KLk6KCvvgAaFLAx11vbHwK4a
   b/Ga0gBXQkxq768Lu4rQgZADtUameJ7Lkg2WSrf39gdBu1vW01F+A/7ji
   qOCgU6hKxL9UjV/8ettkQWXr9k3LpxsfBIkPgWNYaTelfMXYi8R7JAbQn
   PC8qxRhcGX00GSzsseCRcDtEcOD6abp/31X/7oitmkWNnfnfICK8L33Mp
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10409"; a="349863156"
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="349863156"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,275,1650956400"; 
   d="scan'208";a="546797585"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2022 14:08:50 -0700
Subject: [PATCH RFC 03/15] tools/testing/cxl: Add "Get Security State" opcode
 support
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: dan.j.williams@intel.com, bwidawsk@kernel.org, ira.weiny@intel.com,
 vishal.l.verma@intel.com, alison.schofield@intel.com, dave@stgolabs.net
Date: Fri, 15 Jul 2022 14:08:49 -0700
Message-ID: 
 <165791932983.2491387.13708346830998415266.stgit@djiang5-desk3.ch.intel.com>
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

Add the emulation support for handling "Get Security State" opcode for a
CXL memory device for the cxl_test. The function will copy back device
security state bitmask to the output payload.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 tools/testing/cxl/test/mem.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/testing/cxl/test/mem.c b/tools/testing/cxl/test/mem.c
index 723378248321..337e5a099d31 100644
--- a/tools/testing/cxl/test/mem.c
+++ b/tools/testing/cxl/test/mem.c
@@ -11,6 +11,7 @@
 
 struct mock_mdev_data {
 	void *lsa;
+	u32 security_state;
 };
 
 #define LSA_SIZE SZ_128K
@@ -141,6 +142,26 @@ static int mock_id(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 	return 0;
 }
 
+static int mock_get_security_state(struct cxl_dev_state *cxlds,
+				   struct cxl_mbox_cmd *cmd)
+{
+	struct mock_mdev_data *mdata = dev_get_drvdata(cxlds->dev);
+
+	if (cmd->size_in) {
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+		return -EINVAL;
+	}
+
+	if (cmd->size_out != sizeof(u32)) {
+		cmd->return_code = CXL_MBOX_CMD_RC_INPUT;
+		return -EINVAL;
+	}
+
+	memcpy(cmd->payload_out, &mdata->security_state, sizeof(u32));
+
+	return 0;
+}
+
 static int mock_get_lsa(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *cmd)
 {
 	struct cxl_mbox_get_lsa *get_lsa = cmd->payload_in;
@@ -233,6 +254,9 @@ static int cxl_mock_mbox_send(struct cxl_dev_state *cxlds, struct cxl_mbox_cmd *
 	case CXL_MBOX_OP_GET_HEALTH_INFO:
 		rc = mock_health_info(cxlds, cmd);
 		break;
+	case CXL_MBOX_OP_GET_SECURITY_STATE:
+		rc = mock_get_security_state(cxlds, cmd);
+		break;
 	default:
 		break;
 	}


