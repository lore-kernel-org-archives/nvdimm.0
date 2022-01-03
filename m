Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50542CA7
	for <nvdimm@lists.linux.dev>; Mon,  3 Jan 2022 20:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641240695; x=1672776695;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=eN99uTDmncVh4iL2OAQGr2qLxxRilTkwPt0bI8R2V3I=;
  b=hhX/azV+Alsn47OXiytbl2114ALGhj7VlTGAhOj2fQijc8PMKfBsWXcW
   m6V1/kZm5VQM9aYaDeyHb+9MpW/VdTkIXIWiXDazn6y7npI6MLQNgpqSO
   BZ0uGQC7Xmw+Hn8uxZ/Wk8cyoWxPTALjXM2C1EjwXBmNHw0Mv0bNlAQnp
   C6BV18jye1RO4HlVwM3B6lcWOPThQrSFSTEDw8Swr+N0PIOZcwFtT/JNb
   5Q1gL0URfIPOfobaDfBTFi23R+eiMhcNQAMcPDGgnTi0jj2mSQJfXNgTo
   Org/gurqxX3552RfYQw5J1N2UHTPD1LuEr1gvoNhTluORTx/2l3k0yKn4
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="302866888"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="302866888"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525709395"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
From: alison.schofield@intel.com
To: Ben Widawsky <ben.widawsky@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 3/7] libcxl: apply CXL_CAPACITY_MULTIPLIER to partition alignment field
Date: Mon,  3 Jan 2022 12:16:14 -0800
Message-Id: <a5ff95fd75d42c29a15d285caee81cb9ea4c05d8.1641233076.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <cover.1641233076.git.alison.schofield@intel.com>
References: <cover.1641233076.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

The IDENTIFY mailbox command returns the partition alignment field
expressed in multiples of 256 MB. Use CXL_CAPACITY_MULTIPLIER when
returning this field.

This is in sync with all the other partitioning related fields using
the multiplier.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 715d8e4..85a6c0e 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1086,7 +1086,7 @@ CXL_EXPORT unsigned long long cxl_cmd_identify_get_partition_align(
 	if (cmd->status < 0)
 		return cmd->status;
 
-	return le64_to_cpu(id->partition_align);
+	return le64_to_cpu(id->partition_align) * CXL_CAPACITY_MULTIPLIER;
 }
 
 CXL_EXPORT unsigned int cxl_cmd_identify_get_label_size(struct cxl_cmd *cmd)
-- 
2.31.1

