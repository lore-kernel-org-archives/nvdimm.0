From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Mon, 13 May 2019 23:04:33 -0700
Message-ID: <20190514060433.GA181462@google.com>
References: <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
 <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
 <20190509214233.GA20877@mit.edu>
 <80c72e64-2665-bd51-f78c-97f50f9a53ba@gmail.com>
 <20190511173344.GA8507@mit.edu>
 <20190513144451.GQ17751@phenom.ffwll.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190513144451.GQ17751@phenom.ffwll.local>
Sender: linux-kernel-owner@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>, Frank Rowand <frowand.list@gmail.com>, Tim.Bird@sony.com, knut.omang@oracle.com, gregkh@linuxfoundation.org, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, logang@deltatee.com, mpe@ellerman.id.au
List-Id: linux-nvdimm@lists.01.org

On Mon, May 13, 2019 at 04:44:51PM +0200, Daniel Vetter wrote:
> On Sat, May 11, 2019 at 01:33:44PM -0400, Theodore Ts'o wrote:
> > On Fri, May 10, 2019 at 02:12:40PM -0700, Frank Rowand wrote:
> > > However, the reply is incorrect.  Kselftest in-kernel tests (which
> > > is the context here) can be configured as built in instead of as
> > > a module, and built in a UML kernel.  The UML kernel can boot,
> > > running the in-kernel tests before UML attempts to invoke the
> > > init process.
> > 
> > Um, Citation needed?
> > 
> > I don't see any evidence for this in the kselftest documentation, nor
> > do I see any evidence of this in the kselftest Makefiles.
> > 
> > There exists test modules in the kernel that run before the init
> > scripts run --- but that's not strictly speaking part of kselftests,
> > and do not have any kind of infrastructure.  As noted, the
> > kselftests_harness header file fundamentally assumes that you are
> > running test code in userspace.
> 
> Yeah I really like the "no userspace required at all" design of kunit,
> while still collecting results in a well-defined way (unless the current
> self-test that just run when you load the module, with maybe some
> kselftest ad-hoc wrapper around to collect the results).
> 
> What I want to do long-term is to run these kernel unit tests as part of
> the build-testing, most likely in gitlab (sooner or later, for drm.git

Totally! This is part of the reason I have been insisting on a minimum
of UML compatibility for all unit tests. If you can suffiently constrain
the environment that is required for tests to run in, it makes it much
easier not only for a human to run your tests, but it also makes it a
lot easier for an automated service to be able to run your tests.

I actually have a prototype presubmit already working on my
"stable/non-upstream" branch. You can checkout what presubmit results
look like here[1][2].

> only ofc). So that people get their pull requests (and patch series, we
> have some ideas to tie this into patchwork) automatically tested for this

Might that be Snowpatch[3]? I talked to Russell, the creator of Snowpatch,
and he seemed pretty open to collaboration.

Before I heard about Snowpatch, I had an intern write a translation
layer that made Prow (the presubmit service that I used in the prototype
above) work with LKML[4].

I am not married to either approach, but I think between the two of
them, most of the initial legwork has been done to make presubmit on
LKML a reality.

> super basic stuff.

I am really excited to hear back on what you think!

Cheers!

[1] https://kunit-review.googlesource.com/c/linux/+/1509/10#message-7bfa40efb132e15c8388755c273837559911425c
[2] https://kunit-review.googlesource.com/c/linux/+/1509/10#message-a6784496eafff442ac98fb068bf1a0f36ee73509
[3] https://developer.ibm.com/open/projects/snowpatch/
[4] https://kunit.googlesource.com/prow-lkml/
