Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6E7C4202E5E53
 for <linux-nvdimm@lists.01.org>; Mon, 13 Nov 2017 23:43:08 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 05FDFAC005E
 for <linux-nvdimm@lists.01.org>; Tue, 14 Nov 2017 16:47:13 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [RFC PATCH v2 0/7] ndctl: nvdimmd: notify/monitor the feathers of
 over threshold event
Date: Tue, 14 Nov 2017 16:46:57 +0900
Message-Id: <20171114074704.3446-1-qi.fuli@jp.fujitsu.com>
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

Hi, here is my second version of nvdimm daemon, It would be appreciated
if you could check it.

Change log since v1:
 - Adding a config file(/etc/nvdimmd/nvdimmd.conf)
 - Using struct log_ctx instead of syslog()
   - Using log_syslog() to save the notify messages to syslog
   - Using log_file() to save the notify messages to special file
 - Adding LOG_NOTICE level into log_priority
 - Using automake instead of Makefile
 - Adding a new util file(nvdimmd/util.c) including helper functions needed
   for nvdimm daemon.
 - Adding nvdimmd_test program

---
This is a patch set of nvdimmd, a tiny daemon to monitor the features of over
threshold events. When an over thershold event fires, nvdimmd will output the
notification including dimm health status to syslog or a special file to
users' configuration. Users can choose the output format to be structured json
or text.

Here are out put samples.
- json format:
2017/11/10 11:15:03 [28065] log_notify: nvdimm dimm over threshold notify
{
  "dev":"nmem1",
  "id":"cdab-0a-07e0-feffffff",
  "handle":1,
  "phys_id":1,
  "health":{
    "health_state":"non-critical",
    "temperature_celsius":23,
    "spares_percentage":75,
    "alarm_temperature":true,
    "alarm_spares":true,
    "temperature_threshold":40,
    "spares_threshold":5,
    "life_used_percentage":5,
    "shutdown_state":"clean"
  }
}
- text format:
2017/11/10 16:21:53 [12479] log_notify: nvdimm dimm over threshold notify
dev: nmem1
 health_state: non-critical
 spares_percentage: 75

TODO list:
 - The dimms to monitor should be filtered by namespace and region
 - Add more information into the notify message
 - Make nvdimmd_test an ndctl command or an option of ndctl inject-error

QI Fuli (7):
  ndctl: nvdimmd: add LOG_NOTICE level into log_priority
  ndctl: nvdimmd: add nvdimmd necessary util functions
  ndctl: nvdimmd: add nvdimmd necessary functions
  ndctl: nvdimmd: add body file of nvdimm daemon
  ndctl: nvdimmd: add nvdimmd config file
  ndctl: nvdimmd: add the unit file of systemd for nvdimmd service
  ndctl: nvdimmd: add a temporary test for nvdimm daemon

 Makefile.am             |   2 +-
 configure.ac            |   1 +
 nvdimmd/Makefile.am     |  47 ++++++++
 nvdimmd/libnvdimmd.c    | 315 ++++++++++++++++++++++++++++++++++++++++++++++++
 nvdimmd/libnvdimmd.h    |  53 ++++++++
 nvdimmd/nvdimmd.c       | 112 +++++++++++++++++
 nvdimmd/nvdimmd.conf    |  25 ++++
 nvdimmd/nvdimmd.service |   7 ++
 nvdimmd/nvdimmd_test.c  | 142 ++++++++++++++++++++++
 nvdimmd/util.c          |  80 ++++++++++++
 nvdimmd/util.h          |  33 +++++
 util/log.c              |   2 +
 util/log.h              |   3 +
 13 files changed, 821 insertions(+), 1 deletion(-)
 create mode 100644 nvdimmd/Makefile.am
 create mode 100644 nvdimmd/libnvdimmd.c
 create mode 100644 nvdimmd/libnvdimmd.h
 create mode 100644 nvdimmd/nvdimmd.c
 create mode 100644 nvdimmd/nvdimmd.conf
 create mode 100644 nvdimmd/nvdimmd.service
 create mode 100644 nvdimmd/nvdimmd_test.c
 create mode 100644 nvdimmd/util.c
 create mode 100644 nvdimmd/util.h

-- 
2.9.5


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
