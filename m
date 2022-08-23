Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6467BA5E
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661239275; x=1692775275;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8rJ8gEEBtVLYGXTt1L5arjJ8aeJKmNlD+4PYtRRCVes=;
  b=jH7tHIABZfK2P7+j2KGCzAfq1gVQZ2Sl968fHTFo+A6JOunH9dLMjC33
   QuMiryUVhWvK4RKxJMRsgolv9i0KKXG5y4rzy32tqAzNsuZjdDj2bmDoU
   XDIYjfInaVAc+3EMNNrnmiIAL+wjk+AFOGWV72YQNe5U8yzyAye/2c8LL
   razWtWO2SzDRpSHoI1mD7DyT4AKua9H/HSeJe+J0KQMvvc9P6vcZRQs6V
   VRRe6Rg7gTVIOH38Lgh0IBIGqpSCJT8HF3L3RI8ntcitpuX5LT0hgtR6J
   YNtte5aEIoDOcQCugKYrJdzpgPO5Ygq5bAra8d35IeL3HUFc4Uel8GbzR
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="293612577"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="293612577"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="735388590"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:11 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 3/3] cxl/filter: Fix an uninitialized pointer dereference
Date: Tue, 23 Aug 2022 01:21:06 -0600
Message-Id: <20220823072106.398076-4-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823072106.398076-1-vishal.l.verma@intel.com>
References: <20220823072106.398076-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=837; h=from:subject; bh=8rJ8gEEBtVLYGXTt1L5arjJ8aeJKmNlD+4PYtRRCVes=; b=owGbwMvMwCXGf25diOft7jLG02pJDMks9Y82rpzD9XiPz/5/vlEpvj4ZhrEnntescBLlLH+lvv2L 0NGTHaUsDGJcDLJiiix/93xkPCa3PZ8nMMERZg4rE8gQBi5OAZjIF26G//XTtos/2bts0aWdBZu67K u9vihHn/V2i10ef3njrovLT5cx/A/f9Wu7/eOY2Gv8V9hlvoaa1UXqhR/Srv4bxPg4/KrfeUYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Static analysis points out that there was a chance that 'jdecoder' could
be used while uninitialized in walk_decoders(). Initialize it to NULL to
avoid this.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/filter.c b/cxl/filter.c
index 9a3de8c..56c6599 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -796,7 +796,7 @@ static void walk_decoders(struct cxl_port *port, struct cxl_filter_params *p,
 	cxl_decoder_foreach(port, decoder) {
 		const char *devname = cxl_decoder_get_devname(decoder);
 		struct json_object *jchildregions = NULL;
-		struct json_object *jdecoder;
+		struct json_object *jdecoder = NULL;
 
 		if (!p->decoders)
 			goto walk_children;
-- 
2.37.2

