Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151217184641.GI8644@n2100.arm.linux.org.uk>
References: <CAPcyv4hOJuT=i2A_0vDQHsL7MXNgVN_p17q3UW6EcTkxsCMmeg@mail.gmail.com>
	<20151217184641.GI8644@n2100.arm.linux.org.uk>
Date: Thu, 17 Dec 2015 12:35:54 -0800
Message-ID: <CAPcyv4i=gD0D_W8ufjCdjRuekS-mf9fZGmod+zn7dA2zDx7LAw@mail.gmail.com>
Subject: Re: -next regression: "driver cohandle -EPROBE_DEFER from bus_type.match()"
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Tomeu Vizoso <tomeu.vizoso@collabora.com>, Marek Szyprowski <m.szyprowski@samsung.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@ml01.01.org>, Stephen Rothwell <sfr@canb.auug.org.au>, dhowells@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

[Adding Dave Howells who tried to correct this situation earlier this year]

On Thu, Dec 17, 2015 at 10:46 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Dec 17, 2015 at 07:51:14AM -0800, Dan Williams wrote:
>> The commit below causes the libnvdimm sub-system to stop loading.
>> This is due to the fact that nvdimm_bus_match() returns the result of
>> test_bit() which may be negative.  If there are any other bus match
>> functions using test_bit they may be similarly impacted.
>>
>> Can we queue a fixup like the following to libnvdimm, and maybe
>> others, ahead of this driver core change?
>
> This is rather annoying.  Have we uncovered a latent bug in other
> architectures?  Well, looking through the test_bit() implementations,
> it looks like it.
>
> I'll drop the patch set for the time being, we can't go around breaking
> stuff like this.

...or make the interpretation from the return value of ->match() be 0,
-EPROBE_DEFER, or other non-zero value for success?  Although that's
fairly subtle.

> However, I think the test_bit() result should be
> regularised across different architectures - it _looks_ to me like most
> implementations return 0/1 values, but there may be some that don't
> (maybe the assembly versions?)

Correct.  Al the constant versions return 0 or 1, but the assembly
return 0 or non-zero.

Here's a link to Dave's rework.

https://lwn.net/Articles/642437/
