Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <20171215140947.26075-14-hch@lst.de>
References: <20171215140947.26075-1-hch@lst.de> <20171215140947.26075-14-hch@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 17 Dec 2017 09:30:03 -0800
Message-ID: <CAPcyv4j+wo17xRHuJsDqHKZT_xjnt94xaT4VBQ+uhKykoqvywA@mail.gmail.com>
Subject: Re: [PATCH 13/17] memremap: remove to_vmem_altmap
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Logan Gunthorpe <logang@deltatee.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, X86 ML <x86@kernel.org>, Linux MM <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 6:09 AM, Christoph Hellwig <hch@lst.de> wrote:
> All callers are gone now.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Nice,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
