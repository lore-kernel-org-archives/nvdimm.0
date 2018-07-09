Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B2B91203B99A8
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 07:18:08 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 3A7CBAC0104
 for <linux-nvdimm@lists.01.org>; Mon,  9 Jul 2018 23:18:04 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v10 0/4] ndctl, monitor: add ndctl monitor daemon
Date: Mon,  9 Jul 2018 23:17:14 +0900
Message-Id: <20180709141718.6205-1-qi.fuli@jp.fujitsu.com>
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

This is the v10 patch for ndctl monitor, a tiny daemon to monitor
the smart events of nvdimm DIMMs. Since NVDIMM does not have a
feature like mirroring, if it breaks down, the data will be
impossible to restore. Ndctl monitor daemon will catch the smart
events notify from firmware and outputs notification to logfile,
therefore users can replace NVDIMM before it is completely broken.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
---
Change log since v9:
 - Replacing ndctl_cmd_smart_get_event_flags() with
   ndctl_dimm_get_event_flags()
 - Adding ndctl_dimm_get_health() api
 - Adding ndctl_dimm_get_flags() api
 - Adding ndctl_dimm_is_flag_supported api
 - Adding manpage

Change log since v8:
 - Adding ndctl_cmd_smart_get_event_flags() api
 - Adding monitor_filter_arg to the union in util_filter_ctx
 - Removing is_dir()
 - Replacing malloc + vsprintf with vasprintf() in log_file() and log_syslog()
 - Adding parse_monitor_event()
 - Refactoring util_dimm_event_filter()
 - Adding event_flags to monitor
 - Refactoring dimm_event_to_json()
 - Adding check_dimm_supported_threshold_alarms()
 - Fixing fail token

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

QI Fuli (4):
  ndctl, monitor: add a new command - monitor
  ndctl, monitor: add main ndctl monitor configuration file
  ndctl, monitor: add the unit file of systemd for ndctl-monitor service
  ndctl, documentation: add manpage for monitor

 Documentation/ndctl/Makefile.am       |   3 +-
 Documentation/ndctl/ndctl-monitor.txt |  96 ++++
 autogen.sh                            |   3 +-
 builtin.h                             |   1 +
 configure.ac                          |  22 +
 ndctl/Makefile.am                     |  12 +-
 ndctl/lib/libndctl.c                  |  82 ++++
 ndctl/lib/libndctl.sym                |   4 +
 ndctl/libndctl.h                      |  10 +
 ndctl/monitor.c                       | 623 ++++++++++++++++++++++++++
 ndctl/monitor.conf                    |  41 ++
 ndctl/ndctl-monitor.service           |   7 +
 ndctl/ndctl.c                         |   1 +
 util/filter.h                         |   9 +
 14 files changed, 911 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ndctl/ndctl-monitor.txt
 create mode 100644 ndctl/monitor.c
 create mode 100644 ndctl/monitor.conf
 create mode 100644 ndctl/ndctl-monitor.service

-- 
2.18.0


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
