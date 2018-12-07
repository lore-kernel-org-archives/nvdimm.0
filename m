Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Fri, 7 Dec 2018 13:35:35 -0500
From: Kent Overstreet <kent.overstreet@gmail.com>
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
Message-ID: <20181207183535.GA31228@kmo-pixel>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com>
 <841cf4ae-501b-05ae-5863-a51010709b67@ideasonboard.com>
 <CAFd5g47x-UNja72k-CWPmWz9+LTn8pF8Wj5Poq+2FJ93E=vymA@mail.gmail.com>
 <20181204204701.GT28501@garbanzo.do-not-panic.com>
 <f8722f4a-44c8-24c2-c433-5178f9f40b82@ideasonboard.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8722f4a-44c8-24c2-c433-5178f9f40b82@ideasonboard.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Brendan Higgins <brendanhiggins@google.com>, Matthew Wilcox <willy@infradead.org>, Eryu Guan <guaneryu@gmail.com>, Eric Sandeen <sandeen@sandeen.net>, jeffm@suse.com, Sasha Levin <Alexander.Levin@microsoft.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Felix Guo <felixguoxiuping@gmail.com>, Petr Mladek <pmladek@suse.com>, fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 06, 2018 at 12:32:47PM +0000, Kieran Bingham wrote:
> Oh - although, yes - there are some good concepts there - but I'm a bit
> weary of how easy it would be to 'run' the said test against multiple
> kernel version libraries... there would be a lot of possible ABI
> conflicts perhaps.
> 
> My main initial idea for a libumlinux is to provide infrastructure such
> as our linked-lists and other kernel formatting so that we can take
> kernel code directly to userspace for test and debug (assuming that
> there are no hardware dependencies or things that we can't mock out)

I think this would be a really wonderful to make happen, and could potentially
be much wore widely useful than for just running tests, by making it easier to
share code between both kernel and userspace.

For bcachefs I've got a shim layer that lets me build almost everything in
fs/bcachefs and use it as a library in the userspace bcachefs-tools - e.g. for
fsck and migrate. Mine was a quick and dirty hack, but even so it's been
_extremely_ useful and a major success - I think if this became something more
official a lot of uses would be found for it.

I'm not sure if you've actually started on this (haven't seen most of the thread
yet), but if any of the bcachefs-tools shim code is useful feel free to steal it
- I've got dirt-simple, minimum viable shims for the kthread api, workqueus,
timers, the block layer, and assorted other stuff:

https://evilpiepirate.org/git/bcachefs-tools.git/

Going forward, one issue is going to be that a libumllinux is going to want to
shim some interfaces, and for other things it'll just want to pull in the kernel
implementation - e.g. rhashtables. It might be nice if we could refactor things
a bit so that things like rhashtables could be built as a standalone library, as
is.
