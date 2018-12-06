Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from perceval.ideasonboard.com (perceval.ideasonboard.com
 [213.167.242.64])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C04082119682B
 for <linux-nvdimm@lists.01.org>; Thu,  6 Dec 2018 04:16:41 -0800 (PST)
Subject: Re: [RFC v3 14/19] Documentation: kunit: add documentation for KUnit
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-15-brendanhiggins@google.com>
 <b4c72234-8c56-6efa-8003-f89d99a9779e@ideasonboard.com>
 <20181130034525.GP18410@garbanzo.do-not-panic.com>
 <CAFd5g47Cew6pmebsopjzmkd4RpnnC3zLAUfxCybjdhrO35OBpQ@mail.gmail.com>
From: Kieran Bingham <kieran.bingham@ideasonboard.com>
Message-ID: <0927c42a-8e65-f410-e6ed-27576572577f@ideasonboard.com>
Date: Thu, 6 Dec 2018 12:16:33 +0000
MIME-Version: 1.0
In-Reply-To: <CAFd5g47Cew6pmebsopjzmkd4RpnnC3zLAUfxCybjdhrO35OBpQ@mail.gmail.com>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Reply-To: kieran.bingham@ideasonboard.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Brendan Higgins <brendanhiggins@google.com>, mcgrof@kernel.org
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm@lists.01.org, richard@nod.at, Knut Omang <knut.omang@oracle.com>, Felix Guo <felixguoxiuping@gmail.com>, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Daniel Vetter <daniel@ffwll.ch>, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

Hi Brendan,

On 03/12/2018 23:53, Brendan Higgins wrote:
> On Thu, Nov 29, 2018 at 7:45 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>>
>> On Thu, Nov 29, 2018 at 01:56:37PM +0000, Kieran Bingham wrote:
>>> Hi Brendan,
>>>
>>> Please excuse the top posting, but I'm replying here as I'm following
>>> the section "Creating a kunitconfig" in Documentation/kunit/start.rst.
>>>
>>> Could the three line kunitconfig file live under say
>>>        arch/um/configs/kunit_defconfig?


Further consideration to this topic - I mentioned putting it in
  arch/um/configs

- but I think this is wrong.

We now have a location for config-fragments, which is essentially what
this is, under kernel/configs

So perhaps an addition as :

 kernel/configs/kunit.config

Would be more appropriate - and less (UM) architecture specific.



>>>
>>> So that it's always provided? And could even be extended with tests
>>> which people would expect to be run by default? (say in distributions)
>>
>> Indeed, and then a top level 'make kunitconfig' could use it as well.
> 
> Yep, I totally agree.
> 

-- 
Regards
--
Kieran
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
