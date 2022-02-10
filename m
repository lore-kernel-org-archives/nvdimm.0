Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DBE62CA4
	for <nvdimm@lists.linux.dev>; Thu, 10 Feb 2022 02:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644458475; x=1675994475;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=zdPVXTdbWAIRBULjnmsUnkEvtM/Beuh0buw5XHal5qQ=;
  b=hkSIhJjKN6DcR7uTB+LQkfT49xXuYGQeYKWmM7Cxqu8h/axNETx8/s8Q
   CGiYBICI16BRcULwwyD7cL2HdIXYEPFl6rb3HT1rqeQGyr9EFnp5SejSW
   5WsP622Ml41je5sn/by90YjvyJR6RlT2fV8jWtKmTo07fAtBU2FO1Ubaf
   AERH/nkfgg9vhwmNQgy+sMMnkKspDKicpU0Gmptig+5aTFdrp4IWxW8gr
   vcuYGkDNSVQeOrQaurpi3CP4UFDpw1kL+gr8gWz/3TNvU52YKAaDhyAlf
   lVo5sG1YQXipKz+06ZvAGCcG0Z/WrfaiYXaLYF5DejCHqxh8/NgKOKJaq
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10253"; a="236792117"
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="236792117"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:14 -0800
X-IronPort-AV: E=Sophos;i="5.88,357,1635231600"; 
   d="scan'208";a="585799541"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 18:01:13 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH v5 3/6] libcxl: return the partition alignment field in bytes
Date: Wed,  9 Feb 2022 18:05:11 -0800
Message-Id: <6b937b09b61ddf95e069fd7acfda0c5bbb845be8.1644455619.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1644455619.git.alison.schofield@intel.com>
References: <cover.1644455619.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Per the CXL specification, the partition alignment field reports
the alignment value in multiples of 256MB. In the libcxl API, values
for all capacity fields are defined to return bytes.

Update the partition alignment accessor to return bytes so that it
is in sync with other capacity related fields. Use the helpers
cmd_to_identify() and cxl_capacity_to_bytes() to accomplish.

Since this is early in the development cycle, the expectation is that
no third party consumers of this library have come to depend on the
encoded capacity field. If that is not the case, the original format
can be restored, and a new _bytes version introduced.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---

 cxl/lib/libcxl.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 9413384..c05c13c 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -2308,15 +2308,12 @@ CXL_EXPORT int cxl_cmd_identify_get_fw_rev(struct cxl_cmd *cmd, char *fw_rev,
 CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
 		struct cxl_cmd *cmd)
 {
-	struct cxl_cmd_identify *id =
-			(struct cxl_cmd_identify *)cmd->send_cmd->out.payload;
+	struct cxl_cmd_identify *c;
 
-	if (cmd->send_cmd->id != CXL_MEM_COMMAND_ID_IDENTIFY)
-		return -EINVAL;
-	if (cmd->status < 0)
-		return cmd->status;
-
-	return le64_to_cpu(id->partition_align);
+	c = cmd_to_identify(cmd);
+	if (!c)
+		return ULLONG_MAX;
+	return cxl_capacity_to_bytes(c->partition_align);
 }
 
 CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
-- 
2.31.1

