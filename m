From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v3 17/19] of: unittest: migrate tests to run on KUnit
Date: Mon, 3 Dec 2018 16:08:02 -0800
Message-ID: <CAFd5g44bmhAOLYeHX8timke-zSr_6AA4tuxQcfeyc6AHFAxHeQ@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-18-brendanhiggins@google.com> <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAL_Jsq+09Kx7yMBC_Jw45QGmk6U_fp4N6HOZDwYrM4tWw+_dOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, mcgrof@kernel.org, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Wed, Nov 28, 2018 at 12:56 PM Rob Herring <robh@kernel.org> wrote:
>
> On Wed, Nov 28, 2018 at 1:38 PM Brendan Higgins
> <brendanhiggins@google.com> wrote:
> >
> > Migrate tests without any cleanup, or modifying test logic in anyway to
> > run under KUnit using the KUnit expectation and assertion API.
>
> Nice! You beat me to it. This is probably going to conflict with what
> is in the DT tree for 4.21. Also, please Cc the DT list for
> drivers/of/ changes.

Oh, I thought you were asking me to do it :-) In any case, I am happy to.

Oh yeah, sorry about not CC'ing the list.

Cheers
