Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DF49421AEB0A4
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jul 2017 07:21:46 -0700 (PDT)
Date: Wed, 26 Jul 2017 08:23:48 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: FIle copy to FAT FS on NVDIMM hits BUG_ON at fs/buffer.c:3305!
Message-ID: <20170726142348.GA4130@linux.intel.com>
References: <1501018096.2042.70.camel@hpe.com>
 <20170725222247.GA26391@linux.intel.com>
 <20170726082159.GE4039@linux-x5ow.site> <87d18neemb.fsf@devron>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <87d18neemb.fsf@devron>
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
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 26, 2017 at 06:23:08PM +0900, OGAWA Hirofumi wrote:
> "Kani, Toshimitsu" <toshi.kani@hpe.com> writes:
> 
> >  kernel BUG at fs/buffer.c:3305!
> >  invalid opcode: 0000 [#1] SMP
> >   :
> >  Workqueue: writeback wb_workfn (flush-259:0)
> >  task: ffff8d02595b8000 task.stack: ffffa22242400000
> >  RIP: 0010:try_to_free_buffers+0xd2/0xe0
> >  RSP: 0018:ffffa22242403830 EFLAGS: 00010246
> >  RAX: 00afffc000001028 RBX: 0000000000000008 RCX: ffff8d012dcf19c0
> >  RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffffc468e3b52b80
> >  RBP: ffffa22242403858 R08: 0000000000000000 R09: 000000000002067c
> >  R10: ffff8d027ffe6000 R11: 0000000000000000 R12: 0000000000000000
> >  R13: ffff8d022fccdbe0 R14: ffffc468e3b52b80 R15: ffffa22242403ad0
> >  FS:  0000000000000000(0000) GS:ffff8d027fd40000(0000)
> 
> The locking of this path seems to be broken. The guy familiar to
> bdev_write_page() path will made real fix though, The following patch
> should be explaining enough what is wrong.

Is there someone in particular who is familiar with bdev_write_page() that is
working on this fix, or does someone need to pick this up?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
