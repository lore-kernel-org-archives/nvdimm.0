Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8B301843;
	Thu, 28 Apr 2022 23:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651188171; x=1682724171;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=DcotTOS3O4jMaBBScJ/bohnCX9XasUENz2+h4HwZJtg=;
  b=XSq7evaE50D4OX/1k/o0+BSR5GuVK7DZZBoEjXT4tstLSasqeSg735/c
   22E+b28cGTIGFJ11rT/c0y5Zxy6h6XJqPWQ8USGjoLnEIq71dT/iqMQPx
   c9ee54Z18U+u80YtlrITpcOi8I3asXefuqN+CLCNmjmJVvXS5H0SiIl68
   pxV7kK4sXvZgSX1n6a8aUERAo3ZU4Wd9vr+0r3FIuYwPABN39uTWck1UG
   YORuaZqcyyEq/L7/GjSI0PgUyebP1I5h2yeIbWFPAYaTuxpkO7J6lMYx+
   el1i1A4+wd5jKTwWIihuOgNUn7rkhN/QcTHGLO0gLeJG2Z1oMb7QsHv+y
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10331"; a="265984158"
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="265984158"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:22:50 -0700
X-IronPort-AV: E=Sophos;i="5.91,296,1647327600"; 
   d="scan'208";a="581706235"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Apr 2022 16:22:50 -0700
Subject: [PATCH] nvdimm: Allow overwrite in the presence of disabled dimms
From: Dan Williams <dan.j.williams@intel.com>
To: nvdimm@lists.linux.dev
Cc: Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jeff Moyer <jmoyer@redhat.com>,
 Krzysztof Kensicki <krzysztof.kensicki@intel.com>, patches@lists.linux.dev
Date: Thu, 28 Apr 2022 16:22:50 -0700
Message-ID: <165118817010.1772793.5101398830527716084.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

It is not clear why the original implementation of overwrite support
required the dimm driver to be active before overwrite could proceed. In
fact that can lead to cases where the kernel retains an invalid cached
copy of the labels from before the overwrite. Unfortunately the kernel
has not only allowed that case, but enforced it.

Going forward, allow for overwrite to happen while the label area is
offline, and follow-on with updates to 'ndctl sanitize-dimm --overwrite'
to trigger the label area invalidation by default.

Cc: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jeff Moyer <jmoyer@redhat.com>
Reported-by: Krzysztof Kensicki <krzysztof.kensicki@intel.com>
Fixes: 7d988097c546 ("acpi/nfit, libnvdimm/security: Add security DSM overwrite support")
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/nvdimm/security.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/nvdimm/security.c b/drivers/nvdimm/security.c
index 4b80150e4afa..b5aa55c61461 100644
--- a/drivers/nvdimm/security.c
+++ b/drivers/nvdimm/security.c
@@ -379,11 +379,6 @@ static int security_overwrite(struct nvdimm *nvdimm, unsigned int keyid)
 			|| !nvdimm->sec.flags)
 		return -EOPNOTSUPP;
 
-	if (dev->driver == NULL) {
-		dev_dbg(dev, "Unable to overwrite while DIMM active.\n");
-		return -EINVAL;
-	}
-
 	rc = check_security_state(nvdimm);
 	if (rc)
 		return rc;

