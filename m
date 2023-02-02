Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087FC3201
	for <nvdimm@lists.linux.dev>; Thu,  2 Feb 2023 20:56:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675371409; x=1706907409;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZFUwU3TZtHxOAeWJmjwXZ5BEGZIVE58r8GafhRWlncM=;
  b=lymEUaqEkY1hR+W3A8H0nXWbYJg+luaaI1Gb3hFvcdez9Bxr24BU/IAd
   rgPC/nYtkkapL7rhlPYEVbZ8fhWdPgEYl/SD8I7KoFJWRRPGoY3DV1K9N
   y3p1qSc2qOqYw/qYwtLLEdpErBHNs1ZcW4JpnLAvhbN4JvSgLZppXGoAZ
   9Zs8OJ2UWbOM+MJl0aCyhcpnSIEkgCcrHMC42dvec+DiUgVvxBBivRlnL
   PUlNogT/Ecd8kCmJhB7P1Z+JIOBZXBTPfneN54D6iOaBJ9ZKRr1+PMXjU
   EncGe3+xKA1xHv5MCLcYDIlFd2GXMsRCaUI3s3AAUNO2fBXgSsAd+gP44
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="328586546"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="328586546"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 12:56:48 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10609"; a="754204483"
X-IronPort-AV: E=Sophos;i="5.97,268,1669104000"; 
   d="scan'208";a="754204483"
Received: from rcoolman-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.163.245])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Feb 2023 12:56:48 -0800
Subject: [PATCH] daxctl: Fix memblock enumeration off-by-one
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Thu, 02 Feb 2023 12:56:47 -0800
Message-ID: <167537140762.3268840.2926966718345830138.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

A memblock is an inclusive memory range. Bound the search by the last
address in the memory block.

Found by wondering why an offline 32-block (at 128MB == 4GB) range was
reported as 33 blocks with one online.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 daxctl/lib/libdaxctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index 5703992f5b88..d990479d8585 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -1477,7 +1477,7 @@ static int memblock_in_dev(struct daxctl_memory *mem, const char *memblock)
 		err(ctx, "%s: Unable to determine resource\n", devname);
 		return -EACCES;
 	}
-	dev_end = dev_start + daxctl_dev_get_size(dev);
+	dev_end = dev_start + daxctl_dev_get_size(dev) - 1;
 
 	memblock_size = daxctl_memory_get_block_size(mem);
 	if (!memblock_size) {

