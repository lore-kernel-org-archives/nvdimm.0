Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com
 [IPv6:2607:f8b0:4864:20::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4BB2211350C4
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 10:02:58 -0800 (PST)
Received: by mail-oi1-x244.google.com with SMTP id p144-v6so11487397oic.12
 for <linux-nvdimm@lists.01.org>; Tue, 06 Nov 2018 10:02:58 -0800 (PST)
MIME-Version: 1.0
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <20181026003729.8420-2-vishal.l.verma@intel.com>
 <20181106145137.GJ13712@zn.tnic>
 <CAPcyv4j2Y8BEGjixiiCi0_+bbnYJFtezR+FL1_t1J=2X0g7sgg@mail.gmail.com>
 <20181106175341.GK13712@zn.tnic>
In-Reply-To: <20181106175341.GK13712@zn.tnic>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Nov 2018 10:02:46 -0800
Message-ID: <CAPcyv4g=7HZjxQCdA+fYAacEeRPwcuONGiDUZPunL=_V4jf3qQ@mail.gmail.com>
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

On Tue, Nov 6, 2018 at 9:53 AM Borislav Petkov <bp@alien8.de> wrote:
>
> On Tue, Nov 06, 2018 at 08:20:38AM -0800, Dan Williams wrote:
> > I recommended the split so the fixes can be tracked and / or reverted
> > independently if they cause problems.
>
> Do you have anything concrete in mind that might go wrong or just a
> general cautiousness?

Just general cautiousness, I'm not opposed to squashing them.

> Or do you think the hw might not spit what mce_usable_address() is
> checking for, for NVDIMM MCEs, so that you'd like to be able to revert
> that second patch?

mce_usable_address() should not have any sensitivity to NVDIMM vs DRAM MCEs.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
