Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x232.google.com (mail-ot0-x232.google.com
 [IPv6:2607:f8b0:4003:c0f::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id B397422146743
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 10:02:00 -0700 (PDT)
Received: by mail-ot0-x232.google.com with SMTP id 23-v6so3487970otj.0
 for <linux-nvdimm@lists.01.org>; Fri, 23 Mar 2018 10:08:33 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180323081209.31387-4-oohall@gmail.com>
References: <20180323081209.31387-1-oohall@gmail.com>
 <20180323081209.31387-4-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 23 Mar 2018 10:08:32 -0700
Message-ID: <CAPcyv4i2vXN6ib6Ofs0f-hRG93wZ3jYyBHEGQZXOqk9CprPmGw@mail.gmail.com>
Subject: Re: [PATCH 4/6] libnvdimm/of: Symlink platform and region devices
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
> Add a way direct link between the region and the platform device that
> creates the region.
>

This linking would not be needed if of_nd_regions each lived on their own bus.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
