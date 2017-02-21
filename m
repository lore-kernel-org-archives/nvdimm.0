From: Logan Gunthorpe <logang-OTvnGxWRz7hWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 07/14] infiniband: utilize new device_add_cdev helper
 function
Date: Tue, 21 Feb 2017 16:54:05 -0700
Message-ID: <c7d34394-a9e8-fc9f-92f5-42c56a73ad1f@deltatee.com>
References: <1487653253-11497-1-git-send-email-logang@deltatee.com>
 <1487653253-11497-8-git-send-email-logang@deltatee.com>
 <20170221190905.GD13138@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170221190905.GD13138-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Alessandro Zummo <a.zummo-BfzFCNDTiLLj+vYz1yj4TQ@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, linux-iio-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-pci-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Walleij <linus.walleij-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jarkko Sakkinen <jarkko.sakkinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Alexandre Bounine <alexandre.bounine-49Rm3DX9dRQ@public.gmane.org>, Alexandre Belloni <alexandre.belloni-wi1+55ScJUtKEb57/3fJTNBPR1lH4CV8@public.gmane.org>, Peter Meerwald-Stadler <pmeerw-jW+XmwGofnusTnJN9+BGXg@public.gmane.org>, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Peter Huewe <peterhuewe-Mmb7MZpHnFY@public.gmane.org>, Alexandre Courbot <gnurou-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Lars-Peter Clausen <lars-Qo5EllUWu/uELgA04lAiVw@public.gmane.org>, "James E.J. Bottomley" <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, rtc-linux-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Richard Weinberger <richard-/L3Ra7n9ekc@public.gmane.org>, Marek Vasut <marek.vasut-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, tpmdd-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Hans Verkuil <hans.verk>
List-Id: linux-nvdimm@lists.01.org



On 21/02/17 12:09 PM, Jason Gunthorpe wrote:
> On Mon, Feb 20, 2017 at 10:00:46PM -0700, Logan Gunthorpe wrote:
>> This patch updates core/ucm.c which didn't originally use the
>> cdev.kobj.parent with it's parent device. I did not look heavily into
>> whether this was a bug or not, but it seems likely to me there would
>> be a use before free.
> 
> Hum, is probably safe - ib_ucm_remove_one can only happen on module
> unload and the cdev holds the module lock while open.

Ah, yes looks like you are correct.

> Even so device_add_cdev should be used anyhow.

Agreed.

>> I also took a look at core/uverbs_main.c, core/user_mad.c and
>> hw/hfi1/device.c which utilize cdev.kobj.parent but because the
>> infiniband core seems to use kobjs internally instead of struct devices
>> they could not be converted to use the new helper API and still
>> directly manipulate the internals of the kobj.
> 
> Yes, and hfi1 had the same use-afte-free bug when it was first
> submitted as well. IHMO cdev should have a helper entry for this style
> of use case as well.

I agree, but I'm not sure what that api should look like. Same thing but
kobject_add_cdev???

>> diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
>> index e0a995b..38ea316 100644
>> +++ b/drivers/infiniband/core/ucm.c
>> @@ -1283,18 +1283,20 @@ static void ib_ucm_add_one(struct ib_device *device)
>>  		set_bit(devnum, dev_map);
>>  	}
>>  
>> +	device_initialize(&ucm_dev->dev);
> 
> Ah, this needs more help. Once device_initialize is called put_device
> should be the error-unwind, can you use something more like this?

Is that true? Once device_register or device_add is called then you need
to use put_device. But I didn't think that's true for device_initialize.
In fact device_add is what does the first get_device so this doesn't add
up to me. device_initialize only inits some structures it doesn't do
anything that needs to be torn down -- at least that I'm aware of.

I know the DAX code only uses put_device after device_add. [1]

Logan

[1] http://lxr.free-electrons.com/source/drivers/dax/dax.c#L713
