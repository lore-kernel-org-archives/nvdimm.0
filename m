From: Brendan Higgins <brendanhiggins-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 17/18] kernel/sysctl-test: Add null pointer test for
 sysctl.c:proc_dointvec()
Date: Fri, 28 Jun 2019 01:01:54 -0700
Message-ID: <CAFd5g45VJ9yfuESUc=E0ydJyN+mk1b1kyHSCYvO2x9KPC7+3GQ@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-18-brendanhiggins@google.com>
 <20190626021744.GU19023@42.do-not-panic.com>
 <CAAXuY3p+kVhjQ4LYtzormqVcH2vKu1abc_K9Z0XY=JX=bp8NcQ@mail.gmail.com>
 <20190627061021.GE19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20190627061021.GE19023-24ieFPqdLRAUX4Zk0b6cZUEOCMrvLtNR@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, "open list:DOCUMENTATION" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, dri-devel <dri-devel-PD4FTy7X32lNgt0PjOBp9y5qC8QIuHrW@public.gmane.org>, Sasha Levin <Alexander.Levin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, Masahiro Yamada <yamada.masahiro-uWyLwvC0a2jby3iVrkZq2A@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, shuah <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Rob Herring <robh-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-nvdimm <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Kieran Bingham <kieran.bingham-ryLnwIuWjnjg/C1BVhZhaw@public.gmane.org>, wfg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, "Michael Kerrisk (man-pages)" <mtk.manpages-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Iurii Zaikin <yzaikin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jeff Dike <jdike-OPE4K8JWMJJBDgjK7y7TUQ@public.gmane.org>, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Joel Stanley <joel>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 26, 2019 at 11:10 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, Jun 26, 2019 at 09:07:43PM -0700, Iurii Zaikin wrote:
> > On Tue, Jun 25, 2019 at 7:17 PM Luis Chamberlain <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > > +static void sysctl_test_dointvec_table_maxlen_unset(struct kunit *test)
> > > > +{
> > > > +     struct ctl_table table = {
> > > > +             .procname = "foo",
> > > > +             .data           = &test_data.int_0001,
> > > > +             .maxlen         = 0,
> > > > +             .mode           = 0644,
> > > > +             .proc_handler   = proc_dointvec,
> > > > +             .extra1         = &i_zero,
> > > > +             .extra2         = &i_one_hundred,
> > > > +     };
> > > > +     void  *buffer = kunit_kzalloc(test, sizeof(int), GFP_USER);
> > > > +     size_t len;
> > > > +     loff_t pos;
> > > > +
> > > > +     len = 1234;
> > > > +     KUNIT_EXPECT_EQ(test, 0, proc_dointvec(&table, 0, buffer, &len, &pos));
> > > > +     KUNIT_EXPECT_EQ(test, (size_t)0, len);
> > > > +     len = 1234;
> > > > +     KUNIT_EXPECT_EQ(test, 0, proc_dointvec(&table, 1, buffer, &len, &pos));
> > > > +     KUNIT_EXPECT_EQ(test, (size_t)0, len);
> > > > +}
> > >
> > > In a way this is also testing for general kernel API changes. This is and the
> > > last one were good examples. So this is not just testing functionality
> > > here. There is no wrong or write answer if 0 or -EINVAL was returned
> > > other than the fact that we have been doing this for years.
> > >
> > > Its a perhaps small but important difference for some of these tests.  I
> > > *do* think its worth clarifying through documentation which ones are
> > > testing for API consistency Vs proper correctness.
> >
> > You make a good point that the test codifies the existing behavior of
> > the function in lieu of formal documentation.  However, the test cases
> > were derived from examining the source code of the function under test
> > and attempting to cover all branches. The assertions were added only
> > for the values that appeared to be set deliberately in the
> > implementation. And it makes sense to me to test that the code does
> > exactly what the implementation author intended.
>
> I'm not arguing against adding them. I'm suggesting that it is different
> to test for API than for correctness of intended functionality, and
> it would be wise to make it clear which test cases are for API and which
> for correctness.

I see later on that some of the API stuff you are talking about is
public APIs from the standpoint of user (outside of LInux) visible. To
be clear, is that what you mean by public APIs throughout, or would
you distinguish between correctness tests, internal API tests, and
external API tests?

> This will come up later for other kunit tests and it would be great
> to set precendent so that other kunit tests can follow similar
> practices to ensure its clear what is API realted Vs correctness of
> intended functionality.
>
> In fact, I'm not yet sure if its possible to test public kernel API to
> userspace with kunit, but if it is possible... well, that could make
> linux-api folks happy as they could enable us to codify interpreation of
> what is expected into kunit test cases, and we'd ensure that the
> codified interpretation is not only documented in man pages but also
> through formal kunit test cases.
>
> A regression in linux-api then could be formalized through a proper
> kunit tests case. And if an API evolves, it would force developers to
> update the respective kunit which codifies that contract.

Yep, I think that is long term hope. Some of the file system interface
stuff that requires a filesystem to be mounted somewhere might get a
little weird/difficult, but I suspect we should be able to do it
eventually. I mean it's all just C code right? Should mostly boil down
to someone figuring out how to do it the first time.

