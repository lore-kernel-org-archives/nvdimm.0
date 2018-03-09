Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5E31722283536
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 14:57:41 -0800 (PST)
Date: Fri, 9 Mar 2018 15:03:58 -0800
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 4/5] firmware: dmi: Add function to look up a handle and
 return DIMM size
Message-ID: <20180309230357.iz7fx47qywx4ijnj@agluck-desk>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-5-tony.luck@intel.com>
 <20180309112053.20605672@endymion>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180309112053.20605672@endymion>
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
To: Jean Delvare <jdelvare@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 09, 2018 at 11:20:53AM +0100, Jean Delvare wrote:
> > +	else if (size & 0x8000)
> > +		bytes = (u64)(size & 0x7fff) << 10;
> > +	else if (size != 0x7fff)
> > +		bytes = (u64)size << 20;
> > +	else
> > +		bytes = (u64)get_unaligned((u32 *)&d[0x1C]) << 20;
> > +
> > +	dmi_memdev[nr].size = bytes;
> 
> I'm curious, do you really need to know the amount of memory to the
> byte? The SMBIOS specification itself does not support granularity
> under 1 kB. I would be very surprised if any machine running Linux
> today has memory modules under 1 MB. If storing in MB you wouldn't need
> a u64...

I got side-tracked reading the standard with the ancient ways
used to report size back in the day when kilobytes was a
plausible unit. So I wrote code that covers all the crazy
cases.  Persistant DIMMs have sizes measured in gigabytes.
I should stop worrying about "0" vs. "fffffff" and just treat
the old cases as errors and simplify the code to be:

	u32 mbytes;

	if (size == 0 || (size & 0x8000))
		mbytes = 0;
	if (size != 0x7fff)
		mbytes = size;
	else
		mbytes = get_unaligned((u32 *)&d[0x1C]);

Then I can use 32-bit throughout this and patch 5.

Thanks for the review.

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
