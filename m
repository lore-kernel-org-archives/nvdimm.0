Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3427.houston.hpe.com (g4t3427.houston.hpe.com
 [15.241.140.73])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 7709A2217CE4C
 for <linux-nvdimm@lists.01.org>; Fri,  8 Dec 2017 15:46:51 -0800 (PST)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] acpi, nfit: fix health event notification
Date: Fri, 8 Dec 2017 23:51:18 +0000
Message-ID: <1512776323.11639.25.camel@hpe.com>
References: <151209330313.2584.7295902868393348172.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151209330313.2584.7295902868393348172.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <65ED5F90749CFA48A714A781D66130ED@NAMPRD84.PROD.OUTLOOK.COM>
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
To: "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
Cc: "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>, "daniel.k.osawa@intel.com" <daniel.k.osawa@intel.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, 2017-11-30 at 17:55 -0800, Dan Williams wrote:
> Integration testing with a BIOS that generates injected health event
> notifications fails to communicate those events to userspace. The nfit
> driver neglects to link the ACPI DIMM device with the necessary driver
> data so acpi_nvdimm_notify() fails this lookup:
> 
>         nfit_mem = dev_get_drvdata(dev);
>         if (nfit_mem && nfit_mem->flags_attr)
>                 sysfs_notify_dirent(nfit_mem->flags_attr);
> 
> Add the necessary linkage when installing the notification handler and
> clean it up when the nfit driver instance is torn down.
> 
> Cc: <stable@vger.kernel.org>
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Cc: Vishal Verma <vishal.l.verma@intel.com>
> Fixes: ba9c8dd3c222 ("acpi, nfit: add dimm device notification support")
> Reported-by: Daniel Osawa <daniel.k.osawa@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

The fix looks good.  Sorry it appears that I only tested ACPI
notification, not sysfs event, for the original change.

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
