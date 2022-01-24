Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D581B2C80
	for <nvdimm@lists.linux.dev>; Mon, 24 Jan 2022 00:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642984318; x=1674520318;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WYqKjM3YBVT39/qh0s5IDXqejz+JKtb2bzvqd2hP0to=;
  b=SiMaRvhyvJT3uuUtOyd9LDHtfevvIGuW6HMyErIT5Kdz0CWcswUTNcJo
   t+FgXUyHszBAffGfW3ibgvb04iek3P4/60KorSumbGoGqa4RCKWSSQRHd
   d0y5MYHcpgVE3K5P8Fif+w+pdCSQX/S61vhSNIyLk6JJWNvdqXpsVR4as
   qmCY6YolD+4RQLsRndeU911TBSkdxF6Wy1aV3K/jAqXYZ0wvtBX3f+D8G
   T3I3VMabBP014bUKoA3L4EYK9vMOZzoQh+hFjfcvh6Nm33N14QqDg156g
   o7vodxFQbYAwmPzevWn/hnfFTQDcJYUjC3q7i452GBwYnpcdXVfgMjXq8
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10236"; a="306650839"
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="306650839"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:58 -0800
X-IronPort-AV: E=Sophos;i="5.88,311,1635231600"; 
   d="scan'208";a="673453924"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jan 2022 16:31:56 -0800
Subject: [PATCH v3 37/40] tools/testing/cxl: Fix root port to host bridge
 assignment
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 23 Jan 2022 16:31:56 -0800
Message-ID: <164298431629.3018233.14004377108116384485.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Mocked root-ports are meant to be round-robin assigned to host-bridges.

Fixes: 67dcdd4d3b83 ("tools/testing/cxl: Introduce a mocked-up CXL port hierarchy")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 tools/testing/cxl/test/cxl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/cxl/test/cxl.c b/tools/testing/cxl/test/cxl.c
index cd2f20f2707f..7e4a0b1ee436 100644
--- a/tools/testing/cxl/test/cxl.c
+++ b/tools/testing/cxl/test/cxl.c
@@ -558,7 +558,7 @@ static __init int cxl_test_init(void)
 
 	for (i = 0; i < ARRAY_SIZE(cxl_root_port); i++) {
 		struct platform_device *bridge =
-			cxl_host_bridge[i / NR_CXL_ROOT_PORTS];
+			cxl_host_bridge[i % ARRAY_SIZE(cxl_host_bridge)];
 		struct platform_device *pdev;
 
 		pdev = platform_device_alloc("cxl_root_port", i);

