Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD185748A
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886444; x=1707422444;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=KaRzxRlvB9BcP0nu0QZVD/lvIYofxBcR+epWn7ufvY0=;
  b=fMh6BWG7nL2Qy5JUV5MPBrvXEkhtyIN76RGnasCHQHjXpyJVCQ8VXRSH
   T6fy9ozEQJvTgEZTRB2jo8yOnx4o5jtaZCu76bC47IjzpiEPioxRvRLrK
   Y05XWTZ5/mgKMvXJ7/urLF1QJKmcm/JaAZ2VTQQXeMk55rcF+bYUe63DR
   rQBmtejMZEWOc+pKl03Xi/NcuEhXSB6AAjdPDTSCnlRSUfSW9OMixqYrF
   /+qaGrUuoZ5k1IqEzmRLY9rLN3wYfEM0/8QqxXYmrtnodwvCBm71PKw/I
   OISroReecKt8Tx0RjQ207gzvXQC22sTn9v6+dnHIT2bu8iFxirIHvtRZ5
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935453"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935453"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:42 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174665"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174665"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:42 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 08 Feb 2023 13:00:29 -0700
Subject: [PATCH ndctl v2 1/7] cxl/region: skip region_actions for region
 creation
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v2-1-4ea6253000e5@intel.com>
References: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v2-0-4ea6253000e5@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev, 
 Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=1701;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=KaRzxRlvB9BcP0nu0QZVD/lvIYofxBcR+epWn7ufvY0=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2cuedrLONf39nU/2YL5sonFfCbeCpF3/KT3at06p
 Sn4NSS4o5SFQYyLQVZMkeXvno+Mx+S25/MEJjjCzGFlAhnCwMUpABMpFGL4pyWlv2i3kMLrrD7P
 4pjEiafu7Uk2v2F2ePscu7n97/nmTmdk+Pdd2UVPRk3J+5nENMcDOZM8dx5s6vDg/mmUZjhz1pN
 vHAA=
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

Commit 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
removed the early return for create-region, and this caused a
create-region operation to unnecessarily loop through buses and root
decoders only to EINVAL out because ACTION_CREATE is handled outside of
the other actions. This results in confusing messages such as:

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
back to returning early for create-region.

Fixes: 3d6cd829ec08 ("cxl/region: Use cxl_filter_walk() to gather create-region targets")
Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
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

