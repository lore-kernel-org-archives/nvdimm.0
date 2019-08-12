Return-Path: <linux-kernel-owner@vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20190812233336.GA224410@google.com>
References: <20190812182421.141150-1-brendanhiggins@google.com> <20190812182421.141150-4-brendanhiggins@google.com> <20190812225520.5A67C206A2@mail.kernel.org> <20190812233336.GA224410@google.com>
Subject: Re: [PATCH v12 03/18] kunit: test: add string_stream a std::stream like string builder
From: Stephen Boyd <sboyd@kernel.org>
Date: Mon, 12 Aug 2019 16:59:39 -0700
Message-Id: <20190812235940.100842063F@mail.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

Quoting Brendan Higgins (2019-08-12 16:33:36)
> On Mon, Aug 12, 2019 at 03:55:19PM -0700, Stephen Boyd wrote:
> > Quoting Brendan Higgins (2019-08-12 11:24:06)
> > > +void string_stream_clear(struct string_stream *stream)
> > > +{
> > > +       struct string_stream_fragment *frag_container, *frag_containe=
r_safe;
> > > +
> > > +       spin_lock(&stream->lock);
> > > +       list_for_each_entry_safe(frag_container,
> > > +                                frag_container_safe,
> > > +                                &stream->fragments,
> > > +                                node) {
> > > +               list_del(&frag_container->node);
> >=20
> > Shouldn't we free the allocation here? Otherwise, if some test is going
> > to add, add, clear, add, it's going to leak until the test is over?
>=20
> So basically this means I should add a kunit_kfree and
> kunit_resource_destroy (respective equivalents to devm_kfree, and
> devres_destroy) and use kunit_kfree here?
>=20

Yes, or drop the API entirely? Does anything need this functionality?
