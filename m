Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E3EC71A1E11
 for <linux-nvdimm@lists.01.org>; Mon, 22 Aug 2016 15:43:23 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id f189so172613280oig.3
 for <linux-nvdimm@lists.01.org>; Mon, 22 Aug 2016 15:43:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1471639258-28106-1-git-send-email-vishal.l.verma@intel.com>
References: <1471639258-28106-1-git-send-email-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 22 Aug 2016 15:43:22 -0700
Message-ID: <CAPcyv4iw0ErHB-1yp+w4nd+7A5aVHXbieRq2ikR953UL4FBUVQ@mail.gmail.com>
Subject: Re: [PATCH] acpi,
 nfit: check for the correct event code in notifications
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
Cc: Linux ACPI <linux-acpi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Aug 19, 2016 at 1:40 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Commit 209851649dc4 "acpi: nfit: Add support for hot-add" added
> support for _FIT notifications, but it neglected to verify the
> notification event code matches the one in the ACPI spec for
> "NFIT Update". Currently there is only one code in the spec, but
> once additional codes are added, older kernels (without this fix)
> will misbehave by assuming all event notifications are for an
> NFIT Update.
>
> Fixes: 209851649dc4 ("acpi: nfit: Add support for hot-add")
> Cc: <stable@vger.kernel.org>
> Cc: <linux-acpi@vger.kernel.org>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Reported-by: Linda Knippers <linda.knippers@hpe.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good to me.  Given the lead time of spec changes I think this
can wait for the 4.9 merge window.  I'll add it to the -next branch.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
