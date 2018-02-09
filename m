Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A108F223DB78F
 for <linux-nvdimm@lists.01.org>; Thu,  8 Feb 2018 23:56:55 -0800 (PST)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id E9A5AAC012F
 for <linux-nvdimm@lists.01.org>; Fri,  9 Feb 2018 17:02:34 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v3 0/5] ndctl: monitor: monitor the smart events of
Date: Fri,  9 Feb 2018 17:02:20 +0900
Message-Id: <20180209080225.5137-1-qi.fuli@jp.fujitsu.com>
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

This is a patch set of ndctl monitor, a tiny daemon to monitor the smart
events of nvdimm dimms. When a smart event fires, monitor will output
the notification which including dimm health status to syslog or a
special file according to users' configuration. The output notification
follows json format and can be consumed by log collectors like Fluentd.

Currently, I implemeted the following four commands to control monitor daemon.
$ndctl create-monitor
$ndctl list-monitor
$ndctl show-monitor
$ndclt destroy-monitor

I will appreciate if you could give some comments.

Change log since v2:
 - Changing the interface of daemon to the ndctl command line
 - Changing the name of daemon form "nvdimmd" to "monitor"
 - Removing the config file, unit_file, nvdimmd dir
 - Removing nvdimmd_test program
 - Adding ndctl/monitor.c

Change log since v1:
 - Adding a config file(/etc/nvdimmd/nvdimmd.conf)
 - Using struct log_ctx instead of syslog()
    - Using log_syslog() to save the notify messages to syslog
    - Using log_file() to save the notify messages to special file
 - Adding LOG_NOTICE level to log_priority
 - Using automake instead of Makefile
 - Adding a new util file(nvdimmd/util.c) including helper functions
   needed for nvdimm daemon
 - Adding nvdimmd_test program

QI Fuli (5):
  ndctl: monitor: add LOG_NOTICE level to log_priority
  ndctl: monitor: add ndclt create-monitor command
  ndctl: monitor: add ndclt list-monitor command
  ndctl: monitor: add ndclt show-monitor command
  ndctl: monitor: add ndclt destroy-monitor command

 builtin.h         |   4 +
 configure.ac      |   3 +
 ndctl/Makefile.am |   3 +-
 ndctl/monitor.c   | 463 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ndctl/ndctl.c     |   4 +
 util/log.c        |   2 +
 util/log.h        |   3 +
 7 files changed, 481 insertions(+), 1 deletion(-)
 create mode 100644 ndctl/monitor.c

-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
