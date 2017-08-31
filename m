Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm01.jp.fujitsu.com (mgwkm01.jp.fujitsu.com [202.219.69.168])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 683FA21E70D3D
 for <linux-nvdimm@lists.01.org>; Wed, 30 Aug 2017 18:20:20 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 41974AC00BA
 for <linux-nvdimm@lists.01.org>; Thu, 31 Aug 2017 10:21:23 +0900 (JST)
Date: Thu, 31 Aug 2017 10:21:04 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH v3 0/5] show broken dimm info with translate SPA feature.
Message-Id: <20170831102101.DA2C.E1E9C6FF@jp.fujitsu.com>
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


Hi,

I wrote v3 patch set to show broken NVDIMM for ndctl list command.
Please check it.

---
Change log since v2 [1]:
 - Make libndctl-nfit.h and libndctl-nfit.c and define new interfaces
   which use translate spa on them.
 - Add sanity checks for new interfaces.
 - Fix some names
      o trans_spa -> translate_spa
      o sub_cmd -> passthru_cmd
   

Change log since v1 [2]:
 - Use ND_CMD_CALL to call translate SPA feature.
 - Separate patch set of ndctl from kernel patch set.
 - Add a interface to check what feature can call via ND_CMD_CALL by reading
   /device/nfit/dsm_mask 
 - Get only one nvdimm handle and DPA via ioctl() for the time being.
 - Bug fix which i found
     fix calculation of SPA from bad block at dev_badblocks_to_json().



[1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05577.html
[2] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html


----
This patch set is to show information of broken NVDIMM on ndctl.

When a region has a broken block, user needs to replace
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
 - libndctl-nfit supports Translate SPA interface,
 - ndctl list command show bad DIMM with Translate SPA.


Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
