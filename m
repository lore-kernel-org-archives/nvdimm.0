Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB92F2D73B4
	for <nvdimm@lists.linux.dev>; Wed,  1 Oct 2025 19:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759346988; cv=none; b=cqoofAVd45Pa5dc+lHuOSCyOWut+xkoFJQJfTWp14JmVMlnbYL1SWlTFdD5SQWvAp8bB9HpjszE7SSlVNw/5ovk1/Wo2iX/TRIzplKHCjkXk8rB6OjdjDQ8BDO6CrMOtleZ8ZlwUr9YiLpsWW+HlfJsn6ZUeqJM2YxhuZ/hhD0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759346988; c=relaxed/simple;
	bh=MFBAg+spEz7WZxS6zSI67GoxtfRk929vabztcUofWp4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ntrHHe5pTpwCkJCg0rbD7jQ0AxhsUE8qcWmWd+NlPl5Ppvszzotni5VRL1o6sMJb8uHxO6T3zwigebFefIHMMEj6JlLHHzHi88x1poagPv09DmAgqDV938Ts8jYcBlELHYv9co+2gX0Z0CmX0ZC/Ttf9LozxSXp5Jf9Eeci5kRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=B5dtrKTJ; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="B5dtrKTJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1759346986; x=1790882986;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MFBAg+spEz7WZxS6zSI67GoxtfRk929vabztcUofWp4=;
  b=B5dtrKTJbuaIhwsGFrxBhfcQC2r3z73DceG+Kd+m1Cf2GsqXQRB0tbfh
   qRFZprmocmxkAIen2Baq0DbQ4UKiYoubcjDyEQQFz5EQo6WSk+3c3ekPW
   jwdft2u1sdhGVYRJ8uQMk62k1zXJWKtB2+qzx5sxn/CJqeGRUk8mQYZ6Y
   Thj0Et3fYyRGLAghRNBiQtGvKzuKL/2sGW+DQZeYI4ifvYQBZXwYjMAp0
   CA4aFk45r3JDEgszjuRLAypqjYZR74zwEyKxKoOaBllSSQgzzHxA3h/2g
   sfO9fLNvxdQBkVbUHNVxweAYqxoeAiFRM7iuduKcb1ZPe1Sb8M+oA3Wvj
   g==;
X-CSE-ConnectionGUID: AsndHXLnQGqdwvxCBOj2jA==
X-CSE-MsgGUID: HHTDAP2mRWyyCd3DufKGzA==
X-IronPort-AV: E=McAfee;i="6800,10657,11569"; a="60669475"
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208,217";a="60669475"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:29:43 -0700
X-CSE-ConnectionGUID: 3Du7qS/kSe+s4S2BVDiBAQ==
X-CSE-MsgGUID: 66k76zIMS2CsMhuePSolQQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,307,1751266800"; 
   d="scan'208,217";a="179283535"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.124.222.189])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Oct 2025 12:29:43 -0700
From: Alison Schofield <alison.schofield@intel.com>
To: nvdimm@lists.linux.dev,
	Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>
Subject: [ndctl PATCH] README.md: exclude unsupported distros from Repology badge
Date: Wed,  1 Oct 2025 12:29:37 -0700
Message-ID: <20251001192940.406889-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.47.0
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The repology.org badge includes thirty-seven repos that are obsolete
or no longer maintained. Switch to the exclude_unsupported variant to
make the packaging status more relevant and easier to read.

The full list remains available on the Repology project page[1] for
those interested in historical packaging data.

[1] https://repology.org/project/ndctl/versions

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 README.md | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/README.md b/README.md
index 1943fd66d432..a71db28f62fb 100644
--- a/README.md
+++ b/README.md
@@ -4,7 +4,7 @@ Utility library for managing the libnvdimm (non-volatile memory device)
 sub-system in the Linux kernel
   
 <a href="https://repology.org/project/ndctl/versions">
-    <img src="https://repology.org/badge/vertical-allrepos/ndctl.svg" alt="Packaging status" align="right">
+  <img src="https://repology.org/badge/vertical-allrepos/ndctl.svg?exclude_unsupported=1" alt="Packaging status (exclude unsupported)" align="right">
 </a>
 
 Build
-- 
2.37.3

