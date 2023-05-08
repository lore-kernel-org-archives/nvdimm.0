Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 414B7125A7
	for <nvdimm@lists.linux.dev>; Mon,  8 May 2023 19:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683575183; x=1715111183;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=q7CiS3drrcB7MnrBA3PEdX8kN3+1pgcR4Zx7jUmtnsk=;
  b=iMkreiDZlbY7YRrONr2EqTJ5WuWsDDPn0cM09P6N184/qsL1Wap3gOxP
   ePmessbATgx2tU3AkSkDv13YssbF5WV3fRNyJlh5fk2nVFxid8GNQmQPW
   2i3yrAf1VgnqxxcFqAWDC97fJSEH3LbwB7tascvbMpDKU4/6pJVyX51Fl
   eQ20opuPcEWiWaB3NilHfdSk3ZqnR0Z9JjLWgE0154mqDNQ84wvyq1Axc
   piTUkgNTEKtm3hKRsFP/pPhVzPLHXtU8/WLYN1ao5ld5UvjUGMXwtlH8p
   t87/aJxqk6S3xJS2dk5/qFf/Ha36BBXKlwWf8N9cBCrkF3MfuIj6Hj+qe
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="349775586"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="349775586"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 12:46:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10704"; a="698631459"
X-IronPort-AV: E=Sophos;i="5.99,259,1677571200"; 
   d="scan'208";a="698631459"
Received: from djiang5-mobl3.amr.corp.intel.com (HELO [192.168.1.177]) ([10.213.172.228])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 May 2023 12:46:22 -0700
Subject: [NDCTL PATCH] ndctl: Add key cleanup after overwrite operation
From: Dave Jiang <dave.jiang@intel.com>
To: nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Cc: Yi Zhang <yi.zhang@redhat.com>
Date: Mon, 08 May 2023 12:46:21 -0700
Message-ID: <168357518158.2750073.1393407560977941832.stgit@djiang5-mobl3>
User-Agent: StGit/1.5
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Yi reported [1] the key blob is not removed after an overwrite operation is
performed. Issue is discovered when running ndtest. Add the key blob
removal call to address the issue.

[1]: https://github.com/pmem/ndctl/issues/239

Fixes: 8e4193885357 ("ndctl: add an overwrite option to 'sanitize-dimm'")
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Dave Jiang <dave.jiang@intel.com>
---
 ndctl/keys.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/ndctl/keys.c b/ndctl/keys.c
index 2c1f474896c6..3fa076402cfc 100644
--- a/ndctl/keys.c
+++ b/ndctl/keys.c
@@ -658,7 +658,7 @@ int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
 	int rc;
 
 	key = check_dimm_key(dimm, false, ND_USER_KEY);
-	if (key < 0)
+	if (key < 0 && key != -ENOKEY)
 		return key;
 
 	rc = run_key_op(dimm, key, ndctl_dimm_overwrite,
@@ -666,5 +666,8 @@ int ndctl_dimm_overwrite_key(struct ndctl_dimm *dimm)
 	if (rc < 0)
 		return rc;
 
+	if (key >= 0)
+		discard_key(dimm, ND_USER_KEY);
+
 	return 0;
 }


