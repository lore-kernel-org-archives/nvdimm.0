Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com
 [IPv6:2607:f8b0:4864:20::642])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 27C34211E7444
 for <linux-nvdimm@lists.01.org>; Wed,  8 May 2019 19:18:35 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id x15so320300pln.9
 for <linux-nvdimm@lists.01.org>; Wed, 08 May 2019 19:18:35 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <54940124-50df-16ec-1a32-ad794ee05da7@gmail.com>
 <20190507080119.GB28121@kroah.com> <20190507172256.GB5900@mit.edu>
 <4d963cdc-1cbb-35a3-292c-552f865ed1f7@gmail.com>
 <20190509014407.GA7031@mit.edu>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <458dcb03-8dee-a005-97e1-7296a9e5bbfd@gmail.com>
Date: Wed, 8 May 2019 19:18:30 -0700
MIME-Version: 1.0
In-Reply-To: <20190509014407.GA7031@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>, Greg KH <gregkh@linuxfoundation.org>, Brendan Higgins <brendanhiggins@google.com>, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 5/8/19 6:44 PM, Theodore Ts'o wrote:
> On Wed, May 08, 2019 at 05:58:49PM -0700, Frank Rowand wrote:
>>
>> If KUnit is added to the kernel, and a subsystem that I am submitting
>> code for has chosen to use KUnit instead of kselftest, then yes, I do
>> *have* to use KUnit if my submission needs to contain a test for the
>> code unless I want to convince the maintainer that somehow my case
>> is special and I prefer to use kselftest instead of KUnittest.
> 
> That's going to be between you and the maintainer.  Today, if you want
> to submit a substantive change to xfs or ext4, you're going to be
> asked to create test for that new feature using xfstests.  It doesn't
> matter that xfstests isn't in the kernel --- if that's what is
> required by the maintainer.

Yes, that is exactly what I was saying.

Please do not cut the pertinent parts of context that I am replying to.


>>> supposed to be a simple way to run a large number of small tests that
>>> for specific small components in a system.
>>
>> kselftest also supports running a subset of tests.  That subset of tests
>> can also be a large number of small tests.  There is nothing inherent
>> in KUnit vs kselftest in this regard, as far as I am aware.


> The big difference is that kselftests are driven by a C program that
> runs in userspace.  Take a look at tools/testing/selftests/filesystem/dnotify_test.c
> it has a main(int argc, char *argv) function.
> 
> In contrast, KUnit are fragments of C code which run in the kernel;
> not in userspace.  This allows us to test internal functions inside
> complex file system (such as the block allocator in ext4) directly.
> This makes it *fundamentally* different from kselftest.

No, totally incorrect.  kselftests also supports in kernel modules as
I mention in another reply to this patch.

This is talking past each other a little bit, because your next reply
is a reply to my email about modules.

-Frank

> 
> Cheers,
> 
> 						- Ted
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
