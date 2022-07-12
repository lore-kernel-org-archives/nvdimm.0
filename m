Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A7566AA3
	for <nvdimm@lists.linux.dev>; Tue, 12 Jul 2022 19:08:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657652902; x=1689188902;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ScYbThIZfT4n55eM8DUbm+cfiTaDRHUaL5wTJC8Cy8k=;
  b=EYlebMZVCtef4XcvgbX2Gu7wU7g3IPanAIzNM5yYxfUNr2XcKH7cBzPm
   ftHDBLgQcKgSaKY/qxqIDAF8q9Pie/b5jyEdxzE4RJ7hroq7GbOYt2CM0
   AdyY6aMAlTgwU5oEDiitPWi5kfkfNRuAIGW6lcz44wLg3Adui/Xzs2G5m
   ORjNUmyXKJTH5ED/Q/8wR2dY7+bBxbbobdcHRHElqb+xtmhF98GuzezC6
   /JhUzj4suiYBVnzFGhbQnURcFDQNikvyLYFQqGjQKNENGHzF/D9NrVHK0
   kCLzqkX8ixPJl+8kgXf40Ri26g2VpEoVZzyWgo4sazh+HUIhnB1htgp9d
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10406"; a="285047632"
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="285047632"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:08:22 -0700
X-IronPort-AV: E=Sophos;i="5.92,266,1650956400"; 
   d="scan'208";a="599484403"
Received: from sheyting-mobl3.amr.corp.intel.com (HELO [192.168.1.117]) ([10.212.147.156])
  by fmsmga007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2022 12:08:21 -0700
Subject: [ndctl PATCH 10/11] cxl/test: Update CXL memory parameters
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: alison.schofield@intel.com, nvdimm@lists.linux.dev,
 linux-cxl@vger.kernel.org
Date: Tue, 12 Jul 2022 12:08:21 -0700
Message-ID: <165765290152.435671.6682820562953571294.stgit@dwillia2-xfh>
In-Reply-To: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
References: <165765284365.435671.13173937566404931163.stgit@dwillia2-xfh>
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

