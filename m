Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00FCE2115993B
 for <linux-nvdimm@lists.01.org>; Thu, 27 Sep 2018 08:19:31 -0700 (PDT)
Date: Thu, 27 Sep 2018 09:21:40 -0600
From: Keith Busch <keith.busch@linux.intel.com>
Subject: Re: [PATCH 0/3] acpi, nfit: Add dirty shutdown count to sysfs
Message-ID: <20180927152140.GA19589@localhost.localdomain>
References: <153802226065.833068.11943510429252969385.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20180927071135.GB6959@linux-x5ow.site>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180927071135.GB6959@linux-x5ow.site>
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
Cc: linux-acpi@vger.kernel.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Sep 27, 2018 at 09:11:35AM +0200, Johannes Thumshirn wrote:
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

On a related note, the ndctl latch implementation doesn't satisfy all
the needs, so I expect it'll be reverted

  https://lists.01.org/pipermail/linux-nvdimm/2018-September/017892.html
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
