Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 by ml01.01.org (Postfix) with ESMTP id A3CF12218E93E
 for <linux-nvdimm@lists.01.org>; Tue,  5 Dec 2017 13:40:20 -0800 (PST)
Date: Tue, 5 Dec 2017 22:44:41 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [RFC PATCH 4/4] EDAC, skx_edac: Detect non-volatile DIMMs
Message-ID: <20171205214441.pfxusrz5lpew5kre@pd.tnic>
References: <cover.1512070562.git.tony.luck@intel.com>
 <da4c989314e82ec29195804ba5349ac3136f74c0.1512070562.git.tony.luck@intel.com>
 <20171205105451.ob23asixm726hysb@pd.tnic>
 <20171205200336.tbx7oypjuca3g6vn@agluck-desk>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20171205200336.tbx7oypjuca3g6vn@agluck-desk>
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
Cc: Jean Delvare <jdelvare@suse.com>, linux-nvdimm@lists.01.org, Mauro Carvalho Chehab <mchehab@kernel.org>, Aristeu Rozanski <aris@redhat.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, linux-acpi@vger.kernel.org, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Lv Zheng <lv.zheng@intel.com>, linux-edac@vger.kernel.org, Len Brown <lenb@kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 05, 2017 at 12:03:37PM -0800, Luck, Tony wrote:
> I could. But what happens when someone ends up on a system with
> an edac driver configured without ACPI_NFIT that does have NVDIMMs?

Same thing when you land on a system with a kernel where the driver for
a piece of hw is not enabled. I mean, this won't be an issue on distros
as there *everything* is enabled but for tailored configs, where people
want skx_edac but don't need the nvdimm part.

> I can make a stub version of nfit_get_smbios_id() that returns some
> error code ... and have the EDAC driver report size==0.
> 
> Would that be OK?

Sure, thanks!

> /me finds that the "Enter" key on his keyboard will put in a newline.
> Hurrah! now I don't have to copy/paste them from Boris.

Cheers! :-)))

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
