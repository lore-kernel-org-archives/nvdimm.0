Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2F580211CD639
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 16:29:16 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id g16so15123344oib.1
 for <linux-nvdimm@lists.01.org>; Wed, 27 Feb 2019 16:29:16 -0800 (PST)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com>
 <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
 <CAFd5g46NehKo=TT4reQ8r74bDTG9BkR=ELg+Q3n5YooUxFwBmA@mail.gmail.com>
 <1d72f04e-08ba-e3dd-c8c0-512946126113@gmail.com>
In-Reply-To: <1d72f04e-08ba-e3dd-c8c0-512946126113@gmail.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Wed, 27 Feb 2019 16:29:04 -0800
Message-ID: <CAFd5g45GjG871ynfMADN+4zmecfARCk2ribY7MsMSc4=QkNqgQ@mail.gmail.com>
Subject: Re: [RFC v3 17/19] of: unittest: migrate tests to run on KUnit
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Frank Rowand <frowand.list@gmail.com>
Cc: brakmo@fb.com, dri-devel <dri-devel@lists.freedesktop.org>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, "Bird," Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>," linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 18, 2019 at 2:56 PM Frank Rowand <frowand.list@gmail.com> wrote:
>
> On 2/12/19 5:44 PM, Brendan Higgins wrote:
> > On Wed, Nov 28, 2018 at 12:56 PM Rob Herring <robh@kernel.org> wrote:
> >>
> >> On Wed, Nov 28, 2018 at 1:38 PM Brendan Higgins
> >> <brendanhiggins@google.com> wrote:
<snip>
> >>> ---
> >>>  drivers/of/Kconfig    |    1 +
> >>>  drivers/of/unittest.c | 1405 ++++++++++++++++++++++-------------------
> >>>  2 files changed, 752 insertions(+), 654 deletions(-)
> >>>
> > <snip>
> >>> diff --git a/drivers/of/unittest.c b/drivers/of/unittest.c
> >>> index 41b49716ac75f..a5ef44730ffdb 100644
> >>> --- a/drivers/of/unittest.c
> >>> +++ b/drivers/of/unittest.c
<snip>
> >>> +
> >>> +       KUNIT_EXPECT_EQ(test,
> >>> +                       of_property_match_string(np,
> >>> +                                                "phandle-list-names",
> >>> +                                                "first"),
> >>> +                       0);
> >>> +       KUNIT_EXPECT_EQ(test,
> >>> +                       of_property_match_string(np,
> >>> +                                                "phandle-list-names",
> >>> +                                                "second"),
> >>> +                       1);
> >>
> >> Fewer lines on these would be better even if we go over 80 chars.
>
> Agreed.  unittest.c already is a greater than 80 char file in general, and
> is a file that benefits from that.
>

Noted.

