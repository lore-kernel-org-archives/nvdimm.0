Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8831221260A62
 for <linux-nvdimm@lists.01.org>; Thu,  9 May 2019 16:31:57 -0700 (PDT)
Date: Thu, 9 May 2019 19:30:43 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
Message-ID: <20190509233043.GC20877@mit.edu>
References: <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
 <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
 <20190509214233.GA20877@mit.edu>
 <b09ba170-229b-fde4-3e9a-e50d6ab4c1b5@deltatee.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <b09ba170-229b-fde4-3e9a-e50d6ab4c1b5@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, brendanhiggins@google.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, linux-nvdimm@lists.01.org, Frank Rowand <frowand.list@gmail.com>, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, sboyd@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, daniel@ffwll.ch, keescook@google.com, linux-fsdevel@vger.kernel.org, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, May 09, 2019 at 04:20:05PM -0600, Logan Gunthorpe wrote:
> 
> The second item, arguably, does have significant overlap with kselftest.
> Whether you are running short tests in a light weight UML environment or
> higher level tests in an heavier VM the two could be using the same
> framework for writing or defining in-kernel tests. It *may* also be valuable
> for some people to be able to run all the UML tests in the heavy VM
> environment along side other higher level tests.
> 
> Looking at the selftests tree in the repo, we already have similar items to
> what Kunit is adding as I described in point (2) above. kselftest_harness.h
> contains macros like EXPECT_* and ASSERT_* with very similar intentions to
> the new KUNIT_EXECPT_* and KUNIT_ASSERT_* macros.
> 
> However, the number of users of this harness appears to be quite small. Most
> of the code in the selftests tree seems to be a random mismash of scripts
> and userspace code so it's not hard to see it as something completely
> different from the new Kunit:
> 
> $ git grep --files-with-matches kselftest_harness.h *

To the extent that we can unify how tests are written, I agree that
this would be a good thing.  However, you should note that
kselftest_harness.h is currently assums that it will be included in
userspace programs.  This is most obviously seen if you look closely
at the functions defined in the header files which makes calls to
fork(), abort() and fprintf().

So Kunit can't reuse kselftest_harness.h unmodified.  And whether or
not the actual implementation of the header file can be reused or
refactored, making the unit tests use the same or similar syntax would
be a good thing.

Cheers,

						- Ted
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
