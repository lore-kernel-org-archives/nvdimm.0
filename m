Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EAFE821A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:14:25 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id c62so812556oif.2
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 15:14:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493417230.1873.15.camel@perches.com>
References: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493416143.1873.13.camel@perches.com>
 <CAPcyv4iJvjJTd7M5_5saopTvKPStC=sYqq++FbE_qFJwpqmASw@mail.gmail.com>
 <1493417230.1873.15.camel@perches.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 15:14:24 -0700
Message-ID: <CAPcyv4h=DfkJu6+7by0HoVhUOKtoCJmc4GGg3XNxYURCkX09Tw@mail.gmail.com>
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

On Fri, Apr 28, 2017 at 3:07 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2017-04-28 at 14:52 -0700, Dan Williams wrote:
>> On Fri, Apr 28, 2017 at 2:49 PM, Joe Perches <joe@perches.com> wrote:
>> > On Fri, 2017-04-28 at 14:28 -0700, Dan Williams wrote:
>> > > More than one driver has worked around the fact that
>> > > print_hex_dump_debug() requires CONFIG_DYNAMIC_DEBUG=y to build.
>> >
>> > No it doesn't.  builds work fine.  Output is restricted.
>> >
>> > > Provide a dynamic_hex_dump() so that drivers that want the extra debugging to be
>> > > turned off in the CONFIG_DYNAMIC_DEBUG=n can use dynamic_hex_dump()
>> > > directly.
>> >
>> > I think the concept is unnecessary
>> > .
>> > Just use print_hex_dump with KERN_DEBUG.
>>
>> No, we don't want any possibility of output in the
>> CONFIG_DYNAMIC_DEBUG=n case. This is extra debug that only makes sense
>> in the CONFIG_DYNAMIC_DEBUG case.
>
> No, that doesn't work the same.
>
> Look at your conversion of drivers/acpi/nfit/core.c
>
> dev_dbg outputs always when DEBUG is defined and
> optionally outputs when CONFIG_DYNAMIC_DEBUG is enabled.

Right, that's what I want dev_dbg() to output at KERN_DEBUG level
always and the hexdump only in the dynamic case.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
