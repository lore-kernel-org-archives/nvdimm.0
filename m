Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7E5421164F02
 for <linux-nvdimm@lists.01.org>; Mon, 15 Oct 2018 15:59:16 -0700 (PDT)
From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [ndctl PATCH] test, device-dax: Fix intermittent poison
 handling failures
Date: Mon, 15 Oct 2018 22:59:14 +0000
Message-ID: <4ceb4de847d5ede7d2a1c38e0cf6260109578b66.camel@intel.com>
References: <153940497244.1425803.2319137619591631976.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <153940497244.1425803.2319137619591631976.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <C8EFEAB48AAEEC4987A301B95947431D@intel.com>
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
List-ID: <linux-nvdimm@lists.01.org>


On Fri, 2018-10-12 at 21:29 -0700, Dan Williams wrote:
> The device-dax unit test sometimes fails with the following kernel
> message signature:
> 
>      Memory failure: Unable to find user space address 204300 in lt-device-dax
>      Memory failure: 0x204300: forcibly killing lt-device-dax:1334 because of failure to unmap
> 
> This happens when there is a 3rd party vma in the rmap that has an entry
> at the same index as the currently failing page. While the test has
> munmap()'d the previous mapping we still trip over the fact that the
> kernel memory-failure code does not differentiate munmap vs mremap and
> upgrades the failure to process fatal.
> 
> The add_to_kill() routine in the kernel has a comment that says:
> 
>         /*
>          * In theory we don't have to kill when the page was
>          * munmaped. But it could be also a mremap. Since that's
>          * likely very rare kill anyways just out of paranoia, but use
>          * a SIGKILL because the error is not contained anymore.
>          */
> 
> ...when it is determining what to do when it can't find the given pfn
> mapped into the process at the given index.
> 
> Avoid this case by munmap()'ing *and* closing the file to trigger old /
> stale vma's to be reaped. With that the only vma that can be looked up
> is the one the error was injected, the lookup succeeds, and the test
> passes.
> 
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  test/device-dax.c |   49 ++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 34 insertions(+), 15 deletions(-)

Looks good, applied.

> 
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
