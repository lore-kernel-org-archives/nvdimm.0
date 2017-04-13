Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BBE4321939238
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 17:40:38 -0700 (PDT)
Date: Wed, 12 Apr 2017 18:39:18 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [PATCH v4] libnvdimm: fix clear poison locking with spinlock and
 GFP_NOWAIT allocation
Message-ID: <20170413003918.GA10645@omniknight.lm.intel.com>
References: <149202093948.14586.10025145039608378870.stgit@djiang5-desk3.ch.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <149202093948.14586.10025145039608378870.stgit@djiang5-desk3.ch.intel.com>
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/12, Dave Jiang wrote:
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
> A spinlock is introduced to protect the poison list. This allows us to not
> having to acquire the reconfig_mutex for touching the poison list. The
> add_poison() function has been broken out into two helper functions. One to
> allocate the poison entry and the other to apppend the entry. This allows us
> to unlock the poison_lock in non-I/O path and continue to be able to allocate
> the poison entry with GFP_KERNEL. We will use GFP_NOWAIT in the I/O path in
> order to satisfy being in atomic context.
> 
> Signed-off-by: Dave Jiang <dave.jiang@intel.com>
> ---
>  drivers/nvdimm/bus.c      |    7 +++--
>  drivers/nvdimm/core.c     |   61 ++++++++++++++++++++++++++++-----------------
>  drivers/nvdimm/nd-core.h  |    1 +
>  include/linux/libnvdimm.h |    2 -
>  4 files changed, 43 insertions(+), 28 deletions(-)
> 

Looks good!
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
