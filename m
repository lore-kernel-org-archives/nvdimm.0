Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E4C012274F3F9
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 14:17:17 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id e123-v6so6525131oih.13
 for <linux-nvdimm@lists.01.org>; Thu, 12 Apr 2018 14:17:17 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180412202804.18141-1-ross.zwisler@linux.intel.com>
References: <1523404208.5172.7.camel@intel.com>
 <20180412202804.18141-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 12 Apr 2018 14:17:15 -0700
Message-ID: <CAPcyv4gYudKXuq+E0wvSCj8e+HT-JOu6uJKD5k+-g+tzBu=hZw@mail.gmail.com>
Subject: Re: [ndctl PATCH v3] ndctl: complete move to "fsdax" and "devdax"
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

On Thu, Apr 12, 2018 at 1:28 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Add on to the work started by:
>
> commit ebb4fb605e68 ("ndctl, create-namespace: introduce "fsdax" and "devdax" modes")
>
> and change some more user visible places to use "fsdax" and "devdax" modes
> instead of "memory" and "dax", respectively.  Having multiple terms for the
> same mode is confusing for users.
>
> We will continue to accept "memory" and "dax" as parameters, but all output
> and man pages will now use the updated terms.
>
> Note that after the above referenced commit we still printed the old names
> in the default 'ndctl list' output for backward compatibility with scripts.
> This patch intentionally breaks that backward compatibility in favor of
> avoiding confusion and using the new mode names everywhere.
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
