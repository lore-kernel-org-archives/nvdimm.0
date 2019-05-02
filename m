Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com
 [IPv6:2607:f8b0:4864:20::543])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5C0D321243BA5
 for <linux-nvdimm@lists.01.org>; Thu,  2 May 2019 14:18:57 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id e6so1636227pgc.4
 for <linux-nvdimm@lists.01.org>; Thu, 02 May 2019 14:18:57 -0700 (PDT)
Subject: Re: [PATCH v2 04/17] kunit: test: add kunit_stream a std::stream like
 logger
References: <20190501230126.229218-1-brendanhiggins@google.com>
 <20190501230126.229218-5-brendanhiggins@google.com>
 <20190502110008.GC12416@kroah.com>
 <CAFd5g47ssM7RQZxQsUJ86UigcF-Uz+Kwv2yvKN_gZK-TtW89bA@mail.gmail.com>
From: Frank Rowand <frowand.list@gmail.com>
Message-ID: <6fcf1218-a026-fd7b-236f-ea95f6312e1d@gmail.com>
Date: Thu, 2 May 2019 14:18:53 -0700
MIME-Version: 1.0
In-Reply-To: <CAFd5g47ssM7RQZxQsUJ86UigcF-Uz+Kwv2yvKN_gZK-TtW89bA@mail.gmail.com>
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
To: Brendan Higgins <brendanhiggins@google.com>, Greg KH <gregkh@linuxfoundation.org>
Cc: Petr Mladek <pmladek@suse.com>, linux-doc@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, dri-devel <dri-devel@lists.freedesktop.org>, Sasha Levin <Alexander.Levin@microsoft.com>, Michael Ellerman <mpe@ellerman.id.au>, linux-kselftest@vger.kernel.org, shuah@kernel.org, Rob Herring <robh@kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, Kevin Hilman <khilman@baylibre.com>, Knut Omang <knut.omang@oracle.com>, Kieran Bingham <kieran.bingham@ideasonboard.com>, wfg@linux.intel.com, Joel Stanley <joel@jms.id.au>, David Rientjes <rientjes@google.com>, Jeff Dike <jdike@addtoit.com>, Dan Carpenter <dan.carpenter@oracle.com>, devicetree <devicetree@vger.kernel.org>, linux-kbuild@vger.kernel.org, "Bird, Timothy  <Tim.Bird@sony.com>, linux-um@lists.infradead.org, Steven Rostedt" <rostedt@goodmis.org>, Julia Lawall <julia.lawall@lip6.fr>, kunit-dev@googlegroups.com, Richard Weinberger <richard@nod.at>, Stephen Boyd <sboyd@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Luis Chamberlain <mcgrof@kernel.org>, Daniel Vetter <daniel@ffwll.ch>, Kees Cook <keescook@google.com>, linux-fsdevel@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On 5/2/19 1:25 PM, Brendan Higgins wrote:
> On Thu, May 2, 2019 at 4:00 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>>
>> On Wed, May 01, 2019 at 04:01:13PM -0700, Brendan Higgins wrote:
>>> A lot of the expectation and assertion infrastructure prints out fairly
>>> complicated test failure messages, so add a C++ style log library for
>>> for logging test results.
>>
>> Ideally we would always use a standard logging format, like the
>> kselftest tests all are aiming to do.  That way the output can be easily
>> parsed by tools to see if the tests succeed/fail easily.
>>
>> Any chance of having this logging framework enforcing that format as
>> well?
> 
> I agree with your comment on the later patch that we should handle
> this at the wrapper script layer (KUnit tool).

This discussion is a little confusing, because it is spread across two
patches.

I do not agree that this should be handled in the wrapper script, as
noted in my reply to patch 12, so not repeating it here.

-Frank
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
