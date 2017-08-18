Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwym02.jp.fujitsu.com (mgwym02.jp.fujitsu.com [211.128.242.41])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7726121E79008
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 21:44:11 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id AC6F6AC013C
 for <linux-nvdimm@lists.01.org>;
 Fri, 18 Aug 2017 13:46:32 +0900 (JST)
Date: Fri, 18 Aug 2017 13:46:29 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH 0/3] acpi nfit: make emulation of translate SPA on nfit_test
Message-Id: <20170818134627.8EBC.E1E9C6FF@jp.fujitsu.com>
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
Change log since v1 [1]:
 - Separate patch set of kenel from ndctl patch set.
 - Change interface via ND_CMD_CALL.


[1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html

----

Thanks,
---
Yasunori Goto



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
