Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.sfc.wide.ad.jp (shonan.sfc.wide.ad.jp [203.178.142.130])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CBED021E14528
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 14:54:30 -0700 (PDT)
Received: from mail-wr0-f170.google.com (mail-wr0-f170.google.com
 [209.85.128.170])
 by mail.sfc.wide.ad.jp (Postfix) with ESMTPSA id BAFA02783EE
 for <linux-nvdimm@lists.01.org>; Wed, 16 Aug 2017 06:56:51 +0900 (JST)
Received: by mail-wr0-f170.google.com with SMTP id o62so7050570wrc.4
 for <linux-nvdimm@lists.01.org>; Tue, 15 Aug 2017 14:56:51 -0700 (PDT)
MIME-Version: 1.0
From: Honda Michio <micchie@sfc.wide.ad.jp>
Date: Tue, 15 Aug 2017 23:56:48 +0200
Message-ID: <CA+Sc9E0KYUB2BexdwhG5wvMLu38TLagqgEyzQDthpv3L+YuTBA@mail.gmail.com>
Subject: get_user_pages_unlocked() fails for mmap()-ed nvdimm-backed file
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
Cc: Giuseppe Lettieri <g.lettieri@iet.unipi.it>
List-ID: <linux-nvdimm@lists.01.org>

Dear Linux NVDIMM developers,

We are implementing a kernel module that get_user_pages()s an address
provided by a user-space application. This address is a mmap()-ed region of
a file backed by pmem (XFS with DAX).
It works or successfully gets a kernel virtual address for emulated PMEM
with memmap grub option but doesn't work with a real NVDIMM (I use HPE's
NVDIMM).

I wonder if I am doing something fundamentally wrong, or just making a
mistake about kernel configuration or arguments passed to
get_user_pages_unlocked().

I am giving FOLL_WRITE | FOLL_GET | FOLL_SPLIT | FOLL_POPULATE to
get_user_pages_unlocked(); it fails in vm_normal_page() in
follow_page_pte(), then falls into follow_pfn_pte() with flags & FOLL_GET
to be true, causing -EFAULT returned.

I use libnvdimm-for-next branch
(bbb3be170ac2891526ad07b18af7db226879a8e7) and my kernel configuration
looks like:

root@c402:~/deployed/net-next# egrep -i "(dax|nvdimm|pmem)" .config
CONFIG_X86_PMEM_LEGACY_DEVICE=y
CONFIG_X86_PMEM_LEGACY=y
CONFIG_LIBNVDIMM=y
CONFIG_BLK_DEV_PMEM=m
CONFIG_NVDIMM_PFN=y
CONFIG_NVDIMM_DAX=y
CONFIG_DAX=y
CONFIG_DEV_DAX=y
CONFIG_DEV_DAX_PMEM=y
CONFIG_FS_DAX=y
CONFIG_FS_DAX_PMD=y
CONFIG_ARCH_HAS_PMEM_API=y

Thanks in advance!
- Michio
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
