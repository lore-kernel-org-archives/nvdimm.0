Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9D7A7474
	for <nvdimm@lists.linux.dev>; Tue, 10 Jan 2023 23:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673392195; x=1704928195;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=P4hPdW8+bePoAaxzhoqscfaaJ238PGmVdQhKGufS+7Y=;
  b=CGOD0DTgMhn5D9v61hM3orQnWr0My6RGldFr4wq9j9gOUYecYlPzLQj1
   ZprYSbf39FeV1kZ5g4KEMqdp9ekv9BmYYLjvfr15TkVOzaXJVdBBTXvBU
   fTuaeaIV9Qb8om+zIhJneI3PJgg6gckGlKDrr2HXiaKXFz4QxKuBW4N4w
   wNr/qB2TnGIR6XJjjcK3JYO4JumEZ2Ig0P72W5mE2QYqH3UDeilyZRjQm
   HOs6AoEMk0OBXiIcmnHvvpWLY+QXlS8TuGquj8/GLfJQ3lUwbTAiKQ22Y
   Dwka/7jOgLrat2pZGkTcX5sgRYJsmEFmKstgk3JpJyxXd4aEQ+1HiWR9u
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="321981274"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="321981274"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659155916"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="659155916"
Received: from ffallaha-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.116.179])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:52 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 10 Jan 2023 16:09:17 -0700
Subject: [PATCH ndctl 4/4] cxl/region: fix a comment typo
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230110-vv-coverity-fixes-v1-4-c7ee6c76b200@intel.com>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
In-Reply-To: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12-dev-cc11a
X-Developer-Signature: v=1; a=openpgp-sha256; l=813;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=P4hPdW8+bePoAaxzhoqscfaaJ238PGmVdQhKGufS+7Y=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMl7P9j/r16f9PzrvM5ly4XUb3J2ZxTtZuTbwnm5JnjBxVsp
 WVtndpSyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAiRnMZGbY/O7iLP3LWkt25mcxZ5f
 eeaIaI9LgWVXoeyTju12Q5SZmR4eP8cx/tX2y9N29qZ8x+Zp6HG753JGTNqzpbs/dos26DJysA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Fix a typo: s/separted/separated/

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index 89be9b5..efe05aa 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -103,7 +103,7 @@ static const struct option destroy_options[] = {
 
 /*
  * Convert an array of strings that can be a mixture of single items, a
- * command separted list, or a space separated list, into a flattened
+ * command separated list, or a space separated list, into a flattened
  * comma-separated string. That single string can then be used as a
  * filter argument to cxl_filter_walk(), or an ordering constraint for
  * json_object_array_sort()

-- 
2.39.0
