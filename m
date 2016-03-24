Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 by ml01.01.org (Postfix) with ESMTP id 3A2331A1E94
 for <linux-nvdimm@lists.01.org>; Thu, 24 Mar 2016 09:10:57 -0700 (PDT)
Date: Thu, 24 Mar 2016 10:04:52 -0600
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: provide a method to invalidate the bus
 list
Message-ID: <20160324160452.GA5725@linux.intel.com>
References: <20160324011648.20651.33434.stgit@dwillia2-desk3.jf.intel.com>
 <20160324011653.20651.27454.stgit@dwillia2-desk3.jf.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160324011653.20651.27454.stgit@dwillia2-desk3.jf.intel.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Mar 23, 2016 at 06:16:53PM -0700, Dan Williams wrote:
> Consider the following scenario:
> 
>     ndctl_new()
>     ndctl_bus_foreach()
>     <install a new nvdimm-bus provider>
>     ndctl_bus_foreach()
> 
> ...the second ndctl_bus_foreach() will not see any new buses because the
> bus results are cached.  When the holder of the context knows that it
> has invalidated the bus list it needs to call ndctl_invalidate() so that
> subsequent ndctl_bus_foreach() scans are guaranteed to see new buses.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  lib/libndctl.c          |   22 ++++++++++++++++++----
>  lib/libndctl.sym        |    1 +
>  lib/ndctl/libndctl.h.in |    1 +

I can't get this patch to apply because I don't have lib/ndctl/libndctl.h.in
in my source tree.

I'm using your upstream repo:

https://github.com/pmem/ndctl.git

and AFAICT this file doesn't exist in any upstream branches.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
