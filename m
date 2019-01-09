Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x330.google.com (mail-ot1-x330.google.com
 [IPv6:2607:f8b0:4864:20::330])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D2DF4211B5093
 for <linux-nvdimm@lists.01.org>; Wed,  9 Jan 2019 15:49:44 -0800 (PST)
Received: by mail-ot1-x330.google.com with SMTP id v23so8342481otk.9
 for <linux-nvdimm@lists.01.org>; Wed, 09 Jan 2019 15:49:44 -0800 (PST)
MIME-Version: 1.0
References: <e3c4c0e0-1434-4353-b893-2973c04e7ff7@oracle.com>
In-Reply-To: <e3c4c0e0-1434-4353-b893-2973c04e7ff7@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 9 Jan 2019 15:49:32 -0800
Message-ID: <CAPcyv4j67n6H7hD6haXJqysbaauci4usuuj5c+JQ7VQBGngO1Q@mail.gmail.com>
Subject: Re: PMEM error-handling forces SIGKILL causes kernel panic
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
To: Jane Chu <jane.chu@oracle.com>
Cc: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

[ switch to text mail, add lkml and Naoya ]

On Wed, Jan 9, 2019 at 12:19 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Hi, Dan,
>
> Sorry for the late report.
> We recently saw panics from PMEM error handling, here are the log messages
> and stack trace.  "<--" are added by me.
>
> > [ 4488.098830] mce: Uncorrected hardware memory error in user-access at a6ec46f8      <--
> > [ 4488.131625] Memory failure: 0xa6ec46f: forcibly killing ora_pmon_tpcc1:84778
> > [ 4488.144326] Memory failure: 0xa6ec46f: forcibly killing ora_clmn_tpcc1:84780  <-- SIGKILL
> > [ 4488.156965] Memory failure: 0xa6ec46f: forcibly killing ora_psp0_tpcc1:84782
> > [ 4488.169608] Memory failure: 0xa6ec46f: forcibly killing ora_ipc0_tpcc1:84785
> > [ 4488.182210] Memory failure: 0xa6ec46f: forcibly killing ora_vktm_tpcc1:84793
> > [ 4488.194924] Memory failure: 0xa6ec46f: forcibly killing ora_gen0_tpcc1:84797
> > [ 4488.207212] Memory failure: 0xa6ec46f: forcibly killing ora_mman_tpcc1:84799
> > [ 4488.220168] Memory failure: 0xa6ec46f: forcibly killing ora_scmn_tpcc1:84803
> > [ 4488.232974] Memory failure: 0xa6ec46f: forcibly killing ora_diag_tpcc1:84806
> > [ 4488.245660] Memory failure: 0xa6ec46f: forcibly killing ora_scmn_tpcc1:84808
> ..
> > [ 4488.595847] BUG: unable to handle kernel NULL pointer dereference at 00000000      <--
> > [ 4488.604834] IP: _raw_spin_lock_irqsave+0x27/0x48     <-- task->sighand->siglock is NULL
> > [ 4488.610079] PGD 51ef45067 P4D 51ef45067 PUD 51ef44067 PMD 0
> > [ 4488.616514] Oops: 0002 [#1] SMP NOPTI                <-- 2'010: no-page/write/kernel-mode
> > [ 4488.620674] Modules linked in: xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_n
> > [ 4488.712640]  lpc_ich shpchp wmi pcc_cpufreq dm_multipath binfmt_misc sg fuse
> > [ 4488.749400] CPU: 2 PID: 296408 Comm: oracle_296408_t Tainted: G   M
> > [ 4488.764383] Hardware name: Oracle Corporation ORACLE SERVER X8-2/ASM,MB,X8-2,
> > [ 4488.778955] task: ffff997ccab28000 task.stack: ffffb9b832944000
> > [ 4488.789802] RIP: 0010:_raw_spin_lock_irqsave+0x27/0x48
> > [ 4488.799874] RSP: 0018:ffffb9b832947d28 EFLAGS: 00010046
> > [ 4488.810071] RAX: 0000000000000000 RBX: 0000000000000808 RCX: 0000000000000000
> > [ 4488.822959] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000808
> > [ 4488.835375] RBP: ffffb9b832947d38 R08: 0000000000000000 R09: 00000000000052bb
> > [ 4488.847854] R10: 0000000000000001 R11: 0000000000aaaaaa R12: 0000000000000246
> > [ 4488.860446] R13: 0000000000000004 R14: 0000000000000001 R15: 0000000000000009
> > [ 4488.872994] FS:  00007fa0f17533c0(0000) GS:ffff98ba00680000(0000) knlGS:00000
> > [ 4488.886705] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [ 4488.897877] CR2: 0000000000000808 CR3: 000000051146a004 CR4: 00000000007606e0
> > [ 4488.910774] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > [ 4488.923665] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > [ 4488.936517] PKRU: 55555554
> > [ 4488.944467] Call Trace:
> > [ 4488.952152]  force_sig_info+0x2e/0xde
> > [ 4488.961266]  force_sig+0x16/0x18
> > [ 4488.970568]  kill_procs+0x15b/0x1a0        <-- forcing  SIGKILL to the user process
>                                                 <-- due to tk->addr_valid=0 which means rmap()
>                                                 <-- can't find a 'vma' hosting the offending
>                                                 <-- 'pfn', because the process has exited by now.

Ok, that race can happen for the DRAM case as well.

>
> > [ 4488.979601]  memory_failure+0x1dd/0x235
> > [ 4488.989071]  do_machine_check+0x738/0xc89
> > [ 4488.998739]  ? devm_free_irq+0x22/0x71
> > [ 4489.008129]  ? machine_check+0x115/0x124
> > [ 4489.017708]  do_mce+0x15/0x17
> > [ 4489.026260]  machine_check+0x11f/0x124
> > [ 4489.035725] RIP: 0033:0x1253b9e6
> > [ 4489.044695] RSP: 002b:00007ffc205c1600 EFLAGS: 00010246
> > [ 4489.055964] RAX: 000000000000384d RBX: 0000000000000003 RCX: 000000000000002f
> > [ 4489.069509] RDX: 0000000000000007 RSI: 0000000000003f12 RDI: 0000000000003786
> > [ 4489.083065] RBP: 00007ffc205c16a0 R08: 0000009fa526c0e4 R09: 0000009fa526c064
> > [ 4489.096672] R10: 0000000000000000 R11: 0000000000000000 R12: 0000009fa526c086
> > [ 4489.110342] R13: 00007fa0eb399c08 R14: 0000000000000015 R15: 0000009fa526f8b1
> > [ 4489.124026] Code: 00 00 00 00 0f 1f 44 00 00 55 48 89 e5 41 54 53 48 89 fb 9c
> > [ 4489.156598] RIP: _raw_spin_lock_irqsave+0x27/0x48 RSP: ffffb9b832947d28
>
>
> After reboot, the offending 'pfn' is recorded in the 'badblock' record in namespace0.0.
>
> >     "dev":"namespace0.0",
> >     "mode":"fsdax",
> >     "map":"dev",
> >     "size":799063146496,
> >     "uuid":"bf8dc912-e8c2-4099-8571-b0cc32cc9f68",
> >     "blockdev":"pmem0",
> >     "badblock_count":1,
> >     "badblocks":[
> >       {
> >         "offset":969675644,           <-- XXX
> >         "length":1,
> >         "dimms":[
> >           "nmem4"
> >         ]
>
> Per /proc/iomem -
>     03060000000 - 0ed5fffffff   pmem0
> pmem0 is region0 with size = 811748818944,
> namespace0.0 was created over the entire region0, usable size = 799063146496
> so the metadata took (811748818944 - 799063146496) = 0x2F4200000 bytes
> badblock address: (969675644 * 512) + 0x2F4200000 + 0x3060000000 = 0xa6ec46f800
> offending 'pfn': 0xa6ec46f  at starting address 0xa6ec46f000.
>
> Some additional information worth to be noted here:
> 1. The workload consists many processes forming a group sharing the mmap'ed
>    pmem0 region, processes do 'load' and 'store' to the shared region;
> 2. If any process encounters a fatal signal (such as SIGBUS),
>    it shoots down the other processes in the group.

This is also the same as the DRAM case. If they are separate processes
rather than threads than every task outside of the one directly
consuming the poison should receive BUS_MCEERR_AO (action optional) vs
BUS_MCEERR_AR (action required).

> 3. The hardware consists the latest revision CPU and Intel NVDIMM, we suspected
>    the CPU faulty because it generated MCE over PMEM UE in a unlikely high
>    rate for any reasonable NVDIMM (like a few per 24hours).
>
> After swapping the CPU, the problem stopped reproducing.
>
> But one could argue that perhaps the faulty CPU exposed a small race window
> from collect_procs() to unmap_mapping_range() and to kill_procs(), hence
> caught the kernel  PMEM error handler off guard.

There's definitely a race, and the implementation is buggy as can be
seen in __exit_signal:

        sighand = rcu_dereference_check(tsk->sighand,
                                        lockdep_tasklist_lock_is_held());
        spin_lock(&sighand->siglock);

...the memory-failure path needs to hold the proper locks before it
can assume that de-referencing tsk->sighand is valid.

> Also note, the same workload on the same faulty CPU were run on Linux prior to
> the 4.19 PMEM error handling and did not encounter kernel crash, probably because
> the prior HWPOISON handler did not force SIGKILL?

Before 4.19 this test should result in a machine-check reboot, not
much better than a kernel crash.

> Should we not to force the SIGKILL, or find a way to close the race window?

The race should be closed by holding the proper tasklist and rcu read lock(s).
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
