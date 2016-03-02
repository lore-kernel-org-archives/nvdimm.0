Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
 by ml01.01.org (Postfix) with ESMTP id 23FA01A1E80
 for <linux-nvdimm@lists.01.org>; Wed,  2 Mar 2016 06:09:58 -0800 (PST)
Date: Wed, 2 Mar 2016 09:09:47 -0500
From: Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH] dax: check return value of dax_radix_entry()
Message-ID: <20160302140947.GL3730@linux.intel.com>
References: <1456870508-20385-1-git-send-email-ross.zwisler@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1456870508-20385-1-git-send-email-ross.zwisler@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 01, 2016 at 03:15:08PM -0700, Ross Zwisler wrote:
> dax_pfn_mkwrite() previously wasn't checking the return value of the call
> to dax_radix_entry(), which was a mistake.
> 
> Instead, capture this return value and pass it up the stack if it is an
> error.

>  	 */
> -	dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false, true);
> +	error = dax_radix_entry(file->f_mapping, vmf->pgoff, NO_SECTOR, false,
> +			true);
> +	if (error)
> +		return error;
> +
>  	return VM_FAULT_NOPAGE;

You can't return an errno from here.

	if (error)
		return VM_FAULT_SIGBUS;

is better.  For full points,

	if (error == -ENOMEM)
		return VM_FAULT_OOM;
	if (error)
		return VM_FAULT_SIGBUS;
	return VM_FAULT_NOPAGE;

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
