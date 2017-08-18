Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4FEAC21E7903C
 for <linux-nvdimm@lists.01.org>; Thu, 17 Aug 2017 21:29:14 -0700 (PDT)
Received: from m3050.s.css.fujitsu.com (msm.b.css.fujitsu.com [10.134.21.208])
 by kw-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 1EE0DAC00CD
 for <linux-nvdimm@lists.01.org>;
 Fri, 18 Aug 2017 13:31:36 +0900 (JST)
Date: Fri, 18 Aug 2017 13:31:26 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH 0/4] show broken dimm info with translate SPA feature
Message-Id: <20170818133124.8EAB.E1E9C6FF@jp.fujitsu.com>
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

Hello,

I wrote v2 patch set to show broken NVDIMM for ndctl list command.
Please check it.


---
Change log since v1 [1]:
 - Use ND_CMD_CALL to call translate SPA feature.
 - Separate patch set of ndctl from kernel patch set.
 - Add a interface to check what feature can call via ND_CMD_CALL by reading
   /device/nfit/dsm_mask 
 - Get only one nvdimm handle and DPA via ioctl() for the time being.
 - Bug fix which i found
     fix calculation of SPA from bad block at dev_badblocks_to_json().



[1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html


----
This patch set is to show information of broken NVDIMM on ndctl.

When a region has a broken block, user need to replace
the NVDIMM which includes the block.
However there is no information to find which DIMM module have the block.
Not only ndctl does not have such information, nvdimm driver can not
find it.


Fortunately, ACPI 6.2 has new specification of _DSM.
It is "translate spa" which can get NVDIMM handle
and DPA(Dimm Physical Address) from SPA(system Physical Addreess).
It helps for ndctl command to find broken NVDIMM.

This patch set includes followings.
 - some preparations to call Translate SPA via ND_CMD_CALL.
 - libndctl supports Translate SPA interface,
 - ndctl list command show bad DIMM with Translate SPA.


Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
