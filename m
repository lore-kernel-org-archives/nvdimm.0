Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F677E
	for <nvdimm@lists.linux.dev>; Fri,  4 Mar 2022 01:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646357616; x=1677893616;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=miLJJtPTRQFnJT9FxHFesNYqykx3c18f0yF6o+aSLsA=;
  b=UlHH73R37C56TqF9Xx1y/bJbZdt9rJjj635VD0uIGnBZL5+N0LKPVvBG
   xjOwS+67a6ruTu3FCqEBzZnhvOQaOpUijqoKk8jUuKpBZMZljrimX4YFx
   Tc3XcTVXgWdbNKLuBGeF/AgAQU1EvY9/JcHnl+4Nl6oENnLjhTXnPkdpW
   nSNy46+UGC6h+Q/fV2D2JNs8nCyZE2XZ6GeEDwSNgfflbN0sbOaa0KI0H
   aWiqQy6QJl5wUP02pdkao+Q7vxRiStcJMCOMupyk0ZvYN111Fa/WGVzlu
   zXjLhY7F2zKAopP6raGUuzLrWhEJfVtIZXCIx9F7AfhnwtWy0iTP45IS5
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="233827058"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="233827058"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 17:33:35 -0800
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="552020142"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 17:33:35 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] cxl/list: always free the path var in add_cxl_decoder()
Date: Thu,  3 Mar 2022 17:36:43 -0800
Message-Id: <20220304013643.1054605-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Static analysis reported a resource leak where the 'path' variable was
not always freed before returns.

Fixes: 46564977afb7 ("cxl/list: Add decoder support")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 cxl/lib/libcxl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index daa2bbc5a299..aad7559daba2 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -1018,11 +1018,13 @@ static void *add_cxl_decoder(void *parent, int id, const char *cxldecoder_base)
 	cxl_decoder_foreach(port, decoder_dup)
 		if (decoder_dup->id == decoder->id) {
 			free_decoder(decoder, NULL);
+			free(path);
 			return decoder_dup;
 		}
 
 	list_add(&port->decoders, &decoder->list);
 
+	free(path);
 	return decoder;
 err:
 	free(decoder->dev_path);

base-commit: 3b5fb8b6428dfaab39bab58d67412427f514c1f4
-- 
2.31.1

