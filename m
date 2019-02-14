Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com
 [IPv6:2607:f8b0:4864:20::332])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 64886202E5324
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 09:55:39 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id b3so11999558otp.4
 for <linux-nvdimm@lists.01.org>; Thu, 14 Feb 2019 09:55:39 -0800 (PST)
MIME-Version: 1.0
References: <20190214163422.15221-1-elliott@hpe.com>
 <20190214163422.15221-2-elliott@hpe.com>
In-Reply-To: <20190214163422.15221-2-elliott@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 14 Feb 2019 09:55:27 -0800
Message-ID: <CAPcyv4jasx=FGUcY776fbu06CTf5u9pxy+zCEF0y3RUar7F5sw@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] autoconf: print more possible package names for
 keyutils.h
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
To: Robert Elliott <elliott@hpe.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Feb 14, 2019 at 8:29 AM Robert Elliott <elliott@hpe.com> wrote:
>
> The distro package names providing keyutils.h are inconsistent, so
> print more than just one suggestion:
>     keyutils-libs-devel (Red Hat)
>     keyutils-devel (SUSE)
>     libkeyutils-dev (Ubuntu)
>
> Fixes: 86b078b44275 ("ndctl: add passphrase management commands")
> Signed-off-by: Robert Elliott <elliott@hpe.com>

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
