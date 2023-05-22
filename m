Received: from esa6.hc1455-7.c3s2.iphmx.com (esa6.hc1455-7.c3s2.iphmx.com [68.232.139.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6531646AF
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 06:53:12 +0000 (UTC)
X-IronPort-AV: E=McAfee;i="6600,9927,10717"; a="118607969"
X-IronPort-AV: E=Sophos;i="6.00,183,1681138800"; 
   d="scan'208";a="118607969"
Received: from unknown (HELO oym-r4.gw.nic.fujitsu.com) ([210.162.30.92])
  by esa6.hc1455-7.c3s2.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 May 2023 15:52:00 +0900
Received: from oym-m3.gw.nic.fujitsu.com (oym-nat-oym-m3.gw.nic.fujitsu.com [192.168.87.60])
	by oym-r4.gw.nic.fujitsu.com (Postfix) with ESMTP id DFDABDDC63
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:57 +0900 (JST)
Received: from kws-ab1.gw.nic.fujitsu.com (kws-ab1.gw.nic.fujitsu.com [192.51.206.11])
	by oym-m3.gw.nic.fujitsu.com (Postfix) with ESMTP id 21264D9461
	for <nvdimm@lists.linux.dev>; Mon, 22 May 2023 15:51:57 +0900 (JST)
Received: from localhost.localdomain (unknown [10.167.226.45])
	by kws-ab1.gw.nic.fujitsu.com (Postfix) with ESMTP id 669751145B82;
	Mon, 22 May 2023 15:51:56 +0900 (JST)
From: Li Zhijian <lizhijian@fujitsu.com>
To: nvdimm@lists.linux.dev
Cc: linux-cxl@vger.kernel.org,
	Li Zhijian <lizhijian@fujitsu.com>
Subject: [ndctl PATCH v2 3/6] cxl/monitor: use strcmp to compare the reserved word
Date: Mon, 22 May 2023 14:51:45 +0800
Message-Id: <20230522065148.818977-4-lizhijian@fujitsu.com>
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
X-TMASE-Result: 10--4.808400-10.000000
X-TMASE-MatchedRID: 5cMIDPsUQeR/s7IOpKdgtx1kSRHxj+Z5RpgtqnD1BD4yiHqxwIX2MWeX
	mwoqwyphxQTdQMAU4mRZrjNEQuAJgh/Qfe1gmZY9IBYc5Hfv4BPBOVz0Jwcxl6vCrG0TnfVUg9x
	e4gtUJtrIv3U+D7ZhENwU8VHXGipCHxPMjOKY7A/+HHE8LDNSg8RB0bsfrpPIcSqbxBgG0w7eBg
	R0j9VYUfwQigB/IQfQ1Bx2kRmXWMSGYZjW7uqX8puwzcSYfG5zSzXAJYi2bOTKH+L+kVEuvO0Zn
	KZRWS9/2MK+E9GcckZbjBuldNvkMkoq97WSHdFjfupJaud1uZCfRs6uIbkFVw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-22:0,33:0,34:0-0

According to its document, when '-l standard' is specified, log would be
output to the stdout. But actually, since it's using strncmp(a, b, 10)
to compare the former 10 characters, it will also wrongly treat a filename
starting with a substring 'standard' to stdout.

For example:
$ cxl monitor -l standard.log

User is most likely want to save log to ./standard.log instead of stdout.

Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
---
V2: commit log updated # Dave
---
 cxl/monitor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/cxl/monitor.c b/cxl/monitor.c
index f0e3c4c3f45c..179646562187 100644
--- a/cxl/monitor.c
+++ b/cxl/monitor.c
@@ -188,7 +188,7 @@ int cmd_monitor(int argc, const char **argv, struct cxl_ctx *ctx)
 	else
 		monitor.ctx.log_priority = LOG_INFO;
 
-	if (strncmp(log, "./standard", 10) == 0)
+	if (strcmp(log, "./standard") == 0)
 		monitor.ctx.log_fn = log_standard;
 	else {
 		monitor.ctx.log_file = fopen(log, "a+");
-- 
2.29.2

