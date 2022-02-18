Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A39AC321D
	for <nvdimm@lists.linux.dev>; Fri, 18 Feb 2022 05:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645163425; x=1676699425;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=5CY7VAzvb6gzDCLC67LWv5lOMoaOh+t+Oo+4r8gvnHE=;
  b=L4//mvahaodgEPUjIwSsBrpfQeCnGXGk/w58r+wZN6WBgSOI10RvLwz6
   jdSWnyY09PtJXftpcejkJRpQeHKiwKggKXBBlpLzdt0C8A/auB4mGHzV+
   1NESLqiJcJSFF/X1h9e3bxZR5zvToIbAUlPYNXbuesWWuV9RrHH7GTXZa
   Xt2+ZCdEsDLrZbKXXVIt2jojHDKXMiYv3CtN+ApinD1yQACZQg+iZS5eE
   hEiCoeg29CpF9nbmOIQPlgWj+qN7ml9K3f9M9uJUthHNfr+Vbx0IUCQ94
   4WltJSLV7CYDLl7o881rgVVYGbwrbMQa9dOqlMVuOqMPAtEcnSllmV2Ng
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10261"; a="248652781"
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="248652781"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 21:49:50 -0800
X-IronPort-AV: E=Sophos;i="5.88,377,1635231600"; 
   d="scan'208";a="530783595"
Received: from gdhowell-mobl2.amr.corp.intel.com (HELO vverma7-desk.amr.corp.intel.com) ([10.212.78.189])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 21:49:49 -0800
From: Vishal Verma <vishal.l.verma@intel.com>
To: <nvdimm@lists.linux.dev>
Cc: Dan Williams <dan.j.williams@intel.com>,
	Vishal Verma <vishal.l.verma@intel.com>
Subject: [ndctl PATCH] ndctl/test: make inject-smart.sh more tolerant of decimal fields
Date: Thu, 17 Feb 2022 22:49:46 -0700
Message-Id: <20220218054946.535014-1-vishal.l.verma@intel.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1240; h=from:subject; bh=5CY7VAzvb6gzDCLC67LWv5lOMoaOh+t+Oo+4r8gvnHE=; b=owGbwMvMwCXGf25diOft7jLG02pJDEn8xlWigre6WBU55q28zKr3xUafLzG6IOONVmy80NQJCdcf 3M/rKGVhEONikBVTZPm75yPjMbnt+TyBCY4wc1iZQIYwcHEKwETOTWX4K6HeE+7ANm8D82SW4F2bvg spP0hpM8qszzc5+0TeN9vdhZHhhtaUsoYd/lYORzR3VtpXqPYEibduN+OcmT3H5diZxBw2AA==
X-Developer-Key: i=vishal.l.verma@intel.com; a=openpgp; fpr=F8682BE134C67A12332A2ED07AFA61BEA3B84DFF
Content-Transfer-Encoding: 8bit

Some combinations of json-c/jq/other libraries seem to produce differing
outputs for the final jq-filtered smart fields, in that some have a
decimal "42.0" numeric field, where as in other combinations it is a
simple "42" (still a numeric field, not string).

This shouldn't matter in practice, but for this contrived test case, we
need to make sure that "42" is treated the same as "42.0"

Normalize all fields before comparing them to "%0.0f" so that the
comparison doesn't result in superfluous failures.

Reported-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
---
 test/inject-smart.sh | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/test/inject-smart.sh b/test/inject-smart.sh
index 8b91360..046322b 100755
--- a/test/inject-smart.sh
+++ b/test/inject-smart.sh
@@ -105,13 +105,13 @@ get_field()
 	json="$($NDCTL list -b $bus -d $dimm -H)"
 	val="$(jq -r ".[].dimms[].health.$smart_listing" <<< $json)"
 	val="$(translate_val $val)"
-	echo $val
+	printf "%0.0f\n" "$val"
 }
 
 verify()
 {
 	local field="$1"
-	local val="$2"
+	local val="$(printf "%0.0f\n" "$2")"
 
 	[[ "$val" == "$(get_field $field)" ]]
 }
-- 
2.34.1

