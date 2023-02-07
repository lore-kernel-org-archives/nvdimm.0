Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43F3F7480
	for <nvdimm@lists.linux.dev>; Tue,  7 Feb 2023 19:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675797419; x=1707333419;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:references:in-reply-to:to:cc;
  bh=F6i9XzEQEwUXpUjQRIMAD7e50UpecQapEaokHm+Ojxw=;
  b=PEfwjYP7VzKMQvxWu9UJCsJT1wG4QGzwqJ1zuwiuzyV9rAXbcUSTE+w5
   eDsByicadrp64JAtq5MCHGl+yXX62CxiY6cL1990To3XZ/GrRp8fGuUx0
   FNIv93EIk7PbK+VcKWwcDOj2yB4gFL9IzubV957EQTPITdMblvaeLgKN4
   QyOgk39pO/bITQGth3mQUjhGI+6+5DWEO8iOvMiFwwHgXbrzzYoxK2hUx
   sVK7DfvTOr5Obgmx/Kcsbjft7pJ7rjPZolb/cfUyhWCWUBqQI7GbfwmkC
   9GKt/e9EFIh/Z83JS964pZJykI4hxk8X6Arv9ef1maEWpSmQ8zaQRS2fB
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="331734004"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="331734004"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:56 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10614"; a="735649818"
X-IronPort-AV: E=Sophos;i="5.97,278,1669104000"; 
   d="scan'208";a="735649818"
Received: from fvanegas-mobl.amr.corp.intel.com (HELO vverma7-desk1.local) ([10.209.109.6])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Feb 2023 11:16:55 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Date: Tue, 07 Feb 2023 12:16:31 -0700
Subject: [PATCH ndctl 5/7] cxl/region: determine region type based on root
 decoder capability
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230120-vv-volatile-regions-v1-5-b42b21ee8d0b@intel.com>
References: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
In-Reply-To: <20230120-vv-volatile-regions-v1-0-b42b21ee8d0b@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Gregory Price <gregory.price@memverge.com>, 
 Jonathan Cameron <Jonathan.Cameron@Huawei.com>, 
 Davidlohr Bueso <dave@stgolabs.net>, 
 Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-ada30
X-Developer-Signature: v=1; a=openpgp-sha256; l=2566;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=F6i9XzEQEwUXpUjQRIMAD7e50UpecQapEaokHm+Ojxw=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDMmPFi/J5TdfN392dPkDpQdrc3h+8IrGLLTp55mVPm+F/
 Z9Znwz8OkpZGMS4GGTFFFn+7vnIeExuez5PYIIjzBxWJpAhDFycAjCRzhSG//Ef6+1WHZcW3qTY
 dWhZ9yfx80bJhwwuvlUyL9u2qvulHw/Df0f5f5XrH1SvW9t9bzrvT9aif8EaHv+eLsje/Ghq1/n
 kRTwA
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
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 Documentation/cxl/cxl-create-region.txt |  3 ++-
 cxl/region.c                            | 27 +++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 1 deletion(-)

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
index 9079b2d..1c8ccc7 100644
--- a/cxl/region.c
+++ b/cxl/region.c
@@ -448,6 +448,31 @@ static int validate_decoder(struct cxl_decoder *decoder,
 	return 0;
 }
 
+static void set_type_from_decoder(struct cxl_ctx *ctx, struct parsed_params *p)
+{
+	int num_cap = 0;
+
+	/* if param.type was explicitly specified, nothing to do here */
+	if (param.type)
+		return;
+
+	/*
+	 * if the root decoder only has one type of capability, default
+	 * to that mode for the region.
+	 */
+	if (cxl_decoder_is_pmem_capable(p->root_decoder))
+		num_cap++;
+	if (cxl_decoder_is_volatile_capable(p->root_decoder))
+		num_cap++;
+
+	if (num_cap == 1) {
+		if (cxl_decoder_is_volatile_capable(p->root_decoder))
+			p->mode = CXL_DECODER_MODE_RAM;
+		else if (cxl_decoder_is_pmem_capable(p->root_decoder))
+			p->mode = CXL_DECODER_MODE_PMEM;
+	}
+}
+
 static int create_region_validate_config(struct cxl_ctx *ctx,
 					 struct parsed_params *p)
 {
@@ -481,6 +506,8 @@ found:
 		return -ENXIO;
 	}
 
+	set_type_from_decoder(ctx, p);
+
 	rc = validate_decoder(p->root_decoder, p);
 	if (rc)
 		return rc;

-- 
2.39.1

