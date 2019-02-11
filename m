Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4D97A2194EB70
 for <linux-nvdimm@lists.01.org>; Tue, 12 Feb 2019 10:22:39 -0800 (PST)
Subject: Re: [PATCH 5/5] dax: "Hotplug" persistent memory for use like normal
 RAM
References: <20190124231441.37A4A305@viggo.jf.intel.com>
 <20190124231448.E102D18E@viggo.jf.intel.com>
 <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
From: Dave Hansen <dave.hansen@intel.com>
Message-ID: <26ac36f4-7391-5321-217b-50d67e2119d7@intel.com>
Date: Mon, 11 Feb 2019 08:22:20 -0800
MIME-Version: 1.0
In-Reply-To: <c4c6aca8-6ee8-be10-65ae-4cbe0aa03bfb@inria.fr>
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
To: Brice Goglin <Brice.Goglin@inria.fr>, Dave Hansen <dave.hansen@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: thomas.lendacky@amd.com, mhocko@suse.com, linux-nvdimm@lists.01.org, tiwai@suse.de, zwisler@kernel.org, linux-mm@kvack.org, jglisse@redhat.com, fengguang.wu@intel.com, baiyaowei@cmss.chinamobile.com, ying.huang@intel.com, bhelgaas@google.com, akpm@linux-foundation.org, bp@suse.de
List-ID: <linux-nvdimm@lists.01.org>

On 2/9/19 3:00 AM, Brice Goglin wrote:
> I've used your patches on fake hardware (memmap=xx!yy) with an older
> nvdimm-pending branch (without Keith's patches). It worked fine. This
> time I am running on real Intel hardware. Any idea where to look ?

I've run them on real Intel hardware too.

Could you share the exact sequence of commands you're issuing to
reproduce the hang?  My guess would be that there's some odd interaction
between Dan's latest branch and my now (slightly) stale patches.

I'll refresh them this week and see if I can reproduce what you're seeing.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
