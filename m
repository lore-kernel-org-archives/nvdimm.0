From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Mon, 25 Mar 2019 15:12:05 -0700
Message-ID: <CAFd5g46ky5617JB=h-gcgdYMZzKtn9zv=qzvbyyHZpQW0m_84Q@mail.gmail.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
 <CAFd5g47G=mTdk+=wpO+rkyO0+mAbEfPAg=Pr7_507Uek4sdWeA@mail.gmail.com>
 <3bdbe44c-5bd8-db37-89f9-a518cd5a21a8@deltatee.com>
 <CAFd5g45u6oX=nK9anAEdfsV+8SET8Zo_Dpy0WfzCna19r_jSyw@mail.gmail.com>
 <aea24c8e-5ce8-5f33-c81b-d2eeef588ec8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <aea24c8e-5ce8-5f33-c81b-d2eeef588ec8-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
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
Cc: brakmo-b10kYP2dOMg@public.gmane.org, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frank Rowand-real <frowand-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Bird, Timothy" <Tim.Bird-7U/KSKJipcs@public.gmane.org>, Kees Cook <keescook-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-um-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, kunit-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Linux
List-Id: linux-nvdimm@lists.01.org

On Thu, Mar 21, 2019 at 6:12 PM Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> On 3/21/19 4:33 PM, Brendan Higgins wrote:
> > On Thu, Mar 21, 2019 at 3:27 PM Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org> wrote:
> >>
> >>
> >>
> >> On 2019-03-21 4:07 p.m., Brendan Higgins wrote:
> >>> A couple of points, as for needing CONFIG_PCI; my plan to deal with
> >>> that type of thing has been that we would add support for a KUnit/UML
> >>> version that is just for KUnit. It would mock out the necessary bits
> >>> to provide a fake hardware implementation for anything that might
> >>> depend on it. I wrote a prototype for mocking/faking MMIO that I
> >>> presented to the list here[1]; it is not part of the current patchset
> >>> because we decided it would be best to focus on getting an MVP in, but
> >>> I plan on bringing it back up at some point. Anyway, what do you
> >>> generally think of this approach?
> >>
> >> Yes, I was wondering if that might be possible. I think that's a great
> >> approach but it will unfortunately take a lot of work before larger
> >> swaths of the kernel are testable in Kunit with UML. Having more common
> >> mocked infrastructure will be great by-product of it though.
> >
> > Yeah, it's unfortunate that the best way to do something often takes
> > so much longer.
> >
> >>
> >>> Awesome, I looked at the code you posted and it doesn't look like you
> >>> have had too many troubles. One thing that stood out to me, why did
> >>> you need to put it in the kunit/ dir?
> >>
> >> Yeah, writing the code was super easy. Only after, did I realized I
> >> couldn't get it to easily build.
> >
> > Yeah, we really need to fix that; unfortunately, broadly addressing
> > that problem is really hard and will most likely take a long time.
> >
> >>
> >> Putting it in the kunit directory was necessary because nothing in the
> >> NTB tree builds unless CONFIG_NTB is set (see drivers/Makefile) and
> >> CONFIG_NTB depends on CONFIG_PCI. I didn't experiment to see how hard it
> >> would be to set CONFIG_NTB without CONFIG_PCI; I assumed it would be tricky.
> >>
> >>> I am looking forward to see what you think!
> >>
> >> Generally, I'm impressed and want to see this work in upstream as soon
> >> as possible so I can start to make use of it!
> >
> > Great to hear! I was trying to get the next revision out this week,
> > but addressing some of the comments is taking a little longer than
> > expected. I should have something together fairly soon though
> > (hopefully next week). Good news is that next revision will be
> > non-RFC; most of the feedback has settled down and I think we are
> > ready to start figuring out how to merge it. Fingers crossed :-)
> >
> > Cheers
>
> I'll be out of the office next week and will not be able to review.
> Please hold off on any devicetree related files until after I review.

Will do.
