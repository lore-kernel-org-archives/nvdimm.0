Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail1.bemta23.messagelabs.com (mail1.bemta23.messagelabs.com
 [67.219.246.208])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C1B34211069EE
 for <linux-nvdimm@lists.01.org>; Sun,  2 Sep 2018 05:40:52 -0700 (PDT)
From: Ocean HY1 He <hehy1@lenovo.com>
Subject: RE: [External]  Re: [PATCH] libnvdimm, region_devs: stop NDD_ALIASING
 bit test if one test pass
Date: Sun, 2 Sep 2018 12:40:19 +0000
Message-ID: <HK0PR03MB3170B411EB9DF9740AABFAD4890D0@HK0PR03MB3170.apcprd03.prod.outlook.com>
References: <1534651288-30306-1-git-send-email-oceanhehy@gmail.com>
 <1535665860.5995.78.camel@intel.com>
In-Reply-To: <1535665860.5995.78.camel@intel.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "ross.zwisler@linux.intel.com" <ross.zwisler@linux.intel.com>, "oceanhehy@gmail.com" <oceanhehy@gmail.com>, "Jiang, Dave" <dave.jiang@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Verma, Vishal L <vishal.l.verma@intel.com>
> Sent: Friday, August 31, 2018 5:51 AM
> To: Williams, Dan J <dan.j.williams@intel.com>; ross.zwisler@linux.intel.com;
> oceanhehy@gmail.com; Jiang, Dave <dave.jiang@intel.com>
> Cc: linux-kernel@vger.kernel.org; linux-nvdimm@lists.01.org; Ocean HY1 He
> <hehy1@lenovo.com>
> Subject: [External] Re: [PATCH] libnvdimm, region_devs: stop NDD_ALIASING
> bit test if one test pass
> 
> 
> On Sun, 2018-08-19 at 00:01 -0400, Ocean He wrote:
> > From: Ocean He <hehy1@lenovo.com>
> >
> > There is no need to finish entire loop to execute NDD_ALIASING bit
> > test
> > against every nvdimm->flags. In practice, all the nd_mapping->nvdimm
> > have the same flags.
> >
> > Because the check of alias is "if (alias)" but not
> > "if (alias == nd_region->ndr_mappings)", there is no function change
> > while
> > just save a few cycles.
> >
> > Signed-off-by: Ocean He <hehy1@lenovo.com>
> > ---
> > A test to check if all the nd_mapping->nvdimm have the same flags,
> > using
> > Lenovo ThinkSystem SR630 and 4.18-rc6.
> >
> > # ipmctl show -dimm
> >
> > DimmID  Capacity        HealthState     ActionRequired  LockState
> >    FWVersion
> > 0x0021  125.7
> > GiB       Healthy         0               Disabled        01.00.00.48
> > 88
> > 0x0121  125.7
> > GiB       Healthy         0               Disabled        01.00.00.48
> > 88
> > 0x1021  125.7
> > GiB       Healthy         0               Disabled        01.00.00.48
> > 88
> > 0x1121  125.7
> > GiB       Healthy         0               Disabled        01.00.00.48
> > 88
> >
> > # ipmctl create -f -goal -socket 0x0 PersistentMemoryType=AppDirect
> >
> > # ipmctl create -f -goal -socket 0x1 PersistentMemoryType=AppDirect
> >
> > # reboot, to make goal configuration take effect.
> >
> > # ndctl create-namespace -r region0 -s 100m -t pmem -m fsdax
> >
> > # ndctl create-namespace -r region1 -s 100m -t pmem -m fsdax
> >
> > # reboot and find all the nd_mapping->nvdimm have the same flags.
> >
> >  drivers/nvdimm/region_devs.c | 4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/nvdimm/region_devs.c
> > b/drivers/nvdimm/region_devs.c
> > index ec3543b..fc3bc1c 100644
> > --- a/drivers/nvdimm/region_devs.c
> > +++ b/drivers/nvdimm/region_devs.c
> > @@ -234,8 +234,10 @@ int nd_region_to_nstype(struct nd_region
> > *nd_region)
> >  			struct nd_mapping *nd_mapping = &nd_region-
> > >mapping[i];
> >  			struct nvdimm *nvdimm = nd_mapping->nvdimm;
> >
> > -			if (test_bit(NDD_ALIASING, &nvdimm->flags))
> > +			if (test_bit(NDD_ALIASING, &nvdimm->flags))
> > {
> >  				alias++;
> > +				break;
> 
> I think we can go a step further, and instead of the 'break' followed
> by a check for the 'alias' variable, in the loop, just return
> ND_DEVICE_NAMESPACE_PMEM if the NDD_ALIASING bit is found for any
> mapping. Outside the loop, simply return ND_DEVICE_NAMESPACE_IO. That
> makes it much cleaner and now we can get rid of 'alias' entirely.
> 
Hi Vishal,

Thanks for comments and I would send version 2 patch later.

Ocean.
> > +			}
> >  		}
> >  		if (alias)
> >  			return ND_DEVICE_NAMESPACE_PMEM;
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
