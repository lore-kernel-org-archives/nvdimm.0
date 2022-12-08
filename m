Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50952A460
	for <nvdimm@lists.linux.dev>; Thu,  8 Dec 2022 21:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670534980; x=1702070980;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Y2qsFszn+mP0hy2RxCP0ZQdFrN5xKj92BcFOK/t8ENw=;
  b=Sw/fXUzcpwGCobu8VJQPPFEV8GL4U+JDWQp+MBJ2xWIfsQGjXrfEIYbt
   SC4aY73tekIsd87k4sP2Nww00K6VXLmZasSuJbkkntAZ61czKKIe6EoZO
   uYu8kNMeZULUy13tEUGJDpyXxExv+1G5T2q0Vg0SyPOD6SU8E3DwLg7EM
   muUkAI/JTX1HPojPO2INa/wNARO2WH1NSsLG6DU6/Dv3CUPwFBEzldKMG
   m5X6PsSCjq9/LuRJvagu/+sP4zf79qiAoE6Xav6KcM1pYTNM5GidcVuR+
   yjfmmxtkVQXwvHcFiyYlyFKdp8cPDfmM3QRrd1S5KkDwmw9vyGeiIAcVr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="344343310"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="344343310"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10555"; a="647170269"
X-IronPort-AV: E=Sophos;i="5.96,228,1665471600"; 
   d="scan'208";a="647170269"
Received: from kputnam-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.251.25.149])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Dec 2022 13:29:38 -0800
Subject: [ndctl PATCH v2 17/18] cxl/test: Extend cxl-topology.sh for a
 single root-port host-bridge
From: Dan Williams <dan.j.williams@intel.com>
To: linux-cxl@vger.kernel.org
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>,
 Alison Schofield <alison.schofield@intel.com>, vishal.l.verma@intel.com,
 nvdimm@lists.linux.dev, vishal.l.verma@intel.com
Date: Thu, 08 Dec 2022 13:29:38 -0800
Message-ID: <167053497831.582963.5641985826495628885.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
References: <167053487710.582963.17616889985000817682.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

A recent extension of cxl_test adds 2 memory devices attached through a
switch to a single ported host-bridge to reproduce a bug report.

Reported-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Link: http://lore.kernel.org/r/20221010172057.00001559@huawei.com
Tested-by: Alison Schofield <alison.schofield@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/cxl-topology.sh |   48 +++++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 19 deletions(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index 1f15d29f0600..362fffa6d539 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -29,27 +29,30 @@ count=$(jq "length" <<< $json)
 root=$(jq -r ".[] | .bus" <<< $json)
 
 
-# validate 2 host bridges under a root port
+# validate 2 or 3 host bridges under a root port
 port_sort="sort_by(.port | .[4:] | tonumber)"
 json=$($CXL list -b cxl_test -BP)
 count=$(jq ".[] | .[\"ports:$root\"] | length" <<< $json)
-((count == 2)) || err "$LINENO"
+((count == 2)) || ((count == 3)) || err "$LINENO"
+bridges=$count
 
 bridge[0]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[0].port" <<< $json)
 bridge[1]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[1].port" <<< $json)
+((bridges > 2)) && bridge[2]=$(jq -r ".[] | .[\"ports:$root\"] | $port_sort | .[2].port" <<< $json)
 
+# validate root ports per host bridge
+check_host_bridge()
+{
+	json=$($CXL list -b cxl_test -T -p $1)
+	count=$(jq ".[] | .dports | length" <<< $json)
+	((count == $2)) || err "$3"
+}
 
-# validate 2 root ports per host bridge
-json=$($CXL list -b cxl_test -T -p ${bridge[0]})
-count=$(jq ".[] | .dports | length" <<< $json)
-((count == 2)) || err "$LINENO"
-
-json=$($CXL list -b cxl_test -T -p ${bridge[1]})
-count=$(jq ".[] | .dports | length" <<< $json)
-((count == 2)) || err "$LINENO"
+check_host_bridge ${bridge[0]} 2 $LINENO
+check_host_bridge ${bridge[1]} 2 $LINENO
+((bridges > 2)) && check_host_bridge ${bridge[2]} 1 $LINENO
 
-
-# validate 2 switches per-root port
+# validate 2 switches per root-port
 json=$($CXL list -b cxl_test -P -p ${bridge[0]})
 count=$(jq ".[] | .[\"ports:${bridge[0]}\"] | length" <<< $json)
 ((count == 2)) || err "$LINENO"
@@ -65,9 +68,9 @@ switch[2]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[0].host" <<<
 switch[3]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[1].host" <<< $json)
 
 
-# validate the expected properties of the 4 root decoders
-# use the size of the first decoder to determine the cxl_test version /
-# properties
+# validate the expected properties of the 4 or 5 root decoders
+# use the size of the first decoder to determine the
+# cxl_test version / properties
 json=$($CXL list -b cxl_test -D -d root)
 port_id=${root:4}
 port_id_len=${#port_id}
@@ -103,12 +106,19 @@ count=$(jq "[ $decoder_sort | .[3] |
 	select(.nr_targets == 2) ] | length" <<< $json)
 ((count == 1)) || err "$LINENO"
 
+if (( bridges == 3 )); then
+	count=$(jq "[ $decoder_sort | .[4] |
+		select(.pmem_capable == true) |
+		select(.size == $decoder_base_size) |
+		select(.nr_targets == 1) ] | length" <<< $json)
+	((count == 1)) || err "$LINENO"
+fi
 
-# check that all 8 cxl_test memdevs are enabled by default and have a
+# check that all 8 or 10 cxl_test memdevs are enabled by default and have a
 # pmem size of 256M, or 1G
 json=$($CXL list -b cxl_test -M)
 count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
-((count == 8)) || err "$LINENO"
+((bridges == 2 && count == 8 || bridges == 3 && count == 10)) || err "$LINENO"
 
 
 # check that switch ports disappear after all of their memdevs have been
@@ -151,8 +161,8 @@ do
 done
 
 
-# validate host bridge tear down
-for b in ${bridge[@]}
+# validate host bridge tear down for the first 2 bridges
+for b in ${bridge[0]} ${bridge[1]}
 do
 	$CXL disable-port $b -f
 	json=$($CXL list -M -i -p $b)

