Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym04.jp.fujitsu.com (mgwym04.jp.fujitsu.com [211.128.242.43])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 136B520946094
 for <linux-nvdimm@lists.01.org>; Sun,  6 May 2018 22:10:21 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id E5D10AC0106
 for <linux-nvdimm@lists.01.org>; Mon,  7 May 2018 14:10:12 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [PATCH v6 0/4] ndctl, monitor: add ndctl monitor daemon
Date: Mon,  7 May 2018 14:09:22 +0900
Message-Id: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
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

This is the v6 patch for ndctl monitor daemon, a tiny daemon to monitor
the smart events of nvdimm DIMMs. Users can run a monitor as a one-shot
command or a daemon in background by using the [--daemon] option. DIMMs
to monitor can be selected by [--dimm] [--bus] [--region] [--namespace]
options, these options support multiple space-seperated arguments.
When a smart event fires, monitor daemon will log the notifications
which including dimm health status to syslog or a logfile by setting
[--logfile=<file|syslog>] option. monitor also can output the
notifications to stderr when it run as one-shot command by setting
[--logfile=<stderr>]. The notifications follow json format and can be
consumed by log collectors like Fluentd. Users can change the
configuration of monitor by editing the default configuration file
/etc/ndctl/monitor.conf or by using [--config-file=<file>] option to
override the default configuration. 

Users can start a monitor daemon by the following command:
 # ndctl monitor --daemon --logfile /var/log/ndctl/monitor.log

Also, a monitor daemon can be started by systemd:
 # systemctl start ndctl-monitor.service
In this case, monitor daemon follows the default configuration file
/etc/ndctl/monitor.conf.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

---
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
  ndctl, util: add OPTION_FILENAME to parse_opt_type
  ndctl, monitor: add ndctl monitor daemon
  ndctl, monitor: add default configuration file
  ndctl, monitor: add the unit file of systemd for ndctl-monitor service

 Makefile.am                 |   3 +-
 autogen.sh                  |   3 +-
 builtin.h                   |   1 +
 configure.ac                |  22 ++
 ndctl/Makefile.am           |  12 +-
 ndctl/monitor.c             | 460 ++++++++++++++++++++++++++++++++++++
 ndctl/monitor.conf          |  37 +++
 ndctl/ndctl-monitor.service |   7 +
 ndctl/ndctl.c               |   1 +
 util/abspath.c              |  29 +++
 util/help.c                 |   5 -
 util/parse-options.c        |  47 +++-
 util/parse-options.h        |  11 +-
 util/util.h                 |   7 +
 14 files changed, 629 insertions(+), 16 deletions(-)
 create mode 100644 ndctl/monitor.c
 create mode 100644 ndctl/monitor.conf
 create mode 100644 ndctl/ndctl-monitor.service
 create mode 100644 util/abspath.c

-- 
2.17.0.140.g0b0cc9f86


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
