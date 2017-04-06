From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [RFC 6/8] nvmet: Be careful about using iomem accesses when
 dealing with p2pmem
Date: Thu, 6 Apr 2017 08:33:38 +0300
Message-ID: <4df229d8-8124-664a-9bc4-6401bc034be1@grimberg.me>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-7-git-send-email-logang@deltatee.com>
 <080b68b4-eba3-861c-4f29-5d829425b5e7@grimberg.me>
 <20170404154629.GA13552@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170404154629.GA13552-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Stephen Bates <sbates-pv7U853sEMVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-nvdimm@lists.01.org


>> Note that the nvme completion queues are still on the host memory, so
>> this means we have lost the ordering between data and completions as
>> they go to different pcie targets.
>
> Hmm, in this simple up/down case with a switch, I think it might
> actually be OK.
>
> Transactions might not complete at the NVMe device before the CPU
> processes the RDMA completion, however due to the PCI-E ordering rules
> new TLPs directed to the NVMe will complete after the RMDA TLPs and
> thus observe the new data. (eg order preserving)
>
> It would be very hard to use P2P if fabric ordering is not preserved..

I think it still can race if the p2p device is connected with more than
a single port to the switch.

Say it's connected via 2 legs, the bar is accessed from leg A and the
data from the disk comes via leg B. In this case, the data is heading
towards the p2p device via leg B (might be congested), the completion
goes directly to the RC, and then the host issues a read from the
bar via leg A. I don't understand what can guarantee ordering here.

Stephen told me that this still guarantees ordering, but I honestly
can't understand how, perhaps someone can explain to me in a simple
way that I can understand.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
