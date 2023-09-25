Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13B1C250FF
	for <nvdimm@lists.linux.dev>; Mon, 25 Sep 2023 22:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695680198; x=1727216198;
  h=from:date:subject:mime-version:content-transfer-encoding:
   message-id:to:cc;
  bh=OaB6hJF19s8EbOqBpmYN3HuqmyKNHrKoXf6QHQzEAfY=;
  b=cfdX3G8OnyEA+BVkL3DPKBpj7Q5slwSXKJMVULfbB9WW5+0MQghduWhY
   YIwKbkB4lrjWfTuZ/i+38LE1gQwvA92eRleKC6llp+VofA65GLQAH/xH4
   Qj7lGqXRyWzjXO4Qp1oLemvoxu7LgbrjvaCPmFlyLrfpbQzAi/cuHyyq7
   ba1ntIM8cAYGEmN/E1pwV+DcUzWhYOSPJQNkhY35JMNsSUU9F76so5Mau
   5WDe4VbKxogpHc2vv78KqJ99l1lFIhsypOZiAFkqNE7tBdylyk/Vi8Bcm
   IyUCWUF2P/gLwu36OBxWcNUlofFn7pzOa2EYOKKQ5GIE811Zsz79dKa7l
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="412335635"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="412335635"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 15:16:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="742088741"
X-IronPort-AV: E=Sophos;i="6.03,176,1694761200"; 
   d="scan'208";a="742088741"
Received: from iweiny-desk3.amr.corp.intel.com (HELO localhost) ([10.212.66.94])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 15:16:16 -0700
From: Ira Weiny <ira.weiny@intel.com>
Date: Mon, 25 Sep 2023 15:16:09 -0700
Subject: [PATCH ndctl RESEND] test/cxl-event: Skip cxl event testing if
 cxl-test is not available
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20230925-skip-cxl-events-v1-1-bdad7cceb80b@intel.com>
X-B4-Tracking: v=1; b=H4sIAKgGEmUC/3WNsQ6CMBRFf4W82WdoFQxODrI66GgY2vqQF6GQl
 jQYwr9b2B3vuTk5M3hyTB7OyQyOAnvubRxil4BplH0T8itukKk8pIXM0H94QDO1SIHs6PFUizz
 NpC7MkSBaWnlC7ZQ1zep1iu2KB0c1T1voCffyUd6uUEXesB979936QWzv31QQKFAqnYssl3Vhx
 IXtSO3e9B1Uy7L8AO6LTzXNAAAA
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
 Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>
X-Mailer: b4 0.13-dev-0f7f0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1695680176; l=970;
 i=ira.weiny@intel.com; s=20221222; h=from:subject:message-id;
 bh=OaB6hJF19s8EbOqBpmYN3HuqmyKNHrKoXf6QHQzEAfY=;
 b=APA6/NsmFmqiiRw5ZWfgLuwM/JS/PPa7wvzZd2jJi/MkfvwKpe6zmh50oPNMO8OAoMeMJ3gmh
 B2cAFPdxm2tDiFvduQIEYexywEp6MCVxaBf6tr1mt7OEnWuU1RDn6JN
X-Developer-Key: i=ira.weiny@intel.com; a=ed25519;
 pk=brwqReAJklzu/xZ9FpSsMPSQ/qkSalbg6scP3w809Ec=

CXL event testing is only appropriate when the cxl-test modules are
available.

Return error 77 (skip) if cxl-test modules are not available.

Reported-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
Changes for resend:
- iweiny: properly cc the mailing lists
---
 test/cxl-events.sh | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/test/cxl-events.sh b/test/cxl-events.sh
index 33b68daa6ade..fe702bf98ad4 100644
--- a/test/cxl-events.sh
+++ b/test/cxl-events.sh
@@ -10,6 +10,8 @@ num_fatal_expected=2
 num_failure_expected=16
 num_info_expected=3
 
+rc=77
+
 set -ex
 
 trap 'err $LINENO' ERR
@@ -18,6 +20,7 @@ check_prereq "jq"
 
 modprobe -r cxl_test
 modprobe cxl_test
+rc=1
 
 dev_path="/sys/bus/platform/devices"
 

---
base-commit: a871e6153b11fe63780b37cdcb1eb347b296095c
change-id: 20230925-skip-cxl-events-7f16052b9c4e

Best regards,
-- 
Ira Weiny <ira.weiny@intel.com>

