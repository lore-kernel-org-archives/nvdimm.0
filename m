From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v3 08/18] objtool: add kunit_try_catch_throw to the
 noreturn list
Date: Tue, 14 May 2019 11:12:33 -0700
Message-ID: <20190514181233.GB109557@google.com>
References: <20190514054251.186196-1-brendanhiggins@google.com>
 <20190514054251.186196-9-brendanhiggins@google.com>
 <20190514065643.GC2589@hirez.programming.kicks-ass.net>
 <20190514081223.GA230665@google.com>
 <20190514084655.GK2589@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190514084655.GK2589@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: frowand.list@gmail.com, gregkh@linuxfoundation.org, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, tytso@mit.edu, yamada.masahiro@socionext.com, Josh Poimboeuf <jpoimboe@redhat.com>, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.om
List-Id: linux-nvdimm@lists.01.org

On Tue, May 14, 2019 at 10:46:55AM +0200, Peter Zijlstra wrote:
> On Tue, May 14, 2019 at 01:12:23AM -0700, Brendan Higgins wrote:
> > On Tue, May 14, 2019 at 08:56:43AM +0200, Peter Zijlstra wrote:
> > > On Mon, May 13, 2019 at 10:42:42PM -0700, Brendan Higgins wrote:
> > > > This fixes the following warning seen on GCC 7.3:
> > > >   kunit/test-test.o: warning: objtool: kunit_test_unsuccessful_try() falls through to next function kunit_test_catch()
> > > > 
> > > 
> > > What is that file and function; no kernel tree near me seems to have
> > > that.
> > 
> > Oh, sorry about that. The function is added in the following patch,
> > "[PATCH v3 09/18] kunit: test: add support for test abort"[1].
> > 
> > My apologies if this patch is supposed to come after it in sequence, but
> > I assumed it should come before otherwise objtool would complain about
> > the symbol when it is introduced.
> 
> Or send me all patches such that I have context, or have a sane
> Changelog that gives me context. Just don't give me one patch with a
> crappy changelog.

I will provide more context in the next revision.

Sorry about that!
