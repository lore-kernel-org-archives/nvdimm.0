Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 365642020F932
 for <linux-nvdimm@lists.01.org>; Tue, 20 Aug 2019 12:09:50 -0700 (PDT)
Subject: Re: [PATCH v13 00/18] kunit: introduce KUnit, the Linux kernel unit
 testing framework
References: <20190814055108.214253-1-brendanhiggins@google.com>
 <5b880f49-0213-1a6e-9c9f-153e6ab91eeb@kernel.org>
 <20190820182450.GA38078@google.com>
From: shuah <shuah@kernel.org>
Message-ID: <e8eaf28e-75df-c966-809a-2e3631353cc9@kernel.org>
Date: Tue, 20 Aug 2019 13:08:28 -0600
MIME-Version: 1.0
In-Reply-To: <20190820182450.GA38078@google.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: pmladek@suse.com, linux-doc@vger.kernel.org, peterz@infradead.org, amir73il@gmail.com, dri-devel@lists.freedesktop.org, Alexander.Levin@microsoft.com, yamada.masahiro@socionext.com, mpe@ellerman.id.au, linux-kselftest@vger.kernel.org, frowand.list@gmail.com, robh@kernel.org, linux-nvdimm@lists.01.org, khilman@baylibre.com, knut.omang@oracle.com, kieran.bingham@ideasonboard.com, wfg@linux.intel.com, joel@jms.id.au, rientjes@google.com, jdike@addtoit.com, dan.carpenter@oracle.com, devicetree@vger.kernel.org, shuah <shuah@kernel.org>, linux-kbuild@vger.kernel.org, Tim.Bird@sony.com, linux-um@lists.infradead.org, rostedt@goodmis.org, julia.lawall@lip6.fr, jpoimboe@redhat.com, Bjorn Helgaas <bhelgaas@google.com>, kunit-dev@googlegroups.com, tytso@mit.edu, richard@nod.at, sboyd@kernel.org, gregkh@linuxfoundation.org, rdunlap@infradead.org, linux-kernel@vger.kernel.org, mcgrof@kernel.org, daniel@ffwll.ch, keescook@google.com, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 8/20/19 12:24 PM, Brendan Higgins wrote:
> On Tue, Aug 20, 2019 at 11:24:45AM -0600, shuah wrote:
>> On 8/13/19 11:50 PM, Brendan Higgins wrote:
>>> ## TL;DR
>>>
>>> This revision addresses comments from Stephen and Bjorn Helgaas. Most
>>> changes are pretty minor stuff that doesn't affect the API in anyway.
>>> One significant change, however, is that I added support for freeing
>>> kunit_resource managed resources before the test case is finished via
>>> kunit_resource_destroy(). Additionally, Bjorn pointed out that I broke
>>> KUnit on certain configurations (like the default one for x86, whoops).
>>>
>>> Based on Stephen's feedback on the previous change, I think we are
>>> pretty close. I am not expecting any significant changes from here on
>>> out.
>>>
>>
>> Hi Brendan,
>>
>> I found checkpatch errors in one or two patches. Can you fix those and
>> send v14.
> 
> Hi Shuah,
> 
> Are you refering to the following errors?
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> #144: FILE: include/kunit/test.h:456:
> +#define KUNIT_BINARY_CLASS \
> +       kunit_binary_assert, KUNIT_INIT_BINARY_ASSERT_STRUCT
> 
> ERROR: Macros with complex values should be enclosed in parentheses
> #146: FILE: include/kunit/test.h:458:
> +#define KUNIT_BINARY_PTR_CLASS \
> +       kunit_binary_ptr_assert, KUNIT_INIT_BINARY_PTR_ASSERT_STRUCT
> 
> These values should *not* be in parentheses. I am guessing checkpatch is
> getting confused and thinks that these are complex expressions, when
> they are not.
> 
> I ignored the errors since I figured checkpatch was complaining
> erroneously.
> 
> I could refactor the code to remove these macros entirely, but I think
> the code is cleaner with them.
> 

Please do. I am not veru sure what value these macros add.

thanks,
-- Shuah
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
