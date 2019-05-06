From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 11/17] kunit: test: add test managed resource tests
Date: Mon, 6 May 2019 02:03:49 -0700
Message-ID: <CAFd5g44q3qyahykujDzOoO01DwGMUm+Kce-tOAzSW90U4mQM7w@mail.gmail.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-12-brendanhiggins@google.com> <8c37fd20-859c-9c34-4465-8adfcfdaab09@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <8c37fd20-859c-9c34-4465-8adfcfdaab09@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: shuah <shuah@kernel.org>
Cc: Frank Rowand <frowand.list@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, "Bird, Timothy" <Tim.Bird@sony.com>, Amir Goldstein <amir73il@gmail.com>, Dan
List-Id: linux-nvdimm@lists.01.org

On Fri, May 3, 2019 at 7:34 AM shuah <shuah@kernel.org> wrote:
>
> On 5/1/19 5:01 PM, Brendan Higgins wrote:
> > From: Avinash Kondareddy <akndr41@gmail.com>
> >
> > Tests how tests interact with test managed resources in their lifetime.
> >
> > Signed-off-by: Avinash Kondareddy <akndr41@gmail.com>
> > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > ---
>
> I think this change log could use more details. It is vague on what it
> does.

Agreed. Will fix in next revision.
