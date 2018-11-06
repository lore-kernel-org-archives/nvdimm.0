Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x243.google.com (mail-oi1-x243.google.com
 [IPv6:2607:f8b0:4864:20::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EA23A2117CE94
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 08:20:50 -0800 (PST)
Received: by mail-oi1-x243.google.com with SMTP id v198-v6so11228870oif.2
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 08:20:50 -0800 (PST)
MIME-Version: 1.0
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <20181026003729.8420-2-vishal.l.verma@intel.com>
 <20181106145137.GJ13712@zn.tnic>
In-Reply-To: <20181106145137.GJ13712@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Nov 2018 08:20:38 -0800
Message-ID: <CAPcyv4j2Y8BEGjixiiCi0_+bbnYJFtezR+FL1_t1J=2X0g7sgg@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] nfit, mce: validate the mce->addr before using it
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
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 6, 2018 at 6:51 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Thu, Oct 25, 2018 at 06:37:29PM -0600, Vishal Verma wrote:
> > The NFIT machine check handler uses the physical address from the 'mce'
> > structure, and compares it against information in the ACPI NFIT table to
> > determine whether that location lies on an NVDIMM. The mce->addr field
> > however may not always be valid, and this is indicated by the
> > MCI_STATUS_ADDRV bit in the status field.
> >
> > Export mce_usable_address() which already performs validation for the
> > address, and use it in the NFIT handler.
> >
> > Reported-by: Robert Elliott <elliott@hpe.com>
> > Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
> > Cc: stable@vger.kernel.org
> > Cc: Dan Williams <dan.j.williams@intel.com>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > ---
> >  arch/x86/include/asm/mce.h       | 1 +
> >  arch/x86/kernel/cpu/mcheck/mce.c | 3 ++-
> >  drivers/acpi/nfit/mce.c          | 4 ++++
> >  3 files changed, 7 insertions(+), 1 deletion(-)
>
> Is there any particular reason why is this a separate patch and not part
> of the first one?

I recommended the split so the fixes can be tracked and / or reverted
independently if they cause problems.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
