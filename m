Return-Path: <linux-fsdevel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <20150605205052.20751.77149.stgit@dwillia2-desk3.amr.corp.intel.com>
Date: Fri, 5 Jun 2015 14:23:41 -0700
Message-ID: <CAPcyv4i+qGpb1sDPDUksB9YuFGPtNjqhJbVt5GmSt8mfoZYJkg@mail.gmail.com>
Subject: Re: [PATCH v4 0/9] introduce __pfn_t, evacuate struct page from sgls
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-fsdevel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Boaz Harrosh <boaz@plexistor.com>, david <david@fromorbit.com>, linux-arch@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Christoph Hellwig <hch@lst.de>, Julia Lawall <Julia.Lawall@lip6.fr>, Paul Mackerras <paulus@samba.org>, "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>, Matthew Wilcox <willy@linux.intel.com>, Andrew Morton <akpm@linux-foundation.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, Ingo Molnar <mingo@kernel.org>, Martin Schwidefsky <schwidefsky@de.ibm.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 5, 2015 at 2:19 PM, Dan Williams <dan.j.williams@intel.com> wrote:
> Introduce __pfn_t which:
>
> 1/ Allows kernel internal DAX mappings to adhere to the lifetime of the
>    the underlying block device.  In general, it enables a mechanism to
>    allow any device driver to advertise "device memory" (CONFIG_DEV_PFN)
>    to other parts of the kernel.
>
> 2/ Replaces usage of struct page in struct scatterlist.  A scatterlist
>    need only carry enough information to generate a dma address, and
>    removing struct page from scatterlists is a precursor to allowing DMA to
>    device memory.  Some dma mapping implementations are not ready for a
>    scatterlist-pfn to reference unampped device memory, those
>    implementations are disabled by CONFIG_DEV_PFN=y.
>
> Changes since v4 [1]:

v3: https://lists.01.org/pipermail/linux-nvdimm/2015-May/000749.html
