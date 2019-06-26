Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5F4E02129F0EC
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 15:03:53 -0700 (PDT)
Received: by mail-pg1-f195.google.com with SMTP id v9so46pgr.13
 for <linux-nvdimm@lists.01.org>; Wed, 26 Jun 2019 15:03:53 -0700 (PDT)
Date: Wed, 26 Jun 2019 22:03:50 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH v5 13/18] kunit: tool: add Python wrappers for running
 KUnit tests
Message-ID: <20190626220350.GA19023@42.do-not-panic.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-14-brendanhiggins@google.com>
 <20190626000150.GT19023@42.do-not-panic.com>
 <CAFd5g44kkepB2hZcpYL-NB5ZHYE5tP7W-0yducGCX7Khd9gd9w@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFd5g44kkepB2hZcpYL-NB5ZHYE5tP7W-0yducGCX7Khd9gd9w@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Felix Guo <felixguoxiuping@gmail.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Poimboeuf <jpoimboe@redhat.com>, kunit-dev@googlegroups.com, Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Stephen Boyd <sboyd@kernel.org>, Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jun 26, 2019 at 01:02:55AM -0700, Brendan Higgins wrote:
> On Tue, Jun 25, 2019 at 5:01 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Mon, Jun 17, 2019 at 01:26:08AM -0700, Brendan Higgins wrote:
> > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-all_passed.log
> > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-crash.log
> > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-failure.log
> > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-no_tests_run.log
> > >  create mode 100644 tools/testing/kunit/test_data/test_output_isolated_correctly.log
> > >  create mode 100644 tools/testing/kunit/test_data/test_read_from_file.kconfig
> >
> > Why are these being added upstream? The commit log does not explain
> > this.
> 
> Oh sorry, those are for testing purposes. I thought that was clear
> from being in the test_data directory. I will reference it in the
> commit log in the next revision.

Still, I don't get it. They seem to be results from a prior run. Why do
we need them for testing purposes?

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
