From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v4 03/18] kunit: test: add string_stream a std::stream like string builder
Date: Fri, 17 May 2019 10:42:59 -0700
Message-ID: <20190517174300.7949F20848@mail.kernel.org>
References: <20190514221711.248228-1-brendanhiggins@google.com> <20190514221711.248228-4-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190514221711.248228-4-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com, Brendan Higgins <brendanhiggins@google.com>
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-05-14 15:16:56)
> A number of test features need to do pretty complicated string printing
> where it may not be possible to rely on a single preallocated string
> with parameters.
>=20
> So provide a library for constructing the string as you go similar to
> C++'s std::string.
>=20
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>

Is there any reason why we can't use the seqfile API for this? These
both share a similar goal, formatting strings into a buffer to be read
later. Maybe some new APIs would be needed to extract the buffer
differently, but I hope we could share the code.

If it can't be used, can you please add the reasoning to the commit text
here?
