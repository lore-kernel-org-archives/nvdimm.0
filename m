Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B8B921243BC6
 for <linux-nvdimm@lists.01.org>; Thu,  2 May 2019 10:34:26 -0700 (PDT)
Date: Thu, 2 May 2019 13:34:19 -0400
From: Sasha Levin <sashal@kernel.org>
Subject: Re: [v4 2/2] device-dax: "Hotremove" persistent memory that is used
 like normal RAM
Message-ID: <20190502173419.GA3048@sasha-vm>
References: <20190501191846.12634-1-pasha.tatashin@soleen.com>
 <20190501191846.12634-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190501191846.12634-3-pasha.tatashin@soleen.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Pavel Tatashin <pasha.tatashin@soleen.com>
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, dave.hansen@linux.intel.com, ying.huang@intel.com, jmorris@namei.org, david@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, jglisse@redhat.com, bp@suse.de, baiyaowei@cmss.chinamobile.com, zwisler@kernel.org, bhelgaas@google.com, akpm@linux-foundation.org, fengguang.wu@intel.com
List-ID: <linux-nvdimm@lists.01.org>

On Wed, May 01, 2019 at 03:18:46PM -0400, Pavel Tatashin wrote:
>It is now allowed to use persistent memory like a regular RAM, but
>currently there is no way to remove this memory until machine is
>rebooted.
>
>This work expands the functionality to also allows hotremoving
>previously hotplugged persistent memory, and recover the device for use
>for other purposes.
>
>To hotremove persistent memory, the management software must first
>offline all memory blocks of dax region, and than unbind it from
>device-dax/kmem driver. So, operations should look like this:
>
>echo offline > echo offline > /sys/devices/system/memory/memoryN/state

This looks wrong :)

--
Thanks,
Sasha
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
