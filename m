Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm04.jp.fujitsu.com (mgwkm04.jp.fujitsu.com [202.219.69.171])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E2C521E1DAD2
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 02:00:30 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxoi1.gw.nic.fujitsu.com (Postfix) with ESMTP id 419D0AC0142
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 18:02:37 +0900 (JST)
Date: Fri, 04 Aug 2017 18:02:33 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: [RFC/Patch 0/5] ndctl list show broken nvdimm info.
Message-Id: <20170804180231.27BC.E1E9C6FF@jp.fujitsu.com>
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

I made a patch set to show information of broken NVDIMM.

When a region has a broken block, user need to replace
the NVDIMM which includes the block.
However there is no information to find which DIMM module have the block.
Not only ndctl does not have such information, nvdimm driver can not
find it.


Fortunately, ACPI 6.2 has new specification of _DSM.
It is "translate spa" which can get NVDIMM handle
and DPA(Dimm Physical Address) from SPA(system Physical Addreess).
It helps for ndctl command to find broken NVDIMM.
So, This patch set includes followings.
 - support Translate SPA interface,
 - ndctl ask DIMM by Translate SPA and show it.


To be honest, since I'm still newbie about the internal of NVDIMM driver
and ndctl, I may misunderstand/miss something, and I feel my patch
set has likely quick hack....

Especiall, I'm not sure about the followings.

  - What is the maximum size of input/output argument table for _DSM
    for Translate SPA and ioctl()? It seems to depend on max # of
    ways of mirroring. Since ACPI 6.2 seems not to mention it, 
    it depends on vedor's decision, I think....
    Usually, mirroring is 2 way, but I'm not sure it is the maximum number...

  - Though libndctl has many good API, I'm not sure how new APIs
    should be named.


However, I think progress will be better by getting many others advises
than thinking the aboves alone. So, I hope this post is good start
to make this feature.

Anyway, please check and comment.

Thanks,
---
Yasunori Goto



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
