From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 6/8] nvmet: Be careful about using iomem accesses when
 dealing with p2pmem
Date: Thu, 6 Apr 2017 10:02:04 -0600
Message-ID: <cc2ac0cc-8543-5297-bc09-9946cca93894@deltatee.com>
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-7-git-send-email-logang@deltatee.com>
 <080b68b4-eba3-861c-4f29-5d829425b5e7@grimberg.me>
 <20170404154629.GA13552@obsidianresearch.com>
 <4df229d8-8124-664a-9bc4-6401bc034be1@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <4df229d8-8124-664a-9bc4-6401bc034be1-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-nvdimm-y27Ovi1pjclAfugRpC6u6w@public.gmane.org, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-nvdimm@lists.01.org



On 05/04/17 11:33 PM, Sagi Grimberg wrote:
> 
>>> Note that the nvme completion queues are still on the host memory, so
>>> this means we have lost the ordering between data and completions as
>>> they go to different pcie targets.
>>
>> Hmm, in this simple up/down case with a switch, I think it might
>> actually be OK.
>>
>> Transactions might not complete at the NVMe device before the CPU
>> processes the RDMA completion, however due to the PCI-E ordering rules
>> new TLPs directed to the NVMe will complete after the RMDA TLPs and
>> thus observe the new data. (eg order preserving)
>>
>> It would be very hard to use P2P if fabric ordering is not preserved..
> 
> I think it still can race if the p2p device is connected with more than
> a single port to the switch.
> 
> Say it's connected via 2 legs, the bar is accessed from leg A and the
> data from the disk comes via leg B. In this case, the data is heading
> towards the p2p device via leg B (might be congested), the completion
> goes directly to the RC, and then the host issues a read from the
> bar via leg A. I don't understand what can guarantee ordering here.
> 
> Stephen told me that this still guarantees ordering, but I honestly
> can't understand how, perhaps someone can explain to me in a simple
> way that I can understand.

I'll say I don't have a complete understanding of this myself. However,
my understanding is the completion coming from disk won't be sent toward
the RC until all the all the TLPs reached leg B. Then if the RC sends
TLPs to the p2p device via leg B they will be behind all the TLPs the
disk sent. Or something like that. Obviously this will only work with a
tree topology (which I believe is the only topology that makes sense for
PCI). If you had a mesh topology, then the data could route around
congestion and that would get around the ordering restrictions.

Logan
