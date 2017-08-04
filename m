Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
 [66.111.4.25])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EFDAD21E1DAF4
 for <linux-nvdimm@lists.01.org>; Fri,  4 Aug 2017 12:59:34 -0700 (PDT)
Date: Fri, 4 Aug 2017 13:01:44 -0700
From: Greg KH <greg@kroah.com>
Subject: Re: [4.9-stable PATCH] device-dax: fix sysfs duplicate warnings
Message-ID: <20170804200144.GH3477@kroah.com>
References: <15010052332208@kroah.com>
 <150180630236.6719.1152880381080551797.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <150180630236.6719.1152880381080551797.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Cc: Dariusz Dokupil <dariusz.dokupil@intel.com>, stable@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 03, 2017 at 05:25:02PM -0700, Dan Williams wrote:
> commit bbb3be170ac2891526ad07b18af7db226879a8e7 upstream.
> 
> Fix warnings of the form...
> 
>      WARNING: CPU: 10 PID: 4983 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x62/0x80
>      sysfs: cannot create duplicate filename '/class/dax/dax12.0'
>      Call Trace:
>       dump_stack+0x63/0x86
>       __warn+0xcb/0xf0
>       warn_slowpath_fmt+0x5a/0x80
>       ? kernfs_path_from_node+0x4f/0x60
>       sysfs_warn_dup+0x62/0x80
>       sysfs_do_create_link_sd.isra.2+0x97/0xb0
>       sysfs_create_link+0x25/0x40
>       device_add+0x266/0x630
>       devm_create_dax_dev+0x2cf/0x340 [dax]
>       dax_pmem_probe+0x1f5/0x26e [dax_pmem]
>       nvdimm_bus_probe+0x71/0x120
> 
> ...by reusing the namespace id for the device-dax instance name.
> 
> Now that we have decided that there will never by more than one
> device-dax instance per libnvdimm-namespace parent device [1], we can
> directly reuse the namepace ids. There are some possible follow-on
> cleanups, but those are saved for a later patch to simplify the -stable
> backport.
> 
> [1]: https://lists.01.org/pipermail/linux-nvdimm/2016-December/008266.html
> 
> Fixes: 98a29c39dc68 ("libnvdimm, namespace: allow creation of multiple pmem...")
> Cc: Jeff Moyer <jmoyer@redhat.com>
> Cc: <stable@vger.kernel.org>
> Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> ---
>  drivers/dax/dax.c  |   24 ++++++++++++++++--------
>  drivers/dax/dax.h  |    2 +-
>  drivers/dax/pmem.c |   12 +++++++-----
>  3 files changed, 24 insertions(+), 14 deletions(-)

Thanks for the backport, now applied.

greg k-h
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
