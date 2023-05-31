Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA34A1390
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 02:21:00 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10726"; a="120056228"
X-IronPort-AV: E=Sophos;i="6.00,205,1681138800"; 
   d="scan'208";a="120056228"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2023 11:19:49 +0900
Received: from oym-m1.gw.nic.fujitsu.com (oym-nat-oym-m1.gw.nic.fujitsu.com [192.168.87.58])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id 65977C53CA
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:46 +0900 (JST)
Received: from kws-ab4.gw.nic.fujitsu.com (kws-ab4.gw.nic.fujitsu.com [192.51.206.22])
	by oym-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id 984F9D5017
	for <nvdimm@lists.linux.dev>; Wed, 31 May 2023 11:19:45 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab4.gw.nic.fujitsu.com (Postfix) with ESMTP id EE6E568957;
	Wed, 31 May 2023 11:19:44 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v3 0/6] cxl/monitor and ndctl/monitor fixes
Date: Wed, 31 May 2023 10:19:30 +0800
Message-Id: <20230531021936.7366-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27662.004
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27662.004
X-TMASE-Result: 10--18.205800-10.000000
X-TMASE-MatchedRID: VHY4TuAmxSOUEaJ+MItbXqzSsZt54aj7bo9qnUw920fozDhGeQC9EimU
	P9th0lnVnK0E4bVZnFaGfIVSjZQwH5a3SiQKe1CZ5CghTisABMxfT3wDt+vdVw3H/quqvfm40A4
	5IAXRxM1TeKr01gQwdETfkJk5S8qAY0bQ0Hs1qBljeVefXUd21GRVuM5hfkBCNWO9z3c712QZkb
	arnLiOQXsxI/tIum4Yb3JmPdq59vkfE8yM4pjsD67rlQMPRoOCxEHRux+uk8jpP8tMOyYmaA==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

V3:
- update comit log of patch3 and patch6 per Dave's comments.

V2:
- exchange order of previous patch1 and patch2
- add reviewed tag in patch5
- commit log improvements

It mainly fix monitor not working when log file is specified. For
example
$ cxl monitor -l ./cxl-monitor.log
It seems that someone missed something at the begining.

Furture, it compares the filename with reserved word more accurately

patch1-2: It re-enables logfile(including default_log) functionality
and simplify the sanity check in the combination relative path file
and daemon mode.

patch3 and patch6 change strncmp to strcmp to compare the acurrate
reserved words.

Li Zhijian (6):
  cxl/monitor: Enable default_log and refactor sanity check
  cxl/monitor: replace monitor.log_file with monitor.ctx.log_file
  cxl/monitor: use strcmp to compare the reserved word
  cxl/monitor: always log started message
  Documentation/cxl/cxl-monitor.txt: Fix inaccurate description
  ndctl/monitor: use strcmp to compare the reserved word

 Documentation/cxl/cxl-monitor.txt |  3 +--
 cxl/monitor.c                     | 45 ++++++++++++++++---------------
 ndctl/monitor.c                   |  4 +--
 3 files changed, 26 insertions(+), 26 deletions(-)

-- 
2.29.2

