From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v7 16/18] MAINTAINERS: add entry for KUnit the unit
 testing framework
Date: Wed, 10 Jul 2019 13:27:42 -0700
Message-ID: <CAFd5g45zFhBN-yrJbRt6KnFkYKxVqjs9qeQULCSD6z89vvG-Tg@mail.gmail.com>
References: <20190709063023.251446-1-brendanhiggins@google.com>
 <20190709063023.251446-17-brendanhiggins@google.com>
 <7cc417dd-036f-7dc1-6814-b1fdac810f03@kernel.org>
 <CAFd5g4595X8cM919mohQVaShs4dKWzZ_-2RVB=6SH3RdVMwuQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g4595X8cM919mohQVaShs4dKWzZ_-2RVB=6SH3RdVMwuQw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Kevin Hilman <khilman-rdvid1DuHRBWk0Htik3J/w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild@v>
List-Id: linux-nvdimm@lists.01.org

On Tue, Jul 9, 2019 at 11:01 AM Brendan Higgins
<brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Tue, Jul 9, 2019 at 7:53 AM shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > On 7/9/19 12:30 AM, Brendan Higgins wrote:
> > > Add myself as maintainer of KUnit, the Linux kernel's unit testing
> > > framework.
> > >
> > > Signed-off-by: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Reviewed-by: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
> > > Reviewed-by: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
> > > ---
> > >   MAINTAINERS | 11 +++++++++++
> > >   1 file changed, 11 insertions(+)
> > >
> > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > index 677ef41cb012c..48d04d180a988 100644
> > > --- a/MAINTAINERS
> > > +++ b/MAINTAINERS
> > > @@ -8599,6 +8599,17 @@ S:     Maintained
> > >   F:  tools/testing/selftests/
> > >   F:  Documentation/dev-tools/kselftest*
> > >
> > > +KERNEL UNIT TESTING FRAMEWORK (KUnit)
> > > +M:   Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > +L:   linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > +L:   kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
> > > +W:   https://google.github.io/kunit-docs/third_party/kernel/docs/
> > > +S:   Maintained
> > > +F:   Documentation/dev-tools/kunit/
> > > +F:   include/kunit/
> > > +F:   kunit/
> > > +F:   tools/testing/kunit/
> > > +
> > >   KERNEL USERMODE HELPER
> > >   M:  Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > >   L:  linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > >
> >
> > Thanks Brendan.
> >
> > I am good with this. I can take KUnit patches through kselftest
> > with your Ack.
>
> My acknowledgement? Sure! I thought we already agreed to that.
>
> Also, do we need an ack from Masahiro or Michal for the Kbuild patch
> [PATCH v7 06/18]? And an ack from Josh or Peter for the objtool patch
> [PATCH v7 08/18]?

By the way, I am guessing you have already seen it, but I uploaded a
new version to incorporate a suggestion made by Masahiro on patch
06/18. In addition, I have gotten acks on the two patches mentioned
above. So I think we are good to go.

Thanks!
