Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41813211B818D
 for <linux-nvdimm@lists.01.org>; Wed, 16 Jan 2019 13:06:54 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] ndctl/init-labels: Fix label slot accounting per
 UEFI 2.7
Date: Wed, 16 Jan 2019 21:06:52 +0000
Message-ID: <fb819738076d63b197d91e90f8f837e43165d4e3.camel@intel.com>
References: <154752430517.1624143.5852218139800007530.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <154752430517.1624143.5852218139800007530.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <543C6E7ADD9AD043AF56A5D4C96AF65A@intel.com>
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
To: "Williams, Dan J" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "sujith_pandel@dell.com" <sujith_pandel@dell.com>
List-ID: <linux-nvdimm@lists.01.org>


On Mon, 2019-01-14 at 19:51 -0800, Dan Williams wrote:
> Quoting from Linux kernel commit 9e694d9c18dd "libnvdimm, label: change
> nvdimm_num_label_slots per UEFI 2.7":
> 
>     sizeof_namespace_index() fails when NVDIMM devices have the minimum
>     1024 bytes label storage area.  nvdimm_num_label_slots() returns 3
>     slots while the area is only big enough for 2 slots.
> 
>     Change nvdimm_num_label_slots() to calculate a number of label slots
>     according to UEFI 2.7 spec.
> 
> Without this fix attempts to initialize labels on a small (1K) label
> area results in the following:
> 
> libndctl: sizeof_namespace_index: nmem2: label area (1024) too small to host (128 byte) labels
> libndctl: sizeof_namespace_index: nmem2: label area (1024) too small to host (256 byte) labels
> 
> Based on an original patch by Toshi Kani
> Fixes: bdaec95463ca ("ndctl: introduce ndctl_dimm_{validate_labels,init_labels}")
> Reported-by: Sujith Pandel <sujith_pandel@dell.com>
> Link: https://github.com/pmem/ndctl/issues/78
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  ndctl/lib/dimm.c |   35 +++++++++++++++++++++++++----------
>  1 file changed, 25 insertions(+), 10 deletions(-)

Thanks, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
