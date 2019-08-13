From: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 09/18] kunit: test: add support for test abort
Date: Tue, 13 Aug 2019 10:06:27 -0700
Message-ID: <20190813170628.9B0912067D@mail.kernel.org>
References: <20190812182421.141150-1-brendanhiggins@google.com>
 <20190812182421.141150-10-brendanhiggins@google.com>
 <20190813042159.46814206C2@mail.kernel.org>
 <CAFd5g44XyQi-oprPcdgx-EPboQYaHY6Ocz8Te6NX2SxV=mVhQA@mail.gmail.com>
 <20190813055615.CA787206C2@mail.kernel.org>
 <CAFd5g4415URtJBKPhsEw98GxiExJr-fstW6SQ6nmV9ts9ggK-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <CAFd5g4415URtJBKPhsEw98GxiExJr-fstW6SQ6nmV9ts9ggK-g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
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
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-kbuild <linux-kbuild-u79uwXL29TasMV2rI37PzA@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-08-13 00:52:03)
> On Mon, Aug 12, 2019 at 10:56 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> >
> > Quoting Brendan Higgins (2019-08-12 21:57:55)
> > > On Mon, Aug 12, 2019 at 9:22 PM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > >
> > > > Quoting Brendan Higgins (2019-08-12 11:24:12)
> > > > > diff --git a/include/kunit/test.h b/include/kunit/test.h
> > > > > index 2625bcfeb19ac..93381f841e09f 100644
> > > > > --- a/include/kunit/test.h
> > > > > +++ b/include/kunit/test.h
> > > > > @@ -184,6 +191,13 @@ struct kunit {
> > > > >         struct list_head resources; /* Protected by lock. */
> > > > >  };
> > > > >
> > > > > +static inline void kunit_set_death_test(struct kunit *test, bool death_test)
> > > > > +{
> > > > > +       spin_lock(&test->lock);
> > > > > +       test->death_test = death_test;
> > > > > +       spin_unlock(&test->lock);
> > > > > +}
> > > >
> > > > These getters and setters are using spinlocks again. It doesn't make any
> > > > sense. It probably needs a rework like was done for the other bool
> > > > member, success.
> > >
> > > No, this is intentional. death_test can transition from false to true
> > > and then back to false within the same test. Maybe that deserves a
> > > comment?
> >
> > Yes. How does it transition from true to false again?
> 
> The purpose is to tell try_catch that it was expected for the test to
> bail out. Given the default implementation there is no way for this to
> happen aside from abort() being called, but in some implementations it
> is possible to implement a fault catcher which allows a test suite to
> recover from an unexpected failure.
> 
> Maybe it would be best to drop this until I add one of those
> alternative implementations.

Ok.

> 
> > Either way, having a spinlock around a read/write API doesn't make sense
> > because it just makes sure that two writes don't overlap, but otherwise
> > does nothing to keep things synchronized. For example a set to true
> > after a set to false when the two calls to set true or false aren't
> > synchronized means they can happen in any order. So I don't see how it
> > needs a spinlock. The lock needs to be one level higher.
> 
> There shouldn't be any cases where one thread is trying to set it
> while another is trying to unset it. The thing I am worried about here
> is making sure all the cores see the write, and making sure no reads
> or writes get reordered before it. So I guess I just want a fence. So
> I take it I should probably have is a WRITE_ONCE here and READ_ONCE in
> the getter?
> 

Are the gets and sets in program order? If so, WRITE_ONCE and READ_ONCE
aren't required. Otherwise, if it's possible for one thread to write it
and another to read it but the threads are ordered with some other
barrier like a completion or lock, then again the macros aren't needed.
It would be good to read memory-barriers.txt to understand when to use
the read/write macros.
