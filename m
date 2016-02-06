Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <CAPcyv4hAQMjAndt0YaR6Tpz93=9XHtU10mWLHvypYQmBBeuERQ@mail.gmail.com>
References: <1454722827-15744-1-git-send-email-toshi.kani@hpe.com>
	<CAPcyv4hAQMjAndt0YaR6Tpz93=9XHtU10mWLHvypYQmBBeuERQ@mail.gmail.com>
Date: Fri, 5 Feb 2016 17:52:03 -0800
Message-ID: <CAPcyv4jdSLRxpD0cMmF-gK9CGKbnK4G7Z=P2bVtcUZxgNXFgEA@mail.gmail.com>
Subject: Re: [PATCH] devm_memremap: Fix error value when memremap failed
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: owner-linux-mm@kvack.org
To: Toshi Kani <toshi.kani@hpe.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Feb 5, 2016 at 5:49 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> On Fri, Feb 5, 2016 at 5:40 PM, Toshi Kani <toshi.kani@hpe.com> wrote:
>> devm_memremap() returns an ERR_PTR() value in case of error.
>> However, it returns NULL when memremap() failed.  This causes
>> the caller, such as the pmem driver, to proceed and oops later.
>>
>> Change devm_memremap() to return ERR_PTR(-ENXIO) when memremap()
>> failed.
>>
>> Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
>> Cc: Dan Williams <dan.j.williams@intel.com>
>> Cc: Andrew Morton <akpm@linux-foundation.org>
>
> Acked-by: Dan Williams <dan.j.williams@intel.com>

Should also go to -stable, I'll add that and include this with some
other fixes I have brewing.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
