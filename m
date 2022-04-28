Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3984D3D8D
	for <nvdimm@lists.linux.dev>; Thu, 28 Apr 2022 22:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651183833; x=1682719833;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Hrj0oSqW1mU02KYyQv9rVPsdjuM/cGHNMk60O/cQWA4=;
  b=KOO9DR0+r/pl6yDN8ikt2dVQ9e0JBl8tl436A4f5MFvXbXggby7KXMcU
   W05okUnxI3q/6VwgmRMq+sxP8ke6nDhbouhj+xroQ186teyyj+mtdS0w2
   wkDlhEHGWNZLKvsBZyaJJkLUa6lKZG5JZSb0DpNR2/qn+aIhI6vvzxsZN
   2Q8lqDwi29Hof1t2FZ9MpQzsDTy7Wgmk4hLd/9TeSG3/6PuTJTN6rXkPN
   HAI/IzsqQEoSOjZWHF32/P0949zoKIimkekELcel3lLkFG+VWZCnNfwTG
   GuAb/Nvj6m7sW0okJJ/Vlks8L/Br5Ev7MaG55Y3z0Gk88vkkW4jkylya5
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265289558"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265289558"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:32 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="731735541"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 15:10:32 -0700
Subject: [ndctl PATCH 06/10] cxl/list: Auto-enable 'single' mode for port
 listings
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Thu, 28 Apr 2022 15:10:32 -0700
Message-ID: <165118383246.1676208.2097194779584921177.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <165118380037.1676208.7644295506592461996.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The --single parameter instructs the filter code to gate listing of
ancestor ports. However, that behavior can be inferred by attempts to list
a port without the --ports option, i.e. make:

    cxl list -p $port

...equivalent to:

    cxl list -P -S -p $port

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/list.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/cxl/list.c b/cxl/list.c
index 1e9d441190a0..940782d33a10 100644
--- a/cxl/list.c
+++ b/cxl/list.c
@@ -104,6 +104,7 @@ int cmd_list(int argc, const char **argv, struct cxl_ctx *ctx)
 			error("please specify entities to list, e.g. using -m/-M\n");
 			usage_with_options(u, options);
 		}
+		param.single = true;
 	}
 
 	log_init(&param.ctx, "cxl list", "CXL_LIST_LOG");

