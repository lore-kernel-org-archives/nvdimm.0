Received: from esa1.hc1455-7.c3s2.iphmx.com (esa1.hc1455-7.c3s2.iphmx.com [207.54.90.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB3F34A30
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:53:13 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="117393824"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="117393824"
Received: from unknown (HELO yto-r2.gw.nic.fujitsu.com) ([218.44.52.218])
  by esa1.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:52:00 +0900
Received: from yto-m2.gw.nic.fujitsu.com (yto-nat-yto-m2.gw.nic.fujitsu.com [192.168.83.65])
	by yto-r2.gw.nic.fujitsu.com (Postfix) with ESMTP id 2E6E1C68E2
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:58 +0900 (JST)
Received: from kws-ab1.gw.nic.fujitsu.com (kws-ab1.gw.nic.fujitsu.com [192.51.206.11])
	by yto-m2.gw.nic.fujitsu.com (Postfix) with ESMTP id 76192D5EA6
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:57 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id BC60D114601F;
	Mon, 22 May 2023 15:51:56 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 4/6] cxl/monitor: always log started message
Date: Mon, 22 May 2023 14:51:46 +0800
Message-Id: <20230522065148.818977-5-lizhijian@fujitsu.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230522065148.818977-1-lizhijian@fujitsu.com>
References: <20230522065148.818977-1-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--12.232700-10.000000
X-TMASE-MatchedRID: fqEte1jlzl/mh3qTH3T2BBlxrtI3TxRkTfK5j0EZbyt9hFikHEFf1nER
	bS7OZpEDwKkZaLNGSWov47gJfywVWSfB+/OOFhyOTuctSpiuWyUUi4Ehat05499RlPzeVuQQE0o
	8W+GU3zDOG+e9aAIpHqepbdVIZ/l3HxPMjOKY7A/+HHE8LDNSg8RB0bsfrpPIfiAqrjYtFiRAzV
	rWwNWPwOq11iEZvCJi7mcbYkc9NgBKL3Fna1bs1X7cGd19dSFd
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

Tell people monitor is starting rather only daemon mode will log this
message before. It's a minor fix so that whatever stdout or logfile
is specified, people can see a *normal* message.

After this patch
 # cxl monitor
 cxl monitor started.
 ^C
 # cxl monitor -l standard.log
 ^C
 # cat standard.log
 [1684735993.704815571] [818499] cxl monitor started.
 # cxl monitor --daemon -l /var/log/daemon.log
 # cat /var/log/daemon.log
 [1684736075.817150494] [818509] cxl monitor started.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: commit log updated # Dave
---
 cxl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index 179646562187..0736483cc50a 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -205,8 +205,8 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 			err(&monitor, "daemon start failed\n");
 			goto out;
 		}
-		info(&monitor, "cxl monitor daemon started.\n");
 	}
+	info(&monitor, "cxl monitor started.\n");
 
 	rc = monitor_event(ctx);
 
-- 
2.29.2

