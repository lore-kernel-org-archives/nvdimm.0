Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com
 [IPv6:2607:f8b0:4864:20::443])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 30E8C20080F07
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 15:57:12 -0800 (PST)
Received: by mail-pf1-x443.google.com with SMTP id b7so3909597pfi.8
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 15:57:12 -0800 (PST)
Subject: Re: [RFC v3 18/19] of: unittest: split out a couple of test cases
 from unittest
References: <20181128193636.254378-1-brendanhiggins@google.com>
 <20181128193636.254378-19-brendanhiggins@google.com>
 <990bfc7d-dc5e-d8d3-c151-9b321ff2ac10@gmail.com>
 <CAFd5g45tOGgf_sKGYRC=fpnTBKGaG=8frbQdgZ3ZTkQFyTfP5A@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <88fe0546-7850-5bb4-9673-b1aef2dccb3e@gmail.com>
Date: Thu, 14 Feb 2019 15:57:09 -0800
MIME-Version: 1.0
In-Reply-To: <CAFd5g45tOGgf_sKGYRC=fpnTBKGaG=8frbQdgZ3ZTkQFyTfP5A@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>
Cc: brakmo@fb.com, dri-devel@lists.freedesktop.org, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm@lists.01.org, richard@nod.at, Knut Omang <knut.omang@oracle.com>, kieran.bingham@ideasonboard.com, Joel Stanley <joel@jms.id.au>, jdike@addtoit.com, Tim.Bird@sony.com, Kees Cook <keescook@google.com>, linux-um@lists.infradead.org, rostedt@goodmis.org, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Greg KH <gregkh@linuxfoundation.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, mcgrof@kernel.org, Daniel Vetter <daniel@ffwll.ch>, mpe@ellerman.id.au, joe@perches.com, khilman@baylibre.com
List-ID: <linux-nvdimm@lists.01.org>

On 12/5/18 3:54 PM, Brendan Higgins wrote:
> On Tue, Dec 4, 2018 at 2:58 AM Frank Rowand <frowand.list@gmail.com> wrote:
>>
>> Hi Brendan,
>>
>> On 11/28/18 11:36 AM, Brendan Higgins wrote:
>>> Split out a couple of test cases that these features in base.c from the
>>> unittest.c monolith. The intention is that we will eventually split out
>>> all test cases and group them together based on what portion of device
>>> tree they test.
>>
>> Why does splitting this file apart improve the implementation?
> 
> This is in preparation for patch 19/19 and other hypothetical future
> patches where test cases are split up and grouped together by what
> portion of DT they test (for example the parsing tests and the
> platform/device tests would probably go separate files as well). This
> patch by itself does not do anything useful, but I figured it made
> patch 19/19 (and, if you like what I am doing, subsequent patches)
> easier to review.

I do not see any value in splitting the devicetree tests into
multiple files.

Please help me understand what the benefits of such a split are.

Thanks,

Frank
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
