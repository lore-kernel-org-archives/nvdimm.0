Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A677E
	for <nvdimm@lists.linux.dev>; Fri, 11 Mar 2022 03:35:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646969720; x=1678505720;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jmNDiTDvf5Zgv6pKXlS3AQ/GF1OW6tlYhIy5xMQQxtY=;
  b=iiFJ0na00qCpSsWx/3ZXwo7E2LTILUz+OMnf8XBCnKDmA1NFFTFd9zW0
   eARUrEOz/Irv+BRvfn8n91Reode9byRVvX+fczxzXb/Rk7lYqMF0qZBEn
   nHg98j+eai9TDXQ82l+pQIHc6gQKrk+rqYoWdkBvB6QM5CXW+yLjQRYz/
   tPFdx1ENOtVbHLA2pXFBVkWfWFN5wz5RA2ByAB0JKDJPaCNX//JI9eWBb
   65xGO3I8w4SIgOjykVLm4jmulFfqV4PUIpLWi2m7pR0J6E4AEX1gEvw1Z
   incv3uVeWHKr2waubCDu+qneUA4P3ErF0szQ6Q3bNyhaMmH5v9RHCRTYq
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10282"; a="237664333"
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="237664333"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 19:35:19 -0800
X-IronPort-AV: E=Sophos;i="5.90,172,1643702400"; 
   d="scan'208";a="496621036"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2022 19:35:19 -0800
Subject: [ndctl PATCH] build: Fix test timeouts
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev
Date: Thu, 10 Mar 2022 19:35:19 -0800
Message-ID: <164696971934.3344888.14976446737826853353.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Older versions of meson, like the version that ships in CentOS Stream
interpret a timeout of 0 as immediately fail, rather than infinite test
run. Specify a 10 minute timeout by default instead.

Fixes: 4e5faa1726d2 ("build: Add meson build infrastructure")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/meson.build |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/test/meson.build b/test/meson.build
index 07a5bb6e7f62..7ccd45195236 100644
--- a/test/meson.build
+++ b/test/meson.build
@@ -227,7 +227,7 @@ foreach t : tests
       mmap,
     ],
     suite: t[2],
-    timeout : 0,
+    timeout : 600,
     env : [
       'NDCTL=@0@'.format(ndctl_tool.full_path()),
       'DAXCTL=@0@'.format(daxctl_tool.full_path()),

