Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id AAE6B211CD9BC
 for <linux-nvdimm@lists.01.org>; Sun, 24 Feb 2019 10:25:01 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id z19so6032296otm.2
 for <linux-nvdimm@lists.01.org>; Sun, 24 Feb 2019 10:25:00 -0800 (PST)
MIME-Version: 1.0
References: <20190222235854.18927-1-vishal.l.verma@intel.com>
 <CAPcyv4ghTOwomME0GBuFi-ogfB7=D6kQMGR+Gb6b7cvMqLE4EA@mail.gmail.com>
 <00540b00898a544b38a989b0b3b6c005fd50bef4.camel@kernel.org>
In-Reply-To: <00540b00898a544b38a989b0b3b6c005fd50bef4.camel@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 24 Feb 2019 10:24:48 -0800
Message-ID: <CAPcyv4j853QjDpK5ViTgCNSZ2ncmke0T=eZx8i_wt1ULdTbnqg@mail.gmail.com>
Subject: Re: [PATCH] dax: add a 'modalias' attribute to DAX 'bus' devices
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
To: Vishal Verma <vishal@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Feb 23, 2019 at 5:29 PM Vishal Verma <vishal@kernel.org> wrote:
>
> On Fri, 2019-02-22 at 16:24 -0800, Dan Williams wrote:
> > Looks ok, but I think the changelog could be more accurate.
> >
> > On Fri, Feb 22, 2019 at 3:59 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
> > > Add a 'modalias' attribute to devices under the DAX bus so that userspace
> > > is able to dynamically load modules as needed.
> >
> > The modalias is already published in the uevent which is how udev
> > identifies the module. This patch would allow "modalias to module
> > lookups" *outside* of the typical uevent used for dynamically loading
> > modules.
> >
> > Care to fix up the changelog with that detail and why userspace needs
> > to do these lookups in addition to the typical uevent lookups?
> >
>
> Yes, thanks for the feedback, I think this reads better:
>
> 8<----
>
> From 1e399f52f21c22e4c4bd5d48b26f539e12342beb Mon Sep 17 00:00:00 2001
> From: Vishal Verma <vishal.l.verma@intel.com>
> Date: Fri, 22 Feb 2019 16:58:54 -0700
> Subject: [PATCH v2] dax: add a 'modalias' attribute to DAX 'bus' devices
>
> Add a 'modalias' attribute to devices under the DAX bus so that userspace
> is able to dynamically load modules as needed.
>
> Normally, udev can get the modalias from 'uevent', and that is correctly
> set up by the DAX bus. However other tooling such as 'libndctl' for
> interacting with drivers/nvdimm/, and 'libdaxctl' for drivers/dax/ can
> also use the modalias to dynamically load modules via libkmod lookups.
>
> The 'nd' bus set up by the libnvdimm subsystem exports a modalias
> attribute. Imitate this to export the same for the 'dax' bus.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Hansen <dave.hansen@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good,

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
