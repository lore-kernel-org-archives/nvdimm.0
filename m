Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com
 [IPv6:2607:f8b0:4864:20::442])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B191E212657B2
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 14:12:43 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id s11so3827163pfm.12
 for <linux-nvdimm@lists.01.org>; Fri, 10 May 2019 14:12:43 -0700 (PDT)
Subject: Re: [PATCH v2 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
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
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <80c72e64-2665-bd51-f78c-97f50f9a53ba@gmail.com>
Date: Fri, 10 May 2019 14:12:40 -0700
MIME-Version: 1.0
In-Reply-To: <20190509214233.GA20877@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>, Tim.Bird@sony.com, knut.omang@oracle.com, gregkh@linuxfoundation.org, brendanhiggins@google.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, robh@kernel.org, sboyd@kernel.org, shuah@kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, amir73il@gmail.com, dan.carpenter@oracle.com, dan.j.williams@intel.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com
List-ID: <linux-nvdimm@lists.01.org>

On 5/9/19 2:42 PM, Theodore Ts'o wrote:
> On Thu, May 09, 2019 at 11:12:12AM -0700, Frank Rowand wrote:
>>
>>    "My understanding is that the intent of KUnit is to avoid booting a kernel on
>>    real hardware or in a virtual machine.  That seems to be a matter of semantics
>>    to me because isn't invoking a UML Linux just running the Linux kernel in
>>    a different form of virtualization?
>>
>>    So I do not understand why KUnit is an improvement over kselftest.
>>
>>    ...
>>
>>    What am I missing?"
> 
> One major difference: kselftest requires a userspace environment; it
> starts systemd, requires a root file system from which you can load
> modules, etc.  Kunit doesn't require a root file system; doesn't
> require that you start systemd; doesn't allow you to run arbitrary
> perl, python, bash, etc. scripts.  As such, it's much lighter weight
> than kselftest, and will have much less overhead before you can start
> running tests.  So it's not really the same kind of virtualization.
> 
> Does this help?
> 
> 					- Ted
> 

I'm back to reply to this subthread, after a delay, as promised.

That is the type of information that I was looking for, so
thank you for the reply.

However, the reply is incorrect.  Kselftest in-kernel tests (which
is the context here) can be configured as built in instead of as
a module, and built in a UML kernel.  The UML kernel can boot,
running the in-kernel tests before UML attempts to invoke the
init process.

No userspace environment needed.  So exactly the same overhead
as KUnit when invoked in that manner.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
