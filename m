Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22e.google.com (mail-oi0-x22e.google.com
 [IPv6:2607:f8b0:4003:c06::22e])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9B3DE21A0480F
 for <linux-nvdimm@lists.01.org>; Fri,  7 Apr 2017 19:14:49 -0700 (PDT)
Received: by mail-oi0-x22e.google.com with SMTP id b187so104243767oif.0
 for <linux-nvdimm@lists.01.org>; Fri, 07 Apr 2017 19:14:49 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170407231803.14936-1-vishal.l.verma@intel.com>
References: <20170407231803.14936-1-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 7 Apr 2017 19:14:48 -0700
Message-ID: <CAPcyv4hWo+KvySB+TVDKAPkBui_41PvvsEjp6KYQ0dgz1t9GdQ@mail.gmail.com>
Subject: Re: [ndctl PATCH v4 0/6] Add ndctl check-namespace
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
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Apr 7, 2017 at 4:17 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Changes in v4:
> - Change the bitmap code to the kernel's GPLv2 Routines instead of the
>   LGPL ccan/bitmap.
> - Upgrade a few messages from 'info' to 'err'

Thanks Vishal! Applied and pushed out to 'pending'.

https://github.com/pmem/ndctl/tree/pending
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
