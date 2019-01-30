Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x241.google.com (mail-oi1-x241.google.com
 [IPv6:2607:f8b0:4864:20::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4B2952194D3B8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 12:16:48 -0800 (PST)
Received: by mail-oi1-x241.google.com with SMTP id j21so739159oii.8
 for <linux-nvdimm@lists.01.org>; Wed, 30 Jan 2019 12:16:48 -0800 (PST)
MIME-Version: 1.0
References: <20190130200521.9245-1-vishal.l.verma@intel.com>
In-Reply-To: <20190130200521.9245-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 30 Jan 2019 12:16:36 -0800
Message-ID: <CAPcyv4gMFYSk8gG8t7c-aPHSYHHmrQORZj=LD79m7-u1ErRgvw@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl: Fix the failure interpretation for status
 translations
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
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Jan 30, 2019 at 12:05 PM Vishal Verma <vishal.l.verma@intel.com> wrote:
>
> commit 62bbfce3cb62 ("libndctl, intel: Add infrastructure for
> firmware_status translation") has the unfortunate side effect of making
> all NDCTL commands fail with -ENOMSG unless an xlat_firmware_status
> function is defined for the DIMM family. A failure to translate just
> means proceed with the information that we do have, not report a
> command failure.
>
> Fixes: 62bbfce3cb62 ("libndctl, intel: Add infrastructure for firmware_status translation")
> Reported-by: Oliver O'Halloran <oohall@gmail.com>
> Based-on-patch-by: Dan Williams <dan.j.williams@intel.com>

You can just replace that with:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
