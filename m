Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 00D8B2202E4B1
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 15:16:34 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id y27-v6so8770094oix.10
 for <linux-nvdimm@lists.01.org>; Thu, 22 Mar 2018 15:23:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
References: <20180322184007.25667-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 22 Mar 2018 15:23:05 -0700
Message-ID: <CAPcyv4jDEXKsjF+hZOb7aUaqsZRSUGG1sep+BZyhe2+aXo_weA@mail.gmail.com>
Subject: Re: [ndctl PATCH 1/2] ndctl: complete removal of daxctl io
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Mar 22, 2018 at 11:40 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> commit 0a8dd795b4cf ("ndctl: removing daxctl io")
>
> didn't fully remove all daxctl io, leaving behind a few of the lines which
> were added by the original commit:
>
> commit 67b54c1c76e5 ("ndctl: daxctl: Adding io option for daxctl")
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Fixes: commit 0a8dd795b4cf ("ndctl: removing daxctl io")

Yup, looks good, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
