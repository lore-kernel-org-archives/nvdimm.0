From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 17/18] kernel/sysctl-test: Add null pointer test for
 sysctl.c:proc_dointvec()
Date: Tue, 11 Jun 2019 13:29:01 -0700
Message-ID: <CAFd5g47dmcHOCX41cr2v9Kaj3xa_5-PoqUPX_1=AoQLUG90NkQ@mail.gmail.com>
References: <20190514221711.248228-1-brendanhiggins@google.com>
 <20190514221711.248228-18-brendanhiggins@google.com>
 <20190517182254.548EA20815@mail.kernel.org>
 <CAAXuY3p4qhKVsSpQ44_kQeGDMfg7OuFLgFyxhcFWS3yf-5A_7g@mail.gmail.com>
 <20190607190047.C3E7A20868@mail.kernel.org>
 <20190611175830.GA236872@google.com>
 <20190611185018.2E1C021744@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190611185018.2E1C021744-+nuXSHJNwjE76Z2rM5mHXA@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, Joel Stanley <joel-U3u1mxZcP9KHXe+LvDLADg@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, devicetree <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>lin
List-Id: linux-nvdimm@lists.01.org

On Tue, Jun 11, 2019 at 11:50 AM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Quoting Brendan Higgins (2019-06-11 10:58:30)
> > On Fri, Jun 07, 2019 at 12:00:47PM -0700, Stephen Boyd wrote:
> > > Quoting Iurii Zaikin (2019-06-05 18:29:42)
> > > > On Fri, May 17, 2019 at 11:22 AM Stephen Boyd <sboyd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > >
> > > > > Quoting Brendan Higgins (2019-05-14 15:17:10)
> > > > > > diff --git a/kernel/sysctl-test.c b/kernel/sysctl-test.c
> > > > > > new file mode 100644
> > > > > > index 0000000000000..fe0f2bae66085
> > > > > > --- /dev/null
> > > > > > +++ b/kernel/sysctl-test.c
> > > > > > +
> > > > > > +
> > > > > > +static void sysctl_test_dointvec_happy_single_negative(struct kunit *test)
> > > > > > +{
> > > > > > +       struct ctl_table table = {
> > > > > > +               .procname = "foo",
> > > > > > +               .data           = &test_data.int_0001,
> > > > > > +               .maxlen         = sizeof(int),
> > > > > > +               .mode           = 0644,
> > > > > > +               .proc_handler   = proc_dointvec,
> > > > > > +               .extra1         = &i_zero,
> > > > > > +               .extra2         = &i_one_hundred,
> > > > > > +       };
> > > > > > +       char input[] = "-9";
> > > > > > +       size_t len = sizeof(input) - 1;
> > > > > > +       loff_t pos = 0;
> > > > > > +
> > > > > > +       table.data = kunit_kzalloc(test, sizeof(int), GFP_USER);
> > > > > > +       KUNIT_EXPECT_EQ(test, 0, proc_dointvec(&table, 1, input, &len, &pos));
> > > > > > +       KUNIT_EXPECT_EQ(test, sizeof(input) - 1, len);
> > > > > > +       KUNIT_EXPECT_EQ(test, sizeof(input) - 1, pos);
> > > > > > +       KUNIT_EXPECT_EQ(test, -9, *(int *)table.data);
> > > > >
> > > > > Is the casting necessary? Or can the macro do a type coercion of the
> > > > > second parameter based on the first type?
> > > >  Data field is defined as void* so I believe casting is necessary to
> > > > dereference it as a pointer to an array of ints. I don't think the
> > > > macro should do any type coercion that == operator wouldn't do.
> > > >  I did change the cast to make it more clear that it's a pointer to an
> > > > array of ints being dereferenced.
> > >
> > > Ok, I still wonder if we should make KUNIT_EXPECT_EQ check the types on
> > > both sides and cause a build warning/error if the types aren't the same.
> > > This would be similar to our min/max macros that complain about
> > > mismatched types in the comparisons. Then if a test developer needs to
> > > convert one type or the other they could do so with a
> > > KUNIT_EXPECT_EQ_T() macro that lists the types to coerce both sides to
> > > explicitly.
> >
> > Do you think it would be better to do a phony compare similar to how
> > min/max used to work prior to 4.17, or to use the new __typecheck(...)
> > macro? This might seem like a dumb question (and maybe it is), but Iurii
> > and I thought the former created an error message that was a bit easier
> > to understand, whereas __typecheck is obviously superior in terms of
> > code reuse.
> >
> > This is what we are thinking right now; if you don't have any complaints
> > I will squash it into the relevant commits on the next revision:
>
> Can you provide the difference in error messages and describe that in
> the commit text? The commit message is where you "sell" the patch, so
> being able to compare the tradeoff of having another macro to do type
> comparisons vs. reusing the one that's there in kernel.h would be useful
> to allay concerns that we're duplicating logic for better error
> messages.

Oh sorry, I didn't think too hard about the commit message since I
figured it would get split up and squashed into the existing commits.
I just wanted to get it out sooner to discuss this before I post the
next revision (probably later this week).

> Honestly, I'd prefer we just use the macros that we've developed in
> kernel.h to do comparisons here so that we can get code reuse, but more
> importantly so that we don't trip over problems that caused those macros
> to be created in the first place. If the error message is bad, perhaps
> that can be fixed with some sort of compiler directive to make the error
> message a little more useful, i.e. compiletime_warning() thrown into
> __typecheck() or something.

That's a good point. I have no qualms sticking with __typecheck(...)
for now; if we later feel that it is causing problems, we can always
fix it later by supplying our own warning in the manner you suggest.

Iurii, do you have any additional thoughts on this?

>
> > ---
> > From: Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >
> > Adds a warning message when comparing values of different types similar
> > to what min() / max() macros do.
> >
> > Signed-off-by: Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
