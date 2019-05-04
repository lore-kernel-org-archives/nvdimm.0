From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 12/17] kunit: tool: add Python wrappers for running
 KUnit tests
Date: Sat, 4 May 2019 12:42:51 +0200
Message-ID: <20190504104251.GB1478@kroah.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-13-brendanhiggins@google.com>
 <20190502110220.GD12416@kroah.com>
 <CAFd5g47t=EdLKFCT=CnPkrM2z0nDVo24Gz4j0VxFOJbARP37Lg@mail.gmail.com>
 <a49c5088-a821-210c-66de-f422536f5b01@gmail.com>
 <CAFd5g44iWRchQKdJYtjRtPY6e-6e0eXpKXXsx5Ooi6sWE474KA@mail.gmail.com>
 <1a5f3c44-9fa9-d423-66bf-45255a90c468@gmail.com>
 <CAFd5g45RYm+zfdJXnyp2KZZH5ojfOzy++aq+4zBeE5VDu6WgEw@mail.gmail.com>
 <052fa196-4ea9-8384-79b7-fe6bacc0ee82@gmail.com>
 <CAFd5g47aY-CL+d7DfiyTidY4aAVY+eg1TM1UJ4nYqKSfHOi-0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd5g47aY-CL+d7DfiyTidY4aAVY+eg1TM1UJ4nYqKSfHOi-0w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah <shuah@kernel.org>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, "Bird, Timothy" <Tim.Bird@sony.com>, Amir Goldstein <amir73il@gmail.com>, Dan Carpenter <dan.carpent>
List-Id: linux-nvdimm@lists.01.org

On Fri, May 03, 2019 at 04:14:49PM -0700, Brendan Higgins wrote:
> In any case, it sounds like you and Greg are in agreement on the core
> libraries generating the output in TAP13, so I won't argue that point
> further.

Great!

> ## Analysis of using TAP13
> 
> One of my earlier concerns was that TAP13 is a bit over constrained
> for what I would like to output from the KUnit core. It only allows
> data to be output as either:
>  - test number
>  - ok/not ok with single line description
>  - directive
>  - diagnostics
>  - YAML block
> 
> The test number must become before a set of ok/not ok lines, and does
> not contain any additional information. One annoying thing about this
> is it doesn't provide any kind of nesting or grouping.

It should handle nesting just fine, I think we do that already today.

> There is one ok/not ok line per test and it may have a short
> description of the test immediately after 'ok' or 'not ok'; this is
> problematic because it wants the first thing you say about a test to
> be after you know whether it passes or not.

Take a look at the output of our current tests, I think you might find
it to be a bit more flexible than you think.

Also, this isn't our standard, we picked it because we needed a standard
that the tools of today already understand.  It might have issues and
other problems, but we are not in the business of writing test output
parsing tools, and we don't want to force everyone out there to write
custom parsers.  We want them to be able to use the tools they already
have so they can test the kernel, and to do so as easily as possible.

thanks,

greg k-h
