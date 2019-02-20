From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 15/17] of: unittest: migrate tests to run on KUnit
Date: Tue, 19 Feb 2019 18:24:00 -0800
Message-ID: <CAFd5g44OYSEnX4+d6S-j8mR8=7u8mHjgU10Zy_BPbed0u+56ew@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <20190214213729.21702-16-brendanhiggins@google.com>
 <cda7c8db-a6d0-6a93-5c33-9ccf32dfd29a@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <cda7c8db-a6d0-6a93-5c33-9ccf32dfd29a-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Bird,
 Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Luis Chamberlain <mcgrof@kern>
List-Id: linux-nvdimm@lists.01.org

On Fri, Feb 15, 2019 at 4:24 PM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On 2/14/19 1:37 PM, Brendan Higgins wrote:
> > Migrate tests without any cleanup, or modifying test logic in anyway to
> > run under KUnit using the KUnit expectation and assertion API.
> >
> > Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > ---
> >  drivers/of/Kconfig    |    1 +
> >  drivers/of/unittest.c | 1310 +++++++++++++++++++++--------------------
> >  2 files changed, 671 insertions(+), 640 deletions(-)
> >
> > diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > index ad3fcad4d75b8..f309399deac20 100644
> > --- a/drivers/of/Kconfig
> > +++ b/drivers/of/Kconfig
> > @@ -15,6 +15,7 @@ if OF
> >  config OF_UNITTEST
> >       bool "Device Tree runtime unit tests"
> >       depends on !SPARC
> > +     depends on KUNIT
> >       select IRQ_DOMAIN
> >       select OF_EARLY_FLATTREE
> >       select OF_RESOLVE
> > diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
>
> These comments are from applying the patches to 5.0-rc3.
>
> The final hunk of this patch fails to apply because it depends upon
>
>    [PATCH v1 0/1] of: unittest: unflatten device tree on UML when testing.
>

Whoops, I probably should have made a note of that in the commit
description or cover letter, sorry.

> If I apply that patch then I can apply patches 15 through 17.
>
> If I apply patches 1 through 14 and boot the uml kernel then the devicetree
> unittest result is:
>
>   ### dt-test ### FAIL of_unittest_overlay_high_level():2372 overlay_base_root not initialized
>   ### dt-test ### end of unittest - 219 passed, 1 failed
>
> This is as expected from your previous reports, and is fixed after
> applying
>
>    [PATCH v1 0/1] of: unittest: unflatten device tree on UML when testing.
>
> with the devicetree unittest result of:
>
>    ### dt-test ### end of unittest - 224 passed, 0 failed
>
> After adding patch 15, there are a lot of "unittest internal error" messages.

Yeah, I meant to ask you about that. I thought it was due to a change
you made, but after further examination, just now, I found it was my
fault. Sorry for not mentioning that anywhere. I will fix it in v5.

Thanks!
