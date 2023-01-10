Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AE33C3B
	for <nvdimm@lists.linux.dev>; Tue, 10 Jan 2023 23:09:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673392195; x=1704928195;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=mL6lmpUYl41ULhtrwC9KKvuRtlC9LZqv9zJejcRxHKI=;
  b=CxYDC7J8bhT44TeJzeXMnriBod36MihGaEeVewK0c6pLRbWuLoaAa52k
   +pkoPVLYaOgMiLEfz9LmO6AJP9BuRS1ITwDlxos4k6/B0XZh1QPV0FvjF
   RvA7RbE5Ik+JHM8I/3gFklTRNhnj9W/5rttSZW3bWTHjhpUYaBhqaKim8
   9invi1admCekVc6EGZ5+3B1jYrAyuXprSf6KM2Ua3BrOdHy7yiGwFqCkT
   HuSKy1bYgHv+daNNlUS8clRFqdOg+RIx+JwiI+ZfCEcYHaHXl04UtjN/t
   1fPzYzZJjMS1uQu9u2neKDdTlEiOj6FmpxN528rX0H13r2BkVaHKf1vOq
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="321981271"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="321981271"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659155910"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="659155910"
Received: from ffallaha-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.116.179])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:52 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 10 Jan 2023 16:09:16 -0700
Subject: [PATCH ndctl 3/4] cxl/region: fix an out of bounds access in to_csv()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230110-vv-coverity-fixes-v1-3-c7ee6c76b200@intel.com>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
In-Reply-To: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12-dev-cc11a
X-Developer-Signature: v=1; a=openpgp-sha256; l=943;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=mL6lmpUYl41ULhtrwC9KKvuRtlC9LZqv9zJejcRxHKI=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMl7P9i71vl8ObSwPOnXlmuyv2yt/Z9MWTHb5+5O3axzGi5H
 62f1d5SyMIhxMciKKbL83fOR8Zjc9nyewARHmDmsTCBDGLg4BWAitb8YGQ6c2zHdzpLbs1ezdop3+4
 TVx3fLHuqO+hc5xYXzUnZssRUjw6TFNt9nfPX/1ZawhNnqZ/vr1QdfP6mwcXmxb/PStuAF51gA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis reports that when 'csv' is allocated for 'len' bytes,
writing to csv[len] results in an out of bounds access. Fix this
truncation operation to instead write the NUL terminator to csv[len -
1], which is the last byte of the memory allocated.

Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index 9a81113..89be9b5 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -156,7 +156,7 @@ static const char *to_csv(int *count, const char **strings)
 			cursor += snprintf(csv + cursor, len - cursor, "%s%s",
 					   arg, i + 1 < new_count ? "," : "");
 			if (cursor >= len) {
-				csv[len] = 0;
+				csv[len - 1] = 0;
 				break;
 			}
 		}

-- 
2.39.0
