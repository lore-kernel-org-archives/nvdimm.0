Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CDD6173
	for <nvdimm@lists.linux.dev>; Sat, 18 Dec 2021 04:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1639802888; x=1671338888;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=erPehnUg61eJ3t4cb6N6DVNVR/SPCETVOiIHdMY3SkM=;
  b=QN9Q9goI6XPqqgasAIrDifqVEz1VwhRsP3rJ4yDKDyhvml24+qjU8joL
   AjJwSbeC6AIHSGS2e4JdEqLaWWZxMvyp/x0Aips8/gwmmIb8q03ZBeY1h
   MHt9+Kr+blv8BAeDR+y5FU1Dp3WMip/ndaHkuSwrf06haq4e5nSIy7y+Q
   QLMStjAsLwjeSTVFpepSjmVzCmXUOg5PDE8eh7ZB0Hn59Ue84oKS4rF1M
   xuBHsw+6Zf/WMRuXQe26MS4AviC1ikbdO7SE4YWlm1aU4ousgeK9yTo/z
   LrT2yee5ZuF99/9EBWMx/C1JvkmjBpyb3ZWkizmOYvABFld1WXmbIP8mi
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10201"; a="226744619"
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="226744619"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 20:48:07 -0800
X-IronPort-AV: E=Sophos;i="5.88,215,1635231600"; 
   d="scan'208";a="520044506"
Received: from dalbrigh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.254.35.246])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Dec 2021 20:48:07 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: Add a dependency on 'iniparser' to ndctl.spec.in
Date: Fri, 17 Dec 2021 21:48:05 -0700
Message-Id: <20211218044805.443784-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=775; h=from:subject; bh=erPehnUg61eJ3t4cb6N6DVNVR/SPCETVOiIHdMY3SkM=; b=owGbwMvMwCXGf25diOft7jLG02pJDIl7M1jFRffO3yGpLezkVMBiW9XYu8bT10VfwdX/4Do177TX V9o7SlkYxLgYZMUUWf7u+ch4TG57Pk9ggiPMHFYmkCEMXJwCMBG7Uwz/dP3fr5/k2ZPKZMc+W1+bh7 te+fs+jdj1Ju32K5fV3GNuZfgrkly508LBPM273CyHy+6RYGe78YEMvkPtG8/zlx9eep4NAA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

The commit below neglected to add a dependency on iniparser in the spec
file for RPM builds. Fix that now.

Fixes: 4db79b968a06 ("ndctl, util: add parse-configs helper")
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 ndctl.spec.in | 1 +
 1 file changed, 1 insertion(+)

diff --git a/ndctl.spec.in b/ndctl.spec.in
index c753121..cb91119 100644
--- a/ndctl.spec.in
+++ b/ndctl.spec.in
@@ -28,6 +28,7 @@ BuildRequires:	pkgconfig(bash-completion)
 BuildRequires:	pkgconfig(systemd)
 BuildRequires:	keyutils-libs-devel
 BuildRequires:	systemd-rpm-macros
+BuildRequires:	iniparser-devel
 
 %description
 Utility library for managing the "libnvdimm" subsystem.  The "libnvdimm"

base-commit: 3d90ebfae265341cd398c963722f930d102864e8
-- 
2.33.1

