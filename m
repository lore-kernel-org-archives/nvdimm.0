Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 015F0A3B
	for <nvdimm@lists.linux.dev>; Tue, 23 Aug 2022 07:21:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661239274; x=1692775274;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=L8XrefDPQMXBCMvyyrEG92ZKAXZ8Ao9a9bnYvHgSICM=;
  b=NT7B6HX2VnoQYrRcZN3J2EC9MrPDRMRPHg+oDa89p/Li53Wz82D0/xlS
   +ODH+6qSkxMc4CYUo8w1/XJSp60zw658aoMb4UvgqK+sjy7qpNHbOF1KQ
   VDgLquYoBXupb5wVa529DYm6Gmpg6nqMA47Q7+LACQ3laxXVPq8EvnaGa
   vFf/9lGRMA0QBXwvBvar5Qzdwp3RPRkvYUbqPU1UYMFmLgyOVrtzH+fBf
   xMF8DuiUs8uON6XkZXGdegZFlzynugF1vYB5HbokctnbsShxkEBs2qUX6
   wSCDwW9bn0cXhfr9XfjSYIuOwEByaM7f0B2vLwFOfXbswvaD/gJBJkzGU
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10447"; a="293612575"
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="293612575"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:11 -0700
X-IronPort-AV: E=Sophos;i="5.93,256,1654585200"; 
   d="scan'208";a="735388587"
Received: from skummith-mobl1.amr.corp.intel.com (HELO vverma7-desk1.intel.com) ([10.212.54.206])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Aug 2022 00:21:10 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
To: <linux-cxl@vger.kernel.org>
Cc: <nvdimm@lists.linux.dev>,
	Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH 2/3] libcxl: fox a resource leak and a forward NULL check
Date: Tue, 23 Aug 2022 01:21:05 -0600
Message-Id: <20220823072106.398076-3-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823072106.398076-1-vishal.l.verma@intel.com>
References: <20220823072106.398076-1-vishal.l.verma@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1127; h=from:subject; bh=L8XrefDPQMXBCMvyyrEG92ZKAXZ8Ao9a9bnYvHgSICM=; b=owGbwMvMwCXGf25diOft7jLG02pJDMks9Y8+bmosbnrrefe1xLyNMsskFpv943997/nk+aH6rCJi 3kkTOkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjAR172MDEfk3G3sxS9w/eQ5/7n+0u ErPGK7SpnEGfIvr2m+fjzVdwEjw5Y762583Lqt347LweDyq2d8dwQqZS5lZ2yUWO0V03HQnhUA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Static analysis reports a couple of issues in add_cxl_region(). Firstly,
'path' wasn't freed in the success case, only in the error case.
Secondly, the error handling after 'calloc()'ing the region object
erroneously jumped to the error path which tried to free the region object,
instead of directly returning NULL.

Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/lib/libcxl.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/cxl/lib/libcxl.c b/cxl/lib/libcxl.c
index 021d59f..9945fd1 100644
--- a/cxl/lib/libcxl.c
+++ b/cxl/lib/libcxl.c
@@ -482,7 +482,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	region = calloc(1, sizeof(*region));
 	if (!region)
-		goto err;
+		return NULL;
 
 	region->id = id;
 	region->ctx = ctx;
@@ -551,6 +551,7 @@ static void *add_cxl_region(void *parent, int id, const char *cxlregion_base)
 
 	list_add_sorted(&decoder->regions, region, list, region_start_cmp);
 
+	free(path);
 	return region;
 err:
 	free(region->dev_path);
-- 
2.37.2

