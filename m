Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15])
 (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id D432E220C2A75
 for <linux-nvdimm@lists.01.org>; Sat, 10 Mar 2018 05:16:02 -0800 (PST)
Date: Sat, 10 Mar 2018 14:22:17 +0100
From: Jean Delvare <jdelvare@suse.de>
Subject: Re: [PATCH 4/5] firmware: dmi: Add function to look up a handle and
 return DIMM size
Message-ID: <20180310142217.0054dc35@endymion>
In-Reply-To: <20180309230357.iz7fx47qywx4ijnj@agluck-desk>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-5-tony.luck@intel.com>
 <20180309112053.20605672@endymion>
 <20180309230357.iz7fx47qywx4ijnj@agluck-desk>
MIME-Version: 1.0
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
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, linux-nvdimm@lists.01.org, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki  <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo" <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi Tony,

On Fri, 9 Mar 2018 15:03:58 -0800, Luck, Tony wrote:
> I got side-tracked reading the standard with the ancient ways
> used to report size back in the day when kilobytes was a
> plausible unit. So I wrote code that covers all the crazy
> cases.  Persistant DIMMs have sizes measured in gigabytes.
> I should stop worrying about "0" vs. "fffffff" and just treat
> the old cases as errors and simplify the code to be:
> 
> 	u32 mbytes;
> 
> 	if (size == 0 || (size & 0x8000))
> 		mbytes = 0;
> 	if (size != 0x7fff)

"else" missing.

> 		mbytes = size;
> 	else
> 		mbytes = get_unaligned((u32 *)&d[0x1C]);
> 
> Then I can use 32-bit throughout this and patch 5.

Note that it is possible to store MB values (up to 16 MB) using kB as
the unit. The specification allows for it, and a few systems use that
option. For example [1], the DMI data of a Supermicro X8STi board looks
like:

Handle 0x0038, DMI type 17, 28 bytes
Memory Device
	(...)
	Size: 4096 kB

and it is encoded as 0x9000.

I understand you don't care about such "small" memory modules for
persistent DIMMs, however the API is not specific to these, and it
could be confusing for callers that modules between 1 MB and 16 MB are
sometimes reported as 0 and sometimes not. So I believe that your code
should handle this case.

> Thanks for the review.

You're welcome.

[1] Let's be honest, that was the only instance out of the 180 DMI dumps
I collected. So it's fairly rare. But it did happen.

-- 
Jean Delvare
SUSE L3 Support
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
