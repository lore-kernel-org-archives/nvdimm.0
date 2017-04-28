Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x231.google.com (mail-oi0-x231.google.com
 [IPv6:2607:f8b0:4003:c06::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 022D421A0480F
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 16:12:30 -0700 (PDT)
Received: by mail-oi0-x231.google.com with SMTP id y11so43025567oie.0
 for <linux-nvdimm@lists.01.org>; Fri, 28 Apr 2017 16:12:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1493420656.1873.22.camel@perches.com>
References: <149341493336.35578.13631055553267152302.stgit@dwillia2-desk3.amr.corp.intel.com>
 <1493416143.1873.13.camel@perches.com>
 <CAPcyv4iJvjJTd7M5_5saopTvKPStC=sYqq++FbE_qFJwpqmASw@mail.gmail.com>
 <1493417230.1873.15.camel@perches.com>
 <CAPcyv4h=DfkJu6+7by0HoVhUOKtoCJmc4GGg3XNxYURCkX09Tw@mail.gmail.com>
 <CAPcyv4jzMfd8TrFcX0GR+6iz0SaJyO5NzzswrEVm-kNVfgrQFQ@mail.gmail.com>
 <1493418714.1873.18.camel@perches.com>
 <CAPcyv4hDC1f9xRJJyDK09ezF7Q=qz+fvku5qFP_FCrS2xh=zUA@mail.gmail.com>
 <1493420656.1873.22.camel@perches.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Apr 2017 16:12:29 -0700
Message-ID: <CAPcyv4iqK-3X5ngXs6HjTQhtW0DEu5KsBcgAY1nVJCWPnSagGw@mail.gmail.com>
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

On Fri, Apr 28, 2017 at 4:04 PM, Joe Perches <joe@perches.com> wrote:
> On Fri, 2017-04-28 at 15:59 -0700, Dan Williams wrote:
>> ...but again, hex_dump_dbg() implies to me dev_dbg() behavior, i.e.
>> that the hexdump happens in the KERN_DEBUG case
>
> I think you are confusing KERN_DEBUG, a logging level, with a
> preprocessor #define of DEBUG.

Indeed I am.

>
>>  which I don't want. I
>> want the call to be compiled out completely when it can't be
>> enabled/disabled dynamically.
>
> dev_dbg is compiled away completely when DEBUG is
> not defined and when CONFIG_DYNAMIC_DEBUG is not
> defined.
>
> This hex_dump facility should behave the same way.
>
>> I think we do need a hex_dump_dbg(), but that does not eliminate the
>> utility of / need for dynamic_hex_dump().
>
> dynamic_hex_dump should only exist when CONFIG_DYNAMIC_DEBUG
> is enabled and should otherwise be invisible to driver code.
>

So, I overlooked that Linus fixed this compile problem a while back with:

cdf17449af1d hexdump: do not print debug dumps for !CONFIG_DEBUG

Which predated the introduction of ACPI_NFIT_DEBUG. So I can just call
print_hex_dump_debug() and call it a day.

Sorry for the noise, Joe!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
