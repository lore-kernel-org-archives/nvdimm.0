Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 5154420955F00
 for <linux-nvdimm@lists.01.org>; Wed, 28 Feb 2018 10:43:03 -0800 (PST)
Date: Wed, 28 Feb 2018 19:48:45 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH 3/5] acpi, nfit: Add function to look up nvdimm device
 and provide SMBIOS handle
Message-ID: <20180228184845.GE3769@pd.tnic>
References: <20180222195811.27237-1-tony.luck@intel.com>
 <20180222195811.27237-4-tony.luck@intel.com>
 <20180228173621.GA12883@linux.intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20180228173621.GA12883@linux.intel.com>
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, linux-acpi@vger.kernel.org, Tony Luck <tony.luck@intel.com>, Aristeu Rozanski <aris@redhat.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Len Brown <lenb@kernel.org>, Lv Zheng <lv.zheng@intel.com>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 28, 2018 at 10:36:21AM -0700, Ross Zwisler wrote:
> Just a quick nit - I think we're supposed to use SPDX license identifiers for
> new files?

One would think checkpatch would warn about that but nope.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
