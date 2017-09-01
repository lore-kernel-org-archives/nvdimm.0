Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0A0121EB88E0
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 06:11:39 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi2.gw.nic.fujitsu.com (Postfix) with ESMTP id 15717AC0098
 for <linux-nvdimm@lists.01.org>; Fri,  1 Sep 2017 22:14:17 +0900 (JST)
Date: Fri, 01 Sep 2017 22:13:39 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [ndctl PATCH v4 0/5] ndctl: show broken dimm info with translate SPA
 feature.
Message-Id: <20170901221335.C27F.E1E9C6FF@jp.fujitsu.com>
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

I wrote v4 patch set to show broken NVDIMM for ndctl list command.
Please check it.

---
Change log since v3 [1]:
  - Return dimm info when dimm is not interleaved.
    Translate SPA is not necessary for its case.
  - Since ndctl_region is needed to get # of ways of interleave,
    ndctl_region_get_by_physical_address() is created,
    and sanity check (is_valid_spa) use it.
  - rename libndctl-nfit.c to nfit.c
  - move libndctl-nfit.h from ndctl/lib to ndctl/ .
  - not to make libndctl-nfit.la.
  - rename to ndctl_bus_is_nfit_cmd_supported()
  - add annotations.

Change log since v2 [2]:
 - Make libndctl-nfit.h and libndctl-nfit.c and define new interfaces
   which use translate spa on them.
 - Add sanity checks for new interfaces.
 - Fix some names
      o trans_spa -> translate_spa
      o sub_cmd -> passthru_cmd
   

Change log since v1 [3]:
 - Use ND_CMD_CALL to call translate SPA feature.
 - Separate patch set of ndctl from kernel patch set.
 - Add a interface to check what feature can call via ND_CMD_CALL by reading
   /device/nfit/dsm_mask 
 - Get only one nvdimm handle and DPA via ioctl() for the time being.
 - Bug fix which i found
     fix calculation of SPA from bad block at dev_badblocks_to_json().


[1] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05857.html
[2] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05577.html
[3] https://www.mail-archive.com/linux-nvdimm@lists.01.org/msg05287.html


----
This patch set is to show information of broken NVDIMM on ndctl.

When a region has a broken block, user needs to replace
the NVDIMM which includes the block.
However there is no information to find which DIMM module have the block.
Not only ndctl does not have such information, nvdimm driver can not
find it if the region is interleaved.


Fortunately, ACPI 6.2 has new specification of _DSM.
It is "translate spa" which can get NVDIMM handle
and DPA(Dimm Physical Address) from SPA(system Physical Addreess).
It helps for ndctl command to find broken NVDIMM when the region is
interleaved.

This patch set includes followings.
 - introduce libndctl-nfit.h
 - some preparations to call Translate SPA via ND_CMD_CALL.
 - make a function to get dimm by System physical address, and
   other helper functions.
 - ndctl list command show bad DIMM.


Thanks,
---
Yasunori Goto




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
