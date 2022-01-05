Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 386082C80
	for <nvdimm@lists.linux.dev>; Wed,  5 Jan 2022 21:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641418371; x=1672954371;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=VvqYIlkRHgJ9qXPmwzXXUh/RgXfXlalF6pCDeVGVYq4=;
  b=e/Nd6p9bg1sqFaO1moNJuYeYou+EM7Ej7r4IX5RpT13Xug8LGEJE/rDI
   0/3O13trigzOz3UqblqHC+WpRgx+oop5rrX0PEy+Ea94SiJpSeUEwghkf
   5adSXaN+T816oUx0RWi/FgydX+BxxHDb6HRRLVKBv6TcB6H4ir6LdeXFq
   /aPfVB9WxhPEBeQ/UUAci7VkVGzCdA+9H92ruD5k4sezNDM6dnERlLPL7
   tVjoDWsPnApmMpC9oJP+1w8nKR3UyYtb8ajRnGW3d6mObIjY0xl7dgVD2
   FJyu1OLAnqllGPw5DJF8n141g5Gtpc+dne1Nt3kQVW7xv+mET4n0GZfVS
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10217"; a="223224341"
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="223224341"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:00 -0800
X-IronPort-AV: E=Sophos;i="5.88,264,1635231600"; 
   d="scan'208";a="488727326"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2022 13:32:00 -0800
Subject: [ndctl PATCH v3 04/16] ndctl/test: Initialize the label area by
 default
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Date: Wed, 05 Jan 2022 13:32:00 -0800
Message-ID: <164141832017.3990253.10383328274835531066.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <164141829899.3990253.17547886681174580434.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

The removal of BLK-mode support causes nfit_test regions to not be
'aliased' by default, which means that the only way to enable labels is to
initialize the namespace label index block. In support of that the common
'reset()' helper is updated to initialize v1.1 labels instead of zero them.
Additionally, it highlighted that some btt tests have silent assumptions of
v1.1 vs v1.2 label support. Add a 'resetV()' alternative to the common
'reset()' function that initializes the label area to v1.2.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/btt-errors.sh     |    4 ++--
 test/btt-pad-compat.sh |    2 +-
 test/common            |   11 +++++++++--
 test/label-compat.sh   |    2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/test/btt-errors.sh b/test/btt-errors.sh
index 5a20d26fe6d5..6e69178cc3cf 100755
--- a/test/btt-errors.sh
+++ b/test/btt-errors.sh
@@ -45,7 +45,7 @@ trap 'err $LINENO cleanup' ERR
 
 # setup (reset nfit_test dimms)
 modprobe nfit_test
-reset
+resetV
 
 rc=1
 
@@ -124,7 +124,7 @@ dd if=$MNT/$FILE of=/dev/null iflag=direct bs=4096 count=1
 
 # reset everything to get a clean log
 if grep -q "$MNT" /proc/mounts; then umount $MNT; fi
-reset
+resetV
 dev="x"
 json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -t pmem -m sector)
 eval "$(echo "$json" | json2var)"
diff --git a/test/btt-pad-compat.sh b/test/btt-pad-compat.sh
index be538b761151..005316a205c8 100755
--- a/test/btt-pad-compat.sh
+++ b/test/btt-pad-compat.sh
@@ -148,7 +148,7 @@ do_tests()
 	verify_idx 0 1
 
 	# do the same with an old format namespace
-	reset
+	resetV
 	create_oldfmt_ns
 	verify_idx 0 2
 
diff --git a/test/common b/test/common
index 3c54d633251f..b6d47128f209 100644
--- a/test/common
+++ b/test/common
@@ -49,14 +49,21 @@ err()
 reset()
 {
 	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+	$NDCTL init-labels -f -b $NFIT_TEST_BUS0 all
+	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
+}
+
+resetV()
+{
+	$NDCTL disable-region -b $NFIT_TEST_BUS0 all
+	$NDCTL init-labels -f -V 1.2 -b $NFIT_TEST_BUS0 all
 	$NDCTL enable-region -b $NFIT_TEST_BUS0 all
 }
 
 reset1()
 {
 	$NDCTL disable-region -b $NFIT_TEST_BUS1 all
-	$NDCTL zero-labels -b $NFIT_TEST_BUS1 all
+	$NDCTL init-labels -f -b $NFIT_TEST_BUS1 all
 	$NDCTL enable-region -b $NFIT_TEST_BUS1 all
 }
 
diff --git a/test/label-compat.sh b/test/label-compat.sh
index 8ab285878d84..7ae4d5efd0ff 100755
--- a/test/label-compat.sh
+++ b/test/label-compat.sh
@@ -17,7 +17,7 @@ trap 'err $LINENO' ERR
 # setup (reset nfit_test dimms)
 modprobe nfit_test
 $NDCTL disable-region -b $NFIT_TEST_BUS0 all
-$NDCTL zero-labels -b $NFIT_TEST_BUS0 all
+$NDCTL init-labels -f -b $NFIT_TEST_BUS0 all
 
 # grab the largest pmem region on -b $NFIT_TEST_BUS0
 query=". | sort_by(.available_size) | reverse | .[0].dev"

