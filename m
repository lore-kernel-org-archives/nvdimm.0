Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3900B226462F3
 for <linux-nvdimm@lists.01.org>; Mon, 12 Mar 2018 09:39:46 -0700 (PDT)
Date: Mon, 12 Mar 2018 09:46:06 -0700
From: "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH 4/5] firmware: dmi: Add function to look up a handle and
 return DIMM size
Message-ID: <20180312164605.ytd6vl4nygwh2wop@agluck-desk>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-5-tony.luck@intel.com>
 <20180309112053.20605672@endymion>
 <20180309230357.iz7fx47qywx4ijnj@agluck-desk>
 <20180310142217.0054dc35@endymion>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180310142217.0054dc35@endymion>
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
Cc: Mauro Carvalho Chehab <mchehab@kernel.org>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Borislav Petkov <bp@alien8.de>, Aristeu Rozanski <aris@redhat.com>, Borislav Petkov <bp@suse.de>, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sat, Mar 10, 2018 at 02:22:17PM +0100, Jean Delvare wrote:
> Note that it is possible to store MB values (up to 16 MB) using kB as
> the unit. The specification allows for it, and a few systems use that
> option. For example [1], the DMI data of a Supermicro X8STi board looks
> like:
> 
> Handle 0x0038, DMI type 17, 28 bytes
> Memory Device
> 	(...)
> 	Size: 4096 kB
> 
> and it is encoded as 0x9000.
> 
> I understand you don't care about such "small" memory modules for
> persistent DIMMs, however the API is not specific to these, and it
> could be confusing for callers that modules between 1 MB and 16 MB are
> sometimes reported as 0 and sometimes not. So I believe that your code
> should handle this case.

Then I might as well go with a fully standards compliant version
(just in case somebody in the future has a 512KB module encoded as
0x8200, they would also be confused by a return of 0 MB).

That means I should stick with u64 as the type of the "size" field
(using KB in a u32 would max out with 4TB modules, which may happen
before I retire).

-Tony
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
