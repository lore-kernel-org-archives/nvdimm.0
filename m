From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v9 04/18] kunit: test: add kunit_stream a std::stream like logger
Date: Thu, 1 Aug 2019 14:43:42 -0700
Message-ID: <CAFd5g47tk8x5iet=xfPVO6MphD3SsLtYQLrCi5O2h0bvdXwHtA@mail.gmail.com>
References: <20190716175021.9CA412173C@mail.kernel.org> <20190719000834.GA3228@google.com>
 <20190722200347.261D3218C9@mail.kernel.org> <CAFd5g45hdCxEavSxirr0un_uLzo5Z-J4gHRA06qjzcQrTzmjVg@mail.gmail.com>
 <20190722235411.06C1320840@mail.kernel.org> <20190724073125.xyzfywctrcvg6fmh@pathway.suse.cz>
 <CAFd5g47v3Mr4GEGOjqyYy9Jwwm+ow7ypbu9j88rxEN06QCzdxQ@mail.gmail.com>
 <20190726083148.d4gf57w2nt5k7t6n@pathway.suse.cz> <CAFd5g46iAhDZ5C_chi7oYLVOkwcoj6+0nw+kPWuXhqWwWKd9jA@mail.gmail.com>
 <CAFd5g473iFfvBnJs2pcwuJYgY+DpgD6RLzyDFL1otUuScgKUag@mail.gmail.com> <20190801211447.6D3D7206A2@mail.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190801211447.6D3D7206A2@mail.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Boyd <sboyd@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>, Jeff Dike <jdike@addtoit.com>, Kevin Hilman <khilman@baylibre.com>, Logan Gunthorpe <logang@deltatee.com>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Vetter <daniel@ffwll.ch>, Amir Goldstein <amir73il@gmail.com>, Frank Rowand <frowand.list@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Kees Cook <keescook@google.com>, David Rientjes <rientjes@google.com>, kunit-dev@googlegroups.com, Kieran Bingham <kieran.bingham@ideasonboard.com>, Peter Zijlstra <peterz@infradead.org>, Randy Dunlap <rdunlap@infradead.org>, Joel Stanley <joel@jms.id.au>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, shuah <shuah@kernel.org>, wfg@linux.intel.com, Greg KH <gregkh@linuxfoundation.org>, Julia Lawall <ju>
List-Id: linux-nvdimm@lists.01.org

On Thu, Aug 1, 2019 at 2:14 PM Stephen Boyd <sboyd@kernel.org> wrote:
>
> Quoting Brendan Higgins (2019-08-01 11:59:57)
> > On Thu, Aug 1, 2019 at 11:55 AM Brendan Higgins
> > <brendanhiggins@google.com> wrote:
> > >
> > > On Fri, Jul 26, 2019 at 1:31 AM Petr Mladek <pmladek@suse.com> wrote:
> > >
> > > > To be honest I do not fully understand KUnit design. I am not
> > > > completely sure how the tested code is isolated from the running
> > > > system. Namely, I do not know if the tested code shares
> > > > the same locks with the system running the test.
> > >
> > > No worries, I don't expect printk to be the hang up in those cases. It
> > > sounds like KUnit has a long way to evolve before printk is going to
> > > be a limitation.
> >
> > So Stephen, what do you think?
> >
> > Do you want me to go forward with the new kunit_assert API wrapping
> > the string_stream as I have it now? Would you prefer to punt this to a
> > later patch? Or would you prefer something else?
> >
>
> I like the struct based approach. If anything, it can be adjusted to
> make the code throw some records into a spinlock later on and delay the
> formatting of the assertion if need be.

That's a fair point.

> Can you resend with that
> approach? I don't think I'll have any more comments after that.

Cool, will do.

Thanks!
