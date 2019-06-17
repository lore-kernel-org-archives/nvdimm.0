Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
References: <20190617122733.22432-1-hch@lst.de> <20190617122733.22432-8-hch@lst.de>
 <CAPcyv4hbGfOawfafqQ-L1CMr6OMFGmnDtdgLTXrgQuPxYNHA2w@mail.gmail.com> <20190617195404.GA20275@lst.de>
In-Reply-To: <20190617195404.GA20275@lst.de>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 17 Jun 2019 13:36:44 -0700
Message-ID: <CAPcyv4jhhEbLDi82gVw7GLASEtqU=U7Ty67AGwTijmzMqw8X8Q@mail.gmail.com>
Subject: Re: [PATCH 07/25] memremap: validate the pagemap type passed to devm_memremap_pages
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Ben Skeggs <bskeggs@redhat.com>, Linux MM <linux-mm@kvack.org>, nouveau@lists.freedesktop.org, Maling list - DRI developers <dri-devel@lists.freedesktop.org>, linux-nvdimm <linux-nvdimm@lists.01.org>, linux-pci@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jun 17, 2019 at 12:59 PM Christoph Hellwig <hch@lst.de> wrote:
>
> On Mon, Jun 17, 2019 at 12:02:09PM -0700, Dan Williams wrote:
> > Need a lead in patch that introduces MEMORY_DEVICE_DEVDAX, otherwise:
>
> Or maybe a MEMORY_DEVICE_DEFAULT = 0 shared by fsdax and p2pdma?

I thought about that, but it seems is_pci_p2pdma_page() needs the
distinction between the 2 types.
