Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8F5C14F112
	for <nvdimm@lists.linux.dev>; Fri, 12 Apr 2024 21:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712956011; cv=none; b=dK00VNqeGx9mzEC5vJ4nf4Xcu1pDu4pknimMR/hBpFeW9UIcFDkk1N2qzcWpYGHn61eaIegVvr1sL94iXY2bTCB9s0iI0b2I11H4injafEuvn0NKZN1Mldtzypk0z2Mj0V6yQzrXW/wAbjVNN9IAfmnXYgsIP2YRpnGKZngjv4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712956011; c=relaxed/simple;
	bh=3wmzTz80iPfAdbP1tup4gKyym87sHH/5hJcijbZnB+M=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=Wljvn5IOJSIHjgkCXbPNUchfejXO+4uM1OJXtmg2+16q6GUtTo/XqBgjjlUgHgURVKcR/Mqjx7muppLe0cnlcYyIaMN+x4Av4nTwL51bX1TUyuw0Po9xozhKg+TnFj2K1lBtLcORTtU5L1FINVdD51F33RPzUcX3BMs8APPIK64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=XlnKZ7u8; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="XlnKZ7u8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1712956009; x=1744492009;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=3wmzTz80iPfAdbP1tup4gKyym87sHH/5hJcijbZnB+M=;
  b=XlnKZ7u8tGy09SOAxU+IKbR34gUiRjuYD0o1jHqPGjH98e0gx7vU1+lD
   m2Eyh/WWjtqPNML5an2NVqbN59Zt9eLtIrR+mZ6ylse2mWNwgkTdBM+xL
   jQAQSep0rPwNItIDMOAsJCy7D3NCUfLj3urxOlIIRkUNR5ufCu32f9Yhq
   JFYLtqANkA6DTHwNF/acKw73gpLRxyJQEEZ7omM5twBsaKscV0h7NlVmW
   te5lrbipot3a/9WflwWfO7NQYkNHtJw/WRgouQm92uwcMWyw9+cH+j5Nj
   ZC+aMZ6wtYENy+ydaRB0gQK4HpmspZ0fMk3D5hxhz+Mg1SmA+0nlbQQM+
   A==;
X-CSE-ConnectionGUID: oUcz6qsZR7mcNlAmfgspCg==
X-CSE-MsgGUID: As5u1vCeSZ+RARMJnhShzg==
X-IronPort-AV: E=McAfee;i="6600,9927,11042"; a="12211946"
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="12211946"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:06:14 -0700
X-CSE-ConnectionGUID: X65lhZ78QU2NM/TR7rylsg==
X-CSE-MsgGUID: xd6R/6ttTCiHFSbx+kq0lA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,197,1708416000"; 
   d="scan'208";a="21909760"
Received: from vverma7-desk1.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.183.147])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2024 14:06:11 -0700
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH ndctl 0/2] daxctl: Fix error handling and propagation in
 daxctl/device.c
Date: Fri, 12 Apr 2024 15:05:38 -0600
Message-Id: <20240412-vv-daxctl-fixes-v1-0-6e808174e24f@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIACKiGWYC/x3LQQqAIBBA0avErBuwQQi7SrQwnWogLDQkEO+et
 Hx8foHEUTjB1BWInCXJFRqGvgN32LAzim8GUqSVHghzRm9f95y4ycsJVz8aQ2yJjId23ZH/0KZ
 5qfUDCcRsd2EAAAA=
To: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
X-Mailer: b4 0.14-dev-5ce50
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=3wmzTz80iPfAdbP1tup4gKyym87sHH/5hJcijbZnB+M=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDGmSi8zDLoSsZTvhv0jgoRD3+n99b/42zbT1dvc+2lho+
 nO2lLFqRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACYiYcHwP6t7waSQVUXcqeXp
 HOLv5BKaL0sG/f5R9nJD+w/lmIkLhBkZTnX8j3/v57at4FzH9R1rtvfFn01/a9Koe2vhDO/kE0u
 /cQAA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

An intermittently failing daxctl-create.sh test revealed two things:
1/ The kernel handles the 0th DAX device under a region specially, and
refuses to delete it, returning an EBUSY. The daxctl-destroy-device
failed to account for this, even if other aspects of the destroy
operation succeeded (i.e. setting the size to zero). Patch 1 fixes this
by expecting the EBUSY on the 0th device, and not failing for it.

2/ When looping over multiple DAX devices, do_xaction_device() just
returned the status from the action on the last device. Since this order
can be effectively random, so would be the status returned. Patch 2
makes this behavior more consistent by saving any non-zero status from
the device iterations, and returning that instead of the last action's
status.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (2):
      daxctl/device.c: Handle special case of destroying daxX.0
      daxctl/device.c: Fix error propagation in do_xaction_device()

 daxctl/device.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)
---
base-commit: e0d0680bd3e554bd5f211e989480c5a13a023b2d
change-id: 20240412-vv-daxctl-fixes-bd7992ea229d

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

