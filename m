Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4BAFD21B00DDF
 for <linux-nvdimm@lists.01.org>; Wed,  8 Nov 2017 08:53:02 -0800 (PST)
Received: by mail-oi0-x232.google.com with SMTP id a132so2392142oih.11
 for <linux-nvdimm@lists.01.org>; Wed, 08 Nov 2017 08:57:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171107224821.12196-1-vishal.l.verma@intel.com>
References: <20171107224821.12196-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 8 Nov 2017 08:57:01 -0800
Message-ID: <CAPcyv4gRGXq-Vr8LrQ4MN9=AixoGp_6z-SpN4-_mW2hyfkmEKg@mail.gmail.com>
Subject: Re: [PATCH] nfit_test: stricter bounds checking for error injection
 commands
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
Cc: "Dokupil, Dariusz" <dariusz.dokupil@intel.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Nov 7, 2017 at 2:48 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Ensure that the in/out sizes passed in the nd_cmd_package are sane for
> the fixed output size commands (i.e. inject error and clear injected
> error).
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good, I'll also add a:

Reported-by: Dariusz Dokupil <dariusz.dokupil@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
