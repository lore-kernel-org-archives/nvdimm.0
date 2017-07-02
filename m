Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from g4t3425.houston.hpe.com (g4t3425.houston.hpe.com
 [15.241.140.78])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A081F21B02B87
 for <linux-nvdimm@lists.01.org>; Sun,  2 Jul 2017 12:30:16 -0700 (PDT)
From: "Kani, Toshimitsu" <toshi.kani@hpe.com>
Subject: Re: [PATCH] libnvdimm, region, pmem: fix 'badblocks'
 sysfs_get_dirent() reference lifetime
Date: Sun, 2 Jul 2017 19:31:49 +0000
Message-ID: <1499023372.2042.1.camel@hpe.com>
References: <149892424300.37698.9888818880178611728.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <149892424300.37698.9888818880178611728.stgit@dwillia2-desk3.amr.corp.intel.com>
Content-Language: en-US
Content-ID: <776359EA95546649BFFE74CFCBBF8132@NAMPRD84.PROD.OUTLOOK.COM>
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
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, 2017-07-01 at 08:50 -0700, Dan Williams wrote:
> We need to hold a reference on the 'dirent' until we are sure there
> are no more notifications that will be sent. As noted in the new
> comments we take advantage of the fact that the references are taken
> and dropped under device_lock() and that nd_device_notify() holds
> device_lock() over new badblocks notifications. The notifications
> that happen when badblocks are cleared only occur while the device is
> active.
> 
> Also take the opportunity to fix up the error messages to report the
> user visible effect of a sysfs_get_dirent() failure.
> 
> Fixes: 975750a98c26 ("libnvdimm, pmem: Add sysfs notifications to
> badblocks")
> Cc: Toshi Kani <toshi.kani@hpe.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

Reviewed-by: Toshi Kani <toshi.kani@hpe.com>

Thanks Dan!
-Toshi
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
