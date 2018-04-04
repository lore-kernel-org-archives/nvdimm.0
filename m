Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x244.google.com (mail-pl0-x244.google.com
 [IPv6:2607:f8b0:400e:c01::244])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 9377E2264A206
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 04:31:06 -0700 (PDT)
Received: by mail-pl0-x244.google.com with SMTP id c21-v6so9918883plz.10
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 04:31:06 -0700 (PDT)
Date: Wed, 4 Apr 2018 21:30:56 +1000
From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RESEND v2 1/4] libnvdimm: Add of_node to region and bus
 descriptors
Message-ID: <20180404213056.3ef5bd66@gmail.com>
In-Reply-To: <20180403142415.30083-1-oohall@gmail.com>
References: <20180403142415.30083-1-oohall@gmail.com>
MIME-Version: 1.0
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
Cc: linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed,  4 Apr 2018 00:24:12 +1000
Oliver O'Halloran <oohall@gmail.com> wrote:

> We want to be able to cross reference the region and bus devices
> with the device tree node that they were spawned from. libNVDIMM
> handles creating the actual devices for these internally, so we
> need to pass in a pointer to the relevant node in the descriptor.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> ---
Acked-by: Balbir Singh <bsingharora@gmail.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
