Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com
 [IPv6:2607:f8b0:4864:20::542])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9D69E211E2F0C
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 18:12:52 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id a22so256414pgg.13
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 18:12:52 -0700 (PDT)
Subject: Re: [RFC v4 00/17] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20190214213729.21702-1-brendanhiggins@google.com>
 <6d9b3b21-1179-3a45-7545-30aa15306cb4@deltatee.com>
 <CAFd5g47G=mTdk+=wpO+rkyO0+mAbEfPAg=Pr7_507Uek4sdWeA@mail.gmail.com>
 <3bdbe44c-5bd8-db37-89f9-a518cd5a21a8@deltatee.com>
 <CAFd5g45u6oX=nK9anAEdfsV+8SET8Zo_Dpy0WfzCna19r_jSyw@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <aea24c8e-5ce8-5f33-c81b-d2eeef588ec8@gmail.com>
Date: Thu, 21 Mar 2019 18:12:48 -0700
MIME-Version: 1.0
In-Reply-To: <CAFd5g45u6oX=nK9anAEdfsV+8SET8Zo_Dpy0WfzCna19r_jSyw@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, Logan Gunthorpe <logang@deltatee.com>
Cc: brakmo@fb.com, Petr Mladek <pmladek@suse.com>, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, linux-kselftest@vger.kernel.org, Frank Rowand-real <frowand@gmail.com>, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Richard Weinberger <richard@nod.at>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, "Bird, Timothy" <Tim.Bird@sony.com>, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Michael Ellerman <mpe@ellerman.id.au>, Joe Perches <joe@perches.com>, Kevin Hilman <khilman@baylibre.com>
List-ID: <linux-nvdimm@lists.01.org>

On 3/21/19 4:33 PM, Brendan Higgins wrote:
> On Thu, Mar 21, 2019 at 3:27 PM Logan Gunthorpe <logang@deltatee.com> wrote:
>>
>>
>>
>> On 2019-03-21 4:07 p.m., Brendan Higgins wrote:
>>> A couple of points, as for needing CONFIG_PCI; my plan to deal with
>>> that type of thing has been that we would add support for a KUnit/UML
>>> version that is just for KUnit. It would mock out the necessary bits
>>> to provide a fake hardware implementation for anything that might
>>> depend on it. I wrote a prototype for mocking/faking MMIO that I
>>> presented to the list here[1]; it is not part of the current patchset
>>> because we decided it would be best to focus on getting an MVP in, but
>>> I plan on bringing it back up at some point. Anyway, what do you
>>> generally think of this approach?
>>
>> Yes, I was wondering if that might be possible. I think that's a great
>> approach but it will unfortunately take a lot of work before larger
>> swaths of the kernel are testable in Kunit with UML. Having more common
>> mocked infrastructure will be great by-product of it though.
> 
> Yeah, it's unfortunate that the best way to do something often takes
> so much longer.
> 
>>
>>> Awesome, I looked at the code you posted and it doesn't look like you
>>> have had too many troubles. One thing that stood out to me, why did
>>> you need to put it in the kunit/ dir?
>>
>> Yeah, writing the code was super easy. Only after, did I realized I
>> couldn't get it to easily build.
> 
> Yeah, we really need to fix that; unfortunately, broadly addressing
> that problem is really hard and will most likely take a long time.
> 
>>
>> Putting it in the kunit directory was necessary because nothing in the
>> NTB tree builds unless CONFIG_NTB is set (see drivers/Makefile) and
>> CONFIG_NTB depends on CONFIG_PCI. I didn't experiment to see how hard it
>> would be to set CONFIG_NTB without CONFIG_PCI; I assumed it would be tricky.
>>
>>> I am looking forward to see what you think!
>>
>> Generally, I'm impressed and want to see this work in upstream as soon
>> as possible so I can start to make use of it!
> 
> Great to hear! I was trying to get the next revision out this week,
> but addressing some of the comments is taking a little longer than
> expected. I should have something together fairly soon though
> (hopefully next week). Good news is that next revision will be
> non-RFC; most of the feedback has settled down and I think we are
> ready to start figuring out how to merge it. Fingers crossed :-)
> 
> Cheers

I'll be out of the office next week and will not be able to review.
Please hold off on any devicetree related files until after I review.

Thanks,

Frank

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
