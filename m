Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mgwkm02.jp.fujitsu.com (mgwkm02.jp.fujitsu.com [202.219.69.169])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D25E921D0B64D
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 03:24:03 -0700 (PDT)
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com
 [10.134.21.209])
 by kw-mxq.gw.nic.fujitsu.com (Postfix) with ESMTP id 61D88AC00B1
 for <linux-nvdimm@lists.01.org>; Wed, 12 Jul 2017 19:25:45 +0900 (JST)
Date: Wed, 12 Jul 2017 19:25:20 +0900
From: Yasunori Goto <y-goto@jp.fujitsu.com>
Subject: Some thoughts of ndctl list command output
Message-Id: <20170712192518.C683.E1E9C6FF@jp.fujitsu.com>
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

I wrote current impression about ndctl.
If my understanding/thoughts is wrong, please correct me.


Please imagine the following situation.

  - There are 2 NVDIMMs like the following figure.
  - An interleaved region(namespace) is created on NVDIMM 1 and 2,
    and it is /dev/pmem1.
  - A storage region is created on NVDIMM 1 too, it is /dev/pmem2s.
  - Another storage region is created on NVDIMM 2 as /dev/pmem3s.

  +-------------------+-------------------+
  |                   |    /dev/pmem2s    |   NVDIMM 1 (nmem1)
  |/dev/pmem1     X   +-------------------+
  |                   |    /dev/pmem3s    |   NVDIMM 2 (nmem2)
  +-------------------+-------------------+
  
  
  If a place (in the above figure, place "X") is broken and scrubbing can not
  solve error, user will need to replace broken NVDIMM.

  But, how does user can know which NVDIMM is broken?
  Currently, badblock data belongs to region, not DIMM module,
  there is no information which nvdimm has badblock.
  
  In addition, even if user can find that badblock is included in NVDIMM 2
  fortunately, then he/she needs to become aware that /dev/pmem3s is
  also included in NVDIMM 2, because he/she need to backup the region
  before replacing NVDIMM 2.

  However, I suppose it may be a bit difficult for user to be aware of it.
  Because current ndctl does NOT output
  "Which region is included on the (broken) NVDIMM module."
  It can output only 
  "Which NVDIMM is used for the region by "ndctl list -RD". 
  
  As a result, he/she has to SEARCH all of the regions which is mapped on
  "nmem2". It may be a bit troublesome for users, I think.


  In summary, I think...
    - Badblock information on each NVDIMM will be helpful for user to replace
      wrong NVDIMM.
    - ndctl list -D need to output the information which regions/namespaces
      are placed on each NVDIMM.

Any comments are welcome.

Thanks,




_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
