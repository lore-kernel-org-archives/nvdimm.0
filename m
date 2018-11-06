Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail.skyhub.de (mail.skyhub.de [5.9.137.197])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2A6852194D3B9
 for <linux-nvdimm@lists.01.org>; Tue,  6 Nov 2018 10:07:38 -0800 (PST)
Date: Tue, 6 Nov 2018 19:07:35 +0100
From: Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v3 2/2] nfit, mce: validate the mce->addr before using it
Message-ID: <20181106180735.GM13712@zn.tnic>
References: <20181026003729.8420-1-vishal.l.verma@intel.com>
 <20181026003729.8420-2-vishal.l.verma@intel.com>
 <20181106145137.GJ13712@zn.tnic>
 <CAPcyv4j2Y8BEGjixiiCi0_+bbnYJFtezR+FL1_t1J=2X0g7sgg@mail.gmail.com>
 <20181106175341.GK13712@zn.tnic>
 <CAPcyv4g=7HZjxQCdA+fYAacEeRPwcuONGiDUZPunL=_V4jf3qQ@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4g=7HZjxQCdA+fYAacEeRPwcuONGiDUZPunL=_V4jf3qQ@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, linux-nvdimm <linux-nvdimm@lists.01.org>, stable <stable@vger.kernel.org>, linux-edac@vger.kernel.org
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 06, 2018 at 10:02:46AM -0800, Dan Williams wrote:
> Just general cautiousness, I'm not opposed to squashing them.

Nah, I can keep them separate - I was just wondering why.

> mce_usable_address() should not have any sensitivity to NVDIMM vs DRAM
> MCEs.

Ok.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
