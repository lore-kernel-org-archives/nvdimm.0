Return-Path: <owner-linux-mm@kvack.org>
From: Jason Gunthorpe <jgg@mellanox.com>
Subject: Re: add a not device managed memremap_pages v3
Date: Tue, 20 Aug 2019 13:26:29 +0000
Message-ID: <20190820132622.GC29225@mellanox.com>
References: <20190818090557.17853-1-hch@lst.de>
In-Reply-To: <20190818090557.17853-1-hch@lst.de>
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-ID: <76D56E88DFAB2E4AA34C7F681118F0D2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: owner-linux-mm@kvack.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dan Williams <dan.j.williams@intel.com>, Bharata B Rao <bharata@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Aug 18, 2019 at 11:05:53AM +0200, Christoph Hellwig wrote:
> Hi Dan and Jason,
>=20
> Bharata has been working on secure page management for kvmppc guests,
> and one I thing I noticed is that he had to fake up a struct device
> just so that it could be passed to the devm_memremap_pages
> instrastructure for device private memory.
>=20
> This series adds non-device managed versions of the
> devm_request_free_mem_region and devm_memremap_pages functions for
> his use case.
>=20
> Changes since v2:
>  - improved changelogs that the the v2 changes into account
>=20
> Changes since v1:
>  - don't overload devm_request_free_mem_region
>  - export the memremap_pages and munmap_pages as kvmppc can be a module

Looks good, I fixed up the patch with Dan's note and reviewed them as
well.

Applied to hmm.git as requested

Thanks,
Jason
