Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com
 [IPv6:2607:f8b0:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 060B0211E2F0C
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 18:23:56 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id 8so341693pfr.4
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 18:23:56 -0700 (PDT)
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <CAFd5g45F3YUsAjse+Vt5hj5CLjaXrRWgr5zCZZ6CJKc0hboP6Q@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <0e6eb370-3e62-e1a5-1b91-bccc5868e8e4@gmail.com>
Date: Thu, 21 Mar 2019 18:23:53 -0700
MIME-Version: 1.0
In-Reply-To: <CAFd5g45F3YUsAjse+Vt5hj5CLjaXrRWgr5zCZZ6CJKc0hboP6Q@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, Kees Cook <keescook@google.com>, Luis Chamberlain <mcgrof@kernel.org>, shuah@kernel.org, Rob Herring <robh@kernel.org>, Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: brakmo@fb.com, Petr Mladek <pmladek@suse.com>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, "Bird, Timothy" <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On 3/4/19 3:01 PM, Brendan Higgins wrote:
> On Thu, Feb 14, 2019 at 1:38 PM Brendan Higgins
> <brendanhiggins@google.com> wrote:
>>
>> This patch set proposes KUnit, a lightweight unit testing and mocking
>> framework for the Linux kernel.
>>
> 
> <snip>
> 
>> ## More information on KUnit
>>
>> There is a bunch of documentation near the end of this patch set that
>> describes how to use KUnit and best practices for writing unit tests.
>> For convenience I am hosting the compiled docs here:
>> https://google.github.io/kunit-docs/third_party/kernel/docs/
>> Additionally for convenience, I have applied these patches to a branch:
>> https://kunit.googlesource.com/linux/+/kunit/rfc/5.0-rc5/v4
>> The repo may be cloned with:
>> git clone https://kunit.googlesource.com/linux
>> This patchset is on the kunit/rfc/5.0-rc5/v4 branch.
>>
>> ## Changes Since Last Version
>>
>>  - Got KUnit working on (hypothetically) all architectures (tested on
>>    x86), as per Rob's (and other's) request
>>  - Punting all KUnit features/patches depending on UML for now.
>>  - Broke out UML specific support into arch/um/* as per "[RFC v3 01/19]
>>    kunit: test: add KUnit test runner core", as requested by Luis.
>>  - Added support to kunit_tool to allow it to build kernels in external
>>    directories, as suggested by Kieran.
>>  - Added a UML defconfig, and a config fragment for KUnit as suggested
>>    by Kieran and Luis.
>>  - Cleaned up, and reformatted a bunch of stuff.
>>
>> --
>> 2.21.0.rc0.258.g878e2cd30e-goog
>>
> 
> Someone suggested I should send the next revision out as "PATCH"
> instead of "RFC" since there seems to be general consensus about
> everything at a high level, with a couple exceptions.
> 
> At this time I am planning on sending the next revision out as "[PATCH
> v1 00/NN] kunit: introduce KUnit, the Linux kernel unit testing
> framework". Initially I wasn't sure if the next revision should be
> "[PATCH v1 ...]" or "[PATCH v5 ...]". Please let me know if you have a
> strong objection to the former.
> 
> In the next revision, I will be dropping the last two of three patches
> for the DT unit tests as there doesn't seem to be enough features
> currently available to justify the heavy refactoring I did; however, I

Thank you.


> will still include the patch that just converts everything over to
> KUnit without restructuring the test cases:
> https://lkml.org/lkml/2019/2/14/1133

The link doesn't work for me (don't worry about that), so I'm assuming
this is:

   [RFC v4 15/17] of: unittest: migrate tests to run on KUnit

The conversation on that patch ended after:

   >> After adding patch 15, there are a lot of "unittest internal error" messages.
   > 
   > Yeah, I meant to ask you about that. I thought it was due to a change
   > you made, but after further examination, just now, I found it was my
   > fault. Sorry for not mentioning that anywhere. I will fix it in v5.

It is not worth my time to look at patch 15 when it is that broken.  So I
have not done any review of it.

So no, I think you are still in the RFC stage unless you drop patch 15.

> 
> I should have the next revision out in a week or so.
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
