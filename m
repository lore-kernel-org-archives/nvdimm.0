Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x343.google.com (mail-ot1-x343.google.com
 [IPv6:2607:f8b0:4864:20::343])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8D95D211B739B
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 16:29:21 -0800 (PST)
Received: by mail-ot1-x343.google.com with SMTP id n8so22132472otl.6
 for <linux-nvdimm@lists.01.org>; Mon, 21 Jan 2019 16:29:21 -0800 (PST)
MIME-Version: 1.0
References: <154785884329.2202034.3295476681016958230.stgit@dwillia2-desk3.amr.corp.intel.com>
 <20190122002615.GB5855@richard>
In-Reply-To: <20190122002615.GB5855@richard>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 21 Jan 2019 16:29:08 -0800
Message-ID: <CAPcyv4jXS-doCdyTrcV3DL63N-q4m1H2=Msgm1z88HnF8bcEig@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: Clarify nd_pfn_init() flow
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
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Jan 21, 2019 at 4:26 PM Wei Yang <richardw.yang@linux.intel.com> wrote:
[..]
> >@@ -706,6 +711,22 @@ static int nd_pfn_init(struct nd_pfn *nd_pfn)
> >               sig = DAX_SIG;
> >       else
> >               sig = PFN_SIG;
> >+
> >+      /*
> >+       * Check for an existing 'pfn' superblock before writing a new
> >+       * one. The intended flow is that on the first probe of an
> >+       * nd_{pfn,dax} device the superblock is calculated and written
> >+       * to the namespace. In this case nd_pfn_validate() returns
> >+       * -ENODEV because no valid superblock exists currently.
>
> As you replied in following mail:
>
> 3/ If present, nd_pfn_validate() returns 0 and nd_dax_probe()
> registers the dax0.1 device (this is a libnvdimm 'personality device).
>
> So at this point, nd_pfn_validate() return 0 or -ENODEV?

In this case 0, because the configuration was successfully validated.

-ENODEV, is only returned for the initial case where we want the
kernel to write the configuration.

All other error codes are an actual failure and the probe procedure stops.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
