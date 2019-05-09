Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com
 [IPv6:2607:f8b0:4864:20::441])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D9E921214958
 for <linux-nvdimm@lists.01.org>; Thu,  9 May 2019 11:12:16 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id c6so1715022pfa.10
 for <linux-nvdimm@lists.01.org>; Thu, 09 May 2019 11:12:16 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com>
 <20190507080119.GB28121@kroah.com>
 <a09a7e0e-9894-8c1a-34eb-fc482b1759d0@gmail.com>
 <20190509015856.GB7031@mit.edu>
 <580e092f-fa4e-eedc-9e9a-a57dd085f0a6@gmail.com>
 <20190509032017.GA29703@mit.edu>
 <7fd35df81c06f6eb319223a22e7b93f29926edb9.camel@oracle.com>
 <20190509133551.GD29703@mit.edu>
 <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <875c546d-9713-bb59-47e4-77a1d2c69a6d@gmail.com>
Date: Thu, 9 May 2019 11:12:12 -0700
MIME-Version: 1.0
In-Reply-To: <ECADFF3FD767C149AD96A924E7EA6EAF9770D591@USCULXMSG01.am.sony.com>
Content-Language: en-US
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
To: Tim.Bird@sony.com, tytso@mit.edu, knut.omang@oracle.com
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, amir73il@gmail.com, brendanhiggins@google.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, shuah@kernel.org, robh@kernel.org, linux-nvdimm@lists.01.org, khilman@baylibre.com, kieran.bingham@ideasonboard.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, linux-kbuild@vger.kernel.org, jdike@addtoit.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, kunit-dev@googlegroups.com, richard@nod.at, sboyd@kernel.org, gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, daniel@ffwll.ch, keescook@google.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/9/19 10:00 AM, Tim.Bird@sony.com wrote:
>> -----Original Message-----
>> From: Theodore Ts'o 
>>

< massive snip >

I'll reply in more detail to some other earlier messages in this thread
later.

This reply is an attempt to return to the intent of my original reply to
patch 0 of this series.


>> Ultimately, I'm a pragmatist.  If KTF serves your needs best, good for
>> you.  If other approaches are better for other parts of the kernel,
>> let's not try to impose a strict "There Must Be Only One" religion.
>> That's already not true today, and for good reason.  There are many
>> different kinds of kernel code, and many different types of test
>> philosophies.  Trying to force all kernel testing into a single
>> Procrustean Bed is simply not productive.
> 
> Had to look up "Procrustean Bed" - great phrase.  :-)
> 
> I'm not of the opinion that there must only be one test framework
> in the kernel. But we should avoid unnecessary multiplication. Every
> person is going to have a different idea for where the line of necessity
> is drawn.  My own opinion is that what KUnit is adding is different enough
> from kselftest, that it's a valuable addition.  
> 
>  -- Tim

My first reply to patch 0 was in the context of knowing next to nothing
about kselftest.  My level of understanding was essentially from slideware.
(As the thread progressed, I dug a little deeper into kselftest, so now have
a slightly better, though still fairly surface understanding of kselftest).

Maybe I did not explain myself clearly enough in that reply.  I will try
again here.

Patch 0 provided a one paragraph explanation of why KUnit exists, titled

   "## What's so special about unit testing?"

Patch 0 also provided a statement that it is not meant to replace
kselftest, in a paragraph titled

   "## Is KUnit trying to replace other testing frameworks for the kernel?"

I stated:

   "My understanding is that the intent of KUnit is to avoid booting a kernel on
   real hardware or in a virtual machine.  That seems to be a matter of semantics
   to me because isn't invoking a UML Linux just running the Linux kernel in
   a different form of virtualization?

   So I do not understand why KUnit is an improvement over kselftest.

   ...

   What am I missing?"


I was looking for a fuller, better explanation than was given in patch 0
of how KUnit provides something that is different than what kselftest
provides for creating unit tests for kernel code.

New question "(2)":

(2) If KUnit provides something unique, then the obvious follow on
question would be: does it make sense to (a) integrate that feature into
kselftest, (b) integrate the current kselftest in kernel test functionality
into KUnit and convert the in kernel test portion of kselftest to use
KUnit, or (c) KUnit and kselftest are so different that they need to
remain separate features.

*****  Please do not reply to this email with a discussion of "(2)".
*****  Such a discussion is premature if there is not an answer
*****  to my first question.

Observation (3), rephrased:

(3) I also brought up the issue that if option (c) was the answer to
question "(2)" (instead of either option (a) or option (b)) then this
is extra overhead for any developer or maintainer involved in different
subsystems that use the different frameworks.  I intended this as one
possible motivation for why my first question mattered.

Ted grabbed hold of this issue and basically ignored what I intended
to be my core question.  Nobody else has answered my core question,
though Knut's first reply did manage to get somewhere near the
intent of my core question.

*****  Please do not reply to this email with a discussion of "(3)".
*****  Such a discussion is premature if there is not an answer
*****  to my first question.
*****
*****  Also that discussion is already occurring in this thread,
*****  feel free to discuss it there if you want, even though I
*****  feel such discussion is premature.

I still do not have an answer to my original question.

-Frank
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
