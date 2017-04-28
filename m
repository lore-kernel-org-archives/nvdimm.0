Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6B35321A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:59:29 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id w12so42648461oiw.3
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:59:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493418714.1873.18.camel@perches.com>
References: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493416143.1873.13.camel@perches.com>
 <CAPcyv4iJvjJTd7M5_5saopTvKPStC=sYqq++FbE_qFJwpqmASw@mail.gmail.com>
 <1493417230.1873.15.camel@perches.com>
 <CAPcyv4h=DfkJu6+7by0HoVhUOKtoCJmc4GGg3XNxYURCkX09Tw@mail.gmail.com>
 <CAPcyv4jzMfd8TrFcX0GR+6iz0SaJyO5NzzswrEVm-kNVfgrQFQ@mail.gmail.com>
 <1493418714.1873.18.camel@perches.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 15:59:28 -0700
Message-ID: <CAPcyv4hDC1f9xRJJyDK09ezF7Q=qz+fvku5qFP_FCrS2xh=zUA@mail.gmail.com>
Subject: Re: [PATCH 0/3] dynamic_hex_dump cleanup
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
To: Joe Perches <joe@perches.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linux-remoteproc@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Jason Baron <jbaron@akamai.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 28, 2017 at 3:31 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2017-04-28 at 15:19 -0700, Dan Williams wrote:
>> On Fri, Apr 28, 2017 at 3:14 PM, Dan Williams <dan.j.williams@intel.com> wrote:
>> > On Fri, Apr 28, 2017 at 3:07 PM, Joe Perches <joe@perches.com> wrote:
>> > > On Fri, 2017-04-28 at 14:52 -0700, Dan Williams wrote:
>> > > > On Fri, Apr 28, 2017 at 2:49 PM, Joe Perches <joe@perches.com> wrote:
>> > > > > On Fri, 2017-04-28 at 14:28 -0700, Dan Williams wrote:
>> > > > > > More than one driver has worked around the fact that
>> > > > > > print_hex_dump_debug() requires CONFIG_DYNAMIC_DEBUG=y to build.
>> > > > >
>> > > > > No it doesn't.  builds work fine.  Output is restricted.
>> > > > >
>> > > > > > Provide a dynamic_hex_dump() so that drivers that want the extra debugging to be
>> > > > > > turned off in the CONFIG_DYNAMIC_DEBUG=n can use dynamic_hex_dump()
>> > > > > > directly.
>> > > > >
>> > > > > I think the concept is unnecessary
>> > > > > .
>> > > > > Just use print_hex_dump with KERN_DEBUG.
>> > > >
>> > > > No, we don't want any possibility of output in the
>> > > > CONFIG_DYNAMIC_DEBUG=n case. This is extra debug that only makes sense
>> > > > in the CONFIG_DYNAMIC_DEBUG case.
>> > >
>> > > No, that doesn't work the same.
>> > >
>> > > Look at your conversion of drivers/acpi/nfit/core.c
>> > >
>> > > dev_dbg outputs always when DEBUG is defined and
>> > > optionally outputs when CONFIG_DYNAMIC_DEBUG is enabled.
>> >
>> > Right, that's what I want dev_dbg() to output at KERN_DEBUG level
>> > always and the hexdump only in the dynamic case.
>>
>> Joe, I'm trying to understand your objection. What you are proposing
>> is that the debug output is present at the KERN_DEBUG level in the
>> CONFIG_DYNAMIC_DEBUG=n case and that's not what either use case wants.
>> What breaks by letting users call dynamic_hex_dump() directly?
>
> Call it hex_dump_dbg and I have no objections.

...but again, hex_dump_dbg() implies to me dev_dbg() behavior, i.e.
that the hexdump happens in the KERN_DEBUG case which I don't want. I
want the call to be compiled out completely when it can't be
enabled/disabled dynamically.

> The "dynamicism" is a side effect of not having DEBUG
> defined.  dev_dbg will emit if DEBUG is declared regardless
> of dynamic_debug.
>
> This new function should have the same behavior.

I think we do need a hex_dump_dbg(), but that does not eliminate the
utility of / need for dynamic_hex_dump().
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
