Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com
 [IPv6:2607:f8b0:4864:20::642])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 080B121329974
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 02:07:11 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id m12so10402347plt.5
 for <linux-nvdimm@lists.01.org>; Tue, 13 Aug 2019 02:04:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190812182421.141150-1-brendanhiggins@google.com>
 <20190812182421.141150-4-brendanhiggins@google.com>
 <20190812225520.5A67C206A2@mail.kernel.org>
 <20190812233336.GA224410@google.com>
 <20190812235940.100842063F@mail.kernel.org>
 <CAFd5g44xciLPBhH_J3zUcY3TedWTijdnWgF055qffF+dAguhPQ@mail.gmail.com>
 <20190813045623.F3D9520842@mail.kernel.org>
 <CAFd5g46PJNTOUAA4GOOrW==74Zy7u1sRESTanL_BXBn6QykscA@mail.gmail.com>
 <20190813053023.CC86120651@mail.kernel.org>
In-Reply-To: <20190813053023.CC86120651@mail.kernel.org>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Tue, 13 Aug 2019 02:04:44 -0700
Message-ID: <CAFd5g47v7410QRAizPV8zaHrKrc95-Sk-GNzRRVngN741OKnvg@mail.gmail.com>
Subject: Re: [PATCH v12 03/18] kunit: test: add string_stream a std::stream
 like string builder
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
To: Stephen Boyd <sboyd@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Michael Ellerman <mpe@ellerman.id.au>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, shuah <shuah@kernel.org>, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild <linux-kbuild@vger.kernel.org>, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, Josh Poimboeuf <jpoimboe@redhat.com>, kunit-dev@googlegroups.com, Theodore Ts'o <tytso@mit.edu>, Richard Weinberger <richard@nod.at>, Greg KH <gregkh@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Aug 12, 2019 at 10:30 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Brendan Higgins (2019-08-12 22:02:59)
> > On Mon, Aug 12, 2019 at 9:56 PM Stephen Boyd <sboyd@kernel.org> wrote:
> > >
> > > Quoting Brendan Higgins (2019-08-12 17:41:05)
> > > > On Mon, Aug 12, 2019 at 4:59 PM Stephen Boyd <sboyd@kernel.org> wrote:
> > > > >
> > > > > > kunit_resource_destroy (respective equivalents to devm_kfree, and
> > > > > > devres_destroy) and use kunit_kfree here?
> > > > > >
> > > > >
> > > > > Yes, or drop the API entirely? Does anything need this functionality?
> > > >
> > > > Drop the kunit_resource API? I would strongly prefer not to.
> > >
> > > No. I mean this API, string_stream_clear(). Does anything use it?
> >
> > Oh, right. No.
> >
> > However, now that I added the kunit_resource_destroy, I thought it
> > might be good to free the string_stream after I use it in each call to
> > kunit_assert->format(...) in which case I will be using this logic.
> >
> > So I think the right thing to do is to expose string_stream_destroy so
> > kunit_do_assert can clean up when it's done, and then demote
> > string_stream_clear to static. Sound good?
>
> Ok, sure. I don't really see how clearing it explicitly when the
> assertion prints vs. never allocating it to begin with is really any
> different. Maybe I've missed something though.

It's for the case that we *do* print something out. Once we are doing
printing, we don't want the fragments anymore.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
