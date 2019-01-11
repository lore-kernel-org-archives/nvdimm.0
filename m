Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tyo162.gate.nec.co.jp (tyo162.gate.nec.co.jp [114.179.232.162])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D4F33210F75CE
 for <linux-nvdimm@lists.01.org>; Fri, 11 Jan 2019 00:15:25 -0800 (PST)
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: PMEM error-handling forces SIGKILL causes kernel panic
Date: Fri, 11 Jan 2019 08:14:02 +0000
Message-ID: <20190111081401.GA5080@hori1.linux.bs1.fc.nec.co.jp>
References: <e3c4c0e0-1434-4353-b893-2973c04e7ff7@oracle.com>
 <CAPcyv4j67n6H7hD6haXJqysbaauci4usuuj5c+JQ7VQBGngO1Q@mail.gmail.com>
In-Reply-To: <CAPcyv4j67n6H7hD6haXJqysbaauci4usuuj5c+JQ7VQBGngO1Q@mail.gmail.com>
Content-Language: ja-JP
Content-ID: <20D6C8CB51441D4F91DA79AE81215CE1@gisp.nec.co.jp>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Dan, Jane,

Thanks for the report.

On Wed, Jan 09, 2019 at 03:49:32PM -0800, Dan Williams wrote:
> [ switch to text mail, add lkml and Naoya ]
> 
> On Wed, Jan 9, 2019 at 12:19 PM Jane Chu <jane.chu@oracle.com> wrote:
...
> > 3. The hardware consists the latest revision CPU and Intel NVDIMM, we suspected
> >    the CPU faulty because it generated MCE over PMEM UE in a unlikely high
> >    rate for any reasonable NVDIMM (like a few per 24hours).
> >
> > After swapping the CPU, the problem stopped reproducing.
> >
> > But one could argue that perhaps the faulty CPU exposed a small race window
> > from collect_procs() to unmap_mapping_range() and to kill_procs(), hence
> > caught the kernel  PMEM error handler off guard.
> 
> There's definitely a race, and the implementation is buggy as can be
> seen in __exit_signal:
> 
>         sighand = rcu_dereference_check(tsk->sighand,
>                                         lockdep_tasklist_lock_is_held());
>         spin_lock(&sighand->siglock);
> 
> ...the memory-failure path needs to hold the proper locks before it
> can assume that de-referencing tsk->sighand is valid.
> 
> > Also note, the same workload on the same faulty CPU were run on Linux prior to
> > the 4.19 PMEM error handling and did not encounter kernel crash, probably because
> > the prior HWPOISON handler did not force SIGKILL?
> 
> Before 4.19 this test should result in a machine-check reboot, not
> much better than a kernel crash.
> 
> > Should we not to force the SIGKILL, or find a way to close the race window?
> 
> The race should be closed by holding the proper tasklist and rcu read lock(s).

This reasoning and proposal sound right to me. I'm trying to reproduce
this race (for non-pmem case,) but no luck for now. I'll investigate more.

Thanks,
Naoya Horiguchi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
