Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2886F2117CEBE
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 06:51:40 -0800 (PST)
Date: Tue, 6 Nov 2018 15:51:37 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 2/2] nfit, mce: validate the mce->addr before using it
Message-ID: <20181106145137.GJ13712@zn.tnic>
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <20181026003729.8420-2-vishal.l.verma@intel.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20181026003729.8420-2-vishal.l.verma@intel.com>
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
To: Vishal Verma <vishal.l.verma@intel.com>
Cc: Tony Luck <tony.luck@intel.com>, linux-nvdimm@lists.01.org, stable@vger.kernel.org, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 25, 2018 at 06:37:29PM -0600, Vishal Verma wrote:
> The NFIT machine check handler uses the physical address from the 'mce'
> structure, and compares it against information in the ACPI NFIT table to
> determine whether that location lies on an NVDIMM. The mce->addr field
> however may not always be valid, and this is indicated by the
> MCI_STATUS_ADDRV bit in the status field.
> 
> Export mce_usable_address() which already performs validation for the
> address, and use it in the NFIT handler.
> 
> Reported-by: Robert Elliott <elliott@hpe.com>
> Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
> Cc: stable@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> ---
>  arch/x86/include/asm/mce.h       | 1 +
>  arch/x86/kernel/cpu/mcheck/mce.c | 3 ++-
>  drivers/acpi/nfit/mce.c          | 4 ++++
>  3 files changed, 7 insertions(+), 1 deletion(-)

Is there any particular reason why is this a separate patch and not part
of the first one?

Also, do s/mce/MCE/g.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
