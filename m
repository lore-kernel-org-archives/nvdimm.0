Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E264AA460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:29:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534967; x=1702070967;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QAJFQRhtPwzwpUKZtzMWwK4wTVkkYfpEnNbLpyK/lBE=;
  b=Mlqugy9bdEFrhIOAgfGHxA6yPytOu0Pvth3IiJvkt+pw6U6GXP3qmnX1
   xOPAITzG9Ca904Uqp1q9HFTH+tXyNTFrDcSX0z5Le9AjSFufwkBl6RxNm
   rAsKHqQ2uuFyUjRkiARnhuEOV26m1k60sUovFuh6D4pTQicm26MhcuUBF
   YjgjYq85CHLVl2dVP4tmriAQ8UjoVgvM5wa4dspK5D2YP6inMsYDB4Vvu
   7ygQ5dkX0SZWCAjr2/X0h0SHICn25u9vvtxAvaQw6pGQexLt5/gI1kiy8
   +0VfVJFJT98bJ8Ge5IiNCQ0huQjldv5/aP9/C7cMo/XPv3qplljWVqZOg
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="304950802"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="304950802"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:27 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="649323145"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="649323145"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:27 -0800
Subject: [ndctl PATCH v2 15/18] cxl/Documentation: Fix whitespace typos in
 create-region man page
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: vishal.l.verma@intel.com, alison.schofield@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:29:26 -0800
Message-ID: <167053496662.582963.12739035781728195815.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit


---
 Documentation/cxl/cxl-create-region.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index 6b740d5b8d96..e0e6818cfdd1 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -28,7 +28,7 @@ be emitted on stderr.
 EXAMPLE
 -------
 ----
-#cxl create - region - m - d decoder0 .1 - w 2 - g 1024 mem0 mem1
+#cxl create-region -m -d decoder0.1 -w 2 -g 1024 mem0 mem1
 {
   "region":"region0",
   "resource":"0xc90000000",

