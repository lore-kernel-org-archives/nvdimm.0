Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9E823A6
	for <nvdimm@lists.linux.dev>; Tue, 10 Jan 2023 23:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673392194; x=1704928194;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=Gtf6WAW/csOf427X3LRR5XcQfg7g7JRMlkKoYsNZ8zk=;
  b=k5BG7qlwngcYV+vz6o8Zjcop/0NQXQQvohU66EehEkU1vgKEmwoonccV
   64auPOLUQX9Go9+wRauuIvQ7uel06hMJV8qmppd58UNjeCT3wxsIrGZ5r
   2xMmyR+C9YQ9fvnob5A96MEoggnzWzSyZfEcoIouzD8LLK2nJhGKkTZ+M
   pOeQY82LXqajUtRkbuWvpfa5JraH/6DfTmxWjIdM7lD5UJT5+js2+jgDf
   7AVd1+k75OlwEg4KCGerWQ6XBnYmcXo/N3lI06pE+JZxala0KJ+/xjblR
   sdkr9brOVgvU+m5NrHli4Nk4OvEgOJ0JLp0qTZ40+8MqLMHloDRRsxvP8
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="321981266"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="321981266"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:52 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="659155904"
X-IronPort-AV: E=Sophos;i="5.96,315,1665471600"; 
   d="scan'208";a="659155904"
Received: from ffallaha-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.212.116.179])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Jan 2023 15:09:52 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 10 Jan 2023 16:09:14 -0700
Subject: [PATCH ndctl 1/4] ndctl/lib: fix usage of a non NUL-terminated string
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230110-vv-coverity-fixes-v1-1-c7ee6c76b200@intel.com>
References: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
In-Reply-To: <20230110-vv-coverity-fixes-v1-0-c7ee6c76b200@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: Dave Jiang <dave.jiang@intel.com>, Dan Williams <dan.j.williams@intel.com>,
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.12-dev-cc11a
X-Developer-Signature: v=1; a=openpgp-sha256; l=872;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=Gtf6WAW/csOf427X3LRR5XcQfg7g7JRMlkKoYsNZ8zk=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMl7P9irFeUyXWHr15r8dsMkn/UNJ6wnKFrKaMzPzi6K353o
 bvito5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABPRnMPwT/lQ6enUJdbypnX9c9Q9XX
 ZctvxccnjyacUlbnVd26euXwJU0a3cvUFfdS+DSUjX+/NFs5TP+j35525+ni37eI6prAcnAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Static analysis reports that in add_region(), a buffer from pread()
won't have NUL-termination. Hence passing it to strtol subsequently can
be wrong. Manually add the termination after pread() to fix this.

Fixes: c64cc150a21e ("ndctl: add support in libndctl to provide deep flush")
Cc: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl/lib/libndctl.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index f32f704..ddbdd9a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2750,6 +2750,8 @@ static void *add_region(void *parent, int id, const char *region_base)
 		goto out;
 	}
 
+	/* pread() doesn't add NUL termination */
+	buf[1] = 0;
 	perm = strtol(buf, NULL, 0);
 	if (perm == 0) {
 		close(region->flush_fd);

-- 
2.39.0
