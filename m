Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0FD8D20212CBF
 for <linux-nvdimm@lists.01.org>; Wed, 28 Aug 2019 13:26:36 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH] libnvdimm, region: Use struct_size() in kzalloc()
Date: Wed, 28 Aug 2019 20:24:35 +0000
Message-ID: <7980d0c0b43bc6f377e0daad4a066f7ab37c2258.camel@intel.com>
References: <20190610210613.GA21989@embeddedor>
 <3e80b36c86942278ee66aebdd5ea2632f104083a.camel@intel.com>
 <d940183a-c00d-3a96-37bb-9553583f160a@embeddedor.com>
In-Reply-To: <d940183a-c00d-3a96-37bb-9553583f160a@embeddedor.com>
Content-Language: en-US
Content-ID: <3847512B969EEA4C94940FD1F358BBD7@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "Jiang, Dave" <dave.jiang@intel.com>, "gustavo@embeddedor.com" <gustavo@embeddedor.com>, "Busch, Keith" <keith.busch@intel.com>, "Weiny, Ira" <ira.weiny@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, 2019-08-28 at 14:36 -0500, Gustavo A. R. Silva wrote:

> struct_size() does not apply to those scenarios. See below...
> 
> > [1]: 
> > https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/tree/drivers/nvdimm/region_devs.c#n1030
> 
> struct_size() only applies to structures of the following kind:
> 
> struct foo {
>    int stuff;
>    struct boo entry[];
> };
> 
> and this scenario includes two different structures:
> 
> struct nd_region {
> 	...
>         struct nd_mapping mapping[0];
> };
> 
> struct nd_blk_region {
> 	...
>         struct nd_region nd_region;
> };

Yep - I neglected to actually look at the structures involved - you're
right, it doesn't apply here.

> 
> > [2]: 
> > https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/tree/drivers/nvdimm/region_devs.c#n96
> > 
> 
> In this scenario struct_size() does not apply directly because of the
> following
> logic before the call to devm_kzalloc():

Agreed, I missed that the calculation was more involved here.

Thanks for the clarifications, you can add:
Reviewed-by: Vishal Verma <vishal.l.verma@intel.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
