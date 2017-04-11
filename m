Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5CBC621A04823
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 14:34:21 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id g204so12073092oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 14:34:21 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <149194542385.32517.16332902766093858868.stgit@djiang5-desk3.ch.intel.com>
References: <149194542385.32517.16332902766093858868.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Apr 2017 14:34:19 -0700
Message-ID: <CAPcyv4iedwXh7OsCbooooPo2Txp8hUS-NXEHHsRfqmN3s8e7RA@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: fix clear poison locking with spinlock and
 mempool
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Apr 11, 2017 at 2:17 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> The following warning results from holding a lane spinlock,
> preempt_disable(), or the btt map spinlock and then trying to take the
> reconfig_mutex to walk the poison list and potentially add new entries.
>
> BUG: sleeping function called from invalid context at kernel/locking/mutex.
> c:747
> in_atomic(): 1, irqs_disabled(): 0, pid: 17159, name: dd
> [..]
> Call Trace:
> dump_stack+0x85/0xc8
> ___might_sleep+0x184/0x250
> __might_sleep+0x4a/0x90
> __mutex_lock+0x58/0x9b0
> ? nvdimm_bus_lock+0x21/0x30 [libnvdimm]
> ? __nvdimm_bus_badblocks_clear+0x2f/0x60 [libnvdimm]
> ? acpi_nfit_forget_poison+0x79/0x80 [nfit]
> ? _raw_spin_unlock+0x27/0x40
> mutex_lock_nested+0x1b/0x20
> nvdimm_bus_lock+0x21/0x30 [libnvdimm]
> nvdimm_forget_poison+0x25/0x50 [libnvdimm]
> nvdimm_clear_poison+0x106/0x140 [libnvdimm]
> nsio_rw_bytes+0x164/0x270 [libnvdimm]
> btt_write_pg+0x1de/0x3e0 [nd_btt]
> ? blk_queue_enter+0x30/0x290
> btt_make_request+0x11a/0x310 [nd_btt]
> ? blk_queue_enter+0xb7/0x290
> ? blk_queue_enter+0x30/0x290
> generic_make_request+0x118/0x3b0
>
> Two things are done to address this issue. First, we introduce a spinlock to
> protect the poison list. This allows us to not having to acquire the
> reconfig_mutex for touching the poison list. Second, we introduce a mempool
> for the poison list entry allocation. This provides a pool of entries we can
> allocate from. Once we run out, we will acquire entries via GFP_NOWAIT to
> avoid the sleep with GFP_KERNEL allocation.
>
[..]

Wait, if we're just going to GFP_NOWAIT in the end, why even bother
with a mempool?

> +
> +       poison_mempool = mempool_create_slab_pool(SZ_4K, poison_cache);

...otherwise if you want to use a mempool I think it should be
minimally sized to cover the number of entries a single i/o can
generate. I don't think we'll ever exhaust 4096 idle nd_poison
entries.

If we're ok with the memory allocation failing, which I think we are,
we can just keep it simple with kzalloc(GFP_NOWAIT).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
