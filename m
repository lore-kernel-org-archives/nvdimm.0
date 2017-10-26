Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6602B20352602
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 14:50:33 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id h6so8079558oia.10
 for <linux-nvdimm@lists.01.org>; Thu, 26 Oct 2017 14:54:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20171026102931.lpob76adflhqcpbq@mwanda>
References: <20171026102931.lpob76adflhqcpbq@mwanda>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 26 Oct 2017 14:54:18 -0700
Message-ID: <CAPcyv4h0iQ1ypopc1RZ9bL9HebZBsOFesJM3KUM8bU45Y-xc1g@mail.gmail.com>
Subject: Re: [bug report] libnvdimm: clear the internal poison_list when
 clearing badblocks
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
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Oct 26, 2017 at 3:29 AM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Hello Vishal Verma,
>
> The patch e046114af5fc: "libnvdimm: clear the internal poison_list
> when clearing badblocks" from Sep 30, 2016, leads to the following
> static checker warning:

Thanks for the report Dan, we'll take a look.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
