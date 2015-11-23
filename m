Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20151123095302.GA4436@osiris>
References: <20151122035702.9313.52457.stgit@dwillia2-desk3.jf.intel.com>
	<20151123095302.GA4436@osiris>
Date: Mon, 23 Nov 2015 09:09:58 -0800
Message-ID: <CAPcyv4g4NGQHteO=E4k3pRcKC=ByhFNqFh=0mixrsXKq+oMuMQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] arch: consolidate CONFIG_STRICT_DEVM in lib/Kconfig.debug
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org, Russell King <linux@arm.linux.org.uk>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Catalin Marinas <catalin.marinas@arm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Andrew Morton <akpm@linux-foundation.org>, Will Deacon <will.deacon@arm.com>, Ingo Molnar <mingo@redhat.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "H. Peter Anvin" <hpa@zytor.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Thomas Gleixner <tglx@linutronix.de>, "David S. Miller" <davem@davemloft.net>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Nov 23, 2015 at 1:53 AM, Heiko Carstens
<heiko.carstens@de.ibm.com> wrote:
> On Sat, Nov 21, 2015 at 07:57:02PM -0800, Dan Williams wrote:
>> Let all the archs that implement CONFIG_STRICT_DEVM use a common
>> definition in lib/Kconfig.debug.
>>
>> Note, the 'depends on !SPARC' is due to sparc not implementing
>> devmem_is_allowed().
>>
>> Cc: Kees Cook <keescook@chromium.org>
>> Cc: Russell King <linux@arm.linux.org.uk>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will.deacon@arm.com>
>> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: Thomas Gleixner <tglx@linutronix.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: "H. Peter Anvin" <hpa@zytor.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Cc: "David S. Miller" <davem@davemloft.net>
>> Suggested-by: Arnd Bergmann <arnd@arndb.de>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>> ---
>>  arch/arm/Kconfig.debug       |   14 --------------
>>  arch/arm64/Kconfig.debug     |   14 --------------
>>  arch/powerpc/Kconfig.debug   |   12 ------------
>>  arch/s390/Kconfig.debug      |   12 ------------
>>  arch/tile/Kconfig            |    3 ---
>>  arch/unicore32/Kconfig.debug |   14 --------------
>>  arch/x86/Kconfig.debug       |   17 -----------------
>>  lib/Kconfig.debug            |   19 +++++++++++++++++++
>>  8 files changed, 19 insertions(+), 86 deletions(-)
>
> For s390
>
> Acked-by: Heiko Carstens <heiko.carstens@de.ibm.com>
>
>> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
>> index 8c15b29d5adc..ad85145d0047 100644
>> --- a/lib/Kconfig.debug
>> +++ b/lib/Kconfig.debug
>> @@ -1853,3 +1853,22 @@ source "samples/Kconfig"
>>
>>  source "lib/Kconfig.kgdb"
>>
>> +config STRICT_DEVMEM
>> +     bool "Filter access to /dev/mem"
>> +     depends on MMU
>> +     depends on !SPARC
>> +     default y if TILE || PPC || S390
>
> I wouldn't mind if you would remove s390 from this list.
>

Will do. Thanks.
