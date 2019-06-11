From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v4 17/18] kernel/sysctl-test: Add null pointer test for sysctl.c:proc_dointvec()
Date: Tue, 11 Jun 2019 11:50:17 -0700
Message-ID: <20190611185018.2E1C021744@mail.kernel.org>
References: <20190514221711.248228-1-brendanhiggins@google.com> <20190514221711.248228-18-brendanhiggins@google.com> <20190517182254.548EA20815@mail.kernel.org> <CAAXuY3p4qhKVsSpQ44_kQeGDMfg7OuFLgFyxhcFWS3yf-5A_7g@mail.gmail.com> <20190607190047.C3E7A20868@mail.kernel.org> <20190611175830.GA236872@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190611175830.GA236872@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Iurii Zaikin <yzaikin@google.com>, frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.c
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-06-11 10:58:30)
> On Fri, Jun 07, 2019 at 12:00:47PM -0700, Stephen Boyd wrote:
> > Quoting Iurii Zaikin (2019-06-05 18:29:42)
> > > On Fri, May 17, 2019 at 11:22 AM Stephen Boyd <sboyd@kernel.org> wrot=
e:
> > > >
> > > > Quoting Brendan Higgins (2019-05-14 15:17:10)
> > > > > diff --git a/kernel/sysctl-test.c b/kernel/sysctl-test.c
> > > > > new file mode 100644
> > > > > index 0000000000000..fe0f2bae66085
> > > > > --- /dev/null
> > > > > +++ b/kernel/sysctl-test.c
> > > > > +
> > > > > +
> > > > > +static void sysctl_test_dointvec_happy_single_negative(struct ku=
nit *test)
> > > > > +{
> > > > > +       struct ctl_table table =3D {
> > > > > +               .procname =3D "foo",
> > > > > +               .data           =3D &test_data.int_0001,
> > > > > +               .maxlen         =3D sizeof(int),
> > > > > +               .mode           =3D 0644,
> > > > > +               .proc_handler   =3D proc_dointvec,
> > > > > +               .extra1         =3D &i_zero,
> > > > > +               .extra2         =3D &i_one_hundred,
> > > > > +       };
> > > > > +       char input[] =3D "-9";
> > > > > +       size_t len =3D sizeof(input) - 1;
> > > > > +       loff_t pos =3D 0;
> > > > > +
> > > > > +       table.data =3D kunit_kzalloc(test, sizeof(int), GFP_USER);
> > > > > +       KUNIT_EXPECT_EQ(test, 0, proc_dointvec(&table, 1, input, =
&len, &pos));
> > > > > +       KUNIT_EXPECT_EQ(test, sizeof(input) - 1, len);
> > > > > +       KUNIT_EXPECT_EQ(test, sizeof(input) - 1, pos);
> > > > > +       KUNIT_EXPECT_EQ(test, -9, *(int *)table.data);
> > > >
> > > > Is the casting necessary? Or can the macro do a type coercion of the
> > > > second parameter based on the first type?
> > >  Data field is defined as void* so I believe casting is necessary to
> > > dereference it as a pointer to an array of ints. I don't think the
> > > macro should do any type coercion that =3D=3D operator wouldn't do.
> > >  I did change the cast to make it more clear that it's a pointer to an
> > > array of ints being dereferenced.
> >=20
> > Ok, I still wonder if we should make KUNIT_EXPECT_EQ check the types on
> > both sides and cause a build warning/error if the types aren't the same.
> > This would be similar to our min/max macros that complain about
> > mismatched types in the comparisons. Then if a test developer needs to
> > convert one type or the other they could do so with a
> > KUNIT_EXPECT_EQ_T() macro that lists the types to coerce both sides to
> > explicitly.
>=20
> Do you think it would be better to do a phony compare similar to how
> min/max used to work prior to 4.17, or to use the new __typecheck(...)
> macro? This might seem like a dumb question (and maybe it is), but Iurii
> and I thought the former created an error message that was a bit easier
> to understand, whereas __typecheck is obviously superior in terms of
> code reuse.
>=20
> This is what we are thinking right now; if you don't have any complaints
> I will squash it into the relevant commits on the next revision:

Can you provide the difference in error messages and describe that in
the commit text? The commit message is where you "sell" the patch, so
being able to compare the tradeoff of having another macro to do type
comparisons vs. reusing the one that's there in kernel.h would be useful
to allay concerns that we're duplicating logic for better error
messages.

Honestly, I'd prefer we just use the macros that we've developed in
kernel.h to do comparisons here so that we can get code reuse, but more
importantly so that we don't trip over problems that caused those macros
to be created in the first place. If the error message is bad, perhaps
that can be fixed with some sort of compiler directive to make the error
message a little more useful, i.e. compiletime_warning() thrown into
__typecheck() or something.

> ---
> From: Iurii Zaikin <yzaikin@google.com>
>=20
> Adds a warning message when comparing values of different types similar
> to what min() / max() macros do.
>=20
> Signed-off-by: Iurii Zaikin <yzaikin@google.com>
