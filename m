Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 80438210DC1BF
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 06:18:06 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 1C761AC00FD
 for <linux-nvdimm@lists.01.org>; Tue,  7 Aug 2018 22:18:02 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH 0/4] Some fixups and improvements ndctl monitor
Date: Tue,  7 Aug 2018 22:17:52 +0900
Message-Id: <20180807131756.23673-1-qi.fuli@jp.fujitsu.com>
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

Fix a couple of issues about log collection, and add [Install] section
to systemd unit file of ndclt-monitor.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
QI Fuli (4):
  ndctl, monitor: fix the lack of detection of invalid path of log file
  ndctl, monitor: set default log destination to syslog if "--daemon" is specified
  ndctl, monitor: add timestamp and pid to log messages in log_file()
  ndctl, monitor: add [Install] Section to systemd unit file of ndctl-monitor

 Documentation/ndctl/ndctl-monitor.txt | 16 +++++++++++++++-
 ndctl/monitor.c                       | 27 ++++++++++++++++++++++++---
 ndctl/monitor.conf                    |  2 ++
 ndctl/ndctl-monitor.service           |  3 +++
 4 files changed, 44 insertions(+), 4 deletions(-)

-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
