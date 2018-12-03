Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-f195.google.com (mail-pg1-f195.google.com
 [209.85.215.195])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C0F8621163248
 for <linux-nvdimm@lists.01.org>; Mon,  3 Dec 2018 15:44:01 -0800 (PST)
Received: by mail-pg1-f195.google.com with SMTP id z11so6468247pgu.0
 for <linux-nvdimm@lists.01.org>; Mon, 03 Dec 2018 15:44:01 -0800 (PST)
Date: Mon, 3 Dec 2018 15:43:55 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [RFC v3 07/19] kunit: test: add initial tests
Message-ID: <20181203234355.GQ28501@garbanzo.do-not-panic.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-8-brendanhiggins@google.com>
 <20181130034001.GM18410@garbanzo.do-not-panic.com>
 <CAFd5g47CJnfE3Gqc03onidd5FiZSW43-6_dA5czb30-Rb3dyfg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAFd5g47CJnfE3Gqc03onidd5FiZSW43-6_dA5czb30-Rb3dyfg@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm@lists.01.org, richard@nod.at, Knut Omang <knut.omang@oracle.com>, kieran.bingham@ideasonboard.com, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 03, 2018 at 03:26:26PM -0800, Brendan Higgins wrote:
> On Thu, Nov 29, 2018 at 7:40 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >
> > On Wed, Nov 28, 2018 at 11:36:24AM -0800, Brendan Higgins wrote:
> > > Add a test for string stream along with a simpler example.
> > >
> > > Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > > ---
> > >  kunit/Kconfig              | 12 ++++++
> > >  kunit/Makefile             |  4 ++
> > >  kunit/example-test.c       | 88 ++++++++++++++++++++++++++++++++++++++
> >
> > BTW if you need another more concrete but very simple example I think it
> > may be possible to port tools/testing/selftests/sysctl/sysctl.sh +
> > lib/test_sysctl.c into a kunit test. Correct me if I'm wrong.
> 
> I think that is pretty doable. I don't know that I want to shoot for
> that on the next revision. But I can definitely do it in a later
> revision, or a later patchset, unless you would strongly prefer it
> now, that is.

No rush on my end, just figured I'd mention a simple candidate in case
you needed another one to evaluate.

  Luis
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
