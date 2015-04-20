Return-Path: <linux-kernel-owner@vger.kernel.org>
Date: Mon, 20 Apr 2015 09:06:24 +0200
From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 02/21] ND NFIT-Defined/NVIDIMM Subsystem
Message-ID: <20150420070624.GB13876@gmail.com>
References: <20150418013256.25237.96403.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20150418013525.25237.45181.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150418013525.25237.45181.stgit@dwillia2-desk3.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org, Boaz Harrosh <boaz@plexistor.com>, Neil Brown <neilb@suse.de>, Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>, Jens Axboe <axboe@fb.com>, "H. Peter Anvin" <hpa@zytor.com>, Christoph Hellwig <hch@lst.de>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>


* Dan Williams <dan.j.williams@intel.com> wrote:

> Maintainer information and documenation for drivers/block/nd/
> 
> Cc: Andy Lutomirski <luto@amacapital.net>
> Cc: Boaz Harrosh <boaz@plexistor.com>
> Cc: H. Peter Anvin <hpa@zytor.com>
> Cc: Jens Axboe <axboe@fb.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Neil Brown <neilb@suse.de>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  Documentation/blockdev/nd.txt |  867 +++++++++++++++++++++++++++++++++++++++++
>  MAINTAINERS                   |   34 +-
>  2 files changed, 895 insertions(+), 6 deletions(-)
>  create mode 100644 Documentation/blockdev/nd.txt
> 
> diff --git a/Documentation/blockdev/nd.txt b/Documentation/blockdev/nd.txt
> new file mode 100644
> index 000000000000..bcfdf21063ab
> --- /dev/null
> +++ b/Documentation/blockdev/nd.txt
> @@ -0,0 +1,867 @@
> +                 The NFIT-Defined/NVDIMM Sub-system (ND)
> +
> +      nd - kernel abi / device-model & ndctl - userspace helper library
> +                         linux-nvdimm@lists.01.org
> +                            v9: April 17th, 2015
> +
> +
> +  Glossary
> +
> +  Overview
> +    Supporting Documents
> +    Git Trees
> +
> +  NFIT Terminology and NVDIMM Types
>
> [...]
>
> +The “NVDIMM Firmware Interface Table” (NFIT) [...]

Ok, I'll bite.

So why on earth is this whole concept and the naming itself 
('drivers/block/nd/' stands for 'NFIT Defined', apparently) revolving 
around a specific 'firmware' mindset and revolving around specific, 
weirdly named, overly complicated looking firmware interfaces that 
come with their own new weird glossary??

Firmware might be a discovery method - or not. A non-volatile device 
might be e820 enumerated, or PCI discovered - potentially with all 
discovery handled by the driver.

Why do you restrict this driver to a naming and design that is so 
firmware centric?

Discovery matters, but what matters _most_ to devices is actually its 
runtime properties and runtime implementation - and I sure hope 
firmware has no active role in that!

I really think this is backwards from the get go, it gives me a 
feeling of someone having spent way too much time in committee and too 
little time spent thinking about simple, proper kernel design and 
reusing existing terminology ...

Also:

+      nd - kernel abi / device-model & ndctl - userspace helper library

WTF is a 'kernel ABI'??

Thanks,

	Ingo
