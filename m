Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22d.google.com (mail-oi0-x22d.google.com
 [IPv6:2607:f8b0:4003:c06::22d])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B3B9F21A0483B
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 20:11:12 -0700 (PDT)
Received: by mail-oi0-x22d.google.com with SMTP id r203so17928323oib.3
 for <linux-nvdimm@lists.01.org>; Tue, 11 Apr 2017 20:11:12 -0700 (PDT)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 11 Apr 2017 20:11:11 -0700
Message-ID: <CAPcyv4jTHdai-OpBuxdXvjgLnTtTkWxB=Lp8H2F+RW0w8e1PSg@mail.gmail.com>
Subject: Re: [PATCH v3] libnvdimm: fix clear poison locking with spinlock and
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

On Tue, Apr 11, 2017 at 3:19 PM, Dave Jiang <dave.jiang@intel.com> wrote:
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
> reconfig_mutex for touching the poison list. Second, we allocate the poison
> entries using GFP_NOWAIT and avoid the sleep with GFP_KERNEL.

Need to drop the mempool references out of the subject and changelog,
also I only think we should use GFP_NOWAIT in the I/O path. In the
other add_poison() paths that are currently using GFP_KERNEL we can
just drop the lock to do the allocation. That limits the damage of a
memory allocation failure to clearing errors, not tracking new errors.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
