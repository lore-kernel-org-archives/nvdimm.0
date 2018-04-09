Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 821162267F0F2
 for <linux-nvdimm@lists.01.org>; Mon,  9 Apr 2018 13:34:41 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id m22-v6so7153392otf.8
 for <linux-nvdimm@lists.01.org>; Mon, 09 Apr 2018 13:34:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180409200920.20177-2-ross.zwisler@linux.intel.com>
References: <20180409200920.20177-1-ross.zwisler@linux.intel.com>
 <20180409200920.20177-2-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 9 Apr 2018 13:34:39 -0700
Message-ID: <CAPcyv4gb=-8YqXQ51yRf0FCDRT5gGTG7jWi-G6SqNtQR19fX9w@mail.gmail.com>
Subject: Re: [ndctl PATCH 2/2] ndctl: fix some spelling mistakes
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

On Mon, Apr 9, 2018 at 1:09 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
> ---
>  Documentation/ndctl/ndctl-create-namespace.txt |  2 +-
>  ccan/list/list.h                               | 12 ++++++------

ccan changes should go to the ccan upstream, I don't want to carry
local ccan changes in ndctl.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
