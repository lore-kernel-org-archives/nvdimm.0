Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 383272115993B
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 08:33:42 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c12-v6so2964870otl.6
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 08:33:42 -0700 (PDT)
MIME-Version: 1.0
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180927071135.GB6959@linux-x5ow.site>
In-Reply-To: <20180927071135.GB6959@linux-x5ow.site>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 27 Sep 2018 08:33:30 -0700
Message-ID: <CAPcyv4jHbT=C0FAzHN57rQKcO+A3nXbpmb6fzc26sGFpD8y_fQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] acpi, nfit: Add dirty shutdown count to sysfs
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
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 27, 2018 at 12:12 AM Johannes Thumshirn <jthumshirn@suse.de> wrote:
>
> On Wed, Sep 26, 2018 at 09:24:20PM -0700, Dan Williams wrote:
> > The Intel NVDIMM command specification publishes a dirty-shutdown-count
> > in addition to the dirty-shutdown / flush-failed indication that comes
> > from the ACPI NFIT. This is expected to be a common property of NVDIMMs
> > and is a static hardware health detail to be cached / exported via
> > sysfs.
> >
> > Add plumbing for retrieving this data at driver load time, publish the
> > count, and use the dynamically retrieved dirty-shutdown indicator to
> > augment the existing 'flush_failed' flag.
>
> Is this the same thing as the LSS Latch stuff that went into ndctl?

It's a replacement. The latch mechanism is awkward especially when all
that it needed is a rolling count of dirty-shutdown events. The
expectation going forward is that the platform firmware will handle
the latch, if it is present, and the OS need only consume the
dirty-shutdown count. The ndctl implementation called libndctl apis
from the udev queue which we discovered injects unnecessary udev queue
drains / stalls into the boot path. Lastly, the userspace caching
scheme for non-root users to consume the dirty-shutdown-count just
isn't as efficient as teaching the kernel to cache this value and
export it as a standard sysfs attribute.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
