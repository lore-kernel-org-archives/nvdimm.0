Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59415BA24
	for <nvdimm@lists.linux.dev>; Wed, 14 Dec 2022 22:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671055255; x=1702591255;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=mwVah/u+qM7VhJ72QMALIWdkabtUltYcykRGgJ72ORQ=;
  b=EpqNRzsuSJamZu2Q4rOqy5WC5+d0GHWXzHEbjl0mToz2Qkj/zFjWpRsG
   crqK9YOsUZzFEHB0u6Smk8G55Uh90r9XHW4SW4Ysz/7jNS98CsKLRDXnY
   xFRxQ8S/YHeVv+ACLhOfHYf0X2nLkOpAkPDbPoOM+NNtFYFT8UVF+gClB
   tsg0x4tfdaFB+EnPsv0ddraHbxGkv9xWihf8EcepO95tRD5VsK9Kkwid7
   yAf1mS2ZTQIRrxL8nKWfWCFBfygQjmGIPNULymGPjv14+5hXEqXz5OYrS
   d1y6qUGCNhJILzFfzpc5lZbktEtv+pQbXhGeSVOLN308vCIZttKj0FIvH
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="316159244"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="316159244"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:32 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10561"; a="679907729"
X-IronPort-AV: E=Sophos;i="5.96,245,1665471600"; 
   d="scan'208";a="679907729"
Received: from djiang5-desk3.ch.intel.com ([143.182.136.137])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Dec 2022 14:00:32 -0800
Subject: [ndctl PATCH v2 2/4] ndctl/libndctl: Add bus_prefix for CXL
From: Dave Jiang <dave.jiang@intel.com>
To: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Cc: vishal.l.verma@intel.com
Date: Wed, 14 Dec 2022 15:00:31 -0700
Message-ID: 
 <167105523165.3034751.4940603908511673299.stgit@djiang5-desk3.ch.intel.com>
In-Reply-To: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
References: 
 <167105505204.3034751.8113387624258581781.stgit@djiang5-desk3.ch.intel.com>
User-Agent: StGit/1.4
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

When the 'ndbus' is backed by CXL, setup the bus_prefix for dimm object
appropriately.

Signed-off-by: Dave Jiang <dave.jiang@intel.com>

---
v2:
- improve commit log. (Vishal)
---
 ndctl/lib/libndctl.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/ndctl/lib/libndctl.c b/ndctl/lib/libndctl.c
index 10422e24d38b..d2e800bc840a 100644
--- a/ndctl/lib/libndctl.c
+++ b/ndctl/lib/libndctl.c
@@ -2012,6 +2012,12 @@ static void *add_dimm(void *parent, int id, const char *dimm_base)
 			goto out;
 		}
 		rc =  add_papr_dimm(dimm, dimm_base);
+	} else if (ndctl_bus_has_cxl(bus)) {
+		dimm->bus_prefix = strdup("cxl");
+		if (!dimm->bus_prefix) {
+			rc = -ENOMEM;
+			goto out;
+		}
 	}
 
 	if (rc == -ENODEV) {


