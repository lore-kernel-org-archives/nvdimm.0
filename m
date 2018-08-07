Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm03.jp.fujitsu.com (mgwkm03.jp.fujitsu.com [202.219.69.170])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3D615210DC1BF
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 06:18:13 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 01813AC00A4
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 22:18:07 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH 4/4] ndctl,
 monitor: add [Install] Section to systemd unit file of ndctl-monitor
Date: Tue,  7 Aug 2018 22:17:56 +0900
Message-Id: <20180807131756.23673-5-qi.fuli@jp.fujitsu.com>
In-Reply-To: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
References: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch is used to add "[Install]" section to systemd unit file of
ndctl-monitor. Therefore, users can set ndctl-monitor unit enable.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
 ndctl/ndctl-monitor.service | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/ndctl/ndctl-monitor.service b/ndctl/ndctl-monitor.service
index 44f9326..342a1b1 100644
--- a/ndctl/ndctl-monitor.service
+++ b/ndctl/ndctl-monitor.service
@@ -5,3 +5,6 @@ Description=Ndctl Monitor Daemon
 Type=forking
 ExecStart=/usr/bin/ndctl monitor --daemon
 ExecStop=/bin/kill ${MAINPID}
+
+[Install]
+WantedBy=multi-user.target
-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
