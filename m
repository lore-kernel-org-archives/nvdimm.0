Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0962C2CB1
	for <nvdimm@lists.linux.dev>; Mon,  3 Jan 2022 20:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641240697; x=1672776697;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jAsYLLBNz+SUKss7Qz28lVyYvm19aggyMmIkH5M2KtU=;
  b=DojVl7aTRcVVU793b8WC5pu2yFMtxUMLzJjhjbOozexNI1JQ4FbsgINh
   Ls4RP1EXQhx9CQ719G47GrdRZkTPsAjy2rYKj76Q1IhsAzulRxkbbrv/u
   noNLjueFW2RMKrbV3iYU8Tk3633jHzyvY1UncttcriYumqTYfDQNCM09j
   FLV7gk2t//IYA/V1Js2RS6BHLZmbT/d0CdzLKydjVDI0i4fjBvXU3Hr35
   yaR8O9BwO6KaCc8Nlmsyd3f8JXJ6FhXTMErbqVsXkJ6jTGxAM1zzcYfwX
   n7BC/TXes+DYG61GBvoWqwm0UfR+xR4T5ZPv/BroRu7jtvS9bThX+JW6M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10216"; a="302866892"
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="302866892"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2022 12:11:33 -0800
X-IronPort-AV: E=Sophos;i="5.88,258,1635231600"; 
   d="scan'208";a="525709408"
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
Subject: [ndctl PATCH 6/7] ndctl, util: use 'unsigned long long' type in OPT_U64 define
Date: Mon,  3 Jan 2022 12:16:17 -0800
Message-Id: <4653004cf532c2e14f79a45bddf0ebaac09ef4e6.1641233076.git.alison.schofield@intel.com>
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

The OPT_U64 define failed in check_vtype() with unknown 'u64' type.
Replace with 'unsigned long long' to make the OPT_U64 define usable.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 util/parse-options.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/util/parse-options.h b/util/parse-options.h
index 9318fe7..91b7932 100644
--- a/util/parse-options.h
+++ b/util/parse-options.h
@@ -124,7 +124,7 @@ struct option {
 #define OPT_INTEGER(s, l, v, h)     { .type = OPTION_INTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, int *), .help = (h) }
 #define OPT_UINTEGER(s, l, v, h)    { .type = OPTION_UINTEGER, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned int *), .help = (h) }
 #define OPT_LONG(s, l, v, h)        { .type = OPTION_LONG, .short_name = (s), .long_name = (l), .value = check_vtype(v, long *), .help = (h) }
-#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, u64 *), .help = (h) }
+#define OPT_U64(s, l, v, h)         { .type = OPTION_U64, .short_name = (s), .long_name = (l), .value = check_vtype(v, unsigned long long *), .help = (h) }
 #define OPT_STRING(s, l, v, a, h)   { .type = OPTION_STRING,  .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
 #define OPT_FILENAME(s, l, v, a, h) { .type = OPTION_FILENAME, .short_name = (s), .long_name = (l), .value = check_vtype(v, const char **), (a), .help = (h) }
 #define OPT_DATE(s, l, v, h) \
-- 
2.31.1

