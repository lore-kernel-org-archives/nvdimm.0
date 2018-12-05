From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v3 17/19] of: unittest: migrate tests to run on KUnit
Date: Wed, 5 Dec 2018 15:42:46 -0800
Message-ID: <CAFd5g45-HGytAPTx7OQD8B0oAdLncDGSMMTyHCTtyobeUJ15AQ@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com>
 <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
 <18814973-8f0a-4647-a097-fcc3dc0b3cd3@infradead.org>
 <CAFd5g475RK9v9X4qxmXwuHiPMOs05WrZAw6EJWNdVoAHQWguFQ@mail.gmail.com>
 <CAL_JsqL_PivQbrJFEusdKAy-2EQtKL3OHbmyYSK9bzuTOQegqA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAL_JsqL_PivQbrJFEusdKAy-2EQtKL3OHbmyYSK9bzuTOQegqA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: brakmo-b10kYP2dOMg@public.gmane.org, dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org, Tim.Bird-7U/KSKJipcs@public.gmane.org, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Daniel Vetter <daniel-/w4YWyX8dFk@public.gmane.org>, mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org, joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org, khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org
List-Id: linux-nvdimm@lists.01.org

On Tue, Dec 4, 2018 at 5:41 AM Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Mon, Dec 3, 2018 at 6:14 PM Brendan Higgins
> <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> >
> > On Thu, Nov 29, 2018 at 4:40 PM Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org> wrote:
> > >
> > > On 11/28/18 12:56 PM, Rob Herring wrote:
> > > >> diff --git a/drivers/of/Kconfig b/drivers/of/Kconfig
> > > >> index ad3fcad4d75b8..f309399deac20 100644
> > > >> --- a/drivers/of/Kconfig
> > > >> +++ b/drivers/of/Kconfig
> > > >> @@ -15,6 +15,7 @@ if OF
> > > >>  config OF_UNITTEST
> > > >>         bool "Device Tree runtime unit tests"
> > > >>         depends on !SPARC
> > > >> +       depends on KUNIT
> > > > Unless KUNIT has depends, better to be a select here.
> > >
> > > That's just style or taste.  I would prefer to use depends
> > > instead of select, but that's also just my preference.
> >
> > I prefer depends too, but Rob is the maintainer here.
>
> Well, we should be consistent, not the follow the whims of each maintainer.

Sorry, I don't think that came out the way I meant it. I don't really
think we are consistent on this point across the kernel, and I don't
feel very strongly about the point, so I was just looking to follow
the path of least resistance. (I also just assumed Rob would keep us
consistent within drivers/of/.)

I figure if we are running unit tests from the test runner script or
from an automated system, you won't be hunting for dependencies for a
single test every time you want to run a test, so select doesn't make
it easier to configure in most imagined use cases.

KUNIT hypothetically should not depend on anything, so select should
be safe to use.

On the other hand, if we end up being wrong on this point and KUnit
gains widespread adoption, I would prefer not to be in a position
where I have to change a bunch of configs all over the kernel because
this example got copied and pasted.
