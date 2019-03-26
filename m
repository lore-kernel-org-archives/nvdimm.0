Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com
 [IPv6:2607:f8b0:4864:20::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2C7EC211D9159
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 16:42:45 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id 3so11424052oir.7
 for <linux-nvdimm@lists.01.org>; Tue, 26 Mar 2019 16:42:45 -0700 (PDT)
MIME-Version: 1.0
References: <20190323042028.4310-1-decui@microsoft.com>
 <20190323042028.4310-5-decui@microsoft.com>
 <072e59f43a276b9daa93c131866fc26fabaad626.camel@intel.com>
 <PU1P153MB0169D3CF9E54018F22C5EB30BF5F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
In-Reply-To: <PU1P153MB0169D3CF9E54018F22C5EB30BF5F0@PU1P153MB0169.APCP153.PROD.OUTLOOK.COM>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 26 Mar 2019 16:42:32 -0700
Message-ID: <CAPcyv4ge34sJ17xbcEpVaiNwcNiN3Z9fS2fjW9-rkaiYDyN8tA@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 4/5] libndctl: Add a new dimm-op
 cmd_is_supported()
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "dexuan.cui@gmail.com" <dexuan.cui@gmail.com>, Michael Kelley <mikelley@microsoft.com>, "qi.fuli@fujitsu.com" <qi.fuli@fujitsu.com>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Mar 26, 2019 at 4:29 PM Dexuan Cui <decui@microsoft.com> wrote:
[..]
> So IMO we need this new dimm-ops to make "ndctl monitor" work
> for Hyper-V. I think the other non-INTEL families can't work with
> "ndctl monitor" either, but I don't have a hardward to test.

I'm certain you're right. Thanks for blazing the trail!
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
