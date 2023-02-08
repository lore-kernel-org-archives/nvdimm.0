Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1906749F
	for <nvdimm@lists.linux.dev>; Wed,  8 Feb 2023 20:00:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675886448; x=1707422448;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=8SlrqThetKyI2i29+UXfRivo5MP/riXdL060oZwi9S4=;
  b=i+dupsmw6/t4hHhQRet1vARyvODifL2yB88FEPynuD6eIasFOoUPUQ5x
   TUsAqrGsiQKToHHz7TNR6/q62QNARSHiQrB8W+lo95fSIK7s5daFoUKxe
   qZyQRU9dQew3sCcz7qbauGvYv7/SCiAW5iHL5zm0PygMDFFWZsjUja2ii
   LRvR6jWi0vlnRNTNuO/DYq1PTERY0+gS45mPQ/ibJ8C8yDMyogrsG1ZQ5
   jwBbznelaXfDI46HdQGDJ+qCFhc6RGT/RgzBZSgHdlKECigEgfXqUoMmH
   SkEd1nU05I811YnMxCMhITgzA58G/sYS46T6fjhBKw8LwXB2qKYQvwozD
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="329935480"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="329935480"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:45 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10615"; a="776174683"
X-IronPort-AV: E=Sophos;i="5.97,281,1669104000"; 
   d="scan'208";a="776174683"
Received: from laarmstr-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.251.6.109])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Feb 2023 12:00:44 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Wed, 08 Feb 2023 13:00:33 -0700
Subject: [PATCH ndctl v2 5/7] cxl/region: determine region type based on
 root decoder capability
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v2-5-4ea6253000e5@intel.com>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2392;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=8SlrqThetKyI2i29+UXfRivo5MP/riXdL060oZwi9S4=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmP/2fypDt8uPD4q/j5RRv3nrWOUJYpv8BoJ6Hxho3nc
 73Q1TKljlIWBjEuBlkxRZa/ez4yHpPbns8TmOAIM4eVCWQIAxenAEykWZ3hf/5anSiNP2WHj2Z6
 V3c+LFTO/HBpt1PWU1OuKf/DuqevYGL475My2fpM66+mT9fqWGd6x2i8lZob+sfZ4N/6TZY3ruw
 5wAYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

In the common case, root decoders are expected to be either pmem
capable, or volatile capable, but not necessarily both simultaneously.
If a decoder only has one of pmem or volatile capabilities,
cxl-create-region should just infer the type of the region (pmem
or ram) based on this capability.

Maintain the default behavior of cxl-create-region to choose type=pmem,
but only as a fallback if the selected root decoder has multiple
capabilities. If it is only capable of either pmem, or ram, then infer
region type from this without requiring it to be specified explicitly.

Cc: Dan Williams <dan.j.williams@intel.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-create-region.txt |  3 ++-
 cxl/region.c                            | 18 ++++++++++++++++++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/Documentation/cxl/cxl-create-region.txt b/Documentation/cxl/cxl-create-region.txt
index ada0e52..f11a412 100644
--- a/Documentation/cxl/cxl-create-region.txt
+++ b/Documentation/cxl/cxl-create-region.txt
@@ -75,7 +75,8 @@ include::bus-option.txt[]
 
 -t::
 --type=::
-	Specify the region type - 'pmem' or 'ram'. Defaults to 'pmem'.
+	Specify the region type - 'pmem' or 'ram'. Default to root decoder
+	capability, and if that is ambiguous, default to 'pmem'.
 
 -U::
 --uuid=::
diff --git a/cxl/region.c b/cxl/region.c
index 5c908bb..07ce4a3 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -444,6 +444,22 @@ static int validate_decoder(struct cxl_decoder *decoder,
 	return 0;
 }
 
+static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
+{
+	/* if param.type was explicitly specified, nothing to do here */
+	if (param.type)
+		return;
+
+	/*
+	 * default to pmem if both types are set, otherwise the single
+	 * capability dominates.
+	 */
+	if (cxl_decoder_is_volatile_capable(p->root_decoder))
+		p->mode = CXL_DECODER_MODE_RAM;
+	if (cxl_decoder_is_pmem_capable(p->root_decoder))
+		p->mode = CXL_DECODER_MODE_PMEM;
+}
+
 static int create_region_validate_config(struct cxl_ctx *ctx,
 					 struct parsed_params *p)
 {
@@ -477,6 +493,8 @@ found:
 		return -ENXIO;
 	}
 
+	set_type_from_decoder(ctx, p);
+
 	rc = validate_decoder(p->root_decoder, p);
 	if (rc)
 		return rc;

-- 
2.39.1

