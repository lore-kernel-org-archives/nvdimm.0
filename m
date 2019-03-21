Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7D8521959CB2
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 08:56:22 -0700 (PDT)
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
 <01b2a950f661e8ebd6acbc45c2f89c8f10063daf.camel@oracle.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <ce355f5c-189c-816c-cde4-fb4e816d44e7@deltatee.com>
Date: Thu, 21 Mar 2019 09:56:10 -0600
MIME-Version: 1.0
In-Reply-To: <01b2a950f661e8ebd6acbc45c2f89c8f10063daf.camel@oracle.com>
Content-Language: en-CA
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
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
To: Knut Omang <knut.omang@oracle.com>, Brendan Higgins <brendanhiggins@google.com>, keescook@google.com, mcgrof@kernel.org, shuah@kernel.org, robh@kernel.org, kieran.bingham@ideasonboard.com, frowand.list@gmail.com
Cc: brakmo@fb.com, pmladek@suse.com, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, richard@nod.at, wfg@linux.intel.com, joel@jms.id.au, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, daniel@ffwll.ch, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>



On 2019-03-20 11:23 p.m., Knut Omang wrote:
> Testing drivers, hardware and firmware within production kernels was the use
> case that inspired KTF (Kernel Test Framework). Currently KTF is available as a
> standalone git repository. That's been the most efficient form for us so far, 
> as we typically want tests to be developed once but deployed on many different
> kernel versions simultaneously, as part of continuous integration.

Interesting. It seems like it's really in direct competition with KUnit.
I didn't really go into it in too much detail but these are my thoughts:

>From a developer perspective I think KTF not being in the kernel tree is
a huge negative. I want minimal effort to include my tests in a patch
series and minimal effort for other developers to be able to use them.
Needing to submit these tests to another project or use another project
to run them is too much friction.

Also I think the goal of having tests that run on any kernel version is
a pipe dream. You'd absolutely need a way to encode which kernel
versions a test is expected to pass on because the tests might not make
sense until a feature is finished in upstream. And this makes it even
harder to develop these tests because, when we write them, we might not
even know which kernel version the feature will be added to. Similarly,
if a feature is removed or substantially changed, someone will have to
do a patch to disable the test for subsequent kernel versions and create
a new test for changed features. So, IMO, tests absolutely have to be
part of the kernel tree so they can be changed with the respective
features they test.

Kunit's ability to run without having to build and run the entire kernel
 is also a huge plus. (Assuming there's a way to get around the build
dependency issues). Because of this, it can be very quick to run these
tests which makes development a *lot* easier seeing you don't have to
reboot a machine every time you want to test a fix.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
