Return-Path: <owner-linux-mm@kvack.org>
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm/memory-failure: Poison read receives SIGKILL instead
 of SIGBUS if mmaped more than once
Date: Wed, 24 Jul 2019 06:48:54 +0000
Message-ID: <20190724064846.GA17567@hori.linux.bs1.fc.nec.co.jp>
References: <1563925110-19359-1-git-send-email-jane.chu@oracle.com>
 <CAPcyv4hyvHFnSE4AUbXooxX_Ug-raxAJgzC7jzkHp_mSg_sCmg@mail.gmail.com>
In-Reply-To: <CAPcyv4hyvHFnSE4AUbXooxX_Ug-raxAJgzC7jzkHp_mSg_sCmg@mail.gmail.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <A8D19D1E94905D479DFEEA8EADF01457@gisp.nec.co.jp>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Jane Chu <jane.chu@oracle.com>, Dan Williams <dan.j.williams@intel.com>
Cc: Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Jane, Dan,

On Tue, Jul 23, 2019 at 06:34:35PM -0700, Dan Williams wrote:
> On Tue, Jul 23, 2019 at 4:49 PM Jane Chu <jane.chu@oracle.com> wrote:
> >
> > Mmap /dev/dax more than once, then read the poison location using addre=
ss
> > from one of the mappings. The other mappings due to not having the page
> > mapped in will cause SIGKILLs delivered to the process. SIGKILL succeed=
s
> > over SIGBUS, so user process looses the opportunity to handle the UE.
> >
> > Although one may add MAP_POPULATE to mmap(2) to work around the issue,
> > MAP_POPULATE makes mapping 128GB of pmem several magnitudes slower, so
> > isn't always an option.
> >
> > Details -
> >
> > ndctl inject-error --block=3D10 --count=3D1 namespace6.0
> >
> > ./read_poison -x dax6.0 -o 5120 -m 2
> > mmaped address 0x7f5bb6600000
> > mmaped address 0x7f3cf3600000
> > doing local read at address 0x7f3cf3601400
> > Killed
> >
> > Console messages in instrumented kernel -
> >
> > mce: Uncorrected hardware memory error in user-access at edbe201400
> > Memory failure: tk->addr =3D 7f5bb6601000
> > Memory failure: address edbe201: call dev_pagemap_mapping_shift
> > dev_pagemap_mapping_shift: page edbe201: no PUD
> > Memory failure: tk->size_shift =3D=3D 0
> > Memory failure: Unable to find user space address edbe201 in read_poiso=
n
> > Memory failure: tk->addr =3D 7f3cf3601000
> > Memory failure: address edbe201: call dev_pagemap_mapping_shift
> > Memory failure: tk->size_shift =3D 21
> > Memory failure: 0xedbe201: forcibly killing read_poison:22434 because o=
f failure to unmap corrupted page
> >   =3D> to deliver SIGKILL
> > Memory failure: 0xedbe201: Killing read_poison:22434 due to hardware me=
mory corruption
> >   =3D> to deliver SIGBUS
> >
> > Signed-off-by: Jane Chu <jane.chu@oracle.com>
> > ---
> >  mm/memory-failure.c | 16 ++++++++++------
> >  1 file changed, 10 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index d9cc660..7038abd 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -315,7 +315,6 @@ static void add_to_kill(struct task_struct *tsk, st=
ruct page *p,
> >
> >         if (*tkc) {
> >                 tk =3D *tkc;
> > -               *tkc =3D NULL;
> >         } else {
> >                 tk =3D kmalloc(sizeof(struct to_kill), GFP_ATOMIC);
> >                 if (!tk) {
> > @@ -331,16 +330,21 @@ static void add_to_kill(struct task_struct *tsk, =
struct page *p,
> >                 tk->size_shift =3D compound_order(compound_head(p)) + P=
AGE_SHIFT;
> >
> >         /*
> > -        * In theory we don't have to kill when the page was
> > -        * munmaped. But it could be also a mremap. Since that's
> > -        * likely very rare kill anyways just out of paranoia, but use
> > -        * a SIGKILL because the error is not contained anymore.
> > +        * Indeed a page could be mmapped N times within a process. And=
 it's possible
> > +        * that not all of those N VMAs contain valid mapping for the p=
age. In which
> > +        * case we don't want to send SIGKILL to the process on behalf =
of the VMAs
> > +        * that don't have the valid mapping, because doing so will ecl=
ipse the SIGBUS
> > +        * delivered on behalf of the active VMA.
> >          */
> >         if (tk->addr =3D=3D -EFAULT || tk->size_shift =3D=3D 0) {
> >                 pr_info("Memory failure: Unable to find user space addr=
ess %lx in %s\n",
> >                         page_to_pfn(p), tsk->comm);
> > -               tk->addr_valid =3D 0;
> > +               if (tk !=3D *tkc)
> > +                       kfree(tk);
> > +               return;

The immediate return bypasses list_add_tail() below, so we might lose
the chance of sending SIGBUS to the process.

tk->size_shift is always non-zero for !is_zone_device_page(), so
"tk->size_shift =3D=3D 0" effectively checks "no mapping on ZONE_DEVICE" no=
w.
As you mention above, "no mapping" doesn't means "invalid address"
so we can drop "tk->size_shift =3D=3D 0" check from this if-statement.
Going forward in this direction, "tk->addr_valid =3D=3D 0" is equivalent to
"tk->addr =3D=3D -EFAULT", so we seems to be able to remove ->addr_valid.
This observation leads me to the following change, does it work for you?

  --- a/mm/memory-failure.c
  +++ b/mm/memory-failure.c
  @@ -199,7 +199,6 @@ struct to_kill {
   	struct task_struct *tsk;
   	unsigned long addr;
   	short size_shift;
  -	char addr_valid;
   };
  =20
   /*
  @@ -324,7 +323,6 @@ static void add_to_kill(struct task_struct *tsk, stru=
ct page *p,
   		}
   	}
   	tk->addr =3D page_address_in_vma(p, vma);
  -	tk->addr_valid =3D 1;
   	if (is_zone_device_page(p))
   		tk->size_shift =3D dev_pagemap_mapping_shift(p, vma);
   	else
  @@ -336,11 +334,9 @@ static void add_to_kill(struct task_struct *tsk, str=
uct page *p,
   	 * likely very rare kill anyways just out of paranoia, but use
   	 * a SIGKILL because the error is not contained anymore.
   	 */
  -	if (tk->addr =3D=3D -EFAULT || tk->size_shift =3D=3D 0) {
  +	if (tk->addr =3D=3D -EFAULT)
   		pr_info("Memory failure: Unable to find user space address %lx in %s\n=
",
   			page_to_pfn(p), tsk->comm);
  -		tk->addr_valid =3D 0;
  -	}
   	get_task_struct(tsk);
   	tk->tsk =3D tsk;
   	list_add_tail(&tk->nd, to_kill);
  @@ -366,7 +362,7 @@ static void kill_procs(struct list_head *to_kill, int=
 forcekill, bool fail,
   			 * make sure the process doesn't catch the
   			 * signal and then access the memory. Just kill it.
   			 */
  -			if (fail || tk->addr_valid =3D=3D 0) {
  +			if (fail || tk->addr =3D=3D -EFAULT) {
   				pr_err("Memory failure: %#lx: forcibly killing %s:%d because of fail=
ure to unmap corrupted page\n",
   				       pfn, tk->tsk->comm, tk->tsk->pid);
   				do_send_sig_info(SIGKILL, SEND_SIG_PRIV,

> >         }
> > +       if (tk =3D=3D *tkc)
> > +               *tkc =3D NULL;
> >         get_task_struct(tsk);
> >         tk->tsk =3D tsk;
> >         list_add_tail(&tk->nd, to_kill);
>=20
>=20
> Concept and policy looks good to me, and I never did understand what
> the mremap() case was trying to protect against.
>=20
> The patch is a bit difficult to read (not your fault) because of the
> odd way that add_to_kill() expects the first 'tk' to be pre-allocated.
> May I ask for a lead-in cleanup that moves all the allocation internal
> to add_to_kill() and drops the **tk argument?

I totally agree with this cleanup. Thanks for the comment.

Thanks,
Naoya Horiguchi=
