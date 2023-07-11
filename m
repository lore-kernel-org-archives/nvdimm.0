Received: from esa5.hc1455-7.c3s2.iphmx.com (esa5.hc1455-7.c3s2.iphmx.com [68.232.139.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7502F18B10
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 11:55:07 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10767"; a="123651478"
X-IronPort-AV: E=Sophos;i="6.01,196,1684767600"; 
   d="scan'208";a="123651478"
Received: from unknown (HELO yto-r3.gw.nic.fujitsu.com) ([218.44.52.219])
  by esa5.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jul 2023 20:53:57 +0900
Received: from yto-m1.gw.nic.fujitsu.com (yto-nat-yto-m1.gw.nic.fujitsu.com [192.168.83.64])
	by yto-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id A9DC1D501A
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 20:53:54 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m1.gw.nic.fujitsu.com (Postfix) with ESMTP id E6D93CFBC3
	for <nvdimm@lists.linux.dev>; Tue, 11 Jul 2023 20:53:53 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.234.230])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id 3C19D20077BB3;
	Tue, 11 Jul 2023 20:53:53 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev,
	alison.schofield@intel.com
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v4 0/4] cxl/monitor and ndctl/monitor fixes
Date: Tue, 11 Jul 2023 19:53:40 +0800
Message-Id: <20230711115344.562823-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27744.006
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27744.006
X-TMASE-Result: 10--12.270100-10.000000
X-TMASE-MatchedRID: abh1Ba7f5/Ck+AYa0R5ReDBgCmbnj9JmeQYwLifQh6TQarzCEH4/6k7O
	1kmXN49bdZ+iOIKZPqKY2UnY8YSSrbyftOl1RBuHX9knSHW8uXVc8r3LfPzYa6CjQPEjtbB0KZQ
	/22HSWdWcrQThtVmcVoZ8hVKNlDAflrdKJAp7UJnkKCFOKwAEzEsY9G/RZ3FC33Nl3elSfsp9/A
	4bJF/PM2y5fJhI8kWvsSi51GiVI1KUhduZoKKMKPSG/+sPtZVkZFW4zmF+QEJ2pfRE/ZIxx6m7P
	pyf7RSRu+U+TVUiqnWAMuqetGVetsgO3bswsOnS3QfwsVk0UbtuRXh7bFKB7nieVFIFjPpQZWJr
	lTtYkBpzCkjdA54NZSENpV1Zlh4KlExlQIQeRG0=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

V4:
  - Add reviewed tags and minor fixes including comment style and
changelog update
  - combine "cxl/monitor: use strcmp to compare the reserved word" and
    "ndctl/monitor: use strcmp to compare the reserved word" to one
    patch
  - Drop "cxl/monitor: always log started message" which would break a
    json output.

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


*** BLURB HERE ***

Li Zhijian (4):
  cxl/monitor: Enable default_log and refactor sanity check
  cxl/monitor: replace monitor.log_file with monitor.ctx.log_file
  ndctl: use strcmp for reserved word in monitor commands
  Documentation/cxl/cxl-monitor.txt: Fix inaccurate description

 Documentation/cxl/cxl-monitor.txt |  3 +--
 cxl/monitor.c                     | 43 ++++++++++++++++---------------
 ndctl/monitor.c                   |  4 +--
 3 files changed, 25 insertions(+), 25 deletions(-)

-- 
2.29.2

