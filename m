Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x235.google.com (mail-ot0-x235.google.com
 [IPv6:2607:f8b0:4003:c0f::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 23F7281F08
 for <linux-nvdimm@lists.01.org>; Fri, 10 Feb 2017 11:41:22 -0800 (PST)
Received: by mail-ot0-x235.google.com with SMTP id f9so36141068otd.1
 for <linux-nvdimm@lists.01.org>; Fri, 10 Feb 2017 11:41:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1486754370-3057-1-git-send-email-logang@deltatee.com>
References: <1486754370-3057-1-git-send-email-logang@deltatee.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 10 Feb 2017 11:41:20 -0800
Message-ID: <CAPcyv4jA-H5CykS8A_JwGM635MJSa7Bj_G__eq9RwfjFCAke5Q@mail.gmail.com>
Subject: Re: [PATCH] device-dax: don't set kobj parent during cdev init
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: Jan Kara <jack@suse.cz>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sajjan Vikas C <vikas.cha.sajjan@hpe.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 10, 2017 at 11:19 AM, Logan Gunthorpe <logang@deltatee.com> wrote:
> I copied this code and per feedback from Greg Kroah-Hartman [1] the
> cdev's kobject's parent should not be set to the related device.
> This should have minor consequences but isn't doing what anyone
> expects it to.
>
> This patch then fixes device-dax so it doesn't make the same mistake.
>
> [1] https://lkml.org/lkml/2017/2/10/370
>
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>

Thanks for following up with this fix, but this causes a
use-after-free regression:

 general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
 [..]
 Call Trace:
  vsnprintf+0x2d7/0x500
  snprintf+0x49/0x60
  dev_vprintk_emit+0x68/0x230
  ? debug_lockdep_rcu_enabled+0x1d/0x20
  ? trace_hardirqs_off+0xd/0x10
  ? cmpxchg_double_slab.isra.70+0x15a/0x1c0
  ? __slab_free+0x134/0x290
  dev_printk_emit+0x4e/0x70
  __dynamic_dev_dbg+0xc8/0x110
  ? __lock_acquire+0x33d/0x1290
  dax_dev_huge_fault+0xee/0x570 [dax]
  __handle_mm_fault+0x5aa/0x10a0
  handle_mm_fault+0x154/0x350
  ? handle_mm_fault+0x3c/0x350
  __do_page_fault+0x26b/0x4c0
  trace_do_page_fault+0x58/0x270
  do_async_page_fault+0x1a/0xa0
  async_page_fault+0x28/0x30

I added this reference explicitly so the parent struct device has the
correct lifetime after this feedback from Al.

   https://lists.01.org/pipermail/linux-nvdimm/2016-August/006563.html

...so I'm wondering what the actual problem is with setting cdev->parent?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
