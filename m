From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [RFC v3 11/19] kunit: add Python libraries for handing KUnit
 config and kernel
Date: Mon, 3 Dec 2018 15:50:48 -0800
Message-ID: <CAFd5g44L1dV61CPm9GUvOgs-tH_urN-Twm-fj=Pw6h-kgfZ5rQ@mail.gmail.com>
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-12-brendanhiggins@google.com> <20181130034425.GO18410@garbanzo.do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181130034425.GO18410@garbanzo.do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
To: mcgrof@kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, Kees Cook <keescook@google.com>, shuah@kernel.org, Joel Stanley <joel@jms.id.au>, mpe@ellerman.id.au, joe@perches.com, brakmo@fb.com, rostedt@goodmis.org, Tim.Bird@sony.com, khilman@baylibre.com, Julia Lawall <julia.lawall@lip6.fr>, linux-kselftest@vger.kernel.org, kunit-dev@googlegroups.com, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, jdike@addtoit.com, richard@nod.at, linux-um@lists.infradead.org, Daniel Vetter <daniel@ffwll.ch>, dri-devel@lists.freedesktop.org, Rob Herring <robh@kernel.org>, dan.j.williams@intel.com, linux-nvdimm@lists.01.org, kieran.bingham@ideasonboard.com, Frank Rowand <frowand.list@gmail.com>, Knut Omang <knut.omang@oracle.com>, Felix Guo <felixguoxiuping@gmail.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, Nov 29, 2018 at 7:44 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> On Wed, Nov 28, 2018 at 11:36:28AM -0800, Brendan Higgins wrote:
> > The ultimate goal is to create minimal isolated test binaries; in the
> > meantime we are using UML to provide the infrastructure to run tests, so
> > define an abstract way to configure and run tests that allow us to
> > change the context in which tests are built without affecting the user.
> > This also makes pretty and dynamic error reporting, and a lot of other
> > nice features easier.
> >
> > kunit_config.py:
> >   - parse .config and Kconfig files.
> >
> >
> > kunit_kernel.py: provides helper functions to:
> >   - configure the kernel using kunitconfig.
>
> We get the tools to run the config stuff, build, etc, but not a top
> level 'make kunitconfig' or whatever. We have things like 'make
> kvmconfig' and 'make xenconfig', I think it would be reasonable to
> add similar for this.

Are you just asking for a defconfig for KUnit, or are you asking for a
way to run KUnit from make?
