Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x230.google.com (mail-oi0-x230.google.com
 [IPv6:2607:f8b0:4003:c06::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 423A021A04817
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 17:36:00 -0700 (PDT)
Received: by mail-oi0-x230.google.com with SMTP id w12so44008069oiw.3
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 17:36:00 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPcyv4gbTEXjLAP6fT2+tT4tqwA9_8D6MYzzD7wZC8cOQNUVKw@mail.gmail.com>
References: <20170427225706.26791-1-toshi.kani@hpe.com>
 <20170427225706.26791-2-toshi.kani@hpe.com>
 <CAPcyv4j9QPSwpqs9YPjFo=O8RA+NmpsAZhARfNcSqA0TqqMhLA@mail.gmail.com>
 <CAPcyv4gbTEXjLAP6fT2+tT4tqwA9_8D6MYzzD7wZC8cOQNUVKw@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 17:35:59 -0700
Message-ID: <CAPcyv4jQGiDEW6QJYi3EeF5f0UkC=FEx4uA-K+_RaEN-JpZGEw@mail.gmail.com>
Subject: Re: [PATCH 2/2] libnvdimm: clear region badblock in
 nvdimm_clear_poison()
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
To: Toshi Kani <toshi.kani@hpe.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 28, 2017 at 5:12 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Apr 28, 2017 at 5:10 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> On Thu, Apr 27, 2017 at 3:57 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>>> Badblocks are tracked at both region and device levels.
>>> pmem_clear_poison() and nsio_rw_bytes() call nvdimm_clear_poison()
>>> and then badblocks_clear() to clear badblocks at the device level.
>>> However, it does not update badblocks at the region level, which
>>> makes them inconsistent.
>>>
>>> Change nvdimm_clear_poison() to update backblocks at the region
>>> level to keep them consistent.
>>>
>>> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
>>> Cc: Dan Williams <dan.j.williams@intel.com>
>>> Cc: Dave Jiang <dave.jiang@intel.com>
>>> Cc: Vishal Verma <vishal.l.verma@intel.com>
>>
>> This looks good, and it seems we have a bug in the other location that
>> does this in __nd_ioctl(). That other one is missing the
>> "clear_err.cleared / 512" check. Can you respin this and define a
>> common helper that both locations can call?
>
> On second thought, I'll take this and spin my own cleanup / fix on top.
>
> Thanks Toshi!

...and I need to drop it again because it causes this:

[  106.974889] BUG: sleeping function called from invalid context at
kernel/locking/mutex.c:74
7
[  106.977328] in_atomic(): 1, irqs_disabled(): 0, pid: 5584, name: dd
[  106.978845] 1 lock held by dd/5584:
[  106.979923]  #0:  (&bdev->bd_mutex){+.+.+.}, at:
[<ffffffff812f4937>] __blkdev_put+0x47/0x3
70
[  106.982221] CPU: 29 PID: 5584 Comm: dd Tainted: G           O
4.11.0-rc4+ #105
[  106.984329] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS 1.9.3-1.fc25 04/01/
2014
[  106.986638] Call Trace:
[  106.987530]  dump_stack+0x86/0xc3
[  106.988555]  ___might_sleep+0x17d/0x250
[  106.989650]  __might_sleep+0x4a/0x80
[  106.990718]  __mutex_lock+0x58/0x980
[  106.991788]  ? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
[  106.993059]  ? _raw_spin_unlock+0x27/0x40
[  106.994181]  ? debug_lockdep_rcu_enabled+0x1d/0x20
[  106.995430]  mutex_lock_nested+0x1b/0x20
[  106.996552]  nvdimm_bus_lock+0x21/0x30 [libnvdimm]
[  106.997804]  nvdimm_clear_poison+0x11a/0x150 [libnvdimm]
[  106.999138]  nsio_rw_bytes+0x18f/0x280 [libnvdimm]
[  107.000390]  btt_write_pg+0x1d4/0x3c0 [nd_btt]
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
