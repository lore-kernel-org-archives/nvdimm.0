Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42D316002
	for <nvdimm@lists.linux.dev>; Thu, 14 Jul 2022 17:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657818170; x=1689354170;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ScYbThIZfT4n55eM8DUbm+cfiTaDRHUaL5wTJC8Cy8k=;
  b=MKa4J3sSEOUMVbejXDqZhWSAF+qm2S9apugEX6DF+c54kLSCijlpuGhQ
   56GBIk/y/dQ0JZG4stncpe+xUla1BlnVXuFLRUtxLmhDU9OP1Va5L12mz
   t4mt/laPmxT0mH99+LjkOTxr2JqP2v51ic5uxC+y8K4A7m4tDL2+4IlHS
   P+LwfH2Gzy1Tq5pRAAImLRw7YQCSX5hgdHi4ki/IqBUYZVrI+cCFcdqjF
   x8JHA+rkbvqI2d+jwv7XYADg3Im1hKDp84dA4VMv3gOzOB78ln6oCF52G
   UMIBRZQh+jiSI0QJSSuizwssC2+DizwQ4/hHiHgcp99zaPXbOl6XiVLZg
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10408"; a="268602813"
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="268602813"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:50 -0700
X-IronPort-AV: E=Sophos;i="5.92,271,1650956400"; 
   d="scan'208";a="596163896"
Received: from jlcone-mobl1.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.209.2.90])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jul 2022 10:02:49 -0700
Subject: [ndctl PATCH v2 11/12] cxl/test: Update CXL memory parameters
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Thu, 14 Jul 2022 10:02:49 -0700
Message-ID: <165781816971.1555691.18362747345754213762.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
References: <165781810717.1555691.1411727384567016588.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

In support of testing CXL region configurations cxl_test changed the size
of its root decoders and endpoints. Use the size of the first root decoder
to determine if this is an updated kernel.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/cxl-topology.sh |   32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index ff11614f4f14..2583005fef26 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -64,14 +64,9 @@ switch[2]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[0].host" <<<
 switch[3]=$(jq -r ".[] | .[\"ports:${bridge[1]}\"] | $port_sort | .[1].host" <<< $json)
 
 
-# check that all 8 cxl_test memdevs are enabled by default and have a
-# pmem size of 256M
-json=$($CXL list -b cxl_test -M)
-count=$(jq "map(select(.pmem_size == $((256 << 20)))) | length" <<< $json)
-((count == 8)) || err "$LINENO"
-
-
 # validate the expected properties of the 4 root decoders
+# use the size of the first decoder to determine the cxl_test version /
+# properties
 json=$($CXL list -b cxl_test -D -d root)
 port_id=${root:4}
 port_id_len=${#port_id}
@@ -80,26 +75,41 @@ count=$(jq "[ $decoder_sort | .[0] |
 	select(.volatile_capable == true) |
 	select(.size == $((256 << 20))) |
 	select(.nr_targets == 1) ] | length" <<< $json)
-((count == 1)) || err "$LINENO"
+
+if [ $count -eq 1 ]; then
+	decoder_base_size=$((256 << 20))
+	pmem_size=$((256 << 20))
+else
+	decoder_base_size=$((1 << 30))
+	pmem_size=$((1 << 30))
+fi
 
 count=$(jq "[ $decoder_sort | .[1] |
 	select(.volatile_capable == true) |
-	select(.size == $((512 << 20))) |
+	select(.size == $((decoder_base_size * 2))) |
 	select(.nr_targets == 2) ] | length" <<< $json)
 ((count == 1)) || err "$LINENO"
 
 count=$(jq "[ $decoder_sort | .[2] |
 	select(.pmem_capable == true) |
-	select(.size == $((256 << 20))) |
+	select(.size == $decoder_base_size) |
 	select(.nr_targets == 1) ] | length" <<< $json)
 ((count == 1)) || err "$LINENO"
 
 count=$(jq "[ $decoder_sort | .[3] |
 	select(.pmem_capable == true) |
-	select(.size == $((512 << 20))) |
+	select(.size == $((decoder_base_size * 2))) |
 	select(.nr_targets == 2) ] | length" <<< $json)
 ((count == 1)) || err "$LINENO"
 
+
+# check that all 8 cxl_test memdevs are enabled by default and have a
+# pmem size of 256M, or 1G
+json=$($CXL list -b cxl_test -M)
+count=$(jq "map(select(.pmem_size == $pmem_size)) | length" <<< $json)
+((count == 8)) || err "$LINENO"
+
+
 # check that switch ports disappear after all of their memdevs have been
 # disabled, and return when the memdevs are enabled.
 for s in ${switch[@]}

