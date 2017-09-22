Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3272121E43B5C
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 00:41:49 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 74D0CAC0150
 for <linux-nvdimm@lists.01.org>; Fri, 22 Sep 2017 16:44:50 +0900 (JST)
Date: Fri, 22 Sep 2017 16:44:44 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [PATCH v4 0/3] acpi nfit: make emulation of translate SPA on nfit_test
Message-Id: <20170922164440.4A35.E1E9C6FF@jp.fujitsu.com>
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


Hello

I made a v4 patch set to emulate translate SPA by nfit_test.ko module.
If possible, please merge it.

----
This patch set is to emulate translate SPA feature by nfit_test.ko.

Certainly the nfit acpi driver supports translate SPA interface 
via ND_CMD_CALL. But nfit_test does not support it yet.

To test translate SPA with nfit_test, this patch set is needed.

---
Change log since v3 [1]:
  - Rebase current libnvdimm-for-next branch.
  - Fix over 80 character lines and too much tabs which is pointed
    by Verma-san. (Thanks!)
  - Since ndctl became to use the name "nfit_cmd" instead of "passthru",
    "passthru" is renamed to "nfit_cmd".

Change log since v2 [2]:
 - Make private defintion just for nfit_test.
    (NFIT_CMD_TRANSLATE_SPA, struct nd_cmd_translate_spa, and others)
 - Check region by kobj.name instead of using is_nd_pmem().


Change log since v1 [3]:
 - Separate patch set of kenel from ndctl patch set.
 - Change interface via ND_CMD_CALL.

[1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05863.html
[2] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05582.html
[3] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html

----

Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
