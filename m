Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x230.google.com (mail-ot0-x230.google.com
 [IPv6:2607:f8b0:4003:c0f::230])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id EDBA7223DB117
 for <linux-nvdimm@lists.01.org>; Fri,  9 Mar 2018 16:53:36 -0800 (PST)
Received: by mail-ot0-x230.google.com with SMTP id l12so10348641otj.7
 for <linux-nvdimm@lists.01.org>; Fri, 09 Mar 2018 16:59:54 -0800 (PST)
MIME-Version: 1.0
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Mar 2018 16:59:53 -0800
Message-ID: <CAPcyv4jtOQAmXZj-p+UQL=K0vhRQ49h=XPh+L6a=ke2Jw23uZw@mail.gmail.com>
Subject: Re: [ndctl PATCH] libndctl.sym: move new interfaces since v59 to a
 nee section
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

On Fri, Mar 9, 2018 at 3:18 PM, Vishal Verma <vishal.l.verma@intel.com> wrote:
> Since we're adding new interfaces, the libndctl 'current' will change to
> '15'. Add a corresponding section in libndctl.sym, and move the new
> symbols to it.
>
> Cc: Dan Williams <dan.j.williams@intel.com>
> Cc: Dave Jiang <dave.jiang@intel.com>
> Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
> Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>

s/nee/new/ in the Subject: line, but other than that:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
