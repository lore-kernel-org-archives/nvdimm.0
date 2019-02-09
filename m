Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 072F1211CBCE9
 for <linux-nvdimm@lists.01.org>; Fri,  8 Feb 2019 16:56:46 -0800 (PST)
Received: by mail-ot1-x344.google.com with SMTP id z19so4945899otm.2
 for <linux-nvdimm@lists.01.org>; Fri, 08 Feb 2019 16:56:46 -0800 (PST)
MIME-Version: 1.0
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-15-brendanhiggins@google.com>
 <b4c72234-8c56-6efa-8003-f89d99a9779e@ideasonboard.com>
 <20181130034525.GP18410@garbanzo.do-not-panic.com>
 <CAFd5g47Cew6pmebsopjzmkd4RpnnC3zLAUfxCybjdhrO35OBpQ@mail.gmail.com>
 <0927c42a-8e65-f410-e6ed-27576572577f@ideasonboard.com>
In-Reply-To: <0927c42a-8e65-f410-e6ed-27576572577f@ideasonboard.com>
From: Brendan Higgins <brendanhiggins@google.com>
Date: Fri, 8 Feb 2019 16:56:34 -0800
Message-ID: <CAFd5g44fKzriEs_pGyANxe7GuC9Ji2SD7EEz76__h8q9jjg8yA@mail.gmail.com>
Subject: Re: [RFC v3 14/19] Documentation: kunit: add documentation for KUnit
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
To: Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, Frank Rowand <frowand.list@gmail.com>, linux-nvdimm@lists.01.org, richard@nod.at, Knut Omang <knut.omang@oracle.com>, Felix Guo <felixguoxiuping@gmail.com>, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, Steven Rostedt <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Dec 6, 2018 at 4:16 AM Kieran Bingham
<kieran.bingham@ideasonboard.com> wrote:
>
> Hi Brendan,
>
> On 03/12/2018 23:53, Brendan Higgins wrote:
> > On Thu, Nov 29, 2018 at 7:45 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
> >>
> >> On Thu, Nov 29, 2018 at 01:56:37PM +0000, Kieran Bingham wrote:
> >>> Hi Brendan,
> >>>
> >>> Please excuse the top posting, but I'm replying here as I'm following
> >>> the section "Creating a kunitconfig" in Documentation/kunit/start.rst.
> >>>
> >>> Could the three line kunitconfig file live under say
> >>>        arch/um/configs/kunit_defconfig?
>
>
> Further consideration to this topic - I mentioned putting it in
>   arch/um/configs
>
> - but I think this is wrong.
>
> We now have a location for config-fragments, which is essentially what
> this is, under kernel/configs
>
> So perhaps an addition as :
>
>  kernel/configs/kunit.config
>
> Would be more appropriate - and less (UM) architecture specific.

Sorry for the long radio silence.

I just got around to doing this and I found that there are some
configs that are desirable to have when running KUnit under x86 in a
VM, but not UML. So should we have one that goes in with
config-fragments and others that go into architectures? Another idea,
it would be nice to have a KUnit config that runs all known tests
(this probably won't work in practice once we start testing mutually
exclusive things or things with lots of ifdeffery, but it probably
something we should try to maintain as best as we can?); this probably
shouldn't go in with the fragments, right?

I will be sending another revision out soon, but I figured I might be
able to catch you before I did so.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
