Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x242.google.com (mail-ot0-x242.google.com
 [IPv6:2607:f8b0:4003:c0f::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 4F895224AE8DA
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 10:00:39 -0700 (PDT)
Received: by mail-ot0-x242.google.com with SMTP id g97-v6so13987306otg.13
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 10:07:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323081209.31387-3-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-3-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Mar 2018 10:07:11 -0700
Message-ID: <CAPcyv4h=b9fCN7mCU8Yge5804oxVfErXRa_3h7QVcKdEhBbVHg@mail.gmail.com>
Subject: Re: [PATCH 3/6] libnvdimm: Add device-tree based driver
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
Cc: Device Tree <devicetree@vger.kernel.org>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Mar 23, 2018 at 1:12 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> This patch adds peliminary device-tree bindings for the NVDIMM driver.

*preliminary

> Currently this only supports one bus (created at probe time) which all
> regions are added to with individual regions being created by a platform
> device driver.
>
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> I suspect the platform driver should be holding a reference to the
> created region. I left that out here since previously Dan has said
> he'd rather keep the struct device internal to libnvdimm and the only
> other way a region device can disappear is when the bus is unregistered.

Hmm, but this still seems broken if bus teardown races region
teardown. I think the more natural model, given the way libnvdimm is
structured, to have each of these of_nd_region instances create their
own nvdimm bus. Thoughts?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
