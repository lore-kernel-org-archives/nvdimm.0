Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1533F620
	for <nvdimm@lists.linux.dev>; Wed, 27 Sep 2023 00:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695774270; x=1727310270;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=6Q+yyCEe0DKcBWb6PF0uUikdZ9NOToB+Dd79jqNqRUM=;
  b=akCKKg8yLmAQYlqQ4r3UxTyeE9x0NvpNCfVuPX0aN/5qrOp4gWqDTyD6
   Ptr/nYaY4ztKCF5MgebQqkTm8HKdMKrOYGyQ43RvegK/PtsdLqQhRsD7z
   zmHE+ceWa09u4jOz84HuRhFMmliT8U9FzSWV4kzUbZxYV4GpKhk9Nc9R+
   r3sOxA/R5+s6aVIXhPxK63xs19DxF34Iy3Qx2PokW3KKcy9OCRetD2d/E
   S2MkjsEcJVxGV5g1BO9ks1P9Bm5xohi3cn57SDRyVCDIwW6dRHfD3lRJI
   DF04gX8B57DJjRcwhi7pDBV47eyZeB/hNtLioY1/FkVHhk1hECfx4njMW
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="385551287"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="385551287"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 17:24:27 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10845"; a="819218190"
X-IronPort-AV: E=Sophos;i="6.03,179,1694761200"; 
   d="scan'208";a="819218190"
Received: from iweiny-mobl.amr.corp.intel.com (HELO localhost) ([10.212.44.218])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Sep 2023 17:24:27 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Tue, 26 Sep 2023 17:24:25 -0700
Subject: [PATCH ndctl] ndctl/cxl/region: Report max size for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230926-max-size-create-region-v1-1-d3555e91087c@intel.com>
X-B4-Tracking: v=1; b=H4sIADh2E2UC/x3NQQqDQAyF4atI1g3oDLa0VyldZGJGs3BakiJS8
 e4dXf4PPt4GLqbi8Gg2MFnU9V1qdJcGeKIyCupQG0IbYnsPV5xpRdefIJvQV9BkrAS73N9yjon
 7yFBxIhdMRoWng8+k5Zg/JlnX8+/52vc/LNjIMX8AAAA=
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-c6835
X-Developer-Signature: v=1; a=ed25519-sha256; t=1695774266; l=1072;
 i=ira.weiny@intel.com; s=20221211; h=from:subject:message-id;
 bh=6Q+yyCEe0DKcBWb6PF0uUikdZ9NOToB+Dd79jqNqRUM=;
 b=JfGB5H1JVqbYY4ca7m4+v+g8t0G7wq36mNtMGhkxnr9F1jkETw0Cb3/Bl2UQq+p/TS08Bw0ru
 d4v3GnEeSy4CjG5NeNNBW2faZoyVSiUdFWn7oPe9Sb5MJQDCbejNEd1
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=noldbkG+Wp1qXRrrkfY1QJpDf7QsOEthbOT7vm0PqsE=

When creating a region if the size exceeds the max an error is printed.
However, the max available space is not reported which makes it harder
to determine what is wrong.

Add the max size available to the output error.

Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 cxl/region.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/cxl/region.c b/cxl/region.c
index bcd703956207..cb6a547990fb 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -623,8 +623,8 @@ static int create_region(struct cxl_ctx *ctx, int *count,
 	}
 	if (!default_size && size > max_extent) {
 		log_err(&rl,
-			"%s: region size %#lx exceeds max available space\n",
-			cxl_decoder_get_devname(p->root_decoder), size);
+			"%s: region size %#lx exceeds max available space (%#lx)\n",
+			cxl_decoder_get_devname(p->root_decoder), size, max_extent);
 		return -ENOSPC;
 	}
 

---
base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
change-id: 20230926-max-size-create-region-1f57ff3bc53c

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

