Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7382621260519
 for <linux-nvdimm@lists.01.org>; Thu,  9 May 2019 15:20:52 -0700 (PDT)
References: <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com>
 <20190507080119.GB28121@kroah.com>
 <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
 <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
 <20190509214233.GA20877@mit.edu>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <b09ba170-229b-fde4-3e9a-e50d6ab4c1b5@deltatee.com>
Date: Thu, 9 May 2019 16:20:05 -0600
MIME-Version: 1.0
In-Reply-To: <20190509214233.GA20877@mit.edu>
Content-Language: en-US
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Theodore Ts'o <tytso@mit.edu>, Frank Rowand <frowand.list@gmail.com>, Tim.Bird@sony.com, knut.omang@oracle.com, gregkh@linuxfoundation.org, brendanhiggins@google.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, mpe@ellerman.id.au, pmladek@suse.com, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>



On 2019-05-09 3:42 p.m., Theodore Ts'o wrote:
> On Thu, May 09, 2019 at 11:12:12AM -0700, Frank Rowand wrote:
>>
>>     "My understanding is that the intent of KUnit is to avoid booting a kernel on
>>     real hardware or in a virtual machine.  That seems to be a matter of semantics
>>     to me because isn't invoking a UML Linux just running the Linux kernel in
>>     a different form of virtualization?
>>
>>     So I do not understand why KUnit is an improvement over kselftest.
>>
>>     ...
>>
>>     What am I missing?"
> 
> One major difference: kselftest requires a userspace environment; it
> starts systemd, requires a root file system from which you can load
> modules, etc.  Kunit doesn't require a root file system; doesn't
> require that you start systemd; doesn't allow you to run arbitrary
> perl, python, bash, etc. scripts.  As such, it's much lighter weight
> than kselftest, and will have much less overhead before you can start
> running tests.  So it's not really the same kind of virtualization.

I largely agree with everything Ted has said in this thread, but I 
wonder if we are conflating two different ideas that is causing an 
impasse. From what I see, Kunit actually provides two different things:

1) An execution environment that can be run very quickly in userspace on 
tests in the kernel source. This speeds up the tests and gives a lot of 
benefit to developers using those tests because they can get feedback on 
their code changes a *lot* quicker.

2) A framework to write unit tests that provides a lot of the same 
facilities as other common unit testing frameworks from userspace (ie. a 
runner that runs a list of tests and a bunch of helpers such as 
KUNIT_EXPECT_* to simplify test passes and failures).

The first item from Kunit is novel and I see absolutely no overlap with 
anything kselftest does. It's also the valuable thing I'd like to see 
merged and grow.

The second item, arguably, does have significant overlap with kselftest. 
Whether you are running short tests in a light weight UML environment or 
higher level tests in an heavier VM the two could be using the same 
framework for writing or defining in-kernel tests. It *may* also be 
valuable for some people to be able to run all the UML tests in the 
heavy VM environment along side other higher level tests.

Looking at the selftests tree in the repo, we already have similar items 
to what Kunit is adding as I described in point (2) above. 
kselftest_harness.h contains macros like EXPECT_* and ASSERT_* with very 
similar intentions to the new KUNIT_EXECPT_* and KUNIT_ASSERT_* macros.

However, the number of users of this harness appears to be quite small. 
Most of the code in the selftests tree seems to be a random mismash of 
scripts and userspace code so it's not hard to see it as something 
completely different from the new Kunit:

$ git grep --files-with-matches kselftest_harness.h *
Documentation/dev-tools/kselftest.rst
MAINTAINERS
tools/testing/selftests/kselftest_harness.h
tools/testing/selftests/net/tls.c
tools/testing/selftests/rtc/rtctest.c
tools/testing/selftests/seccomp/Makefile
tools/testing/selftests/seccomp/seccomp_bpf.c
tools/testing/selftests/uevent/Makefile
tools/testing/selftests/uevent/uevent_filtering.c

Thus, I can personally see a lot of value in integrating the kunit test 
framework with this kselftest harness. There's only a small number of 
users of the kselftest harness today, so one way or another it seems 
like getting this integrated early would be a good idea. Letting Kunit 
and Kselftests progress independently for a few years will only make 
this worse and may become something we end up regretting.

Logan







_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
