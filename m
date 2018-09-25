Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9C62F21B02822
 for <linux-nvdimm@lists.01.org>; Tue, 25 Sep 2018 11:09:49 -0700 (PDT)
References: <20180925162231.4354-1-logang@deltatee.com>
 <20180925162231.4354-2-logang@deltatee.com>
 <1537896340.11137.19.camel@acm.org>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <3efcee21-e439-f6ed-230b-c52c4872f0d2@deltatee.com>
Date: Tue, 25 Sep 2018 12:09:31 -0600
MIME-Version: 1.0
In-Reply-To: <1537896340.11137.19.camel@acm.org>
Content-Language: en-CA
Subject: Re: [PATCH v7 01/13] PCI/P2PDMA: Support peer-to-peer memory
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
To: Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Alex Williamson <alex.williamson@redhat.com>, =?UTF-8?B?SsOpcsO0bWUgR2xpc3Nl?= <jglisse@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Bjorn Helgaas <bhelgaas@google.com>, Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>
List-ID: <linux-nvdimm@lists.01.org>



On 2018-09-25 11:25 a.m., Bart Van Assche wrote:
> It's great to see this patch series making progress. Unfortunately I didn't
> have the time earlier to have a closer look at this patch series. I hope that
> you don't mind that I ask a few questions about the implementation?

Thanks for the review Bart!

>> +static void pci_p2pdma_percpu_kill(void *data)
>> +{
>> +	struct percpu_ref *ref = data;
>> +
>> +	if (percpu_ref_is_dying(ref))
>> +		return;
>> +
>> +	percpu_ref_kill(ref);
>> +}
> 
> The percpu_ref_is_dying() test should either be removed or a comment should be
> added above it that explains why it is necessary. Is the purpose of that call
> perhaps to protect against multiple calls of pci_p2pdma_percpu_kill()? If so,
> which mechanism serializes these multiple calls?

Hmm, yes, this was copied from device DAX, but I see it has been removed
from there since then. I'll remove it for v8.

>> +static void pci_p2pdma_release(void *data)
>> +{
>> +	struct pci_dev *pdev = data;
>> +
>> +	if (!pdev->p2pdma)
>> +		return;
>> +
>> +	wait_for_completion(&pdev->p2pdma->devmap_ref_done);
>> +	percpu_ref_exit(&pdev->p2pdma->devmap_ref);
>> +
>> +	gen_pool_destroy(pdev->p2pdma->pool);
>> +	pdev->p2pdma = NULL;
>> +}
> 
> Which code frees the memory pdev->p2pdma points at? Other functions similar to
> pci_p2pdma_release() call devm_remove_action(), e.g. hmm_devmem_ref_exit().

pdev->p2pdma is allocated using devm so it will be freed when the PCI
driver is being unwound. pci_p2pdma_release() is a devm action itself
which is registered right after the devm_kzalloc() call. Therefore the
memory will be freed in the next devm action. I don't exactly know what
hmm is doing there but we don't have similar actions to remove.

>> +static int pci_p2pdma_setup(struct pci_dev *pdev)
>> +{
>> +	int error = -ENOMEM;
>> +	struct pci_p2pdma *p2p;
>> +
>> +	p2p = devm_kzalloc(&pdev->dev, sizeof(*p2p), GFP_KERNEL);
>> +	if (!p2p)
>> +		return -ENOMEM;
>> +
>> +	p2p->pool = gen_pool_create(PAGE_SHIFT, dev_to_node(&pdev->dev));
>> +	if (!p2p->pool)
>> +		goto out;
>> +
>> +	init_completion(&p2p->devmap_ref_done);
>> +	error = percpu_ref_init(&p2p->devmap_ref,
>> +			pci_p2pdma_percpu_release, 0, GFP_KERNEL);
>> +	if (error)
>> +		goto out_pool_destroy;
>> +
>> +	percpu_ref_switch_to_atomic_sync(&p2p->devmap_ref);
> 
> Why are percpu_ref_init() and percpu_ref_switch_to_atomic_sync() called
> separately instead of passing PERCPU_REF_INIT_ATOMIC to percpu_ref_init()?
> Would using PERCPU_REF_INIT_ATOMIC eliminate a call_rcu_sched() call and
> hence make this function faster?

I can't even remember why we are switching to atomic at all. It probably
shouldn't be there. I'll remove it for v8.


>> +static struct pci_dev *find_parent_pci_dev(struct device *dev)
>
> The above function increases the reference count of the device it returns a
> pointer to. It is a good habit to explain such behavior above the function
> definition.

Will do.

>> +static void seq_buf_print_bus_devfn(struct seq_buf *buf, struct pci_dev *pdev)
>> +{
>> +	if (!buf)
>> +		return;
>> +
>> +	seq_buf_printf(buf, "%s;", pci_name(pdev));
>> +}
> 
> NULL checks in functions that print to a seq buffer are unusual. Is it
> possible that a NULL pointer gets passed as the first argument to
> seq_buf_print_bus_devfn()?

Yes. There are two paths here one that's verbose and one that's not. In
the non-verbose case, we pass NULL instead of the seq_buf, so both calls
need to ensure the seq_buf is not NULL before trying to print to it.

>> +struct pci_p2pdma_client {
>> +	struct list_head list;
>> +	struct pci_dev *client;
>> +	struct pci_dev *provider;
>> +};
> 
> Is there a reason that the peer-to-peer client and server code exist in the
> same source file? If not, have you considered to split the p2pdma.c file into
> two files - one with the code for devices that provide p2p functionality and
> another file with the code that supports p2p users? I think that would make it
> easier to follow the code.

I see what you're saying but generally I get push back against adding
extra files. I'm going to leave it the way it is unless other people
voice their opinions in favour of the change.

>> +/**
>> + * pci_free_p2pmem - allocate peer-to-peer DMA memory
>> + * @pdev: the device the memory was allocated from
>> + * @addr: address of the memory that was allocated
>> + * @size: number of bytes that was allocated
>> + */
>> +void pci_free_p2pmem(struct pci_dev *pdev, void *addr, size_t size)
>> +{
>> +	gen_pool_free(pdev->p2pdma->pool, (uintptr_t)addr, size);
>> +	percpu_ref_put(&pdev->p2pdma->devmap_ref);
>> +}
>> +EXPORT_SYMBOL_GPL(pci_free_p2pmem);
> 
> Please fix the header of this function - there is a copy-paste error in the
> function header.

Will do.

Logan
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
