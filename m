Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D7FD500
	for <nvdimm@lists.linux.dev>; Sun,  6 Nov 2022 23:46:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1667778418; x=1699314418;
  h=subject:from:to:cc:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1m26oHecianIsW7mMpSdF2J3D9I0WaMck1/vbIPkuCQ=;
  b=EiBz5L+5CnzCKp3Be5kCGAp0+oVOhU0vg8rIao/LVNnTwjZIgtp0bESm
   HkFVguprB+IZeYTRok196rhOD4Ny/y9iw6PWMnUHIB1DV9hYTbXXr4qry
   FPaun/9nfdHwJHWbelCP/m17qb17jjOeyQlU3BA4JkAU9zd+nnrDnEYtr
   o+jykpc+bcrWHO11HtFK3WvS9IPST/WHhWe7fQIUpCuI1K0ULL0WXy50f
   8WOMHtl9PIlpw/vl/ywB62DATB6pgTsXgBPgUw+adSple/BVF6JAD9GQT
   t06O6aPyyYs9BstTxSroPtQj6EOZWyzpHtD0PWATG6A7paXx0HZ7QaXw9
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="312052567"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="312052567"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:46:58 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10523"; a="964951323"
X-IronPort-AV: E=Sophos;i="5.96,143,1665471600"; 
   d="scan'208";a="964951323"
Received: from durgasin-mobl.amr.corp.intel.com (HELO dwillia2-xfh.jf.intel.com) ([10.212.240.219])
  by fmsmga005-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2022 15:46:57 -0800
Subject: [ndctl PATCH 02/15] ndctl/test: Add kernel backtrace detection to
 some dax tests
From: Dan Williams <dan.j.williams@intel.com>
To: vishal.l.verma@intel.com
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Date: Sun, 06 Nov 2022 15:46:57 -0800
Message-ID: <166777841716.1238089.7618196736080256393.stgit@dwillia2-xfh.jf.intel.com>
In-Reply-To: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
References: <166777840496.1238089.5601286140872803173.stgit@dwillia2-xfh.jf.intel.com>
User-Agent: StGit/0.18-3-g996c
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

It is useful to fail a test if it triggers a backtrace. Generalize the
mechanism from test/cxl-topology.sh and add it to tests that want
to validate clean kernel logs.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 test/common              |   10 ++++++++++
 test/cxl-region-sysfs.sh |    4 +---
 test/cxl-topology.sh     |    5 +----
 test/dax.sh              |    2 ++
 test/daxdev-errors.sh    |    2 ++
 test/multi-dax.sh        |    2 ++
 6 files changed, 18 insertions(+), 7 deletions(-)

diff --git a/test/common b/test/common
index 65615cc09a3e..44cc352f6009 100644
--- a/test/common
+++ b/test/common
@@ -132,3 +132,13 @@ json2var()
 {
 	sed -e "s/[{}\",]//g; s/\[//g; s/\]//g; s/:/=/g"
 }
+
+# check_dmesg
+# $1: line number where this is called
+check_dmesg()
+{
+	# validate no WARN or lockdep report during the run
+	log=$(journalctl -r -k --since "-$((SECONDS+1))s")
+	grep -q "Call Trace" <<< $log && err $1
+	true
+}
diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index 63186b60dfec..e128406cd8c8 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -164,8 +164,6 @@ readarray -t endpoint < <($CXL free-dpa -t pmem ${mem[*]} |
 			  jq -r ".[] | .decoder.decoder")
 echo "$region released ${#endpoint[@]} targets: ${endpoint[@]}"
 
-# validate no WARN or lockdep report during the run
-log=$(journalctl -r -k --since "-$((SECONDS+1))s")
-grep -q "Call Trace" <<< $log && err "$LINENO"
+check_dmesg "$LINENO"
 
 modprobe -r cxl_test
diff --git a/test/cxl-topology.sh b/test/cxl-topology.sh
index f7e390d22680..1f15d29f0600 100644
--- a/test/cxl-topology.sh
+++ b/test/cxl-topology.sh
@@ -169,9 +169,6 @@ done
 # validate that the bus can be disabled without issue
 $CXL disable-bus $root -f
 
-
-# validate no WARN or lockdep report during the run
-log=$(journalctl -r -k --since "-$((SECONDS+1))s")
-grep -q "Call Trace" <<< $log && err "$LINENO"
+check_dmesg "$LINENO"
 
 modprobe -r cxl_test
diff --git a/test/dax.sh b/test/dax.sh
index bb9848b10ecc..3ffbc8079eba 100755
--- a/test/dax.sh
+++ b/test/dax.sh
@@ -118,4 +118,6 @@ else
 	run_xfs
 fi
 
+check_dmesg "$LINENO"
+
 exit 0
diff --git a/test/daxdev-errors.sh b/test/daxdev-errors.sh
index 7f79718113d0..84ef93499acf 100755
--- a/test/daxdev-errors.sh
+++ b/test/daxdev-errors.sh
@@ -71,6 +71,8 @@ if read sector len < /sys/bus/platform/devices/nfit_test.0/$busdev/$region/badbl
 fi
 [ -n "$sector" ] && echo "fail: $LINENO" && exit 1
 
+check_dmesg "$LINENO"
+
 _cleanup
 
 exit 0
diff --git a/test/multi-dax.sh b/test/multi-dax.sh
index 04070adb18e4..d471e1c96b5e 100755
--- a/test/multi-dax.sh
+++ b/test/multi-dax.sh
@@ -28,6 +28,8 @@ chardev1=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices
 json=$($NDCTL create-namespace -b $NFIT_TEST_BUS0 -r $region -t pmem -m devdax -a $ALIGN_SIZE -s 16M)
 chardev2=$(echo $json | jq ". | select(.mode == \"devdax\") | .daxregion.devices[0].chardev")
 
+check_dmesg "$LINENO"
+
 _cleanup
 
 exit 0

