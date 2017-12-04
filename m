Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E43BA20352A8C
 for <linux-nvdimm@lists.01.org>; Mon,  4 Dec 2017 13:58:47 -0800 (PST)
Date: Mon, 4 Dec 2017 14:03:16 -0800
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [RFC PATCH 2/4] firmware: dmi: Add function to look up a handle
 and return DIMM size
Message-ID: <20171204220316.nl5m4lmyek7alvhb@agluck-desk>
References: <cover.1512070562.git.tony.luck@intel.com>
 <2fae02861e5c446c0cdd30ba3e00fad55db97807.1512070562.git.tony.luck@intel.com>
 <20171204213813.rm32qqeqchx37c5x@pd.tnic>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171204213813.rm32qqeqchx37c5x@pd.tnic>
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
To: Borislav Petkov <bp@alien8.de>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Dec 04, 2017 at 10:38:14PM +0100, Borislav Petkov wrote:
> On Thu, Nov 30, 2017 at 12:40:40PM -0800, Tony Luck wrote:
> >  	dmi_memdev[nr].bank = dmi_string(dm, d[0x11]);
> 
> <---- newline here.
> 
> > +	size = get_unaligned((u16 *)&d[0xC]);
> > +	if (size == 0)
> > +		bytes = 0;
> > +	else if (size == 0xffff)
> > +		bytes = ~0ul;
> > +	else if (size & 0x8000)
> > +		bytes = (u64)(size & 0x7fff) << 10;
> > +	else if (size != 0x7fff)
> > +		bytes = (u64)size << 20;
> > +	else
> > +		bytes = (u64)get_unaligned((u32 *)&d[0x1C]) << 20;
> 
> <---- newline here.

Ok ... it does read better with those breaks. Will add.

> So dmi_memdev_name() also loops over dmi_memdev and returns bank and
> device. This new function returns size.
> 
> If code is going to be calling those one after the other, you could do a
> 
> 	dmi_memdev_desc(u16 handle, struct memdev_desc *desc)

Current callers are from different code paths (dmi_memdev_name() from
ghes and EFI, dmi_memdev_size() just from the Skylake EDAC driver).
If we later find a place that calls both this would be a good cleanup.

> which fills up a descriptor with all fields a caller would need in one
> go so that you don't have to iterate multiple times. Looking at struct
> dmi_memdev_info, there are no more fields so maybe this is probably
> silly though or you can simply return struct dmi_memdev_info directly...
> 
> Meh.

I take it that you talked yourself out of asking for the cleanup now?

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
