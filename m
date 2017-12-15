Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0A74022119BC3
 for <linux-nvdimm@lists.01.org>; Fri, 15 Dec 2017 12:48:56 -0800 (PST)
Date: Fri, 15 Dec 2017 13:53:36 -0700
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: Re: [PATCH v3 2/3] hmat: add heterogeneous memory sysfs support
Message-ID: <20171215205336.GB5454@linux.intel.com>
References: <20171214021019.13579-1-ross.zwisler@linux.intel.com>
 <20171214021019.13579-3-ross.zwisler@linux.intel.com>
 <CAJZ5v0h8=mh9BKa2eZzqbc12T6saB+q19yqSfRLYKOiUjS2Cjg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAJZ5v0h8=mh9BKa2eZzqbc12T6saB+q19yqSfRLYKOiUjS2Cjg@mail.gmail.com>
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
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: "Box, David E" <david.e.box@intel.com>, Dave Hansen <dave.hansen@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Anaczkowski,, "Robert  <robert.moore@intel.com>, ACPI Devel Maling List" <linux-acpi@vger.kernel.org>, Odzioba,, "Erik  <erik.schmauss@intel.com>, Len Brown" <lenb@kernel.org>, John Hubbard <jhubbard@nvidia.com>, Jerome Glisse <jglisse@redhat.com>, devel@acpica.org, "Kogut, Jaroslaw  <Jaroslaw.Kogut@intel.com>, Linux Memory Management List" <linux-mm@kvack.org>, "Koss, Marcin  <marcin.koss@intel.com>, Brice Goglin <brice.goglin@gmail.com>, Nachimuthu, Murugasamy" <murugasamy.nachimuthu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Koziej,, "Joonas  <joonas.lahtinen@intel.com>, Andrew Morton <akpm@linux-foundation.org>, Tim Chen" <tim.c.chen@linux.intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Dec 15, 2017 at 01:52:03AM +0100, Rafael J. Wysocki wrote:
<>
> > diff --git a/drivers/acpi/hmat/core.c b/drivers/acpi/hmat/core.c
> > new file mode 100644
> > index 000000000000..61b90dadf84b
> > --- /dev/null
> > +++ b/drivers/acpi/hmat/core.c
> > @@ -0,0 +1,536 @@
> > +/*
> > + * Heterogeneous Memory Attributes Table (HMAT) representation in sysfs
> > + *
> > + * Copyright (c) 2017, Intel Corporation.
> > + *
> > + * This program is free software; you can redistribute it and/or modify it
> > + * under the terms and conditions of the GNU General Public License,
> > + * version 2, as published by the Free Software Foundation.
> > + *
> > + * This program is distributed in the hope it will be useful, but WITHOUT
> > + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> > + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> > + * more details.
> > + */
> 
> Minor nit for starters: you should use SPDX license indentifiers in
> new files and if you do so, the license boilerplace is not necessary
> any more.

Okay, I'll fix that up.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
