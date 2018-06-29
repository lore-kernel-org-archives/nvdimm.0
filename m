Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x241.google.com (mail-ot0-x241.google.com
 [IPv6:2607:f8b0:4003:c0f::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8F18C203369D6
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 16:57:30 -0700 (PDT)
Received: by mail-ot0-x241.google.com with SMTP id d19-v6so11680401oti.8
 for <linux-nvdimm@lists.01.org>; Fri, 29 Jun 2018 16:57:30 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180629233927.6232-2-ross.zwisler@linux.intel.com>
References: <20180629233927.6232-1-ross.zwisler@linux.intel.com>
 <20180629233927.6232-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 29 Jun 2018 16:57:29 -0700
Message-ID: <CAPcyv4h+gtn-r6cVJS9wp+kbu9WGzWNFBBKQ0WjGpD7nJoo-cA@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/3] ndctl/list.c: simplify flags handling
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

On Fri, Jun 29, 2018 at 4:39 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> ndctl/list.c keeps track of a set of enum util_json_flags which are based
> on the command line options passed in.  This handling is a little messy,
> though.  We have an accessor function, listopts_to_flags(), which is used
> multiple times.  We sometimes pass the flags around as function arguments,
> and we also have a copy stashed in the local struct list_filter_arg called
> "lfa".  In some functions we access the flags in multiple ways.
>
> These flags are local to ndctl/list.c, are set exactly once per invocation
> and never change.  Create a variable local to that file, initialize it once
> and use it everywhere.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  ndctl/list.c  | 54 +++++++++++++++++++++++++++---------------------------
>  util/filter.h |  1 -
>  2 files changed, 27 insertions(+), 28 deletions(-)

I don't see the point of this thrash. It's not a win code size wise
and I think it needlessly adds more dependence on global variables.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
