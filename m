Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from gateway20.websitewelcome.com (gateway20.websitewelcome.com
 [192.185.59.4])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 617622020F95D
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 12:39:05 -0700 (PDT)
Received: from cm13.websitewelcome.com (cm13.websitewelcome.com [100.42.49.6])
 by gateway20.websitewelcome.com (Postfix) with ESMTP id CD61B400D4A78
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 13:32:03 -0500 (CDT)
References: <20190610210613.GA21989@embeddedor>
 <3e80b36c86942278ee66aebdd5ea2632f104083a.camel@intel.com>
From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: [PATCH] libnvdimm, region: Use struct_size() in kzalloc()
Message-ID: <d940183a-c00d-3a96-37bb-9553583f160a@embeddedor.com>
Date: Wed, 28 Aug 2019 14:36:59 -0500
MIME-Version: 1.0
In-Reply-To: <3e80b36c86942278ee66aebdd5ea2632f104083a.camel@intel.com>
Content-Language: en-US
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
To: "Verma, Vishal L" <vishal.l.verma@intel.com>, "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "Busch, Keith" <keith.busch@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Vishal,

On 8/28/19 1:51 PM, Verma, Vishal L wrote:

[..]

> 
> Hi Gustavo,
> 
> The patch looks good to me, however it looks like it might've missed
> some instances where this replacement can be performed?
> 

struct_size() does not apply to those scenarios. See below...

> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/tree/drivers/nvdimm/region_devs.c#n1030

struct_size() only applies to structures of the following kind:

struct foo {
   int stuff;
   struct boo entry[];
};

and this scenario includes two different structures:

struct nd_region {

	...

        struct nd_mapping mapping[0];
};

struct nd_blk_region {

	...

        struct nd_region nd_region;
};

> [2]: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/tree/drivers/nvdimm/region_devs.c#n96
> 

In this scenario struct_size() does not apply directly because of the following
logic before the call to devm_kzalloc():

 	size_t flush_data_size = sizeof(void *);
	
	[..]

        for (i = 0; i < nd_region->ndr_mappings; i++) {

		[..]

                /* at least one null hint slot per-dimm for the "no-hint" case */
                flush_data_size += sizeof(void *);
		
		[..]

                flush_data_size += nvdimm->num_flush * sizeof(void *);
        }

Thanks
--
Gustavo


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
