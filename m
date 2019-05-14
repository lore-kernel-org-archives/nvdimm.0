From: Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Tue, 14 May 2019 14:05:05 +0200
Message-ID: <CAKMK7uHqtSF_sazJTbFL+xmQJRk4iwukCKZHoDHhsKkLXk=ECQ@mail.gmail.com>
References: <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
 <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
 <20190509214233.GA20877@mit.edu>
 <80c72e64-2665-bd51-f78c-97f50f9a53ba@gmail.com>
 <20190511173344.GA8507@mit.edu>
 <20190513144451.GQ17751@phenom.ffwll.local>
 <20190514060433.GA181462@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190514060433.GA181462-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Linux Doc Mailing List <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

On Tue, May 14, 2019 at 8:04 AM Brendan Higgins
<brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Mon, May 13, 2019 at 04:44:51PM +0200, Daniel Vetter wrote:
> > On Sat, May 11, 2019 at 01:33:44PM -0400, Theodore Ts'o wrote:
> > > On Fri, May 10, 2019 at 02:12:40PM -0700, Frank Rowand wrote:
> > > > However, the reply is incorrect.  Kselftest in-kernel tests (which
> > > > is the context here) can be configured as built in instead of as
> > > > a module, and built in a UML kernel.  The UML kernel can boot,
> > > > running the in-kernel tests before UML attempts to invoke the
> > > > init process.
> > >
> > > Um, Citation needed?
> > >
> > > I don't see any evidence for this in the kselftest documentation, nor
> > > do I see any evidence of this in the kselftest Makefiles.
> > >
> > > There exists test modules in the kernel that run before the init
> > > scripts run --- but that's not strictly speaking part of kselftests,
> > > and do not have any kind of infrastructure.  As noted, the
> > > kselftests_harness header file fundamentally assumes that you are
> > > running test code in userspace.
> >
> > Yeah I really like the "no userspace required at all" design of kunit,
> > while still collecting results in a well-defined way (unless the current
> > self-test that just run when you load the module, with maybe some
> > kselftest ad-hoc wrapper around to collect the results).
> >
> > What I want to do long-term is to run these kernel unit tests as part of
> > the build-testing, most likely in gitlab (sooner or later, for drm.git
>
> Totally! This is part of the reason I have been insisting on a minimum
> of UML compatibility for all unit tests. If you can suffiently constrain
> the environment that is required for tests to run in, it makes it much
> easier not only for a human to run your tests, but it also makes it a
> lot easier for an automated service to be able to run your tests.
>
> I actually have a prototype presubmit already working on my
> "stable/non-upstream" branch. You can checkout what presubmit results
> look like here[1][2].

ug gerrit :-)

> > only ofc). So that people get their pull requests (and patch series, we
> > have some ideas to tie this into patchwork) automatically tested for this
>
> Might that be Snowpatch[3]? I talked to Russell, the creator of Snowpatch,
> and he seemed pretty open to collaboration.
>
> Before I heard about Snowpatch, I had an intern write a translation
> layer that made Prow (the presubmit service that I used in the prototype
> above) work with LKML[4].

There's about 3-4 forks/clones of patchwork. snowpatch is one, we have
a different one on freedesktop.org. It's a bit a mess :-/

> I am not married to either approach, but I think between the two of
> them, most of the initial legwork has been done to make presubmit on
> LKML a reality.

We do have presubmit CI working already with our freedesktop.org
patchwork. The missing glue is just tying that into gitlab CI somehow
(since we want to unify build testing more and make it easier for
contributors to adjust things).
-Daniel

> > super basic stuff.
>
> I am really excited to hear back on what you think!
>
> Cheers!
>
> [1] https://kunit-review.googlesource.com/c/linux/+/1509/10#message-7bfa40efb132e15c8388755c273837559911425c
> [2] https://kunit-review.googlesource.com/c/linux/+/1509/10#message-a6784496eafff442ac98fb068bf1a0f36ee73509
> [3] https://developer.ibm.com/open/projects/snowpatch/
> [4] https://kunit.googlesource.com/prow-lkml/
> _______________________________________________
> dri-devel mailing list
> dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org
> https://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
