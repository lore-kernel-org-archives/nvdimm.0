Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CCA2C80
	for <nvdimm@lists.linux.dev>; Wed, 26 Jan 2022 05:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643174640; x=1674710640;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VAAD+TueKcO3yWsENF5eR+Zwzsq2qza8sccWNpnGYbo=;
  b=PbQ1B96eLyBNrxzxxc6cxYSbxDkJQwdt8VfWtK531cqloXXjoM0RV/Kj
   W76CPlJyqFWmxmDUP91hGVGlF9y1KZp+bpdfz4GTjHm1Qb9v912FcF0nh
   XSMLppxzZeZTtXjr6PtsuSCYdMM7s/TxYjetGfxU1lCvvMznJ4bU4Gt74
   BDO1oVguELpml4v+z2dHds+h//yQqjeBvji2L2cM7Ryrqj1kLaltmi4oC
   4DpZbHK/LoYbX7eLr6frt/3DjHw5MPnKAJTGr1GJUf8wzo1sc8V9bflsu
   Nfv0s+LE3x2t12gx6PAkqj7cGVmU6Ll0F2WIDs9sH1mzJnmkpx2h1+m/z
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10238"; a="245315999"
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="245315999"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 21:23:59 -0800
X-IronPort-AV: E=Sophos;i="5.88,316,1635231600"; 
   d="scan'208";a="628195580"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Jan 2022 21:23:59 -0800
Subject: [PATCH 0/2] cxl/port: Robustness fixes for decoder enumeration
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: linux-pci@vger.kernel.org, nvdimm@lists.linux.dev, ben.widawsky@intel.com
Date: Tue, 25 Jan 2022 21:23:58 -0800
Message-ID: <164317463887.3438644.4087819721493502301.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

Further testing of the decoder toplogy enumeration patches found cases
where the driver is too strict about what it accepts. First, there is no
expectation that the decoder's target list is valid when the decoder is
disabled. Make decoder_populate_targets() failures non-fatal on disabled
decoders. Second, if the decoder emits out-of-bounds / reserved values
at init warn and continue if at least one valid decoder was found. This
future-proofs the driver against changes to the interleave_ways
encoding, at least for continuing to operate decoders that conform to
current expectations.

Applies on top of:

https://lore.kernel.org/r/164298411792.3018233.7493009997525360044.stgit@dwillia2-desk3.amr.corp.intel.com

---

Dan Williams (2):
      cxl/core/port: Fix / relax decoder target enumeration
      cxl/core/port: Handle invalid decoders


 drivers/cxl/acpi.c      |    2 +-
 drivers/cxl/core/hdm.c  |   36 ++++++++++++++++++++++++++++++------
 drivers/cxl/core/port.c |    5 ++++-
 3 files changed, 35 insertions(+), 8 deletions(-)
