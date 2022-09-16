Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C3017F4
	for <nvdimm@lists.linux.dev>; Fri, 16 Sep 2022 01:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663292107; x=1694828107;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GbjGsk48B5jT8oeQhzL1rnsT1NQxODvuyZ+YY+8XGL8=;
  b=e+PorOQOfZ79FKOOPjD6dftGnlJJ2AVcgr/QOouFf6F0TTz9cF/C/xpd
   l6GVb4b4XDOmBiAvswXSR0M/Q70ZzrCy2akfI/H4/ZnoLgq6/oKk7Aarb
   AKUV/nyuCEvmJnex/IfG7XVoaFmcPJmACbG80UG8kfMh5YdaaVz0AcsBd
   s2F0YtBPL4FoLGMkTsdCu+V/Qlw04VRd52W69gQKJ5zMfv+fVj52KG4kV
   TPKLmPXHYZvDd6tftoB46HmD5/s/sJyTk9xCiQSyvyzWZs+K40W/ff8//
   lsf7XheUlxmVoTaPp4HFT7uhOk5oMYYGvxZGWpy/qp2yIsa9L9WcYAQuT
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10471"; a="300247782"
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="300247782"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 18:35:06 -0700
X-IronPort-AV: E=Sophos;i="5.93,319,1654585200"; 
   d="scan'208";a="743164761"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.209.120.139])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Sep 2022 18:35:06 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH 2/2] cxl/test: allow another host bridge in cxl-topology check
Date: Thu, 15 Sep 2022 18:35:02 -0700
Message-Id: <1380b5042ba3baf39777183205cc3d6974519159.1663290390.git.alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663290390.git.alison.schofield@intel.com>
References: <cover.1663290390.git.alison.schofield@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Update the related count checks to allow a third CXL Host
Bridge in the cxl_test topology.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-topology.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 2583005fef26..11c39f61cf52 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -32,7 +32,7 @@ root=$(jq -r ".[] | .bus" <<< $json)
 port_sort="sort_by(.port | .[4:] | tonumber)"
 json=$($CXL list -b cxl_test -BP)
 count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
-((count == 2)) || err "$LINENO"
+((count == 4)) || err "$LINENO"
 
 bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
 bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
@@ -103,11 +103,11 @@ count=$(jq "[ $decoder_sort | .[3] |
 ((count == 1)) || err "$LINENO"
 
 
-# check that all 8 cxl_test memdevs are enabled by default and have a
+# check that all 16 cxl_test memdevs are enabled by default and have a
 # pmem size of 256M, or 1G
 json=$($CXL list -b cxl_test -M)
 count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
-((count == 8)) || err "$LINENO"
+((count == 16 )) || err "$LINENO"
 
 
 # check that switch ports disappear after all of their memdevs have been
-- 
2.31.1

