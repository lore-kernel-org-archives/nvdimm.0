Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 676962129F0E5
 for <linux-nvdimm@lists.01.org>; Fri, 21 Jun 2019 12:21:02 -0700 (PDT)
Subject: Re: [PATCH v5 00/18] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20190617082613.109131-1-brendanhiggins@google.com>
 <10feac3e-7621-65e5-fbf0-9c63fcbe09c9@gmail.com>
 <69809117-dcda-160a-ee0a-d1d3b4c5cd8a@kernel.org>
 <20190621181342.GA17166@mit.edu>
From: shuah <shuah@kernel.org>
Message-ID: <6f3f5184-d14e-1b46-17f1-391ee67e699c@kernel.org>
Date: Fri, 21 Jun 2019 13:20:58 -0600
MIME-Version: 1.0
In-Reply-To: <20190621181342.GA17166@mit.edu>
Content-Language: en-US
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
To: Theodore Ts'o <tytso@mit.edu>, Frank Rowand <frowand.list@gmail.com>, Brendan Higgins <brendanhiggins@google.com>, gregkh@linuxfoundation.org, jpoimboe@redhat.com, keescook@google.com, kieran.bingham@ideasonboard.com, mcgrof@kernel.org, peterz@infradead.org, robh@kernel.org, sboyd@kernel.org, yamada.masahiro@socionext.com, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, kunit-dev@googlegroups.com, linux-doc@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, Alexander.Levin@microsoft.com, Tim.Bird@sony.com, amir73il@gmail.com, dan.carpenter@oracle.com, daniel@ffwll.ch, jdike@addtoit.com, joel@jms.id.au, julia.lawall@lip6.fr, khilman@baylibre.com, knut.omang@oracle.com, logang@deltatee.com, mpe@ellerman.id.au, pmladek@suse.com, rdunlap@infradead.org, richard@nod.at, rientjes@google.com, rostedt@goodmis.org, wfg@linux.intel.com, shuah <shuah@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On 6/21/19 12:13 PM, Theodore Ts'o wrote:
> On Fri, Jun 21, 2019 at 08:59:48AM -0600, shuah wrote:
>>>> ### But wait! Doesn't kselftest support in kernel testing?!
>>>>
>>>> ....
>>
>> I think I commented on this before. I agree with the statement that
>> there is no overlap between Kselftest and KUnit. I would like see this
>> removed. Kselftest module support supports use-cases KUnit won't be able
>> to. I can build an kernel with Kselftest test modules and use it in the
>> filed to load and run tests if I need to debug a problem and get data
>> from a system. I can't do that with KUnit.
>>
>> In my mind, I am not viewing this as which is better. Kselftest and
>> KUnit both have their place in the kernel development process. It isn't
>> productive and/or necessary to comparing Kselftest and KUnit without a
>> good understanding of the problem spaces for each of these.
>>
>> I would strongly recommend not making reference to Kselftest and talk
>> about what KUnit offers.
> 
> Shuah,
> 
> Just to recall the history, this section of the FAQ was added to rebut
> the ***very*** strong statements that Frank made that there was
> overlap between Kselftest and Kunit, and that having too many ways for
> kernel developers to do the identical thing was harmful (he said it
> was too much of a burden on a kernel developer) --- and this was an
> argument for not including Kunit in the upstream kernel.
> 
> If we're past that objection, then perhaps this section can be
> dropped, but there's a very good reason why it was there.  I wouldn't
> Brendan to be accused of ignoring feedback from those who reviewed his
> patches.   :-)
> 

Agreed. I understand that this FAQ probably was needed at one time and
Brendan added it to address the concerns.

I think at some point we do need to have a document that outlines when
to KUnit and when to use Kselftest modules. I think one concern people
have is that if KUnit is perceived as a  replacement for Ksefltest
module, Kselftest module will be ignored leaving users without the
ability to build and run with Kselftest modules and load them on a need
basis to gather data on a systems that aren't dedicated strictly for
testing.

I am trying to move the conversation forward from KUnit vs. Kselftest
modules discussion to which problem areas each one addresses keeping
in mind that it is not about which is better. Kselftest and KUnit both
have their place in the kernel development process. We just have to be
clear on usage as we write tests for each.

thanks,
-- Shuah


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
