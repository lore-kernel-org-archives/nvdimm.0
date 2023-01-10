Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B5B22C80
	for <nvdimm@lists.linux.dev>; Tue, 10 Jan 2023 23:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673392194; x=1704928194;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=t2rn+Iy4jdDZV+5z4dc6ZLrjqjVRNl6oqWZfHBzRwBA=;
  b=U53m4qffQPdg5IwQjwZRJlqoPvwJcPSltiSHNMGuywPFWnzhBY/BTba6
   HWjqsKRIyICkSx1DKsE7z5fReH64BYgngEAjqRO6ciphcVsgWRioxKc0e
   HQlqWDNxjl2iHP55FNlq4M2fz1thR2PYQCBLuzKz/ihznjwRMKA1HvTsA
   ypvr8dhDcTBbvCdbLx8B8hpqW6nyNDUYo+1m2+5RR72UtbxE0SiXk9oV0
   dApysWPkIu2C83OD+2RGmi6252ZSbmdWXoNt+FkDJB3tc2hus8SMe99Yi
   OxEVTSaPEbOnJzrgA8Ccay/Gh772lZvBSjxBIihxfnoqOIbW4wsQPlhUb
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="321981268"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="321981268"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659155907"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="659155907"
Received: from ffallaha-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.116.179])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:52 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 10 Jan 2023 16:09:15 -0700
Subject: [PATCH ndctl 2/4] cxl/region: fix a resource leak in to_csv()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230110-vv-coverity-fixes-v1-2-c7ee6c76b200@intel.com>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
In-Reply-To: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12-dev-cc11a
X-Developer-Signature: v=1; a=openpgp-sha256; l=984;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=t2rn+Iy4jdDZV+5z4dc6ZLrjqjVRNl6oqWZfHBzRwBA=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMl7P9jzLc3u1Z8pvcD56LEnYR6pE2Yk3PjykifSs+AH06TK
 ppKKjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExEcDojw87Y75XR26fyRHLtVFdqTr
 A9ffBWspXkmsXvvyz/8eJY1QNGhg3JbBy/rzxmzuF2fynFJu20L29yA49FzdSmKWnGAlLXGAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis reports there can be a memory leak in to_csv as an exit
path returns from the function before freeing 'csv'. Since this is the
only errpr path exit point after the allocation, just free() before
returning.

Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index bb3a10a..9a81113 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -146,8 +146,10 @@ static const char *to_csv(int *count, const char **strings)
 		return NULL;
 	for (i = 0; i < *count; i++) {
 		list = strdup(strings[i]);
-		if (!list)
+		if (!list) {
+			free(csv);
 			return NULL;
+		}
 
 		for (arg = strtok_r(list, which_sep(list), &save); arg;
 		     arg = strtok_r(NULL, which_sep(list), &save)) {

-- 
2.39.0
