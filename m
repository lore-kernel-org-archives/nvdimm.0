Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5432716FF45
	for <nvdimm@lists.linux.dev>; Thu, 29 Feb 2024 21:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709242124; cv=none; b=dsN6IydEZq4DJrgEIyp43vdA2K+zFb5cg6KFj52Sx7TM7B8Q9A8ayG8pmEo8HAi17NcX/T8OrIxB0cSyzOk1JorBlIQLdFFHSErwXDag1OclabnBBDQZzRw3S8IquvvNlJcipViXS+N3aEJ2z9tzJLZCu/mf1EeoW1yqVDDyOEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709242124; c=relaxed/simple;
	bh=5FdqLWBpCA7zLkCQhq87cYmm4IIyGem84G5wya1sdac=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=KSHUXgQPdYvmGy3huFy2LugBN9izCSDK0QKsSZS1bi8gMlCP9IvdQsf0h+iJHO/n58pmL64GDh3CvQUI8lprj2UoqbC8u0mtnEtsX7Pi0mKtjIVlRaMp0J9Z/CrmXPUZb0utqZ7I2O7C9Wu31sycd9uDIw//rOWmnTsTst42hko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EQ5SLWYD; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EQ5SLWYD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709242123; x=1740778123;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5FdqLWBpCA7zLkCQhq87cYmm4IIyGem84G5wya1sdac=;
  b=EQ5SLWYDUDBUg2M55UHB+pwuYknmZ5L5WYSxd7aTqV6pFk1FTjgzLcZ5
   jgYD34Sk9HK/ASql8gCC5CZqfFi6pgpWYIqYFVDqfRlKLRtklajuu7K7o
   G3OpcmvgjlCRkpzBx2T0+k4J7SoPAqO8WsmFSs2AVToSN3tnR3wTpPixW
   BqlO/yMQYNH0v2/UMdMCK95SaVMDAUrFqfL+UhzZiH2a6lrw5j5TT3gCs
   vzGdm/e+PoWPo772PUvYKVdJT9+qAOFZflbl6KAd1lPLGb7IaXjBB0Nj2
   p8p4LicrwVDp+FHKNMjOWDUIpz9uZQ2U6j4/haTrNNAtCsqePodyq/TnF
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10999"; a="3866983"
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="3866983"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 13:28:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,194,1705392000"; 
   d="scan'208";a="7899662"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.136.104])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Feb 2024 13:28:41 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/documentation: tidy up cxl-wait-sanitize man page format
Date: Thu, 29 Feb 2024 13:28:38 -0800
Message-Id: <20240229212838.2006205-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Remove extra '==' to address these asciidoctor complaints:

Generating Documentation/cxl/cxl-wait-sanitize with a custom command
ERROR: cxl-wait-sanitize.txt: line 1: non-conforming manpage title
ERROR: cxl-wait-sanitize.txt: line 3: name section expected
WARNING: cxl-wait-sanitize.txt: line 4: unterminated example block
WARNING: cxl-wait-sanitize.txt: line 26: unterminated listing block

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 Documentation/cxl/cxl-wait-sanitize.txt | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-wait-sanitize.txt b/Documentation/cxl/cxl-wait-sanitize.txt
index 9047b74f0716..e8f2044e4882 100644
--- a/Documentation/cxl/cxl-wait-sanitize.txt
+++ b/Documentation/cxl/cxl-wait-sanitize.txt
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 cxl-wait-sanitize(1)
-======================
+====================
 
 NAME
 ----

base-commit: 4d767c0c9b91d254e8ff0d7f0d3be04a498ad9f0
-- 
2.37.3

