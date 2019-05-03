From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH v2 12/17] kunit: tool: add Python wrappers for running
 KUnit tests
Date: Fri, 3 May 2019 08:41:49 +0200
Message-ID: <20190503064149.GB20723@kroah.com>
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-13-brendanhiggins@google.com>
 <20190502110220.GD12416@kroah.com>
 <CAFd5g47t=EdLKFCT=CnPkrM2z0nDVo24Gz4j0VxFOJbARP37Lg@mail.gmail.com>
 <a49c5088-a821-210c-66de-f422536f5b01@gmail.com>
 <CAFd5g44iWRchQKdJYtjRtPY6e-6e0eXpKXXsx5Ooi6sWE474KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAFd5g44iWRchQKdJYtjRtPY6e-6e0eXpKXXsx5Ooi6sWE474KA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Brendan Higgins <brendanhiggins@google.com>
Cc: Frank Rowand <frowand.list@gmail.com>, Kees Cook <keescook@google.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, Luis Chamberlain <mcgrof@kernel.org>, Rob Herring <robh@kernel.org>, Stephen Boyd <sboyd@kernel.org>, shuah@kernel.org, devicetree <devicetree@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-um@lists.infradead.org, Sasha Levin <Alexander.Levin@microsoft.com>, "Bird, Timothy" <Tim.Bird@sony.com>, Amir Goldstein <amir73il@gmail.com>, Dan Carpenter <dan.carpenter@oracle.com>
List-Id: linux-nvdimm@lists.01.org

On Thu, May 02, 2019 at 04:45:29PM -0700, Brendan Higgins wrote:
> On Thu, May 2, 2019 at 2:16 PM Frank Rowand <frowand.list@gmail.com> wrote:
> >
> > On 5/2/19 11:07 AM, Brendan Higgins wrote:
> > > On Thu, May 2, 2019 at 4:02 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > >>
> > >> On Wed, May 01, 2019 at 04:01:21PM -0700, Brendan Higgins wrote:
> > >>> From: Felix Guo <felixguoxiuping@gmail.com>
> > >>>
> > >>> The ultimate goal is to create minimal isolated test binaries; in the
> > >>> meantime we are using UML to provide the infrastructure to run tests, so
> > >>> define an abstract way to configure and run tests that allow us to
> > >>> change the context in which tests are built without affecting the user.
> > >>> This also makes pretty and dynamic error reporting, and a lot of other
> > >>> nice features easier.
> > >>>
> > >>> kunit_config.py:
> > >>>   - parse .config and Kconfig files.
> > >>>
> > >>> kunit_kernel.py: provides helper functions to:
> > >>>   - configure the kernel using kunitconfig.
> > >>>   - build the kernel with the appropriate configuration.
> > >>>   - provide function to invoke the kernel and stream the output back.
> > >>>
> > >>> Signed-off-by: Felix Guo <felixguoxiuping@gmail.com>
> > >>> Signed-off-by: Brendan Higgins <brendanhiggins@google.com>
> > >>
> > >> Ah, here's probably my answer to my previous logging format question,
> > >> right?  What's the chance that these wrappers output stuff in a standard
> > >> format that test-framework-tools can already parse?  :)
> 
> To be clear, the test-framework-tools format we are talking about is
> TAP13[1], correct?

Yes.

> My understanding is that is what kselftest is being converted to use.

Yes, and I think it's almost done.  The core of kselftest provides
functions that all tests can use to log messages in the correct format.

The core of kunit should also log the messages in this format as well,
and not rely on the helper scripts as Frank points out, not everyone
will use/want them.  Might as well make it easy for everyone to always
do the right thing and not force it to always be added in later.

thanks,

greg k-h
