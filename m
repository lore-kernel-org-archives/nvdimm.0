Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D7D2F211BFCDD
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 15:20:31 -0800 (PST)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v5 1/7] libndctl: Use the supported_alignment attribute
Date: Wed, 30 Jan 2019 23:20:30 +0000
Message-ID: <8cd1f3f0731d2fbc98c16cbee20f8f7fa143db62.camel@intel.com>
References: <20190130105927.31901-1-oohall@gmail.com>
In-Reply-To: <20190130105927.31901-1-oohall@gmail.com>
Content-Language: en-US
Content-ID: <3E265F90860FA04FAC83E7201D9297E9@intel.com>
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
To: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "oohall@gmail.com" <oohall@gmail.com>
List-ID: <linux-nvdimm@lists.01.org>


On Wed, 2019-01-30 at 21:59 +1100, Oliver O'Halloran wrote:
> Newer kernels provide the "supported_alignments" sysfs attribute that
> indicates what alignments can be used with a PFN or DAX namespace. This
> patch adds the plumbing inside of libndctl to allow users to query this
> information through using:
> 	ndctl_{dax|pfn}_get_supported_alignment(), and
> 	ndctl_{dax|pfn}_get_num_alignments()
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> v5: Fixed comment wording
> 
> v4: Changed return code of ndctl_pfn_get_supported_alignment from -1 to
>     -1 to -EINVAL.
> 
>     Reworded comment about why we default to 4K and 2M alignments when
>     the sysfs attribute is missing.
> 
>     Shuffled around prototypes in ndctl.h.
> 
>     80 char compliance fixes.
> 
>     rebased onto pending branch
> 
> v3: Changed the return type of the *_get_supported_alignment() functions
>     to unsigned long to match the existing *_get_alignment() functions.
> ---
>  ndctl/lib/libndctl.c   | 43 ++++++++++++++++++++++++++++++++++++++++++
>  ndctl/lib/libndctl.sym |  4 ++++
>  ndctl/libndctl.h       |  4 ++++
>  3 files changed, 51 insertions(+)
> 
Thanks for the reworks, Oliver. I've applied the series.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
