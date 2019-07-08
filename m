From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v6 18/18] MAINTAINERS: add proc sysctl KUnit test to PROC
 SYSCTL section
Date: Mon, 8 Jul 2019 16:15:49 -0700
Message-ID: <CAFd5g44j7ECQorYLnDQadAaj+yBki98kFjmjejn+3W4eHtqGDA@mail.gmail.com>
References: <20190704003615.204860-1-brendanhiggins@google.com>
 <20190704003615.204860-19-brendanhiggins@google.com> <20190705204810.GE19023@42.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190705204810.GE19023@42.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Luis Chamberlain <mcgrof@kernel.org>, Iurii Zaikin <yzaikin@google.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Peter Zijlstra <peterz@infradead.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah <shuah@kernel.org>, Theodore Ts'o <tytso@mit.edu>, Masahiro Yamada <yamada.masahiro@socionext.com>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, linux-fsdevel@vger.kernel.org, linux-kbuild <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-ks>
List-Id: linux-nvdimm@lists.01.org

CC'ing Iurii Zaikin

On Fri, Jul 5, 2019 at 1:48 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Jul 03, 2019 at 05:36:15PM -0700, Brendan Higgins wrote:
> > Add entry for the new proc sysctl KUnit test to the PROC SYSCTL section.
> >
> > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> > Acked-by: Luis Chamberlain <mcgrof@kernel.org>
>
> Come to think of it, I'd welcome Iurii to be added as a maintainer,
> with the hope Iurii would be up to review only the kunit changes. Of
> course if Iurii would be up to also help review future proc changes,
> even better. 3 pair of eyeballs is better than 2 pairs.

What do you think, Iurii?
