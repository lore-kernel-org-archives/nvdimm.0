Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59B5D211E34B6
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 20:31:17 -0700 (PDT)
Received: by mail-oi1-x241.google.com with SMTP id w139so689462oie.9
 for <linux-nvdimm@lists.01.org>; Thu, 21 Mar 2019 20:31:17 -0700 (PDT)
MIME-Version: 1.0
References: <PU1P153MB01691E80896E9EAA0C8245EDBF7D0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
 <9876fd8a491e339f2f41a47e2195d354bf0d5fb2.camel@intel.com>
 <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169CA436F52268DD2BEF745BF430@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 21 Mar 2019 20:31:05 -0700
Message-ID: <CAPcyv4jR2-9JSh+tdyyWX1pK6o+h-bHAsuj1JSdNA7Tr8OJrMw@mail.gmail.com>
Subject: Re: [ndctl PATCH v2 4/4] ndctl, monitor: support NVDIMM_FAMILY_HYPERV
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
To: Dexuan Cui <decui@microsoft.com>
Cc: "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Michael Kelley <mikelley@microsoft.com>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 21, 2019 at 7:09 PM Dexuan Cui <decui@microsoft.com> wrote:
[..]
> > That way if the user enters any of the unsupported options, they will
> > just fail normally, and the user will be expected to provide the right
> > options for the environment they know they're running in.
>
> When the user enters any of the unsupported options, they will only
> get an "no dimms to monitor" error, which gives no hint why the
> error happens, and confuses the user...

For the monitor it should be ok to specify options and thresholds that
the DIMM does not support. The events simply won't fire. Now if the
user cares to know which events are supported / live we can add "list"
 enumeration interface for that, but I otherwise think monitor should
just silently handle unsupported monitor options.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