> > > > +static void sysctl_test_dointvec_single_less_int_min(struct kunit *test)
> > > > +{
> > > > +     struct ctl_table table = {
> > > > +             .procname = "foo",
> > > > +             .data           = &test_data.int_0001,
> > > > +             .maxlen         = sizeof(int),
> > > > +             .mode           = 0644,
> > > > +             .proc_handler   = proc_dointvec,
> > > > +             .extra1         = &i_zero,
> > > > +             .extra2         = &i_one_hundred,
> > > > +     };
> > > > +     char input[32];
> > > > +     size_t len = sizeof(input) - 1;
> > > > +     loff_t pos = 0;
> > > > +     unsigned long abs_of_less_than_min = (unsigned long)INT_MAX
> > > > +                                          - (INT_MAX + INT_MIN) + 1;
> > > > +
> > > > +     KUNIT_EXPECT_LT(test,
> > > > +                     (size_t)snprintf(input, sizeof(input), "-%lu",
> > > > +                                      abs_of_less_than_min),
> > > > +                     sizeof(input));
> > > > +
> > > > +     table.data = kunit_kzalloc(test, sizeof(int), GFP_USER);
> > > > +     KUNIT_EXPECT_EQ(test, -EINVAL,
> > > > +                     proc_dointvec(&table, 1, input, &len, &pos));
> > > > +     KUNIT_EXPECT_EQ(test, sizeof(input) - 1, len);
> > > > +     KUNIT_EXPECT_EQ(test, 0, ((int *)table.data)[0]);
> > > > +}
> > >
> > > API test.
> > >
> > Not sure why.
>
> Because you are codifying that we *definitely* return -EINVAL on
> overlow. Some parts of the kernel return -ERANGE for overflows for
> instance.
>
> It would be a generic test for overflow if it would just test
> for any error.
>
> It is a fine and good test to keep. All these tests are good to keep.
>
> > I believe there has been a real bug with int overflow in
> > proc_dointvec.
> > Covering it with test seems like a good idea.
>
> Oh definitely.
>
> > > > +static void sysctl_test_dointvec_single_greater_int_max(struct kunit *test)
> > > > +{
> > > > +     struct ctl_table table = {
> > > > +             .procname = "foo",
> > > > +             .data           = &test_data.int_0001,
> > > > +             .maxlen         = sizeof(int),
> > > > +             .mode           = 0644,
> > > > +             .proc_handler   = proc_dointvec,
> > > > +             .extra1         = &i_zero,
> > > > +             .extra2         = &i_one_hundred,
> > > > +     };
> > > > +     char input[32];
> > > > +     size_t len = sizeof(input) - 1;
> > > > +     loff_t pos = 0;
> > > > +     unsigned long greater_than_max = (unsigned long)INT_MAX + 1;
> > > > +
> > > > +     KUNIT_EXPECT_GT(test, greater_than_max, (unsigned long)INT_MAX);
> > > > +     KUNIT_EXPECT_LT(test, (size_t)snprintf(input, sizeof(input), "%lu",
> > > > +                                            greater_than_max),
> > > > +                     sizeof(input));
> > > > +     table.data = kunit_kzalloc(test, sizeof(int), GFP_USER);
> > > > +     KUNIT_EXPECT_EQ(test, -EINVAL,
> > > > +                     proc_dointvec(&table, 1, input, &len, &pos));
> > > > +     KUNIT_EXPECT_EQ(test, sizeof(input) - 1, len);
> > > > +     KUNIT_EXPECT_EQ(test, 0, ((int *)table.data)[0]);
> > > > +}
> > > > +
> > >
> > > API test.
> > >
> > > > +static struct kunit_case sysctl_test_cases[] = {
> > > > +     KUNIT_CASE(sysctl_test_dointvec_null_tbl_data),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_table_maxlen_unset),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_table_len_is_zero),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_table_read_but_position_set),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_happy_single_positive),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_happy_single_negative),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_single_less_int_min),
> > > > +     KUNIT_CASE(sysctl_test_dointvec_single_greater_int_max),
> > > > +     {}
> > > > +};
> > >
> > > Oh all are API tests.. perhaps then just rename then
> > > sysctl_test_cases to sysctl_api_test_cases.
> > >
> > > Would be good to add at least *two* other tests cases for this
> > > example, one which does a valid read and one which does a valid write.
> > Added valid reads. There already are 2 valid writes.
>
> Thanks.
>
> > > If that is done either we add another kunit test module for correctness
> > > or just extend the above and use prefix / postfixes on the functions
> > > to distinguish between API / correctness somehow.
> > >
> > > > +
> > > > +static struct kunit_module sysctl_test_module = {
> > > > +     .name = "sysctl_test",
> > > > +     .test_cases = sysctl_test_cases,
> > > > +};
> > > > +
> > > > +module_test(sysctl_test_module);
> > > > diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> > > > index cbdfae3798965..389b8986f5b77 100644
> > > > --- a/lib/Kconfig.debug
> > > > +++ b/lib/Kconfig.debug
> > > > @@ -1939,6 +1939,16 @@ config TEST_SYSCTL
> > > >
> > > >         If unsure, say N.
> > > >
> > > > +config SYSCTL_KUNIT_TEST
> > > > +     bool "KUnit test for sysctl"
> > > > +     depends on KUNIT
> > > > +     help
> > > > +       This builds the proc sysctl unit test, which runs on boot. For more
> > > > +       information on KUnit and unit tests in general please refer to the
> > > > +       KUnit documentation in Documentation/dev-tools/kunit/.
> > >
> > > A little more description here would help. It is testing for API and
> > > hopefully also correctness (if extended with those two examples I
> > > mentioned).
> > >
> > Added "Tests the API contract and implementation correctness of sysctl."
>
> Yes, much clearer, thanks!

Cheers!
