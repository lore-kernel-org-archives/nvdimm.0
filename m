Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9F81F22620E77
 for <linux-nvdimm@lists.01.org>; Fri,  6 Apr 2018 11:28:25 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id v64-v6so2160788otb.13
 for <linux-nvdimm@lists.01.org>; Fri, 06 Apr 2018 11:28:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180406052116.31483-1-oohall@gmail.com>
References: <20180406052116.31483-1-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 6 Apr 2018 11:28:24 -0700
Message-ID: <CAPcyv4hRut3MjihCStXkO6QGXYQf6gmoPPmv_=9K-Z8qoVLL0Q@mail.gmail.com>
Subject: Re: [PATCH v3 1/4] libnvdimm: Add of_node to region and bus
 descriptors
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Apr 5, 2018 at 10:21 PM, Oliver O'Halloran <oohall@gmail.com> wrote:
> We want to be able to cross reference the region and bus devices
> with the device tree node that they were spawned from. libNVDIMM
> handles creating the actual devices for these internally, so we
> need to pass in a pointer to the relevant node in the descriptor.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>

These look good to me. I'll get them applied today and let them soak
over the weekend for a pull request on Monday.

If anyone wants to add Acks or Reviews I can append them to the merge
tag. If there are any NAKs please speak up now, but as far as I know
there are no pending device-tree design concerns.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
