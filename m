Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-io0-x242.google.com (mail-io0-x242.google.com
 [IPv6:2607:f8b0:4001:c06::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4EB2A21B00DC1
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 10:01:17 -0800 (PST)
Received: by mail-io0-x242.google.com with SMTP id x63so2456195ioe.6
 for <linux-nvdimm@lists.01.org>; Wed, 15 Nov 2017 10:05:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171115175131.23631-1-oohall@gmail.com>
References: <20171115175131.23631-1-oohall@gmail.com>
From: Dan Williams <dan.j.williams@gmail.com>
Date: Wed, 15 Nov 2017 10:05:24 -0800
Message-ID: <CAA9_cmcn=VyR3xZWOtxpko6+AhnjC1xqrYXsyz4Z5A+i2DfSbQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] libnvdimm: Add of_node to region and bus descriptors
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
Cc: linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Nov 15, 2017 at 9:51 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> We want to be able to cross reference the region and bus devices
> with the device tree node that they were spawned from. libNVDIMM
> handles creating the actual devices for these internally, so we
> need to pass in a pointer to the relevant node in the descriptor.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>

Looks ok to me,

Acked-by: Dan Williams <dan.j.williams@intel.com>

...this is late if you were expecting a 4.15 merge.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
