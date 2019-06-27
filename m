From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v5 13/18] kunit: tool: add Python wrappers for running
 KUnit tests
Date: Wed, 26 Jun 2019 17:23:12 -0700
Message-ID: <CAFd5g44ZbVCM3rksF44z_diiejS+Xc+qcXm120L+t+FHwuGyrA@mail.gmail.com>
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <20190617082613.109131-14-brendanhiggins@google.com> <20190626000150.GT19023@42.do-not-panic.com>
 <CAFd5g44kkepB2hZcpYL-NB5ZHYE5tP7W-0yducGCX7Khd9gd9w@mail.gmail.com> <20190626220350.GA19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190626220350.GA19023@42.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Peter Zijlstra <peterz@infradead.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah <shuah@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Masahiro Yamada <yamada.masahiro@socionext.com>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-ks>
List-Id: linux-nvdimm@lists.01.org

On Wed, Jun 26, 2019 at 3:03 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Jun 26, 2019 at 01:02:55AM -0700, Brendan Higgins wrote:
> > On Tue, Jun 25, 2019 at 5:01 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> > >
> > > On Mon, Jun 17, 2019 at 01:26:08AM -0700, Brendan Higgins wrote:
> > > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-all_passed.log
> > > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-crash.log
> > > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-failure.log
> > > >  create mode 100644 tools/testing/kunit/test_data/test_is_test_passed-no_tests_run.log
> > > >  create mode 100644 tools/testing/kunit/test_data/test_output_isolated_correctly.log
> > > >  create mode 100644 tools/testing/kunit/test_data/test_read_from_file.kconfig
> > >
> > > Why are these being added upstream? The commit log does not explain
> > > this.
> >
> > Oh sorry, those are for testing purposes. I thought that was clear
> > from being in the test_data directory. I will reference it in the
> > commit log in the next revision.
>
> Still, I don't get it. They seem to be results from a prior run. Why do
> we need them for testing purposes?

Those logs are the raw output from UML with KUnit installed. They are
for testing kunit_tool, the Python scripts added in this commit. One
of the things that kunit_tool does is parses the results output by
UML, extracts the KUnit data, and presents it in a user friendly
manner.

I added these logs so I could test that kunit_tool parses certain
kinds of output correctly. For example, I want to know that it parses
a test failure correctly and includes the appropriate context. So I
have a log from a unit test that failed, and I have a test (a Python
test that is also in this commit) that tests whether kunit_tool can
parse the log correctly.

Does that make sense?
