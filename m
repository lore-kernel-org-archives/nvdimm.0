From: Brendan Higgins <brendanhiggins@google.com>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Date: Tue, 14 May 2019 01:38:19 -0700
Message-ID: <20190514083819.GC230665@google.com>
References: <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
 <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
 <20190509214233.GA20877@mit.edu>
 <b09ba170-229b-fde4-3e9a-e50d6ab4c1b5@deltatee.com>
 <20190509233043.GC20877@mit.edu>
 <8914afef-1e66-e6e3-f891-5855768d3018@deltatee.com>
 <6d6e91ec-33d3-830b-4895-4d7a20ba7d45@gmail.com>
 <3faa022b-0b70-0375-aa6d-12ea83a2671f@deltatee.com>
 <d148a554-2a71-a5a4-4bb2-d84d2c483277@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <d148a554-2a71-a5a4-4bb2-d84d2c483277@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Frank Rowand <frowand.list@gmail.com>
Cc: Logan Gunthorpe <logang@deltatee.com>, Theodore Ts'o <tytso@mit.edu>, Tim.Bird@sony.com, knut.omang@oracle.com, gregkh@linuxfoundation.org, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, mpe@ellerman.id.au, pm
List-Id: linux-nvdimm@lists.01.org

On Fri, May 10, 2019 at 03:13:40PM -0700, Frank Rowand wrote:
> On 5/10/19 9:17 AM, Logan Gunthorpe wrote:
> > 
> > 
> > On 2019-05-09 11:18 p.m., Frank Rowand wrote:
> > 
> >> YES, kselftest has in-kernel tests.  (Excuse the shouting...)
> > 
> > Cool. From my cursory look, in my opinion, these would be greatly
> > improved by converting them to the framework Brendan is proposing for Kunit.
> > 
> >>> If they do exists, it seems like it would make sense to
> >>> convert those to kunit and have Kunit tests run-able in a VM or
> >>> baremetal instance.
> >>
> >> They already run in a VM.
> >>
> >> They already run on bare metal.
> >>
> >> They already run in UML.
> > 
> > Simply being able to run in UML is not the only thing here. Kunit
> > provides the infrastructure to quickly build, run and report results for
> > all the tests from userspace without needing to worry about the details
> > of building and running a UML kernel, then parsing dmesg to figure out
> > what tests were run or not.
> 
> Yes.  But that is not the only environment that KUnit must support to be
> of use to me for devicetree unittests (this is not new, Brendan is quite
> aware of my needs and is not ignoring them).
> 
> 
> >> This is not to say that KUnit does not make sense.  But I'm still trying
> >> to get a better description of the KUnit features (and there are
> >> some).
> > 
> > So read the patches, or the documentation[1] or the LWN article[2]. It's
> > pretty well described in a lot of places -- that's one of the big
> > advantages of it. In contrast, few people seems to have any concept of
> > what kselftests are or where they are or how to run them (I was
> > surprised to find the in-kernel tests in the lib tree).
> > 
> > Logan
> > 
> > [1] https://google.github.io/kunit-docs/third_party/kernel/docs/
> > [2] https://lwn.net/Articles/780985/
> 
> I have been following the RFC versions.  I have installed the RFC patches
> and run them to the extent that they worked (devicetree unittests were
> a guinea pig for test conversion in the RFC series, but the converted
> tests did not work).  I read portions of the code while trying to
> understand the unittests conversion.  I made review comments based on
> the portion of the code that I did read.  I have read the documentation
> (very nice btw, as I have said before, but should be expanded).
> 
> My comment is that the description to submit the patch series should
> be fuller -- KUnit potentially has a lot of nice attributes, and I
> still think I have only scratched the surface.  The average reviewer
> may have even less in-depth knowledge than I do.  And as I have
> commented before, I keep diving into areas that I had no previous
> experience with (such as kselftest) to be able to properly judge this
> patch series.

Thanks for the praise! That means a lot coming from you!

I really cannot disagree that I could use more documentation. You can
pretty much always use more documentation. Nevertheless, is there a
particular part of the documentation that you think it lacking?

It sounds like there was a pretty long discussion here about, a number
of different things.

Do you want a better description of what unit testing is and how KUnit
helps make it possible?

Do you want more of an explanation distinguishing KUnit from kselftest?
How so?

Do you just want better documentation on how to test the kernel? What
tools we have at our disposal and when to use what tools?

Thanks!
