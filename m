From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v3 08/19] arch: um: add shim to trap to allow installing a
 fault catcher for tests
Date: Mon, 3 Dec 2018 15:37:13 -0800
Message-ID: <CAFd5g45+1wHteYs5YiL19x=L=g=oab5uJrabdKO8q_jS4-ojbg@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-9-brendanhiggins@google.com> <20181130034135.GN18410@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130034135.GN18410@garbanzo.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mcgrof@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Nov 29, 2018 at 7:41 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Nov 28, 2018 at 11:36:25AM -0800, Brendan Higgins wrote:
> > +static void segv_run_catcher(jmp_buf *catcher, void *fault_addr)
> > +{
> > +     current->thread.fault_addr = fault_addr;
> > +     UML_LONGJMP(catcher, 1);
> > +}
>
> Some documentation about what this does exactly would be appreciated.
> With the goal it may be useful to others wanting to consider support
> for other archs -- if that actually ends up being desirable.

Yeah, I should. Should this go in the wrapper around the abort() hack?
Or do you think I should write some documentation on how KUnit works
under Documentation/ ?
