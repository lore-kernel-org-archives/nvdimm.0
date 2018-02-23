Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x241.google.com (mail-pl0-x241.google.com
 [IPv6:2607:f8b0:400e:c01::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C5B162243695A
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 04:54:58 -0800 (PST)
Received: by mail-pl0-x241.google.com with SMTP id k8so4854277pli.8
 for <linux-nvdimm@lists.01.org>; Fri, 23 Feb 2018 05:01:00 -0800 (PST)
Date: Fri, 23 Feb 2018 18:30:53 +0530
From: Aishwarya Pant <aishpant@gmail.com>
Subject: Re: [PATCH] acpi: nfit: document sysfs interface
Message-ID: <20180223130053.GA17196@mordor.localdomain>
References: <20180219180754.GA31007@mordor.localdomain>
 <CAPcyv4iQzEeZO-LYPvKQJHzrb3mrgENWZdnH2LzDV49tyfNM2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4iQzEeZO-LYPvKQJHzrb3mrgENWZdnH2LzDV49tyfNM2Q@mail.gmail.com>
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
Cc: Julia Lawall <julia.lawall@lip6.fr>, Jonathan Corbet <corbet@lwn.net>, Greg KH <gregkh@linuxfoundation.org>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 21, 2018 at 03:46:06PM -0800, Dan Williams wrote:

<snip>

> 
> So, this looks great and is something I've had on my backlog for a
> while. That said this is a bit incomplete. These attributes are
> relative to the the "nd" bus which is the libnvdimm sub-system sysfs
> interface. This document describes that sysfs layout [3]. Ideally that
> content would be converted into Documentation/ABI format and merged
> with what you have done here into an overall
> Documentation/ABI/testing/sysfs-bus-nvdimm file.
> 
> I realize that's quite a bit more work, so I'm fine if we start with
> the nfit attributes and save that follow on work for a separate patch
> in the future.

Thanks for the review!

I'll keep the libnvdim interface in my backlog for now. I just sent a revision
of the nfit patch with the suggested changes.

Aishwarya

> 
> [3]: https://git.kernel.org/pub/scm/linux/kernel/git/nvdimm/nvdimm.git/tree/Documentation/nvdimm/nvdimm.txt?h=libnvdimm-for-next
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
