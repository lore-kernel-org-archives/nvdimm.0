Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x344.google.com (mail-ot1-x344.google.com
 [IPv6:2607:f8b0:4864:20::344])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C64002117D779
 for <linux-nvdimm@lists.01.org>; Wed, 24 Oct 2018 17:25:58 -0700 (PDT)
Received: by mail-ot1-x344.google.com with SMTP id c23so6900032otl.9
 for <linux-nvdimm@lists.01.org>; Wed, 24 Oct 2018 17:25:58 -0700 (PDT)
MIME-Version: 1.0
References: <20181024200148.12597-1-vishal.l.verma@intel.com>
In-Reply-To: <20181024200148.12597-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 24 Oct 2018 17:25:46 -0700
Message-ID: <CAPcyv4huj1kPOWWjHONdS__6wOd2OEw9NrS0YfaRdBMYzzPTVA@mail.gmail.com>
Subject: Re: [PATCH] nfit, mce: only handle uncorrectable machine checks
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
To: Vishal L Verma <vishal.l.verma@intel.com>
Cc: linux-edac@vger.kernel.org, Borislav Petkov <bp@alien8.de>, "Luck, Tony  <tony.luck@intel.com>, stable <stable@vger.kernel.org>, linux-nvdimm" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Oct 24, 2018 at 1:03 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> We only want a machine check error to be added to libnvdimm's 'badblock'
> if it was an uncorrectable error. Currently we insert both corrected and
> uncorrectable errors. Add a check in the nfit mce handler to filter out
> corrected mce events.
>
> Reported-by: Omar Avelar <omar.avelar@intel.com>
> Fixes: 6839a6d96f4e ("nfit: do an ARS scrub on hitting a latent media error")
> Cc: stable@vger.kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Tony Luck <tony.luck@intel.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good, will let this sit in -next until the back half of the merge window.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
