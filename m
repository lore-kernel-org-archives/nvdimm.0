Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2002C9C
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 00:18:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641341911; x=1672877911;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=floHASOYdpfcLvJAjGooz1XwbnJEgPMj7c5hxh7mhwA=;
  b=UozcGYt1drargOsrXywNv9pG7Kow8NG9oFhne88eZqY9RaglJtPXn3xO
   GMjjLyAROlOuXr5yKaxbpG5imdiIOWzpXtfGlzC4tcifv/ff0mrMY1lqc
   mB5iEp87ChdYOBBLq6+PkkqNnBxCOYSfnPpbC3Bq+ww6O8R41t+taki1f
   CGo1LDPPCFw7M+PWWsBewKg2S+kuROAom48EBztVW6HDuIbbRfx7eKjZv
   zwpPTwsjNPIBz1WfKtYd9vnbGisfvcCr/lBRk84+wsthg7ZUIgzpfbV0I
   9gX3Ge3MheM5mDtH8iYFYzsb67qm3fNNwwtuX0Aik9/0H7BHw1RQrsXM0
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="266607507"
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="266607507"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:18:30 -0800
X-IronPort-AV: E=Sophos;i="5.88,262,1635231600"; 
   d="scan'208";a="760617690"
Received: from acramesh-mobl.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.251.136.16])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jan 2022 16:18:30 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl: add repology graphic to README.md
Date: Tue,  4 Jan 2022 17:18:23 -0700
Message-Id: <20220105001823.299797-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.33.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=708; h=from:subject; bh=floHASOYdpfcLvJAjGooz1XwbnJEgPMj7c5hxh7mhwA=; b=owGbwMvMwCXGf25diOft7jLG02pJDIlXHh9tlmHfeqe+6xW/AvPr2A17tyc88XdrVl8f4D6j9bRf R9+kjlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAExk3idGhutqJk8+mjAHvX3EVbT7Q9 stJ6Wrynt2Ml1gfKiwnE1lrjTDH17OIzpHk+7arJO68Irl5Nam5i8KO8+s+nHt0sKp5kv6BTgA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Add a graphic/badge from repology showing the packaging status of ndctl
with various distros.

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 README.md | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/README.md b/README.md
index 89dfc87..4ab4523 100644
--- a/README.md
+++ b/README.md
@@ -4,6 +4,9 @@
 Utility library for managing the libnvdimm (non-volatile memory device)
 sub-system in the Linux kernel
   
+<a href="https://repology.org/project/ndctl/versions">
+    <img src="https://repology.org/badge/vertical-allrepos/ndctl.svg" alt="Packaging status" align="right">
+</a>
 
 Build
 =====

base-commit: 57be068ef6aaf94c4d9ff0c06bd41a004e4ecf2c
-- 
2.33.1

