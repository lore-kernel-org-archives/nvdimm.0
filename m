Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE6C5693
	for <nvdimm@lists.linux.dev>; Thu,  7 Dec 2023 04:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fAc6Ff8B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1701923391; x=1733459391;
  h=from:subject:date:message-id:mime-version:
   content-transfer-encoding:to:cc;
  bh=crFblJXBJpmgdZMb8VBkVNZfUekrTLxrxXJ8ZTtZ1Kc=;
  b=fAc6Ff8B2VOWQPSXpLoaLnf9A+he8/pFBmyiIhYyvDWt12FG9kZeIrBG
   bB2cIyO0tuS+3mTRy5S6r4SalibPkwSi36hRiU4G3ONKX8y4KuF1w2zGz
   iMI2idvFgqBaoI93wk7+I0tp16tp6QubZ9jlEbRTgBtKMmsu8FQEI8axt
   8RG12td0Melb0czWRhKFw33qTP0zNn/6girt3SEZQmu5aqncvJWXe+bu4
   603HjB+FJzyV0jWlJu3rycuHXvgwtAhF4G1jBb8M1RaMm8GW4xQdDkNFB
   PIpNMmqttpYCDPkpHw34B8uv9VW8WlN470XK9I+P2Nlr4Lp0+zDpd/5so
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="398052146"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="398052146"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:29:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10916"; a="800586754"
X-IronPort-AV: E=Sophos;i="6.04,256,1695711600"; 
   d="scan'208";a="800586754"
Received: from apbrezen-mobl.amr.corp.intel.com (HELO [192.168.1.200]) ([10.213.160.175])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Dec 2023 20:29:50 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: [PATCH 0/2] Add DAX ABI for memmap_on_memory
Date: Wed, 06 Dec 2023 21:29:14 -0700
Message-Id: <20231206-vv-dax_abi-v1-0-474eb88e201c@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIABpKcWUC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDI2NDAyNT3bIy3ZTEivjEpExdQ/NEI0PLZBMzA3MzJaCGgqLUtMwKsGHRsbW
 1APQeGphcAAAA
To: Dan Williams <dan.j.williams@intel.com>, 
 Vishal Verma <vishal.l.verma@intel.com>
Cc: David Hildenbrand <david@redhat.com>, Dave Jiang <dave.jiang@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 Huang Ying <ying.huang@intel.com>, 
 Jonathan Cameron <Jonathan.Cameron@huawei.com>, nvdimm@lists.linux.dev
X-Mailer: b4 0.13-dev-26615
X-Developer-Signature: v=1; a=openpgp-sha256; l=1018;
 i=vishal.l.verma@intel.com; h=from:subject:message-id;
 bh=crFblJXBJpmgdZMb8VBkVNZfUekrTLxrxXJ8ZTtZ1Kc=;
 b=owGbwMvMwCXGf25diOft7jLG02pJDKmFXgbCmVvuX3xXMH+Bc+eKgJXCjxSTNGf7T73AZOpav
 9n+ZQtLRykLgxgXg6yYIsvfPR8Zj8ltz+cJTHCEmcPKBDKEgYtTACainMfwV3J6ZPekoOVmymKr
 PoX/2dDLbHrs9k+eoGveqcu4xf7mvGb4zZa8Z278rd0Kx0UeKc04KH2hclPQWQvWZSGJld9PnXF
 k4wYA
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp;
 fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF

The DAX drivers were missing sysfs ABI documentation entirely.  Add this
missing documentation for the sysfs ABI for DAX regions and Dax devices
in patch 1. Add a new ABI for toggling memmap_on_memory semantics in
patch 2.

The missing ABI was spotted in [1], this series is a split of the new
ABI additions behind the initial documentation creation.

[1]: https://lore.kernel.org/linux-cxl/651f27b728fef_ae7e7294b3@dwillia2-xfh.jf.intel.com.notmuch/

Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
Vishal Verma (2):
      Documentatiion/ABI: Add ABI documentation for sys-bus-dax
      dax: add a sysfs knob to control memmap_on_memory behavior

 drivers/dax/bus.c                       |  40 ++++++++
 Documentation/ABI/testing/sysfs-bus-dax | 164 ++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+)
---
base-commit: c4e1ccfad42352918810802095a8ace8d1c744c9
change-id: 20231025-vv-dax_abi-17a219c46076

Best regards,
-- 
Vishal Verma <vishal.l.verma@intel.com>

