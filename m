Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D1CCB211546E6
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 11:03:45 -0700 (PDT)
References: <20180913001156.4115-1-logang@deltatee.com>
 <20180913001156.4115-7-logang@deltatee.com>
 <20180921164126.GI224714@bhelgaas-glaptop.roam.corp.google.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <e9739430-b238-2078-a51f-d76bae5342d1@deltatee.com>
Date: Fri, 21 Sep 2018 12:03:12 -0600
MIME-Version: 1.0
In-Reply-To: <20180921164126.GI224714@bhelgaas-glaptop.roam.corp.google.com>
Content-Language: en-US
Subject: Re: [PATCH v6 06/13] PCI/P2PDMA: Add P2P DMA driver writer's
 documentation
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Alex Williamson <alex.williamson@redhat.com>, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>

On 2018-09-21 10:41 AM, Bjorn Helgaas wrote:
>> +away, the one returned will be chosen at random. This function returns the PCI
> 
> s/the one returned will be chosen at random/one will be chosen
> arbitrarily/ ?  (I doubt it's really random)

You're the second person to ask this, but yes, we really do it randomly.
Such that if there are multiple drivers getting resources they should be
evenly distributed. It's not the ideal solution but if it were to do it
arbitrarily then the code would likely return the same device all the
time and any additional devices would not get used.

>> +Struct Page Caveats
>> +-------------------
>> +
>> +Driver writers should be very careful about not passing these special
>> +struct pages to code that isn't prepared for it. At this time, the kernel
>> +interfaces do not have any checks for ensuring this. This obviously
>> +precludes passing these pages to userspace.
> 
> Sounds like landmines here since the reader probably can't translate
> "code that isn't prepared for it" into a list of interfaces that are
> off-limits.  But that's a VM issue that is above my pay grade, so I'm
> not suggesting any change; just pointing out something that makes me
> wonder "hmmm..., how would I act on this?"

Yes, these are big landmines. These are the problems we have been
fighting with trying to get P2P memory into the kernel and the first
step seems to have settled on the developer using them has to be careful
and ensure they are only sent to paths that are used correctly. This
series does these things in the block layer and RDMA interface, but due
to Jens not wanting to add warnings to the common code, it's still
possible for a developer to code something that sends these pages to
block devices that are not prepared for it.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
