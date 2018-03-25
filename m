Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pf0-x234.google.com (mail-pf0-x234.google.com
 [IPv6:2607:f8b0:400e:c00::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 8767A21E49051
 for <linux-nvdimm@lists.01.org>; Sun, 25 Mar 2018 16:10:27 -0700 (PDT)
Received: by mail-pf0-x234.google.com with SMTP id g14so300586pfh.3
 for <linux-nvdimm@lists.01.org>; Sun, 25 Mar 2018 16:17:03 -0700 (PDT)
Date: Mon, 26 Mar 2018 10:16:47 +1100
From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [PATCH 1/6] libnvdimm: Add of_node to region and bus descriptors
Message-ID: <20180326101647.07673304@gmail.com>
In-Reply-To: <20180323081209.31387-1-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
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
Cc: devicetree@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Fri, 23 Mar 2018 19:12:04 +1100
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
