Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from smtp.codeaurora.org (smtp.codeaurora.org [198.145.29.96])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A9AD921A04801
 for <linux-nvdimm@lists.01.org>; Fri, 31 Mar 2017 16:51:24 -0700 (PDT)
Subject: Re: [RFC 1/8] Introduce Peer-to-Peer memory (p2pmem) device
References: <1490911959-5146-1-git-send-email-logang@deltatee.com>
 <1490911959-5146-2-git-send-email-logang@deltatee.com>
 <cb102386-0314-a3a3-ed44-b42debdf1512@codeaurora.org>
 <7158f2e8-2016-f398-e77f-0fcbe6cb41dd@deltatee.com>
 <e6a74aeb-9f54-51c5-8ad9-3b6fb92c03b3@codeaurora.org>
 <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
From: Sinan Kaya <okaya@codeaurora.org>
Message-ID: <0ae27bca-21be-b89c-aba4-6cc9766ebd7b@codeaurora.org>
Date: Fri, 31 Mar 2017 19:51:20 -0400
MIME-Version: 1.0
In-Reply-To: <0280fbb4-ba9e-ac64-6bb3-b72590a54e57@deltatee.com>
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
To: Logan Gunthorpe <logang@deltatee.com>, Christoph Hellwig <hch@lst.de>, Sagi Grimberg <sagi@grimberg.me>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Steve Wise <swise@opengridcomputing.com>, Stephen Bates <sbates@raithlin.com>, Max Gurtovoy <maxg@mellanox.com>, Dan Williams <dan.j.williams@intel.com>, Keith Busch <keith.busch@intel.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-scsi@vger.kernel.org, linux-nvdimm@lists.01.org, linux-rdma@vger.kernel.org, linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
List-ID: <linux-nvdimm@lists.01.org>

On 3/31/2017 6:42 PM, Logan Gunthorpe wrote:
> 
> 
> On 31/03/17 03:38 PM, Sinan Kaya wrote:
>> On 3/31/2017 5:23 PM, Logan Gunthorpe wrote:
>>> What exactly would you white/black list? It can't be the NIC or the
>>> disk. If it's going to be a white/black list on the switch or root port
>>> then you'd need essentially the same code to ensure they are all behind
>>> the same switch or root port.
>>
>> What is so special about being connected to the same switch?
>>
>> Why don't we allow the feature by default and blacklist by the root ports
>> that don't work with a quirk.
> 
> Well root ports have the same issue here. There may be more than one
> root port or other buses (ie QPI) between the devices in question. So
> you can't just say "this system has root port X therefore we can always
> use p2pmem". 

We only care about devices on the data path between two devices.

> In the end, if you want to do any kind of restrictions
> you're going to have to walk the tree, as the code currently does, and
> figure out what's between the devices being used and black or white list
> accordingly. Then seeing there's just such a vast number of devices out
> there you'd almost certainly have to use some kind of white list and not
> a black list. Then the question becomes which devices will be white
> listed? 

How about a combination of blacklist + time bomb + peer-to-peer feature?

You can put a restriction with DMI/SMBIOS such that all devices from 2016
work else they belong to blacklist.

> The first to be listed would be switches seeing they will always
> work. This is pretty much what we have (though it doesn't currently
> cover multiple levels of switches). The next step, if someone wanted to
> test with specific hardware, might be to allow the case where all the
> devices are behind the same root port which Intel Ivy Bridge or newer.

Sorry, I'm not familiar with Intel architecture. Based on what you just
wrote, I think I see your point. 

I'm trying to generalize what you are doing to a little
bigger context so that I can use it on another architecture like arm64
where I may or may not have a switch.

This text below is sort of repeating what you are writing above. 

How about this:

The goal is to find a common parent between any two devices that need to
use your code. 

- all bridges/switches on the data need to support peer-to-peer, otherwise
stop.

- Make sure that all devices on the data path are not blacklisted via your
code.

- If there is at least somebody blacklisted, we stop and the feature is
not allowed.

- If we find a common parent and no errors, you are good to go.

- We don't care about devices above the common parent whether they have
some feature X, Y, Z or not. 

Maybe, a little bit less code than what you have but it is flexible and
not that too hard to implement.

Well, the code is in RFC. I don't see why we can't remove some restrictions
and still have your code move forward. 

> However, I don't think a comprehensive white list should be a
> requirement for this work to go forward and I don't think anything
> you've suggested will remove any of the "ugliness".

I don't think the ask above is a very big deal. If you feel like
addressing this on another patchset like you suggested in your cover letter,
I'm fine with that too.

> 
> What we discussed at LSF was that only allowing cases with a switch was
> the simplest way to be sure any given setup would actually work.
> 
>> I'm looking at this from portability perspective to be honest.
> 
> I'm looking at this from the fact that there's a vast number of
> topologies and devices involved, and figuring out which will work is
> very complicated and could require a lot of hardware testing. The LSF
> folks were primarily concerned with not having users enable the feature
> and see breakage or terrible performance.
> 
>> I'd rather see the feature enabled by default without any assumptions.
>> Using it with a switch is just a use case that you happened to test.
>> It can allow new architectures to use your code tomorrow.
> 
> That's why I was advocating for letting userspace decide such that if
> you're setting up a system with this you say to use a specific p2pmem
> device and then you are responsible to test and benchmark it and decide
> to use it in going forward. However, this has received a lot of push back.

Yeah, we shouldn't trust the userspace for such things.

> 
> Logan
> 


-- 
Sinan Kaya
Qualcomm Datacenter Technologies, Inc. as an affiliate of Qualcomm Technologies, Inc.
Qualcomm Technologies, Inc. is a member of the Code Aurora Forum, a Linux Foundation Collaborative Project.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
