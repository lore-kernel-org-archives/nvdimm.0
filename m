Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF926429E
	for <nvdimm@lists.linux.dev>; Thu,  3 Mar 2022 23:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646351918; x=1677887918;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=0lW4gvWPJsyvRtUphgHqpq31haxj97zHKuPmqOkz/To=;
  b=UT0PZHjTcOBSkGm3hGHxCxAO3NcDx+0AD8UDX1/Z/tADJB7P4V/IyKMy
   cHhfAi+alBeG4Gn09yVvQWO1jwnIlHiaKKbw0Q+/VGrpKXIR4xGL+/SgB
   LahePO3iBe1iwcdfBwQmR6ezQxO9qTL2b124D8I6Y+/lAibag8hbOzMKq
   x0n20Dj0h54NrwH0OpoTQtIA6wNgpIeOz35kS+rdK7rcWyPcmfHoUOgJs
   3m6EfkPEbwheCC0JuCQqyhl99qgpItL4Xwi8JUWpTtdKaetZVqHlKg6Ki
   +w0TAohtBczxb3TMblJ3qhQ7a6Tddy63SHH6IjNahTtp51KlM+a6BxcKR
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="254040020"
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="254040020"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 15:58:16 -0800
X-IronPort-AV: E=Sophos;i="5.90,153,1643702400"; 
   d="scan'208";a="508796424"
Received: from alison-desk.jf.intel.com (HELO localhost) ([10.54.74.41])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 15:58:16 -0800
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev
Subject: [ndctl PATCH] libdaxctl: free resource allocated with asprintf()
Date: Thu,  3 Mar 2022 16:01:33 -0800
Message-Id: <20220304000133.1053883-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Static analysis reported this resource leak.

Fixes: d07508a0cc3c ("libdaxctl: add daxctl_region_create_dev()")
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 daxctl/lib/libdaxctl.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/daxctl/lib/libdaxctl.c b/daxctl/lib/libdaxctl.c
index f173bbb7c514..5703992f5b88 100644
--- a/daxctl/lib/libdaxctl.c
+++ b/daxctl/lib/libdaxctl.c
@@ -624,10 +624,9 @@ DAXCTL_EXPORT int daxctl_region_create_dev(struct daxctl_region *region)
 	}
 
 	rc = sysfs_write_attr(ctx, path, num_devices);
-	if (rc)
-		return rc;
+	free(num_devices);
 
-	return 0;
+	return rc;
 }
 
 DAXCTL_EXPORT int daxctl_region_destroy_dev(struct daxctl_region *region,

base-commit: 3b5fb8b6428dfaab39bab58d67412427f514c1f4
-- 
2.31.1

