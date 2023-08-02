Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79009847C
	for <nvdimm@lists.linux.dev>; Wed,  2 Aug 2023 14:27:24 +0000 (UTC)
Received: from lhrpeml500005.china.huawei.com (unknown [172.18.147.201])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4RGDjp4p31z6J6JC;
	Wed,  2 Aug 2023 22:23:42 +0800 (CST)
Received: from localhost (10.202.227.76) by lhrpeml500005.china.huawei.com
 (7.191.163.240) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.27; Wed, 2 Aug
 2023 15:27:21 +0100
Date: Wed, 2 Aug 2023 15:27:20 +0100
From: Jonathan Cameron <Jonathan.Cameron@Huawei.com>
To: Vishal Verma <vishal.l.verma@intel.com>
CC: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Dan Williams
	<dan.j.williams@intel.com>, Dave Jiang <dave.jiang@intel.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<nvdimm@lists.linux.dev>, <linux-cxl@vger.kernel.org>, Huang Ying
	<ying.huang@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, Aneesh
 Kumar K.V <aneesh.kumar@linux.ibm.com>, Michal Hocko <mhocko@suse.com>, Jeff
 Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH v3 2/2] dax/kmem: allow kmem to add memory with
 memmap_on_memory
Message-ID: <20230802152720.00007160@Huawei.com>
In-Reply-To: <20230801-vv-kmem_memmap-v3-2-406e9aaf5689@intel.com>
References: <20230801-vv-kmem_memmap-v3-0-406e9aaf5689@intel.com>
	<20230801-vv-kmem_memmap-v3-2-406e9aaf5689@intel.com>
Organization: Huawei Technologies Research and Development (UK) Ltd.
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.227.76]
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 lhrpeml500005.china.huawei.com (7.191.163.240)
X-CFilter-Loop: Reflected

On Tue, 01 Aug 2023 23:55:38 -0600
Vishal Verma <vishal.l.verma@intel.com> wrote:

> Large amounts of memory managed by the kmem driver may come in via CXL,
> and it is often desirable to have the memmap for this memory on the new
> memory itself.
> 
> Enroll kmem-managed memory for memmap_on_memory semantics as a default.
> Add a sysfs override under the dax device to opt out of this behavior.
> 
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Michal Hocko <mhocko@suse.com>
> Cc: Oscar Salvador <osalvador@suse.de>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Huang Ying <ying.huang@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Hi Vishal,

In general looks fine to me.  Just a question for potential discussion if didn't
miss it in earlier versions.

FWIW
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

Also, any docs need updating?  Doesn't seem like the DAX ABI docs are present in
Documentation/ABI so not sure where it should be updated.

Jonathan


>  
> @@ -1400,6 +1435,13 @@ struct dev_dax *devm_create_dev_dax(struct dev_dax_data *data)
>  	dev_dax->align = dax_region->align;
>  	ida_init(&dev_dax->ida);
>  
> +	/*
> +	 * If supported by memory_hotplug, allow memmap_on_memory behavior by
> +	 * default. This can be overridden via sysfs before handing the memory
> +	 * over to kmem if desired.
> +	 */
> +	dev_dax->memmap_on_memory = true;

If there are existing users, then this is a fairly significant change of defaults.
Maybe it should be false and opt in rather than out?

> +
>  	inode = dax_inode(dax_dev);
>  	dev->devt = inode->i_rdev;
>  	dev->bus = &dax_bus_type;