>
> > On the of_property_match_string(...), I have no opinion. I will do
> > whatever you like best.
> >
> > Nevertheless, as far as the KUNIT_EXPECT_*(...), I do have an opinion: I am
> > trying to establish a good, readable convention. Given an expect statement
> > structured as
> > ```
> > KUNIT_EXPECT_*(
> >     test,
> >     expect_arg_0, ..., expect_arg_n,
> >     fmt_str, fmt_arg_0, ..., fmt_arg_n)
> > ```
> > where `test` is the `struct kunit` context argument, `expect_arg_{0, ..., n}`
> > are the arguments the expectations is being made about (so in the above example,
> > `of_property_match_string(...)` and `1`), and `fmt_*` is the optional format
> > string that comes at the end of some expectations.
> >
> > The pattern I had been trying to promote is the following:
> >
> > 1) If everything fits on 1 line, do that.
> > 2) If you must make a line split, prefer to keep `test` on its own line,
> > `expect_arg_{0, ..., n}` should be kept together, if possible, and the format
> > string should follow the conventions already most commonly used with format
> > strings.
> > 3) If you must split up `expect_arg_{0, ..., n}` each argument should get its
> > own line and should not share a line with either `test` or any `fmt_*`.
> >
> > The reason I care about this so much is because expectations should be
> > extremely easy to read; they are the most important part of a unit
> > test because they tell you what the test is verifying. I am not
> > married to the formatting I proposed above, but I want something that
> > will be extremely easy to identify the arguments that the expectation
> > is on. Maybe that means that I need to add some syntactic fluff to
> > make it clearer, I don't know, but this is definitely something we
> > need to get right, especially in the earliest examples.
>
> I will probably raise the ire of the kernel formatting rule makers by offering
> what I think is a _much_ more readable format __for this specific case__.
> In other words for drivers/of/unittest.c.
>
> If you can not make your mail window _very_ wide, or if this email has been
> line wrapped, this example will not be clear.
>
> Two possible formats:
>
>
> ### -----  version 1, as created by the patch series
>
> static void of_unittest_property_string(struct kunit *test)
> {
>         const char *strings[4];
>         struct device_node *np;
>         int rc;
>
>         np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>
>         KUNIT_EXPECT_EQ(
>                 test,
>                 of_property_match_string(np, "phandle-list-names", "first"),
>                 0);
>         KUNIT_EXPECT_EQ(
>                 test,
>                 of_property_match_string(np, "phandle-list-names", "second"),
>                 1);
>         KUNIT_EXPECT_EQ(
>                 test,
>                 of_property_match_string(np, "phandle-list-names", "third"),
>                 2);
>         KUNIT_EXPECT_EQ_MSG(
>                 test,
>                 of_property_match_string(np, "phandle-list-names", "fourth"),
>                 -ENODATA,
>                 "unmatched string");
>         KUNIT_EXPECT_EQ_MSG(
>                 test,
>                 of_property_match_string(np, "missing-property", "blah"),
>                 -EINVAL,
>                 "missing property");
>         KUNIT_EXPECT_EQ_MSG(
>                 test,
>                 of_property_match_string(np, "empty-property", "blah"),
>                 -ENODATA,
>                 "empty property");
>         KUNIT_EXPECT_EQ_MSG(
>                 test,
>                 of_property_match_string(np, "unterminated-string", "blah"),
>                 -EILSEQ,
>                 "unterminated string");
>
>         /* of_property_count_strings() tests */
>         KUNIT_EXPECT_EQ(test,
>                         of_property_count_strings(np, "string-property"), 1);
>         KUNIT_EXPECT_EQ(test,
>                         of_property_count_strings(np, "phandle-list-names"), 3);
>         KUNIT_EXPECT_EQ_MSG(
>                 test,
>                 of_property_count_strings(np, "unterminated-string"), -EILSEQ,
>                 "unterminated string");
>         KUNIT_EXPECT_EQ_MSG(
>                 test,
>                 of_property_count_strings(np, "unterminated-string-list"),
>                 -EILSEQ,
>                 "unterminated string array");
>
>
>
>
> ### -----  version 2, modified to use really long lines
>
> static void of_unittest_property_string(struct kunit *test)
> {
>         const char *strings[4];
>         struct device_node *np;
>         int rc;
>
>         np = of_find_node_by_path("/testcase-data/phandle-tests/consumer-a");
>         KUNIT_ASSERT_NOT_ERR_OR_NULL(test, np);
>
>         KUNIT_EXPECT_EQ(    test, of_property_match_string(np, "phandle-list-names", "first"),  0);
>         KUNIT_EXPECT_EQ(    test, of_property_match_string(np, "phandle-list-names", "second"), 1);
>         KUNIT_EXPECT_EQ(    test, of_property_match_string(np, "phandle-list-names", "third"),  2);
>         KUNIT_EXPECT_EQ_MSG(test, of_property_match_string(np, "phandle-list-names", "fourth"), -ENODATA, "unmatched string");
>         KUNIT_EXPECT_EQ_MSG(test, of_property_match_string(np, "missing-property", "blah"),     -EINVAL, "missing property");
>         KUNIT_EXPECT_EQ_MSG(test, of_property_match_string(np, "empty-property", "blah"),       -ENODATA, "empty property");
>         KUNIT_EXPECT_EQ_MSG(test, of_property_match_string(np, "unterminated-string", "blah"),  -EILSEQ, "unterminated string");
>
>         /* of_property_count_strings() tests */
>         KUNIT_EXPECT_EQ(    test, of_property_count_strings(np, "string-property"),             1);
>         KUNIT_EXPECT_EQ(    test, of_property_count_strings(np, "phandle-list-names"),          3);
>         KUNIT_EXPECT_EQ_MSG(test, of_property_count_strings(np, "unterminated-string"),         -EILSEQ, "unterminated string");
>         KUNIT_EXPECT_EQ_MSG(test, of_property_count_strings(np, "unterminated-string-list"),    -EILSEQ, "unterminated string array");
>
>
>         ------------------------  ------------------------------------------------------------- --------------------------------------
>              ^                         ^                                                             ^
>              |                         |                                                             |
>              |                         |                                                             |
>             mostly boilerplate        what is being tested                                          expected result, error message
>             (can vary in relop
>              and _MSG or not)
>
> In my opinion, the second version is much more readable.  It is easy to see the
> differences in the boilerplate.  It is easy to see what is being tested, and how
> the arguments of the tested function vary for each test.  It is easy to see the
> expected result and error message.  The entire block fits into a single short
> window (though much wider).

I have no opinion on the over 80 char thing, so as long as everyone
else is okay with it, I have no complaints.

Cheers
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
