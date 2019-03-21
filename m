From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Thu, 21 Mar 2019 16:26:45 -0600
Message-ID: <3bdbe44c-5bd8-db37-89f9-a518cd5a21a8@deltatee.com>
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
 <CAFd5g47G=mTdk+=wpO+rkyO0+mAbEfPAg=Pr7_507Uek4sdWeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAFd5g47G=mTdk+=wpO+rkyO0+mAbEfPAg=Pr7_507Uek4sdWeA@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Kees Cook <keescook@google.com>, Luis Chamberlain <mcgrof@kernel.org>, shuah@kernel.org, Rob Herring <robh@kernel.org>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Joel Stanley <joel@jms.id.au>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, brakmo@fb.com, Steven Rostedt <rostedt@goodmis.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kevin Hilman <khilman@baylibre.com>, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>
List-Id: linux-nvdimm@lists.01.org



On 2019-03-21 4:07 p.m., Brendan Higgins wrote:
> A couple of points, as for needing CONFIG_PCI; my plan to deal with
> that type of thing has been that we would add support for a KUnit/UML
> version that is just for KUnit. It would mock out the necessary bits
> to provide a fake hardware implementation for anything that might
> depend on it. I wrote a prototype for mocking/faking MMIO that I
> presented to the list here[1]; it is not part of the current patchset
> because we decided it would be best to focus on getting an MVP in, but
> I plan on bringing it back up at some point. Anyway, what do you
> generally think of this approach?

Yes, I was wondering if that might be possible. I think that's a great
approach but it will unfortunately take a lot of work before larger
swaths of the kernel are testable in Kunit with UML. Having more common
mocked infrastructure will be great by-product of it though.

> Awesome, I looked at the code you posted and it doesn't look like you
> have had too many troubles. One thing that stood out to me, why did
> you need to put it in the kunit/ dir?

Yeah, writing the code was super easy. Only after, did I realized I
couldn't get it to easily build.

Putting it in the kunit directory was necessary because nothing in the
NTB tree builds unless CONFIG_NTB is set (see drivers/Makefile) and
CONFIG_NTB depends on CONFIG_PCI. I didn't experiment to see how hard it
would be to set CONFIG_NTB without CONFIG_PCI; I assumed it would be tricky.

> I am looking forward to see what you think!

Generally, I'm impressed and want to see this work in upstream as soon
as possible so I can start to make use of it!

Logan
