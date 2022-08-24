Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 009831C3E
	for <nvdimm@lists.linux.dev>; Wed, 24 Aug 2022 23:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661382613; x=1692918613;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VG2H/jyzfAXq2A25f2uUq50DnWPDZ33iXFfSEee0MpI=;
  b=KRznJX8JMt8m/+Bv+rBS7mqRkPJ82rEAiGmDS/EqabArcYe2oKC2TXmY
   /npLOTH8uXzYp7yyiQphW4W2zFsKhTmC2H7dMpL5gccwjMgCz/z6y4UHQ
   C0plTJ5Ujre6c2d9eagEcH7s0wqm+5kj91clUOCYSrhJjqa5HjCPwxGuu
   acGGUXLMbKib0H+LSqJ5keGIzNTrSbGxmJsmMOcjg3uhUcxn8EegH5qf6
   /EsrCzXdWBBoZ0K4UXCgcYoz+ISnUckk9tV54da4hRqV++GfC5Bq+9ekV
   TfckQYnf9OrLzkk+z2/iDsw7Dxc9jRv661sgeT19BpwPjJD8juEFct/4Z
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="358069267"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="358069267"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 16:10:13 -0700
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="639328510"
Received: from aschofie-mobl2.amr.corp.intel.com (HELO localhost) ([10.212.128.158])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 16:10:08 -0700
From: alison.schofield@intel.com
To: Vishal Verma <vishal.l.verma@intel.com>,
	Dan Williams <dan.j.williams@intel.com>
Cc: Alison Schofield <alison.schofield@intel.com>,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: [ndctl PATCH] cxl/test: Use interleave arithmetic to sort memdevs for a region
Date: Wed, 24 Aug 2022 16:09:58 -0700
Message-Id: <20220824230958.125906-1-alison.schofield@intel.com>
X-Mailer: git-send-email 2.37.2
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Alison Schofield <alison.schofield@intel.com>

Test cxl-region-sysfs.sh assumes Modulo arithmetic. XOR arithmetic
is being introduced and requires a different ordering of the memdevs
in the region.

Update the test to sort the memdevs based on interleave arithmetic.
If the interleave arithmetic attribute for the root decoder is not
visible in sysfs, driver support for XOR math is not present. Default
to Modulo sorting order.

Signed-off-by: Alison Schofield <alison.schofield@intel.com>
---
 test/cxl-region-sysfs.sh | 44 ++++++++++++++++++++++++++++++++--------
 1 file changed, 36 insertions(+), 8 deletions(-)

diff --git a/test/cxl-region-sysfs.sh b/test/cxl-region-sysfs.sh
index ae0f55653814..1af0ae7e632c 100644
--- a/test/cxl-region-sysfs.sh
+++ b/test/cxl-region-sysfs.sh
@@ -58,15 +58,43 @@ readarray -t mem_sort1 < <($CXL list -M -p $port_dev1 | jq -r ".[] | .memdev")
 
 # TODO: add a cxl list option to list memdevs in valid region provisioning
 # order, hardcode for now.
+
+# Sort based on root decoder interleave arithmetic.
+# Default to Modulo if the sysfs attribute is not emitted.
+if [ ! -e /sys/bus/cxl/devices/$decoder/interleave_arithmetic ]; then
+	ia="0"
+else
+	ia=$(cat /sys/bus/cxl/devices/$decoder/interleave_arithmetic)
+fi
+
 mem_sort=()
-mem_sort[0]=${mem_sort0[0]}
-mem_sort[1]=${mem_sort1[0]}
-mem_sort[2]=${mem_sort0[2]}
-mem_sort[3]=${mem_sort1[2]}
-mem_sort[4]=${mem_sort0[1]}
-mem_sort[5]=${mem_sort1[1]}
-mem_sort[6]=${mem_sort0[3]}
-mem_sort[7]=${mem_sort1[3]}
+if [ $ia == "0" ]; then
+	# Modulo Arithmetic
+	mem_sort[0]=${mem_sort0[0]}
+	mem_sort[1]=${mem_sort1[0]}
+	mem_sort[2]=${mem_sort0[2]}
+	mem_sort[3]=${mem_sort1[2]}
+	mem_sort[4]=${mem_sort0[1]}
+	mem_sort[5]=${mem_sort1[1]}
+	mem_sort[6]=${mem_sort0[3]}
+	mem_sort[7]=${mem_sort1[3]}
+
+elif [ $ia == "1" ]; then
+	# XOR Arithmetic
+	mem_sort[0]=${mem_sort1[0]}
+	mem_sort[1]=${mem_sort0[0]}
+	mem_sort[2]=${mem_sort1[2]}
+	mem_sort[3]=${mem_sort0[2]}
+	mem_sort[4]=${mem_sort1[1]}
+	mem_sort[5]=${mem_sort0[1]}
+	mem_sort[6]=${mem_sort1[3]}
+	mem_sort[7]=${mem_sort0[3]}
+else
+	# Unknown Arithmetic
+	echo "Unknown interleave arithmetic: $ia for $decoder"
+	modprobe -r cxl-test
+	exit 1
+fi
 
 # TODO: use this alternative memdev ordering to validate a negative test for
 # specifying invalid positions of memdevs

base-commit: c9c9db39354ea0c3f737378186318e9b7908e3a7
-- 
2.31.1

