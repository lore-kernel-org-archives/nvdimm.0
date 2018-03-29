Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x233.google.com (mail-ot0-x233.google.com
 [IPv6:2607:f8b0:4003:c0f::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0E2BC225501DE
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 16:22:05 -0700 (PDT)
Received: by mail-ot0-x233.google.com with SMTP id r30-v6so8069599otr.2
 for <linux-nvdimm@lists.01.org>; Thu, 29 Mar 2018 16:28:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180329231836.29453-2-vishal.l.verma@intel.com>
References: <20180329231836.29453-1-vishal.l.verma@intel.com>
 <20180329231836.29453-2-vishal.l.verma@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 29 Mar 2018 16:28:45 -0700
Message-ID: <CAPcyv4hhF=ZYs1nOhVjEoYnBiz+r4XhZLE6VOXrhmvaszvZHbw@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/3] ndctl,
 inject-smart: fix usage of strerror(errno)
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

On Thu, Mar 29, 2018 at 4:18 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> We were incorrectly using strerror(errno) for a number of libndctl
> calls, which is incorrect, as libndctl doesn't set errno.
> Instead, use the return code from the API to print the error.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

Looks good.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
