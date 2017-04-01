Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x235.google.com (mail-oi0-x235.google.com
 [IPv6:2607:f8b0:4003:c06::235])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2404721A0481D
 for <linux-nvdimm@lists.01.org>; Sat,  1 Apr 2017 08:54:01 -0700 (PDT)
Received: by mail-oi0-x235.google.com with SMTP id o67so89162250oib.1
 for <linux-nvdimm@lists.01.org>; Sat, 01 Apr 2017 08:54:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170304061307.13530-4-vishal.l.verma@intel.com>
References: <20170304061307.13530-1-vishal.l.verma@intel.com>
 <20170304061307.13530-4-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Sat, 1 Apr 2017 08:53:59 -0700
Message-ID: <CAPcyv4g-=yZQUGUtbQOq-wg0sYvb=Fa8DLJv53WOkJRvCpqWLw@mail.gmail.com>
Subject: Re: [ndctl PATCH v3 3/7] ccan: Add ccan/bitmap in preparation for the
 BTT checker
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

On Fri, Mar 3, 2017 at 10:13 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> The BTT checker will include a bitmap test where we mark a bit for
> each post-map and free block, and check if the bitmap is full. Add
> ccan/bitmap to facilitate this.

Our license compliance tooling flagged this as incompatible for use
with the ndctl utility. We could include it in libndctl since that is
LGPL, but since ndctl is GPLv2 the static linking to this LGPL code
gets flagged. Lets just copy the GPLv2 bitmap implementation from the
kernel.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
