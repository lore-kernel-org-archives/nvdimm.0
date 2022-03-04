Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813A47E
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 00:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646355066; x=1677891066;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bOlSA7wYoXhVYBU+aB/Iuek6BOIGklB9faL2KaZETpE=;
  b=W4YChKVH6E3JNaMS8Je4Uhv0jAzcy7SBQ/97SZEWk3rpzCgp5sHFAcY4
   VHAu/3rgl7lpb/MCPYusmdXBYN4fBPGrNgflBScr7G6vrX/XuBy8BkpXt
   0X+QEw9uRjPtFfNs94bPXPl6miBqSnpd/8eZCbazYv3yAR7q8FZhsIggG
   HUs5jZaTuo/w5MxKFtL/y7aks3Zb7rKXdSx9AeOVlAyIal00iDqq5e1ej
   C6Q6HPiHvzMhCZs//Vj3zTA58Yb2K+nPXI358L/zMJBdIwToCw1mulZ4g
   7S+va8yjqzeu9IeCtYpuq4N1206/xu31+YT9uKvfe0BwiRgNse+FJpFj4
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="234467746"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="234467746"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 16:51:05 -0800
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="536082701"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 16:51:05 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] cxl/list: tidy the error path in add_cxl_decoder()
Date: Thu,  3 Mar 2022 16:54:23 -0800
Message-Id: <20220304005423.1054282-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Static analysis reported this NULL pointer dereference during
cleanup on error in add_cxl_decoder().

Fixes: 46564977afb7 ("cxl/list: Add decoder support")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index daa2bbc5a299..27c9e2ef8bc5 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -919,11 +919,11 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 
 	decoder->dev_path = strdup(cxldecoder_base);
 	if (!decoder->dev_path)
-		goto err;
+		goto err_decoder;
 
 	decoder->dev_buf = calloc(1, strlen(cxldecoder_base) + 50);
 	if (!decoder->dev_buf)
-		goto err;
+		goto err_decoder;
 	decoder->buf_len = strlen(cxldecoder_base) + 50;
 
 	sprintf(path, "%s/start", cxldecoder_base);
@@ -1024,10 +1024,12 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	list_add(&port->decoders, &decoder->list);
 
 	return decoder;
-err:
+
+err_decoder:
 	free(decoder->dev_path);
 	free(decoder->dev_buf);
 	free(decoder);
+err:
 	free(path);
 	return NULL;
 }

base-commit: 3b5fb8b6428dfaab39bab58d67412427f514c1f4
-- 
2.31.1

