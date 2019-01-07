Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B018F21B02822
 for <linux-nvdimm@lists.01.org>; Mon,  7 Jan 2019 00:38:47 -0800 (PST)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id A46E3AC0137
 for <linux-nvdimm@lists.01.org>; Mon,  7 Jan 2019 17:38:43 +0900 (JST)
From: QI Fuli <qi.fuli@jp.fujitsu.com>
Subject: [ndctl PATCH v2 0/2] ndctl, monitor: refactor read_config_file
Date: Mon,  7 Jan 2019 17:38:31 +0900
Message-Id: <20190107083833.25941-1-qi.fuli@jp.fujitsu.com>
MIME-Version: 1.0
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

This patch set is used for refactoring read_config_file by using
ccan/ciniparser library.

Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>
--
Change log since v1:
- Fix the conflicts with the lastest cleanup patch of monitor

QI Fuli (2):
  ndctl: add the ciniparser tool from ccan
  ndctl, monitor: refactor read_config_file

 Makefile.am                  |   6 +-
 ccan/ciniparser/LICENSE      |   1 +
 ccan/ciniparser/ciniparser.c | 480 +++++++++++++++++++++++++++++++++++
 ccan/ciniparser/ciniparser.h | 262 +++++++++++++++++++
 ccan/ciniparser/dictionary.c | 266 +++++++++++++++++++
 ccan/ciniparser/dictionary.h | 166 ++++++++++++
 ndctl/Makefile.am            |   1 +
 ndctl/monitor.c              | 115 +++------
 ndctl/monitor.conf           |   2 +
 9 files changed, 1212 insertions(+), 87 deletions(-)
 create mode 120000 ccan/ciniparser/LICENSE
 create mode 100644 ccan/ciniparser/ciniparser.c
 create mode 100644 ccan/ciniparser/ciniparser.h
 create mode 100644 ccan/ciniparser/dictionary.c
 create mode 100644 ccan/ciniparser/dictionary.h

-- 
2.20.1


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
