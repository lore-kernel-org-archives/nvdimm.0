Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x243.google.com (mail-ot0-x243.google.com
 [IPv6:2607:f8b0:4003:c0f::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 03A75226C7C2F
 for <linux-nvdimm@lists.01.org>; Tue,  3 Apr 2018 10:37:52 -0700 (PDT)
Received: by mail-ot0-x243.google.com with SMTP id y46-v6so20316325otd.4
 for <linux-nvdimm@lists.01.org>; Tue, 03 Apr 2018 10:37:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180403142415.30083-3-oohall@gmail.com>
References: <20180403142415.30083-1-oohall@gmail.com>
 <20180403142415.30083-3-oohall@gmail.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 3 Apr 2018 10:37:51 -0700
Message-ID: <CAPcyv4jW5H8A96MFD7-UazNSZq-t1_NfrChNB3p9=somdBpsNw@mail.gmail.com>
Subject: Re: [RESEND v2 3/4] doc/devicetree: Persistent memory region bindings
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

On Tue, Apr 3, 2018 at 7:24 AM, Oliver O'Halloran <oohall@gmail.com> wrote:
> Add device-tree binding documentation for the nvdimm region driver.
>
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---
> v2: Changed name from nvdimm-region to pmem-region.
>     Cleaned up the example binding and fixed the overlapping regions.
>     Added support for multiple regions in a single reg.
> ---
>  .../devicetree/bindings/pmem/pmem-region.txt       | 80 ++++++++++++++++++++++
>  MAINTAINERS                                        |  1 +
>  2 files changed, 81 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/pmem/pmem-region.txt

Device-tree folks, does this look, ok?

Oliver, is there any concept of a management interface to the
device(s) backing these regions? libnvdimm calls these "nmem" devices
and support operations like health status and namespace label
management.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
