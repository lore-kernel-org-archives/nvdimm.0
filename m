Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 903858F6E
	for <nvdimm@lists.linux.dev>; Tue,  2 May 2023 19:41:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683056462; x=1714592462;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=emspTz4gcRVjN1eavz3Gc7S3hJxYpHSez1F9Se080g8=;
  b=ZcObgPnCXgu40lwnkrXRg0SqBpwWs7M0LCnGwGCS4IntGI7fEsLAiY0N
   nb+xCMsTf8lFv0sKfjLhZsdV6XnMHkBE7pLxrYUu2IOhaM/3YY+rfxzxg
   SeInc7klJWnVeEdtdrNqY/wEF2S61oZZF3a1sccWSXTkDxEDX8n76kZjy
   6PY39ikiMCezVsCAwKNMsm3lHivB65JVkScOullNWF0vklE5bAAzwwQaT
   +Sg1zmCbkRsTo6WB+UA219TVqlMZv0g4jYKEpzGcb6pcZvGoShurMqJ+h
   uf5FAqXVK5tii7L4OWg0l9RzdNh/yW+waf+WXq+bmG8aq2IkbQRKKB/yq
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="413941135"
X-IronPort-AV: E=Sophos;i="5.99,245,1677571200"; 
   d="scan'208";a="413941135"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2023 12:41:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10698"; a="699093194"
X-IronPort-AV: E=Sophos;i="5.99,245,1677571200"; 
   d="scan'208";a="699093194"
Received: from gjunker-mobl1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.212.73.6])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 May 2023 12:41:01 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 02 May 2023 13:40:46 -0600
Subject: [PATCH ndctl] ndctl/namespace.c: fix unchecked return value from
 uuid_parse()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230502-vv-coverity-v1-1-079352646ba2@intel.com>
X-B4-Tracking: v=1; b=H4sIAD1nUWQC/zWNQQqDMBBFryKz7tA0asFeRbqYJKPOJkpSBot4d
 6Pg8vH+42+QOQln+FQbJFbJMscCr0cFfqI4MkooDNbY2rTGoir6WUv0+2OoqQu+MeTCG0rhKDO
 6RNFPZ6P6vKenXRIPsl5f/XffDyv5ZHp7AAAA
To: nvdimm@lists.linux.dev
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.13-dev-2eb1a
X-Developer-Signature: v=1; a=openpgp-sha256; l=1440;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=emspTz4gcRVjN1eavz3Gc7S3hJxYpHSez1F9Se080g8=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDCmB6XYnD4prmsos54xceF1xltsCk/PxUyZNEfzu4stv8
 Wjh7d3KHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIFhZGhnsLP66yEJGsX3B3
 YV3hjc/HZy3M3fXny/yVmUmOlUd+J2ow/FN/mmTx5r5g99FOqZum0d8Z03zkXmRk7znx7PlZifo
 j0VwA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis reports that write_pfn_sb() neglects to check the return
value from uuid_parse as is done elsewhere. Since the uuid being parsed
comes from the user, check for failure, and return an EINVAL if so.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/namespace.c | 16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

diff --git a/ndctl/namespace.c b/ndctl/namespace.c
index 722f13a..aa8c23a 100644
--- a/ndctl/namespace.c
+++ b/ndctl/namespace.c
@@ -1869,15 +1869,19 @@ static int write_pfn_sb(int fd, unsigned long long size, const char *sig,
 	npfns = PHYS_PFN(size - SZ_8K);
 	pfn_align = parse_size64(param.align);
 	align = max(pfn_align, SUBSECTION_SIZE);
-	if (param.uuid)
-		uuid_parse(param.uuid, uuid);
-	else
+	if (param.uuid) {
+		if (uuid_parse(param.uuid, uuid))
+			return -EINVAL;
+	} else {
 		uuid_generate(uuid);
+	}
 
-	if (param.parent_uuid)
-		uuid_parse(param.parent_uuid, parent_uuid);
-	else
+	if (param.parent_uuid) {
+		if (uuid_parse(param.parent_uuid, parent_uuid))
+			return -EINVAL;
+	} else {
 		memset(parent_uuid, 0, sizeof(uuid_t));
+	}
 
 	if (strcmp(param.map, "dev") == 0)
 		mode = PFN_MODE_PMEM;

---
base-commit: 26d9ce3351361631677e2cae933e3641540fa807
change-id: 20230502-vv-coverity-d3a9dc40abd6

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

