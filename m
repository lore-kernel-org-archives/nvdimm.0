From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v3 08/19] arch: um: add shim to trap to allow installing a
 fault catcher for tests
Date: Mon, 3 Dec 2018 16:44:56 -0800
Message-ID: <CAFd5g45p55GXuk-PcaknVHywJ25LsM+7N83L_g0ob6Q0FTwSrg@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-9-brendanhiggins@google.com>
 <20181130033429.GK18410@garbanzo.do-not-panic.com>
 <CAFd5g45+MAVaSW8HN9x57Y8Um=TV1Oa=-K8yExPBS-4KjLyciQ@mail.gmail.com>
 <20181203234628.GR28501@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20181203234628.GR28501-dAjH6bxAqesAS62YNPtMr3dQhYtBYE6JAL8bYrjMMd8@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: brakmo-b10kYP2dOMg@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Mon, Dec 3, 2018 at 3:46 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Dec 03, 2018 at 03:34:57PM -0800, Brendan Higgins wrote:
> > On Thu, Nov 29, 2018 at 7:34 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > >
> > > On Wed, Nov 28, 2018 at 11:36:25AM -0800, Brendan Higgins wrote:
> > > > diff --git a/arch/um/kernel/trap.c b/arch/um/kernel/trap.c
> > > > index cced829460427..bf90e678b3d71 100644
> > > > --- a/arch/um/kernel/trap.c
> > > > +++ b/arch/um/kernel/trap.c
> > > > @@ -201,6 +201,12 @@ void segv_handler(int sig, struct siginfo *unused_si, struct uml_pt_regs *regs)
> > > >       segv(*fi, UPT_IP(regs), UPT_IS_USER(regs), regs);
> > > >  }
> > > >
> > > > +static void segv_run_catcher(jmp_buf *catcher, void *fault_addr)
> > > > +{
> > > > +     current->thread.fault_addr = fault_addr;
> > > > +     UML_LONGJMP(catcher, 1);
> > > > +}
> > > > +
> > > >  /*
> > > >   * We give a *copy* of the faultinfo in the regs to segv.
> > > >   * This must be done, since nesting SEGVs could overwrite
> > > > @@ -219,7 +225,10 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
> > > >       if (!is_user && regs)
> > > >               current->thread.segv_regs = container_of(regs, struct pt_regs, regs);
> > > >
> > > > -     if (!is_user && (address >= start_vm) && (address < end_vm)) {
> > > > +     catcher = current->thread.fault_catcher;
> > >
> > > This and..
> > >
> > > > +     if (catcher && current->thread.is_running_test)
> > > > +             segv_run_catcher(catcher, (void *) address);
> > > > +     else if (!is_user && (address >= start_vm) && (address < end_vm)) {
> > > >               flush_tlb_kernel_vm();
> > > >               goto out;
> > > >       }
> > >
> > > *not this*
> >
> > I don't understand. Are you saying the previous block of code is good
> > and this one is bad?
>
> No, I was saying that the above block of code is a functional change,
> but I was also pointing out other areas which were not and could be
> folded into a separate atomic patch where no functionality changes.
>
> > > > @@ -246,12 +255,10 @@ unsigned long segv(struct faultinfo fi, unsigned long ip, int is_user,
> > > >               address = 0;
> > > >       }
> > > >
> > > > -     catcher = current->thread.fault_catcher;
> > > >       if (!err)
> > > >               goto out;
> > > >       else if (catcher != NULL) {
> > > > -             current->thread.fault_addr = (void *) address;
> > > > -             UML_LONGJMP(catcher, 1);
> > > > +             segv_run_catcher(catcher, (void *) address);
> > > >       }
> > > >       else if (current->thread.fault_addr != NULL)
> > > >               panic("fault_addr set but no fault catcher");
> > >
> > > But with this seems one atomic change which should be submitted
> > > separately, its just a helper. Think it would make the actual
> > > change needed easier to review, ie, your needed changes would
> > > be smaller and clearer for what you need.
> >
> > Are you suggesting that I pull out the bits needed to implement abort
> > in the next patch and squash it into this one?
>
> No, I'm suggesting you can probably split this patch in 2, one which
> wraps things with no functional changes, and another which adds your
> changes.
>

That makes sense.

Thanks for the clarification!
