Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 79E04211D59AF
 for <linux-nvdimm@lists.01.org>; Mon, 25 Mar 2019 08:24:18 -0700 (PDT)
Date: Mon, 25 Mar 2019 17:24:09 +0200
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH 0/2] Remove support for deprecated %pf and %pF in vsprintf
Message-ID: <20190325152409.GF9224@smile.fi.intel.com>
References: <20190322132108.25501-1-sakari.ailus@linux.intel.com>
 <CAMuHMdVmqqjVx7As9AAywYxYXG=grijF5rF77OBn6TUjM9+xKw@mail.gmail.com>
 <20190322135350.2btpno7vspvewxvk@paasikivi.fi.intel.com>
 <20190322170550.GX9224@smile.fi.intel.com>
 <20190324211008.lypghym3gqcp62th@mara.localdomain>
 <20190324211932.GK9224@smile.fi.intel.com>
 <20190325151259.2w22y4ijqilrbaxj@kekkonen.localdomain>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20190325151259.2w22y4ijqilrbaxj@kekkonen.localdomain>
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
Cc: Petr Mladek <pmladek@suse.com>, scsi <linux-scsi@vger.kernel.org>, Linux PM list <linux-pm@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>, linux-um@lists.infradead.org, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Linux MMC List <linux-mmc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-f2fs-devel@lists.sourceforge.net, linux-block@vger.kernel.org, ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>, Linux ARM <linux-arm-kernel@lists.infradead.org>, netdev <netdev@vger.kernel.org>, sparclinux <sparclinux@vger.kernel.org>, xen-devel@lists.xenproject.org, ceph-devel <ceph-devel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, linux-btrfs <linux-btrfs@vger.kernel.org>, Lars Ellenberg <drbd-dev@lists.linbit.com>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 25, 2019 at 05:13:00PM +0200, Sakari Ailus wrote:

> All other invalid pointer conversion specifiers currently result into a
> warning only. I see that as an orthogonal change to this set. I found
> another issue in checkpatch.pl that may require some discussion; would you
> be ok with addressing this in another set?

If it looks better that way, I have no objection.

-- 
With Best Regards,
Andy Shevchenko


_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
