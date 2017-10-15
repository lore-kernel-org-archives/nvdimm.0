Return-Path: <owner-linux-mm@kvack.org>
MIME-Version: 1.0
In-Reply-To: <CAAKD3BBR2CmQvg-3bqPog0VFrEm=QU-b-xBDH-_Q+sXV9NkFUA@mail.gmail.com>
References: <CAPcyv4gXzC8OUgO_PciQ2phyq0YtmXjMGWvoPSVVuuZR7ohVCg@mail.gmail.com>
 <20171009191820.GD15336@obsidianresearch.com> <CAPcyv4h_uQGBAX6-bMkkZLO_YyQ6t4n_b8tH8wU_P0Jh23N5MQ@mail.gmail.com>
 <20171010172516.GA29915@obsidianresearch.com> <CAPcyv4jL5fN7jjXkQum8ERQ45eW63dCYp5Pm6aHY4OPudz4Wsw@mail.gmail.com>
 <20171010180512.GA31734@obsidianresearch.com> <CAPcyv4gCBu5ptmWyof+Z-p7NbuCygEs2rMe2wdL0n3QQbXhrzA@mail.gmail.com>
 <20171012182712.GA5772@obsidianresearch.com> <CAPcyv4g1zXq7MbtivoviHEME6Oi8YJOnVG3jBah3YpHXPAhg6Q@mail.gmail.com>
 <20171013065047.GA26461@lst.de> <20171013150348.GA11257@obsidianresearch.com> <CAAKD3BBR2CmQvg-3bqPog0VFrEm=QU-b-xBDH-_Q+sXV9NkFUA@mail.gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 15 Oct 2017 08:21:25 -0700
Message-ID: <CAPcyv4gBbTr6qbR0AQb1uwWoYQZCwPLGSLdkv4dQP3RUm9XhUw@mail.gmail.com>
Subject: Re: [PATCH v7 07/12] dma-mapping: introduce dma_has_iommu()
Content-Type: text/plain; charset="UTF-8"
Sender: owner-linux-mm@kvack.org
To: Matan Barak <matanb@dev.mellanox.co.il>
Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Christoph Hellwig <hch@lst.de>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Jan Kara <jack@suse.cz>, Ashok Raj <ashok.raj@intel.com>, "Darrick J. Wong" <darrick.wong@oracle.com>, linux-rdma <linux-rdma@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Joerg Roedel <joro@8bytes.org>, Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org, Linux MM <linux-mm@kvack.org>, Jeff Moyer <jmoyer@redhat.com>, Linux API <linux-api@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, David Woodhouse <dwmw2@infradead.org>, Robin Murphy <robin.murphy@arm.com>, Marek Szyprowski <m.szyprowski@samsung.com>, Liran Liss <liranl@mellanox.com>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, Oct 15, 2017 at 8:14 AM, Matan Barak <matanb@dev.mellanox.co.il> wrote:
[..]
> IMHO, using iommu for that and causing DMA errors just because the
> lease broke isn't the right thing to do.

Yes, see the current proposal over in this thread:

https://lists.01.org/pipermail/linux-nvdimm/2017-October/012885.html

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
