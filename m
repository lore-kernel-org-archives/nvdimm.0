Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from ale.deltatee.com (ale.deltatee.com [207.54.116.67])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1D57721131DA0
 for <linux-nvdimm@lists.01.org>; Fri, 21 Sep 2018 12:41:20 -0700 (PDT)
References: <20180920215824.19464.8884.stgit@localhost.localdomain>
 <20180920222415.19464.38400.stgit@localhost.localdomain>
 <a40a78c0-207b-03b7-344c-847b12a4f896@microsoft.com>
From: Logan Gunthorpe <logang@deltatee.com>
Message-ID: <4d984974-ff16-35e4-76ff-f5e43e5e90da@deltatee.com>
Date: Fri, 21 Sep 2018 13:41:12 -0600
MIME-Version: 1.0
In-Reply-To: <a40a78c0-207b-03b7-344c-847b12a4f896@microsoft.com>
Content-Language: en-US
Subject: Re: [PATCH v4 1/5] mm: Provide kernel parameter to allow disabling
 page init poisoning
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
To: Pasha Tatashin <Pavel.Tatashin@microsoft.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "mhocko@suse.com" <mhocko@suse.com>, "dave.hansen@intel.com" <dave.hansen@intel.com>, "jglisse@redhat.com" <jglisse@redhat.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mingo@kernel.org" <mingo@kernel.org>, "kirill.shutemov@linux.intel.com" <kirill.shutemov@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On 2018-09-21 1:04 PM, Pasha Tatashin wrote:
> 
>> +			pr_err("vm_debug option '%c' unknown. skipped\n",
>> +			       *str);
>> +		}
>> +
>> +		str++;
>> +	}
>> +out:
>> +	if (page_init_poisoning && !__page_init_poisoning)
>> +		pr_warn("Page struct poisoning disabled by kernel command line option 'vm_debug'\n");
> 
> New lines '\n' can be removed, they are not needed for kprintfs.

No, that's not correct.

A printk without a newline termination is not emitted
as output until the next printk call. (To support KERN_CONT).
Therefore removing the '\n' causes a printk to not be printed when it is
called which can cause long delayed messages and subtle problems when
debugging. Always keep the newline in place even though the kernel will
add one for you if it's missing.

Logan

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
