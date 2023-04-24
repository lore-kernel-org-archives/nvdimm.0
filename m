Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6FEE63AD
	for <nvdimm@lists.linux.dev>; Mon, 24 Apr 2023 19:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682366384; x=1713902384;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Faw8xP/k7KDSo+QDpEupmd/VRIE/HwlIRSmiJdGJIig=;
  b=h//zSPDKSbsXiw/SWtYZKXznHW+BdhmXda1YXv1BdpEPmZmjqt844RZu
   YioYGAqEkFfac5cADZ5REesEBmfj19Y7p4kVlAG7x3DVW67hI36heiaEH
   Hhi976CysIpDJz9MsT/poNnzL4RGdxKVqXc+uuiTWSU3RaL6G4uQGQ+lU
   9wTsvsp98Dky7fdHeVfhKR7BoFctzdK1HMJoX0AANVtnwRp9uDBXEjHN1
   E1adVdbfx9tWc14iXQdPoXK4ZStH0wdjW+J8+w2CGN5mMClxrF1AnbwuJ
   fAr7u5pS4fo48tIAaWUT6Ip8Tx52cOTBL89sSIPwrce8MUknqA3dCN79N
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="326157356"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="326157356"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10690"; a="670622081"
X-IronPort-AV: E=Sophos;i="5.99,223,1677571200"; 
   d="scan'208";a="670622081"
Received: from fbirang-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.88.12])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2023 12:59:43 -0700
Subject: [PATCH 2/4] cxl/list: Filter root decoders by region
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Mon, 24 Apr 2023 12:59:43 -0700
Message-ID: <168236638318.1027628.17234728660914767074.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
References: <168236637159.1027628.7560967008080605819.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Arrange for util_cxl_decoder_filter_by_region() to consider that root
decoders host multiple regions, unlike switch and endpoint decoders that
have a 1:1 relationship.

Before: (list the root decoders hosting region4 and region9)
    # cxl list -Du -d root -r 4,9
      Warning: no matching devices found

    [
    ]

After:
    # cxl list -Du -d root -r 4,9
    [
      {
        "decoder":"decoder3.0",
        "resource":"0xf010000000",
        "size":"1024.00 MiB (1073.74 MB)",
        "interleave_ways":1,
        "max_available_extent":"512.00 MiB (536.87 MB)",
        "volatile_capable":true,
        "nr_targets":1
      },
      {
        "decoder":"decoder3.5",
        "resource":"0xf1d0000000",
        "size":"256.00 MiB (268.44 MB)",
        "interleave_ways":1,
        "accelmem_capable":true,
        "nr_targets":1
      }
    ]

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 cxl/filter.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/cxl/filter.c b/cxl/filter.c
index 90b13be79d9c..6e8d42165205 100644
--- a/cxl/filter.c
+++ b/cxl/filter.c
@@ -661,6 +661,12 @@ util_cxl_decoder_filter_by_region(struct cxl_decoder *decoder,
 	if (!__ident)
 		return decoder;
 
+	/* root decoders filter by children */
+	cxl_region_foreach(decoder, region)
+		if (util_cxl_region_filter(region, __ident))
+			return decoder;
+
+	/* switch and endpoint decoders have a 1:1 association with a region */
 	region = cxl_decoder_get_region(decoder);
 	if (!region)
 		return NULL;

