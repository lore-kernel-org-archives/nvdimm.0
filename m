Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5108714EC53
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 21:06:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712956003; cv=none; b=QwEnH4ZvmMXPTYkb304rF7quKOx3Lq3ho2/6gZGEyHexPcL4jzobE5W71gJ8nC7IXmOUrK0TFI5iPnLLxfC/fWn5cpKOeAmt1yc2R40w4OPwpUJk31KZR4VHGPjEgib3A9MuGX9XRDd7lp0CKsRWeaQV8Pcm3mPQTeLG7UhnoEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712956003; c=relaxed/simple;
	bh=4OoKlgOE9tKbs4ksjOdP6+J+Tu5xTpeSXjhKP83Imbc=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=ulfnid6Pl7EDQsy39ppn+Hi7iKNXdEhx6ggIiZBUo9Jm71wUP3zPoMq4C/CCD8YmI4N+E1YnkcOth2iXg8szyo4Rw3zwtPQ8LMC9ZCkT4YfoDeLYYF58FdXEF/R/STHxIsjnyFfXir9s/lE1NcSxPL4po3WatIKW0p6QK2eoesE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XctKZmpI; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XctKZmpI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712956002; x=1744492002;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=4OoKlgOE9tKbs4ksjOdP6+J+Tu5xTpeSXjhKP83Imbc=;
  b=XctKZmpIfKI3qc5ymnsUo2eRFafd2LUZIei4OLgiVXa031OrOZPFUy77
   lf0Z8Wyp0NpYHi0DUhuedBHlhsMoCWJuw9LOyyi8QiOUHo8ZC5eqC9b+A
   toiJwHuUSLiAZAOyzFIlVxWHo6KH9xESGQ1Hb+BwGB3NV8sgrpJF3mj81
   J/mxv3Bv/+pWG2Ip/8Zl06cRs/VmHiPyDOtczz9yRZbOyn932rv4EGJj9
   XRGG9ZN/Yqanv6IzBUjWuBLjdCp4Co5YeSP2ip8OY6+8MQYH797ZkmlYA
   MnnZ3c3p1uFYuECFsFbN/G/zeFZawTPgZtDL+HnSOBCFyNSJFnMWTH8jc
   w==;
X-CSE-ConnectionGUID: 6igAPRYpSpuGRC/sxCWfWw==
X-CSE-MsgGUID: m2aupxKeTjWCpA4wNj0I5g==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12211948"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="12211948"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:06:14 -0700
X-CSE-ConnectionGUID: o94hUSh4QzipNCfvniNrqg==
X-CSE-MsgGUID: CASqLeUMSjKK+jZgOYGBdQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21909763"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.183.147])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:06:12 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Fri, 12 Apr 2024 15:05:39 -0600
Subject: [PATCH ndctl 1/2] daxctl/device.c: Handle special case of
 destroying daxX.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240412-vv-daxctl-fixes-v1-1-6e808174e24f@intel.com>
References: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
In-Reply-To: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=1450;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=4OoKlgOE9tKbs4ksjOdP6+J+Tu5xTpeSXjhKP83Imbc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGmSi5yuHmfh9NGL/PJCYvozg5c9xrpXLgZx3PRvamOtb
 gvNCRPtKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwEQUYxn+2XnHGNwP5pI708D7
 ltHc6uL1Aytqm2XdMtoY5paun8JuxcjQ2Ru/b7eFMOthZvHU9TnTn4esqlotuVCu+szVG+ZdH+R
 4AQ==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The kernel has special handling for destroying the 0th dax device under
any given DAX region (daxX.0). It ensures the size is set to 0, but
doesn't actually remove the device, instead it returns an EBUSY,
indicating that this device cannot be removed.

Add an expectation in daxctl's dev_destroy() helper to handle this case
instead of returning the error - as far as the user is concerned, the
size has been set to zero, and the destroy operation has been completed,
even if the kernel indicated an EBUSY.

Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Reported-by: Ira Weiny <ira.weiny@intel.com>
Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 daxctl/device.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/daxctl/device.c b/daxctl/device.c
index 83913430..83c61389 100644
--- a/daxctl/device.c
+++ b/daxctl/device.c
@@ -675,6 +675,13 @@ static int dev_destroy(struct daxctl_dev *dev)
 		return rc;
 
 	rc = daxctl_region_destroy_dev(daxctl_dev_get_region(dev), dev);
+	/*
+	 * The kernel treats daxX.0 specially. It can't be deleted to ensure
+	 * there is always a /sys/bus/dax/ present. If this happens, an
+	 * EBUSY is returned. Expect it and don't treat it as an error.
+	 */
+	if (daxctl_dev_get_id(dev) == 0 && rc == -EBUSY)
+		return 0;
 	if (rc < 0)
 		return rc;
 

-- 
2.44.0

