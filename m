From: Stephen Boyd <sboyd@kernel.org>
Subject: Re: [PATCH v13 09/18] kunit: test: add support for test abort
Date: Wed, 14 Aug 2019 00:16:57 -0700
Message-ID: <20190814071658.066412054F@mail.kernel.org>
References: <20190814055108.214253-1-brendanhiggins@google.com> <20190814055108.214253-10-brendanhiggins@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190814055108.214253-10-brendanhiggins@google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: frowand.list@gmail.com, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com
Cc: devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com, Brendan Higgins <brendanhiggins@google.com>
List-Id: linux-nvdimm@lists.01.org

Quoting Brendan Higgins (2019-08-13 22:50:59)
> Add support for aborting/bailing out of test cases, which is needed for
> implementing assertions.
>=20
> An assertion is like an expectation, but bails out of the test case
> early if the assertion is not met. The idea with assertions is that you
> use them to state all the preconditions for your test. Logically
> speaking, these are the premises of the test case, so if a premise isn't
> true, there is no point in continuing the test case because there are no
> conclusions that can be drawn without the premises. Whereas, the
> expectation is the thing you are trying to prove.
>=20
> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@kernel.org>
