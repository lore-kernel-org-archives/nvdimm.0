Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2660B211B5A42
 for <linux-nvdimm@lists.01.org>; Thu, 24 Jan 2019 14:22:43 -0800 (PST)
Date: Thu, 24 Jan 2019 14:22:06 -0800
From: Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Update filesystem-dax and NVDIMM entries
Message-ID: <20190124222205.GA28691@iweiny-DESK2.sc.intel.com>
References: <154835747897.2884847.389054528444820204.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <154835747897.2884847.389054528444820204.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Jan Kara <jack@suse.cz>, linux-nvdimm@lists.01.org, linux-kernel@vger.kernel.org, Matthew Wilcox <willy@infradead.org>, Ross Zwisler <zwisler@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jan 24, 2019 at 11:17:59AM -0800, Dan Williams wrote:
> Ross has moved on to other areas.
> 
> Matthew and Jan are trusted reviewers for DAX.
> 
> Dan is now coordinating filesystem-dax pull requests.
> 
> Ira and Keith are now involved with the NVDIMM and Device-DAX
> sub-systems.
> 
> The linux-nvdimm mailing hosts a patchwork instance for both DAX and
> NVDIMM patches.
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Ira Weiny <ira.weiny@intel.com>
> Cc: Ross Zwisler <zwisler@kernel.org>
> Cc: Keith Busch <keith.busch@intel.com>
> Cc: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Acked-by: Ira Weiny <ira.weiny@intel.com>

> ---
>  MAINTAINERS |   17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 51029a425dbe..5f43ee438a74 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4535,10 +4535,11 @@ S:	Maintained
>  F:	drivers/i2c/busses/i2c-diolan-u2c.c
>  
>  FILESYSTEM DIRECT ACCESS (DAX)
> -M:	Matthew Wilcox <willy@infradead.org>
> -M:	Ross Zwisler <zwisler@kernel.org>
> -M:	Jan Kara <jack@suse.cz>
> +M:	Dan Williams <dan.j.williams@intel.com>
> +R:	Matthew Wilcox <willy@infradead.org>
> +R:	Jan Kara <jack@suse.cz>
>  L:	linux-fsdevel@vger.kernel.org
> +L:	linux-nvdimm@lists.01.org
>  S:	Supported
>  F:	fs/dax.c
>  F:	include/linux/dax.h
> @@ -4546,9 +4547,9 @@ F:	include/trace/events/fs_dax.h
>  
>  DEVICE DIRECT ACCESS (DAX)
>  M:	Dan Williams <dan.j.williams@intel.com>
> -M:	Dave Jiang <dave.jiang@intel.com>
> -M:	Ross Zwisler <zwisler@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
> +M:	Keith Busch <keith.busch@intel.com>
> +M:	Dave Jiang <dave.jiang@intel.com>
>  L:	linux-nvdimm@lists.01.org
>  S:	Supported
>  F:	drivers/dax/
> @@ -8641,7 +8642,6 @@ S:	Maintained
>  F:	tools/lib/lockdep/
>  
>  LIBNVDIMM BLK: MMIO-APERTURE DRIVER
> -M:	Ross Zwisler <zwisler@kernel.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
> @@ -8654,7 +8654,6 @@ F:	drivers/nvdimm/region_devs.c
>  LIBNVDIMM BTT: BLOCK TRANSLATION TABLE
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dan Williams <dan.j.williams@intel.com>
> -M:	Ross Zwisler <zwisler@kernel.org>
>  M:	Dave Jiang <dave.jiang@intel.com>
>  L:	linux-nvdimm@lists.01.org
>  Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
> @@ -8662,7 +8661,6 @@ S:	Supported
>  F:	drivers/nvdimm/btt*
>  
>  LIBNVDIMM PMEM: PERSISTENT MEMORY DRIVER
> -M:	Ross Zwisler <zwisler@kernel.org>
>  M:	Dan Williams <dan.j.williams@intel.com>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
> @@ -8681,9 +8679,10 @@ F:	Documentation/devicetree/bindings/pmem/pmem-region.txt
>  
>  LIBNVDIMM: NON-VOLATILE MEMORY DEVICE SUBSYSTEM
>  M:	Dan Williams <dan.j.williams@intel.com>
> -M:	Ross Zwisler <zwisler@kernel.org>
>  M:	Vishal Verma <vishal.l.verma@intel.com>
>  M:	Dave Jiang <dave.jiang@intel.com>
> +M:	Keith Busch <keith.busch@intel.com>
> +M:	Ira Weiny <ira.weiny@intel.com>
>  L:	linux-nvdimm@lists.01.org
>  Q:	https://patchwork.kernel.org/project/linux-nvdimm/list/
>  T:	git git://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
