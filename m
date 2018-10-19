Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com
 [IPv6:2607:f8b0:4864:20::341])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4DFD721173C92
 for <linux-nvdimm@lists.01.org>; Thu, 18 Oct 2018 23:27:47 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id q50so32226231otd.0
 for <linux-nvdimm@lists.01.org>; Thu, 18 Oct 2018 23:27:47 -0700 (PDT)
MIME-Version: 1.0
References: <20181016235120.138227-1-brendanhiggins@google.com>
 <CAA9_cmeRE3mPvxb3NciGFYjNu9aMFx4iTMeUq2fC3UtsyXky2A@mail.gmail.com>
In-Reply-To: <CAA9_cmeRE3mPvxb3NciGFYjNu9aMFx4iTMeUq2fC3UtsyXky2A@mail.gmail.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Thu, 18 Oct 2018 23:27:34 -0700
Message-ID: <CAFd5g46P8PuGH8B5B3mT=M1a4Lg7JTOdWJ8LECo8-i2a=fUZDA@mail.gmail.com>
Subject: Re: [RFC v1 00/31] kunit: Introducing KUnit, the Linux kernel unit
 testing framework
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
To: dan.j.williams@intel.com
Cc: brakmo@fb.com, richard@nod.at, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, jdike@addtoit.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, rostedt@goodmis.org, linux-um@lists.infradead.org, Julia Lawall <julia.lawall@lip6.fr>, mcgrof@kernel.org, Joel Stanley <joel@jms.id.au>, linux-kselftest@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>, joe@perches.com, shuah@kernel.org, khilman@baylibre.com, kunit-dev@googlegroups.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 17, 2018 at 8:55 PM Dan Williams <dan.j.williams@intel.com> wrote:
<snip>
> > ## More information on KUnit
> >
> > There is a bunch of documentation near the end of this patch set that
> > describes how to use KUnit and best practices for writing unit tests.
> > For convenience I am hosting the compiled docs here:
> > https://google.github.io/kunit-docs/third_party/kernel/docs/
>
> Nice! I've been using mocking techniques in kernel code for the
> libnvdimm test infrastructure in tools/testing/nvdimm/. It's part unit
> test infrastructure, part emulation, and I've always had the feeling
> it's all a bit too adhoc. I'm going to take a look and see what can be
> converted to kunit. Please include linux-nvdimm@lists.01.org on future
> postings.

Great to hear!

Interesting, is this kind of like the nfsim stuff?
>
> I'll shamelessly plug my lwn article about unit testing
> https://lwn.net/Articles/654071/ because it's always good to find
> fellow co-travelers to compare notes and advocate for more test
> oriented kernel development.

Most definitely! I will take a look, and be in touch.

Cheers!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
