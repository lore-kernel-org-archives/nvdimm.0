Return-Path: <owner-linux-mm@kvack.org>
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH] mm, memory-failure: clarify error message
Date: Mon, 20 May 2019 10:21:05 +0000
Message-ID: <20190520102106.GA12721@hori.linux.bs1.fc.nec.co.jp>
References: <1558066095-9495-1-git-send-email-jane.chu@oracle.com>
 <512532de-4c09-626d-380f-58cef519166b@arm.com>
In-Reply-To: <512532de-4c09-626d-380f-58cef519166b@arm.com>
Content-Language: ja-JP
Content-Type: text/plain; charset="iso-2022-jp"
Content-ID: <CEE34CE09A73174D91E6FF4DEC23B445@gisp.nec.co.jp>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: Jane Chu <jane.chu@oracle.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, May 17, 2019 at 10:18:02AM +0530, Anshuman Khandual wrote:
>=20
>=20
> On 05/17/2019 09:38 AM, Jane Chu wrote:
> > Some user who install SIGBUS handler that does longjmp out
>=20
> What the longjmp about ? Are you referring to the mechanism of catching t=
he
> signal which was registered ?

AFAIK, longjmp() might be useful for signal-based retrying, so highly
optimized applications like Oracle DB might want to utilize it to handle
memory errors in application level, I guess.

>=20
> > therefore keeping the process alive is confused by the error
> > message
> >   "[188988.765862] Memory failure: 0x1840200: Killing
> >    cellsrv:33395 due to hardware memory corruption"
>=20
> Its a valid point because those are two distinct actions.
>=20
> > Slightly modify the error message to improve clarity.
> >=20
> > Signed-off-by: Jane Chu <jane.chu@oracle.com>
> > ---
> >  mm/memory-failure.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> >=20
> > diff --git a/mm/memory-failure.c b/mm/memory-failure.c
> > index fc8b517..14de5e2 100644
> > --- a/mm/memory-failure.c
> > +++ b/mm/memory-failure.c
> > @@ -216,10 +216,9 @@ static int kill_proc(struct to_kill *tk, unsigned =
long pfn, int flags)
> >  	short addr_lsb =3D tk->size_shift;
> >  	int ret;
> > =20
> > -	pr_err("Memory failure: %#lx: Killing %s:%d due to hardware memory co=
rruption\n",
> > -		pfn, t->comm, t->pid);
> > -
> >  	if ((flags & MF_ACTION_REQUIRED) && t->mm =3D=3D current->mm) {
> > +		pr_err("Memory failure: %#lx: Killing %s:%d due to hardware memory "
> > +			"corruption\n", pfn, t->comm, t->pid);
> >  		ret =3D force_sig_mceerr(BUS_MCEERR_AR, (void __user *)tk->addr,
> >  				       addr_lsb, current);
> >  	} else {
> > @@ -229,6 +228,8 @@ static int kill_proc(struct to_kill *tk, unsigned l=
ong pfn, int flags)
> >  		 * This could cause a loop when the user sets SIGBUS
> >  		 * to SIG_IGN, but hopefully no one will do that?
> >  		 */
> > +		pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardwar=
e "
> > +			"memory corruption\n", pfn, t->comm, t->pid);
> >  		ret =3D send_sig_mceerr(BUS_MCEERR_AO, (void __user *)tk->addr,
> >  				      addr_lsb, t);  /* synchronous? */
>=20
> As both the pr_err() messages are very similar, could not we just switch =
between "Killing"
> and "Sending SIGBUS to" based on a variable e.g action_[kill|sigbus] eval=
uated previously
> with ((flags & MF_ACTION_REQUIRED) && t->mm =3D=3D current->mm).

That might need additional if sentence, which I'm not sure worth doing.
I think that the simplest fix for the reported problem (a confusing message=
)
is like below:

	-	pr_err("Memory failure: %#lx: Killing %s:%d due to hardware memory corru=
ption\n",
	+	pr_err("Memory failure: %#lx: Sending SIGBUS to %s:%d due to hardware me=
mory corruption\n",
			pfn, t->comm, t->pid);

Or, if we have a good reason to separate the message for MF_ACTION_REQUIRED=
 and
MF_ACTION_OPTIONAL, that might be OK.

Thanks,
Naoya Horiguchi=
