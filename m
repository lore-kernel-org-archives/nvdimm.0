Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 339EB2034A7B3
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 03:25:54 -0700 (PDT)
Date: Thu, 26 Oct 2017 13:29:31 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] libnvdimm: clear the internal poison_list when clearing
 badblocks
Message-ID: <20171026102931.lpob76adflhqcpbq@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
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
To: vishal.l.verma@intel.com
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

Hello Vishal Verma,

The patch e046114af5fc: "libnvdimm: clear the internal poison_list
when clearing badblocks" from Sep 30, 2016, leads to the following
static checker warning:

	drivers/nvdimm/core.c:601 nvdimm_forget_poison()
	warn: potential integer overflow from user 'start + len'

drivers/nvdimm/core.c
   597  void nvdimm_forget_poison(struct nvdimm_bus *nvdimm_bus, phys_addr_t start,
   598                  unsigned int len)
   599  {
   600          struct list_head *poison_list = &nvdimm_bus->poison_list;
   601          u64 clr_end = start + len - 1;
                              ^^^^^^^^^^^
Thes come from the __nd_ioctl() and it looks like they haven't been
checked before we call this function.  It's hard for me to read this
function well enough that I can say for sure the overflow is harmless.

Please review?

   602          struct nd_poison *pl, *next;
   603  
   604          spin_lock(&nvdimm_bus->poison_lock);
   605          WARN_ON_ONCE(list_empty(poison_list));
   606  
   607          /*
   608           * [start, clr_end] is the poison interval being cleared.
   609           * [pl->start, pl_end] is the poison_list entry we're comparing
   610           * the above interval against. The poison list entry may need
   611           * to be modified (update either start or length), deleted, or
   612           * split into two based on the overlap characteristics
   613           */
   614  
   615          list_for_each_entry_safe(pl, next, poison_list, list) {
   616                  u64 pl_end = pl->start + pl->length - 1;
   617  
   618                  /* Skip intervals with no intersection */
   619                  if (pl_end < start)
   620                          continue;
   621                  if (pl->start >  clr_end)
   622                          continue;
   623                  /* Delete completely overlapped poison entries */
   624                  if ((pl->start >= start) && (pl_end <= clr_end)) {
   625                          list_del(&pl->list);

regards,
dan carpenter
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
