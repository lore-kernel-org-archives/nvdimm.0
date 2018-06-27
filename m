Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E5BE221B02845
 for <linux-nvdimm@lists.01.org>; Tue, 26 Jun 2018 22:25:06 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 5FB9CAC054D
 for <linux-nvdimm@lists.01.org>; Wed, 27 Jun 2018 14:24:57 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v8 0/3] ndctl, monitor: add ndctl monitor daemon
Date: Wed, 27 Jun 2018 14:24:23 +0900
Message-Id: <20180627052426.26020-1-qi.fuli@jp.fujitsu.com>
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

This is the v8 patch for ndctl monitor, a tiny daemon to monitor
the smart events of nvdimm DIMMs. Since NVDIMM does not have a
feature like mirroring, if it breaks down, the data will be
impossible to restore. Ndctl monitor daemon will catch the smart
events notify from firmware and outputs notification to logfile,
therefore users can replace NVDIMM before it is completely broken.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
Change log since v7:
 - Replacing logreport() with log_file() and log_syslog()
 - Refactoring read_config_file()
 - Replacing set_confile() with parse_config()
 - Fixing the ndctl/ndct.conf file

Change log since v6:
 - Changing License to GPL-2.0
 - Adding event object to output notification
 - Adding [--dimm-event] option to filter notification by event type
 - Rewriting read_config_file()
 - Replacing monitor_dimm_event() with monitor_event()
 - Renaming some variables

Change log since v5:
 - Fixing systemd unit file cannot be installed bug
 - Adding license to ./util/abspath.c

Change log since v4:
 - Adding OPTION_FILENAME to make sure filename is correct
 - Adding configuration file
 - Adding [--config-file] option to override the default configuration
 - Making some options support multiple space-seperated arguments
 - Making systemctl enable ndctl-monitor.service command work
 - Making systemctl restart ndctl-monitor.service command work
 - Making the directory of systemd unit file to be configurable
 - Changing log_file() and log_syslog() to logreport()
 - Changing date format in notification to nanoseconds since epoch
 - Changing select() to epoll()
 - Adding filter_bus() and filter_region()

Change log since v3:
 - Removing create-monitor, show-monitor, list-monitor, destroy-monitor
 - Adding [--daemon] option to run ndctl monitor as a daemon 
 - Using systemd to manage ndctl monitor daemon
 - Replacing filter_monitor_dimm() with filter_dimm()

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

QI Fuli (3):
  ndctl, monitor: add ndctl monitor
  ndctl, monitor: add main ndctl monitor configuration file
  ndctl, monitor: add the unit file of systemd for ndctl-monitor service

 autogen.sh                  |   3 +-
 builtin.h                   |   1 +
 configure.ac                |  22 ++
 ndctl/Makefile.am           |  12 +-
 ndctl/monitor.c             | 623 ++++++++++++++++++++++++++++++++++++
 ndctl/monitor.conf          |  41 +++
 ndctl/ndctl-monitor.service |   7 +
 ndctl/ndctl.c               |   1 +
 8 files changed, 708 insertions(+), 2 deletions(-)
 create mode 100644 ndctl/monitor.c
 create mode 100644 ndctl/monitor.conf
 create mode 100644 ndctl/ndctl-monitor.service

-- 
2.17.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
