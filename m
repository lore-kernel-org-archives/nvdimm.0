Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DC214F122
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 21:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712956011; cv=none; b=X/+P3NEjAFJve2MsPKgh44SxxlbuOOsZvE5+dOg38FzlK+6rpscAOW43KP3IEMxAK8qJp2D/g9jyUJ8t5ys0cAOOQ7d2nlGWOr/lgatywLKE2CZ/8fQJnaoZ/lCe8qiCTE+bONEE+pMRZhnD13cbWjcSOizPDwkC/Gnj4+CZeEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712956011; c=relaxed/simple;
	bh=CSEdPdPYTjr5gHfBvjI2/VJYMO4SMTS2WFurQWRnuug=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=sXU2TL0ricq0p8qgCf+MO0vyelhcSHLR4fpgaUNSrgRxCBw1NcXHQ7rClU0EY/kuuyIgcw+gp8IyXasQX7zuq2IVqDh68LKWBKRkwVPxd2ggFLyFg9LVvnY3UN5AKwkh/sYxn4yQ0M123p5RcSJgXthMEV3xSheMK0BTg3wcpvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=TznaPaEg; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="TznaPaEg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712956009; x=1744492009;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=CSEdPdPYTjr5gHfBvjI2/VJYMO4SMTS2WFurQWRnuug=;
  b=TznaPaEgB6gcD9YdSgrNzjNkQKGJ3ea4x8aDZKl4UXxbDx7yvIuXvYIo
   gufUbZLnXtiN3ZHWxw7tdWNuVmhll6XlxtlsX81WSD3l1yqOYKZ/hD38r
   A8BB/NBHj8+sXs+Cmq2D5qhBbYZXyT/Ts87vu/xC8Y7J83wLAxtOVl+pE
   H27qwKN6DoAySj3YpJha641hIOWMUPs8tXd40Nx33C3XedRijg9l9SWGo
   ZGlwxmfZsiM+Y0XtOTAaip+ZBUfTzJjHdGikOxMZdiOPmJGJ3Nsv8gvQZ
   84h86JlZU03KfQZP6QUPVlWsCxN+uSm4OSlns/5bk04P7+F4iOC+Ny015
   g==;
X-CSE-ConnectionGUID: K22F1k+wSF6hqc6LQ1O6WA==
X-CSE-MsgGUID: 2u/d65tzTuSgIE8hPenD+g==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12211952"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="12211952"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:06:21 -0700
X-CSE-ConnectionGUID: +7qdXTwXRMOYzGYPZOPyEA==
X-CSE-MsgGUID: ZtLyK7EISFG2CfvLsqMyjA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21909770"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.183.147])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:06:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 12 Apr 2024 15:05:40 -0600
Subject: [PATCH ndctl 2/2] daxctl/device.c: Fix error propagation in
 do_xaction_device()
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240412-vv-daxctl-fixes-v1-2-6e808174e24f@intel.com>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
In-Reply-To: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=1972;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=CSEdPdPYTjr5gHfBvjI2/VJYMO4SMTS2WFurQWRnuug=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGmSi5zmtUwysZc/7huavtrHtX/bgdnP1jzUdY6qfTB/1
 0uP9B9LO0pZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRrgCGf2btKvvX+H07tEB5
 Y97M8ASBWRcMDl8+8V9xk4NM7nQLQSaG/5FOHAc+hH5mrb1Vczr9Zuj0k+xPcmv/pH3Z6lY64Vm
 tByMA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The loop through the provided list of devices in do_xaction_device()
returns the status based on whatever the last device did. Since the
order of processing devices, especially in cases like the 'all' keyword,
can be effectively random, this can lead to the same command, and same
effects, exiting with a different error code based on device ordering.

This was noticed with flakiness in the daxctl-create.sh unit test. Its
'destroy-device all' command would either pass or fail based on the
order it tried to destroy devices in. (Recall that until now, destroying
a daxX.0 device would result in a failure).

Make this slightly more consistent by saving a failed status in
do_xaction_device if any iteration of the loop produces a failure.
Return this saved status instead of returning the status of the last
device processed.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/device.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/daxctl/device.c b/daxctl/device.c
index 83c61389..14d62148 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -1012,7 +1012,7 @@ static int do_xaction_device(const char *device, enum device_action action,
 	struct json_object *jdevs = NULL;
 	struct daxctl_region *region;
 	struct daxctl_dev *dev;
-	int rc = -ENXIO;
+	int rc = -ENXIO, saved_rc = 0;
 
 	*processed = 0;
 
@@ -1059,6 +1059,8 @@ static int do_xaction_device(const char *device, enum device_action action,
 				rc = -EINVAL;
 				break;
 			}
+			if (rc)
+				saved_rc = rc;
 		}
 	}
 
@@ -1070,7 +1072,7 @@ static int do_xaction_device(const char *device, enum device_action action,
 	if (jdevs)
 		util_display_json_array(stdout, jdevs, flags);
 
-	return rc;
+	return saved_rc;
 }
 
 int cmd_create_device(int argc, const char **argv, struct daxctl_ctx *ctx)

-- 
2.44.0

