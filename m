Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6C77485
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797414; x=1707333414;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=XiqSgrEeiTGZTsz88Eua46t0Quv54okbY2837bnGN40=;
  b=GSWVYTSH+olzhdQhjR/hyLxyDkd35ARb7u3WuN57Vk03bT5TNBb34fhL
   ARTWsZdpWnNHLEGL3ynCmhbuCZKTjJMwV7Tk8U5lIuAno/qWehQUdrlbd
   AR8mW+kkU3xv/0lLLQ0utLpYN8OSGEfQ202tlSyWSRLWEOLNVgLYy7nPs
   8ztdTV5KdlfjW+dKcfX1fwgoL/XogspZwPZHTBuBeD2WpblJ5aN431cOr
   xzwwfmo/S4AHeiSkCmLv07bg0CGhg0qxFigLGoZphpPh2z41z7zFhIyou
   OzhC+UqBPSXEq587B8zFO7WYRbte12nOi0VNY43hjTuuwOefbBQ4oV46h
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331733979"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331733979"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:53 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649805"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649805"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:53 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Feb 2023 12:16:27 -0700
Subject: [PATCH ndctl 1/7] cxl/region: skip region_actions for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v1-1-b42b21ee8d0b@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=1601;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=XiqSgrEeiTGZTsz88Eua46t0Quv54okbY2837bnGN40=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi/2CVmykn2Tse2mVyInL8ZrORy8funVaduHW+fWv
 17g2/VOo6OUhUGMi0FWTJHl756PjMfktufzBCY4wsxhZQIZwsDFKQATiTvB8E+/m43Txpi1gP2Q
 8K/EP7ofrm275/dnvvPxH5O7Micq/TvJ8E83Rf+Jmamv7fL1ltWihYnHqgSfCfZ2r7aVbjVZ9LO
 /iQkA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Commit 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
removed the early return for create-region, and this caused a
create-region operation to unnecessarily loop through buses and root
decoders only to EINVAL out because ACTION_CREATE is handled outside of
the other actions. This results in confising messages such as:

  # cxl create-region -t ram -d 0.0 -m 0,4
  {
    "region":"region7",
    "resource":"0xf030000000",
    "size":"512.00 MiB (536.87 MB)",
    ...
  }
  cxl region: decoder_region_action: region0: failed: Invalid argument
  cxl region: region_action: one or more failures, last failure: Invalid argument
  cxl region: cmd_create_region: created 1 region

Since there's no need to walk through the topology after creating a
region, and especially not to perform an invalid 'action', switch
back to retuening early for create-region.

Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
Cc: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 cxl/region.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/region.c b/cxl/region.c
index efe05aa..38aa142 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -789,7 +789,7 @@ static int region_action(int argc, const char **argv, struct cxl_ctx *ctx,
 		return rc;
 
 	if (action == ACTION_CREATE)
-		rc = create_region(ctx, count, p);
+		return create_region(ctx, count, p);
 
 	cxl_bus_foreach(ctx, bus) {
 		struct cxl_decoder *decoder;

-- 
2.39.1

