Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym03.jp.fujitsu.com (mgwym03.jp.fujitsu.com [211.128.242.42])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CB21C2095DE6F
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:31:51 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by yt-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 8678CAC0118
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:32:57 +0900 (JST)
Date: Thu, 31 Aug 2017 10:32:41 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v3 0/3] acpi nfit: make emulation of translate SPA on nfit_test
Message-Id: <20170831103238.DA41.E1E9C6FF@jp.fujitsu.com>
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
To: NVDIMM-ML <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>


This patch set is to emulate translate SPA feature by nfit_test.ko.

Certainly the nfit acpi driver supports translate SPA interface 
via ND_CMD_CALL. But nfit_test does not support it yet.

To test translate SPA with nfit_test, this patch set is needed.

---
Change log since v2 [1]:
 - Make private defintion just for nfit_test.
    (NFIT_CMD_TRANSLATE_SPA, struct nd_cmd_translate_spa, and others)
 - Check region by kobj.name instead of using is_nd_pmem().


Change log since v1 [2]:
 - Separate patch set of kenel from ndctl patch set.
 - Change interface via ND_CMD_CALL.

[1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05582.html
[2] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html

----

Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
