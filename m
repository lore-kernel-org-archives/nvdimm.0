Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id DE1ED21217972
 for <linux-nvdimm@lists.01.org>; Thu, 25 Apr 2019 11:32:17 -0700 (PDT)
Subject: Re: [v3 1/2] device-dax: fix memory and resource leak if hotplug fails
References: <20190425175440.9354-1-pasha.tatashin@soleen.com>
 <20190425175440.9354-2-pasha.tatashin@soleen.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <67dba1e2-155c-f572-81dd-a6d589d0e8a5@intel.com>
Date: Thu, 25 Apr 2019 11:32:15 -0700
MIME-Version: 1.0
In-Reply-To: <20190425175440.9354-2-pasha.tatashin@soleen.com>
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
To: Pavel Tatashin <pasha.tatashin@soleen.com>, jmorris@namei.org, sashal@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-nvdimm@lists.01.org, akpm@linux-foundation.org, mhocko@suse.com, dave.hansen@linux.intel.com, dan.j.williams@intel.com, keith.busch@intel.com, vishal.l.verma@intel.com, dave.jiang@intel.com, zwisler@kernel.org, thomas.lendacky@amd.com, ying.huang@intel.com, fengguang.wu@intel.com, bp@suse.de, bhelgaas@google.com, baiyaowei@cmss.chinamobile.com, tiwai@suse.de, jglisse@redhat.com, david@redhat.com
List-ID: <linux-nvdimm@lists.01.org>

On 4/25/19 10:54 AM, Pavel Tatashin wrote:
>  	rc = add_memory(numa_node, new_res->start, resource_size(new_res));
> -	if (rc)
> +	if (rc) {
> +		release_resource(new_res);
> +		kfree(new_res);
>  		return rc;
> +	}

Looks good to me:

Reviewed-by: Dave Hansen <dave.hansen@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
