Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B5BC1211B1102
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 13:53:03 -0800 (PST)
Subject: Re: [PATCH 4/4] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190116181859.D1504459@viggo.jf.intel.com>
 <20190116181905.12E102B4@viggo.jf.intel.com>
 <CAErSpo55j7odYf-B-KSoogabD9Qqt605oUGYe6td9wZdYNq_Hg@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <f786481c-d38d-5129-318b-cb61b6251c47@intel.com>
Date: Wed, 16 Jan 2019 13:53:03 -0800
MIME-Version: 1.0
In-Reply-To: <CAErSpo55j7odYf-B-KSoogabD9Qqt605oUGYe6td9wZdYNq_Hg@mail.gmail.com>
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
To: Bjorn Helgaas <bhelgaas@google.com>, Dave Hansen <dave.hansen@linux.intel.com>
Cc: thomas.lendacky@amd.com, dave@sr71.net, linux-nvdimm@lists.01.org, Takashi Iwai <tiwai@suse.de>, Huang Ying <ying.huang@intel.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org, mhocko@suse.com, Borislav Petkov <bp@suse.de>, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, Wu Fengguang <fengguang.wu@intel.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <linux-nvdimm@lists.01.org>

On 1/16/19 1:16 PM, Bjorn Helgaas wrote:
>> +       /*
>> +        * Set flags appropriate for System RAM.  Leave ..._BUSY clear
>> +        * so that add_memory() can add a child resource.
>> +        */
>> +       new_res->flags = IORESOURCE_SYSTEM_RAM;
> IIUC, new_res->flags was set to "IORESOURCE_MEM | ..." in the
> devm_request_mem_region() path.  I think you should keep at least
> IORESOURCE_MEM so the iomem_resource tree stays consistent.

I went to look at fixing this.  It looks like "IORESOURCE_SYSTEM_RAM"
includes IORESOURCE_MEM:

> #define IORESOURCE_SYSTEM_RAM           (IORESOURCE_MEM|IORESOURCE_SYSRAM)

Did you want the patch to expand this #define, or did you just want to
ensure that IORESORUCE_MEM got in there somehow?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
