Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 881D121A07A82
 for <linux-nvdimm@lists.01.org>; Fri,  8 Feb 2019 16:40:21 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id a11so8909747otr.10
 for <linux-nvdimm@lists.01.org>; Fri, 08 Feb 2019 16:40:21 -0800 (PST)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com>
 <841cf4ae-501b-05ae-5863-a51010709b67@ideasonboard.com>
 <CAFd5g47x-UNja72k-CWPmWz9+LTn8pF8Wj5Poq+2FJ93E=vymA@mail.gmail.com>
 <20181204204701.GT28501@garbanzo.do-not-panic.com>
 <f8722f4a-44c8-24c2-c433-5178f9f40b82@ideasonboard.com>
 <20181206153718.GD24603@bombadil.infradead.org>
 <20181211140926.7wzd5jh6klcfsfgz@pathway.suse.cz>
 <20181211094140.2a928fe7@gandalf.local.home>
 <34f9e9f3-6bca-f11f-097c-c6e0cb779b61@cambridgegreys.com>
In-Reply-To: <34f9e9f3-6bca-f11f-097c-c6e0cb779b61@cambridgegreys.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Fri, 8 Feb 2019 16:40:08 -0800
Message-ID: <CAFd5g46kQ=x0PA+04qSm4At23cNvYTUszPb-6eadJ9N04POFUQ@mail.gmail.com>
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
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
To: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Cc: brakmo@fb.com, Knut Omang <knut.omang@oracle.com>, jeffm@suse.com, dri-devel@lists.freedesktop.org, Sasha Levin <Alexander.Levin@microsoft.com>, Linux Trace Devel <linux-trace-devel@vger.kernel.org>, linux-kselftest@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Rob Herring <robh@kernel.org>, linux-nvdimm@lists.01.org, mpe@ellerman.id.au, Eric Sandeen <sandeen@sandeen.net>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Matthew Wilcox <willy@infradead.org>, Felix Guo <felixguoxiuping@gmail.com>, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Petr Mladek <pmladek@suse.com>, shuah@kernel.org, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kent Overstreet <kent.overstreet@gmail.com>, Luis Chamberlain <mcgrof@kernel.org>, Eryu Guan <guaneryu@gmail.com>, Daniel Vetter <daniel@ffwll.ch>, richard@nod.at, joe@perches.com, linux-fsdevel@vger.kernel.org, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 11, 2018 at 9:02 AM Anton Ivanov
<anton.ivanov@cambridgegreys.com> wrote:
>
>
> On 12/11/18 2:41 PM, Steven Rostedt wrote:
> > On Tue, 11 Dec 2018 15:09:26 +0100
> > Petr Mladek <pmladek@suse.com> wrote:
> >
> >>> We have liburcu already, which is good.  The main sticking points are:
> >>>
> >>>   - printk has started adding a lot of %pX enhancements which printf
> >>>     obviously doesn't know about.
> >> I wonder how big problem it is and if it is worth using another
> >> approach.
> > No, please do not change the %pX approach.
> >
> >> An alternative would be to replace them with helper functions
> >> the would produce the same string. The meaning would be easier
> >> to understand. But concatenating with the surrounding text
> >> would be less elegant. People might start using pr_cont()
> >> that is problematic (mixed lines).
> >>
> >> Also the %pX formats are mostly used to print context of some
> >> structures. Even the helper functions would need some maintenance
> >> to keep them compatible.
> >>
> >> BTW: The printk() feature has been introduced 10 years ago by
> >> the commit 4d8a743cdd2690c0bc8 ("vsprintf: add infrastructure
> >> support for extended '%p' specifiers").
> > trace-cmd and perf know about most of the %pX data and how to read it.
> > Perhaps we can extend the libtraceevent library to export a generic way
> > to read data from printk() output for other tools to use.
>
> Going back for a second to using UML for this. UML console at present is
> interrupt driven - it emulates serial IO using several different
> back-ends (file descriptors, xterm or actual tty/ptys). Epoll events on
> the host side are used to trigger the UML interrupts - both read and write.
>
> This works OK for normal use, but may result in all kinds of interesting
> false positives/false negatives when UML is used to run unit tests
> against a change which changes interrupt behavior.
>
> IMO it may be useful to consider some alternatives specifically for unit
> test coverage purposes where printk and/or the whole console output
> altogether bypass some of the IRQ driven semantics.

Whoops, sorry, didn't see your comment before I went on vacation.

I completely agree. It is also annoying when trying to test other
really low level parts of the kernel. I would really like to get KUnit
to the point where it does not have any dependencies on anything in
the kernel, but that is very challenging for many reasons. This
loosely relates to what Luis, myself, and others have talked about in
other threads about having a stricter notion of code dependencies in
the kernel. Thinking about it now, I suspect it might be easier to
limit KUnit's dependency on kernel infrastructure first; that could
kind of motivate the later work.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
