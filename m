Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 19E5B212C01E4
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:46:47 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id t76so20216096oih.4
 for <linux-nvdimm@lists.01.org>; Wed, 17 Jul 2019 18:44:19 -0700 (PDT)
MIME-Version: 1.0
References: <20190717225400.9494-1-vishal.l.verma@intel.com>
 <20190717225400.9494-3-vishal.l.verma@intel.com>
In-Reply-To: <20190717225400.9494-3-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 17 Jul 2019 18:44:07 -0700
Message-ID: <CAPcyv4ha=vK9fJRkwMzGFOnmnSsgo6HE=_yk_f_O9HawkbJ2DA@mail.gmail.com>
Subject: Re: [ndctl PATCH v6 02/13] libdaxctl: add interfaces to
 enable/disable devices
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, Pavel Tatashin <pasha.tatashin@soleen.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jul 17, 2019 at 3:54 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> Add new libdaxctl interfaces to disable a device_dax based device, and
> to enable it into the given mode. The modes available are 'devdax',
> and 'system-ram', where devdax is the normal device DAX mode used
> via a character device, and 'system-ram' uses the kernel's 'kmem'
> facility to hotplug the device making it usable as normal memory.
>
> This adds the following new interfaces:
>
>   daxctl_dev_disable;
>   daxctl_dev_enable_devdax;
>   daxctl_dev_enable_ram;
>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
