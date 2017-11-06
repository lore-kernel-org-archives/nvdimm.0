Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-qk0-x22a.google.com (mail-qk0-x22a.google.com
 [IPv6:2607:f8b0:400d:c09::22a])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 033E02034EE13
 for <linux-nvdimm@lists.01.org>; Mon,  6 Nov 2017 15:28:15 -0800 (PST)
Received: by mail-qk0-x22a.google.com with SMTP id 78so6217199qkz.0
 for <linux-nvdimm@lists.01.org>; Mon, 06 Nov 2017 15:32:14 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20171030204127.4779-1-Lijun.Pan@dell.com>
References: <20171030204127.4779-1-Lijun.Pan@dell.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 6 Nov 2017 15:32:12 -0800
Message-ID: <CAPcyv4gxRuMBb2cCnONg5Hq2PgzirHwOULjOfspOezkeBrmfGw@mail.gmail.com>
Subject: Re: [PATCH] acpi/nfit: export read_only attribute of dimms
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
To: Lijun Pan <Lijun.Pan@dell.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Oct 30, 2017 at 1:41 PM, Lijun Pan <Lijun.Pan@dell.com> wrote:
> Though flags attribute provides enough information about
> the dimm, it is nice to export the read_only attribute if
> bit3 of NVDIMM state flag is set.
> If error is injected by BIOS, bit3 and bit1 are both set.
> If DIMM is set to read-only by BIOS, bit3 is set.
> Hence bit3 is good enough to tell whether the dimm is in
> read-only mode or not.

Hmm, can you say about more about why we need this additional attribute?

Applications don't read and write the DIMM directly, they only
interface with the DIMM through namespaces of a given region. The
region device already has a 'read_only' attribute. See
read_only_show() in drivers/nvdimm/region_devs.c.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
