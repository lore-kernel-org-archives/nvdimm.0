Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B10F23D2
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:53:10 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="117393822"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="117393822"
Received: from unknown (HELO oym-r3.gw.nic.fujitsu.com) ([210.162.30.91])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:51:59 +0900
Received: from oym-m4.gw.nic.fujitsu.com (oym-nat-oym-m4.gw.nic.fujitsu.com [192.168.87.61])
	by oym-r3.gw.nic.fujitsu.com (Postfix) with ESMTP id EBB19CA1E6
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:56 +0900 (JST)
Received: from kws-ab1.gw.nic.fujitsu.com (kws-ab1.gw.nic.fujitsu.com [192.51.206.11])
	by oym-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 25389D4C19
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:56 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id 6BDBF11456CA;
	Mon, 22 May 2023 15:51:55 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 0/6] cxl/monitor and ndctl/monitor fixes
Date: Mon, 22 May 2023 14:51:42 +0800
Message-Id: <20230522065148.818977-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1408-9.0.0.1002-27642.005
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1408-9.0.1002-27642.005
X-TMASE-Result: 10--15.705800-10.000000
X-TMASE-MatchedRID: lefCZilwG1QL0MkR8StpMKoXHZz/dXlxyiKgKtIyB4oyiHqxwIX2MVYM
	JR3dIrh2x8o59scni6zp/lHXBmQcxnqDDsxI37Z8sjFnB5RHQ19LGPRv0WdxQt9zZd3pUn7Kffw
	OGyRfzzO+959IOAxa3ZVZrNbX8SJvaYizM4uRZ4UkC1wj1BQEa7TrV2IG143XdqX0RP2SMcepuz
	6cn+0UkbvlPk1VIqp1gDLqnrRlXrbIDt27MLDp0t0H8LFZNFG7bkV4e2xSge7lUP9lzy7KHbHym
	MiQauFOCfup4XgjsmEpEBNkJd5bdEsMHBii02BH
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

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

