Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 26CBB21A0483A
 for <linux-nvdimm@lists.01.org>; Wed, 12 Apr 2017 13:00:24 -0700 (PDT)
Date: Wed, 12 Apr 2017 13:59:03 -0600
From: Vishal Verma <vishal.l.verma@intel.com>
Subject: Re: [RFC PATCH] x86, mce: change the mce notifier to 'blocking' from
 'atomic'
Message-ID: <20170412195903.GA29506@omniknight.lm.intel.com>
References: <20170411224457.24777-1-vishal.l.verma@intel.com>
 <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20170412091442.dwonfr4dwyta7nvx@pd.tnic>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Borislav Petkov <bp@suse.de>
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 04/12, Borislav Petkov wrote:
> On Tue, Apr 11, 2017 at 04:44:57PM -0600, Vishal Verma wrote:
> > The NFIT MCE handler callback (for handling media errors on NVDIMMs)
> > takes a mutex to add the location of a memory error to a list. But since
> > the notifier call chain for machine checks (x86_mce_decoder_chain) is
> > atomic, we get a lockdep splat like:
> > =

> >   BUG: sleeping function called from invalid context at kernel/locking/=
mutex.c:620
> >   in_atomic(): 1, irqs_disabled(): 0, pid: 4, name: kworker/0:0
> >   [..]
> >   Call Trace:
> >    dump_stack+0x86/0xc3
> >    ___might_sleep+0x178/0x240
> >    __might_sleep+0x4a/0x80
> >    mutex_lock_nested+0x43/0x3f0
> >    ? __lock_acquire+0xcbc/0x1290
> >    nfit_handle_mce+0x33/0x180 [nfit]
> >    notifier_call_chain+0x4a/0x70
> >    atomic_notifier_call_chain+0x6e/0x110
> >    ? atomic_notifier_call_chain+0x5/0x110
> >    mce_gen_pool_process+0x41/0x70
> > =

> > Commit 648ed94038c030245a06e4be59744fd5cdc18c40
> >       x86/mce: Provide a lockless memory pool to save error records
> > Changes the mce notifier callbacks to be run in a process context, and
> > this can allow us to use the 'blocking' type notifier, where we can take
> > mutexes etc. in the call chain functions.
> > =

> > Reported-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> > Cc: Borislav Petkov <bp@suse.de>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  arch/x86/kernel/cpu/mcheck/mce-genpool.c  | 2 +-
> >  arch/x86/kernel/cpu/mcheck/mce-internal.h | 2 +-
> >  arch/x86/kernel/cpu/mcheck/mce.c          | 8 ++++----
> >  3 files changed, 6 insertions(+), 6 deletions(-)
> > =

> > While this patch almost solves the problem, I think it is not quite rig=
ht.
> > The x86_mce_decoder_chain is also called from print_mce for fatal machi=
ne
> > checks, and that is, afaict, still from an atomic context. One thing To=
ny
> > suggested was splitting the notifier chain into two distinct chains, one
> > for regular logging and recoverable actions that allows blocking, the
> > other from the panic path.
> =

> Well, if Mohammad won't come to the mountain...
> =

> So the NFIT handler has:
> =

>         /* We only care about memory errors */
>         if (!(mce->status & MCACOD))
>                 return NOTIFY_DONE;
> =

> what severity are we talking here? Errors which can be reported on the
> panic path, i.e., in atomic context or only AO/AR ones which don't raise
> an #MC exception?

I don't think we can do anything about the panic path errors. The NFIT
handler takes the recoverable machine checks, and essentially, adds the
location to a list.

> =

> -- =

> Regards/Gruss,
>     Boris.
> =

> SUSE Linux GmbH, GF: Felix Imend=F6rffer, Jane Smithard, Graham Norton, H=
RB 21284 (AG N=FCrnberg)
> -- =

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
