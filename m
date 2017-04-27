From: Logan Gunthorpe <logang@deltatee.com>
Subject: Re: [PATCH v2 15/21] xen-blkfront: Make use of the new sg_map helper
 function
Date: Thu, 27 Apr 2017 17:29:08 -0600
Message-ID: <eb33e0ce-987f-a345-ca95-71e4c0a4d1ea@deltatee.com>
References: <1493144468-22493-1-git-send-email-logang@deltatee.com>
 <1493144468-22493-16-git-send-email-logang@deltatee.com>
 <20170426073720.okv33ly2ldepilti@dhcp-3-128.uk.xensource.com>
 <df6586e2-7d45-6b0b-facb-4dea882df06e@deltatee.com>
 <20170427205339.GB26330@obsidianresearch.com>
 <02ba3c7b-5fab-a06c-fbbf-c3be1c0fae1b@deltatee.com>
 <20170427221132.GA30036@obsidianresearch.com>
 <3a7c0d27-0744-4e91-b37f-3885c50455e8@deltatee.com>
 <20170427232022.GA30398@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20170427232022.GA30398@obsidianresearch.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, linux-nvdimm@ml01.01.org, dri-devel@lists.freedesktop.org, Stephen Bates <sbates@raithlin.com>, dm-devel@redhat.com, target-devel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, devel@driverdev.osuosl.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-rdma@vger.kernel.org, Sumit Semwal <sumit.semwal@linaro.org>, Ross Zwisler <ross.zwisler@linux.intel.com>, open-iscsi@googlegroups.com, linux-media@vger.kernel.org, Juergen Gross <jgross@suse.com>, Julien Grall <julien.grall@arm.com>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, intel-gfx@lists.freedesktop.org, sparmaintainer@unisys.com, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, megaraidlinux.pdl@broadcom.com, Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen" <martin.p>
List-Id: linux-nvdimm@lists.01.org



On 27/04/17 05:20 PM, Jason Gunthorpe wrote:
> It seems the most robust: test for iomem, and jump to a slow path
> copy, otherwise inline the kmap and memcpy
> 
> Every place doing memcpy from sgl will need that pattern to be
> correct.

Ok, sounds like a good place to start to me. I'll see what I can do for
a v3 of this set. Though, I probably won't send anything until after the
merge window.

>>> sg_miter will still fail when the sg contains __iomem, however I would
>>> expect that the sg_copy will work with iomem, by using the __iomem
>>> memcpy variant.
>>
>> Yes, that's true. Any sg_miters that ever see iomem will need to be
>> converted to support it. This isn't much different than the other
>> kmap(sg_page()) users I was converting that will also fail if they see
>> iomem. Though, I suspect an sg_miter user would be easier to convert to
>> iomem than a random kmap user.
> 
> How? sg_miter seems like the next nightmare down this path, what is
> sg_miter_next supposed to do when something hits an iomem sgl?

My proposal is roughly included in the draft I sent upthread. We add an
sg_miter flag indicating the iteratee supports iomem and if miter finds
iomem (with the support flag set) it sets ioaddr which is __iomem. The
iteratee then just needs to null check addr and ioaddr and perform the
appropriate action.

Logan
