Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93C563C8
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 14:22:03 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10708"; a="117626492"
X-IronPort-AV: E=Sophos;i="5.99,272,1677510000"; 
   d="scan'208";a="117626492"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 May 2023 23:20:51 +0900
Received: from yto-m4.gw.nic.fujitsu.com (yto-nat-yto-m4.gw.nic.fujitsu.com [192.168.83.67])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 426BEC68E2
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:48 +0900 (JST)
Received: from kws-ab3.gw.nic.fujitsu.com (kws-ab3.gw.nic.fujitsu.com [192.51.206.21])
	by yto-m4.gw.nic.fujitsu.com (Postfix) with ESMTP id 82025D3F00
	for <nvdimm@lists.linux.dev>; Sat, 13 May 2023 23:20:47 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab3.gw.nic.fujitsu.com (Postfix) with ESMTP id E3E572007CDDD;
	Sat, 13 May 2023 23:20:46 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH 0/6] cxl/monitor and ndctl/monitor fixes
Date: Sat, 13 May 2023 22:20:32 +0800
Message-Id: <20230513142038.753351-1-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSS-9.1.0.1417-9.0.0.1002-27622.007
X-TM-AS-User-Approved-Sender: Yes
X-TMASE-Version: IMSS-9.1.0.1417-9.0.1002-27622.007
X-TMASE-Result: 10--12.003500-10.000000
X-TMASE-MatchedRID: 1Eu80e4q/YQvKBNTYKG+pVhRyidsElYkZR+OFNkbtdo5tco/jPiDm8rM
	f2YsbSCKsO8/6EKWP4/pJX2bP1RYr0AmNAVBRJ9hJAtcI9QUBGsEa8g1x8eqFzVjvc93O9dkGZG
	2q5y4jkF7MSP7SLpuGG9yZj3aufb5HxPMjOKY7A+Wlioo2ZbGwdmzcdRxL+xwKrauXd3MZDXt+7
	WsvSOmi/C1+rKtAsAyU1pvK+qI91BB1EgYL0jh18goQpZ4D7fw
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

It mainly fix monitor not working when log file is specified. For
example
$ cxl monitor -l ./cxl-monitor.log
It seems that someone missed something at the begining.

Furture, it compares the filename with reserved works more accurately

Li Zhijian (6):
  cxl/monitor: Fix monitor not working
  cxl/monitor: compare the whole filename with reserved words
  cxl/monitor: Enable default_log and refactor sanity check
  cxl/monitor: always log started message
  Documentation/cxl/cxl-monitor.txt: Fix inaccurate description
  ndctl/monitor: compare the whole filename with reserved words

 Documentation/cxl/cxl-monitor.txt |  3 +-
 cxl/monitor.c                     | 47 ++++++++++++++++---------------
 ndctl/monitor.c                   |  4 +--
 3 files changed, 27 insertions(+), 27 deletions(-)

-- 
2.29.2

