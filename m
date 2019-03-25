Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id BD8CE211D07A6
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 14:19:08 -0700 (PDT)
Date: Mon, 25 Mar 2019 16:19:06 -0500
From: Bjorn Helgaas <helgaas@kernel.org>
Subject: Re: [PATCH v2 1/1] treewide: Switch printk users from %pf and %pF to
 %ps and %pS, respectively
Message-ID: <20190325211906.GA24180@google.com>
References: <20190325193229.23390-1-sakari.ailus@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190325193229.23390-1-sakari.ailus@linux.intel.com>
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
To: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Petr Mladek <pmladek@suse.com>, linux-scsi@vger.kernel.org, linux-pm@vger.kernel.org, linux-mmc@vger.kernel.org, linux-nvdimm@lists.01.org, linux-um@lists.infradead.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, linux-acpi@vger.kernel.org, netdev@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-pci@vger.kernel.org, sparclinux@vger.kernel.org, xen-devel@lists.xenproject.org, ceph-devel@vger.kernel.org, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, drbd-dev@lists.linbit.com
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 25, 2019 at 09:32:28PM +0200, Sakari Ailus wrote:
> %pF and %pf are functionally equivalent to %pS and %ps conversion
> specifiers. The former are deprecated, therefore switch the current users
> to use the preferred variant.
> 
> The changes have been produced by the following command:
> 
> 	git grep -l '%p[fF]' | grep -v '^\(tools\|Documentation\)/' | \
> 	while read i; do perl -i -pe 's/%pf/%ps/g; s/%pF/%pS/g;' $i; done
> 
> And verifying the result.
> 
> Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
> Acked-by: David Sterba <dsterba@suse.com> (for btrfs)
> Acked-by: Mike Rapoport <rppt@linux.ibm.com> (for mm/memblock.c)
> Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Acked-by: Bjorn Helgaas <bhelgaas@google.com> (for drivers/pci)

Thanks a lot for cleaning this up.  This has been annoying for a long time.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
