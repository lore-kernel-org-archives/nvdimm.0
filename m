Return-Path: <linux-kernel-owner@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1449006492-1474-1-git-send-email-krivenok.dmitry@gmail.com>
References: <1449006492-1474-1-git-send-email-krivenok.dmitry@gmail.com>
Date: Thu, 3 Dec 2015 18:52:32 -0800
Message-ID: <CAPcyv4ghneEfKyOp35x2WurE52aWEfS-fGPg56oeOq407tTe6Q@mail.gmail.com>
Subject: Re: [PATCH] nvdimm: improve diagnosibility of namespaces
From: Dan Williams <dan.j.williams@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
To: "Dmitry V. Krivenok" <krivenok.dmitry@gmail.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Dec 1, 2015 at 1:48 PM, Dmitry V. Krivenok
<krivenok.dmitry@gmail.com> wrote:
> In order to bind namespace to the driver user must first
> set all mandatory attributes in the following order:
> - uuid
> - size
> - sector_size (for blk namespace only)
>
> If the order is wrong, then user either won't be able to set
> the attribute or bind the namespace.
>
> This simple patch improves diagnosibility of common operations
> with namespaces by printing some details about the error
> instead of failing silently.
>
> Below are examples of error messages (assuming dyndbg is
> enabled for nvdimms):
>
> [/]# echo 4194304 > /sys/bus/nd/devices/region5/namespace5.0/size
> [  288.372612] nd namespace5.0: __size_store: uuid not set
> [  288.374839] nd namespace5.0: size_store: 400000 fail (-6)
> sh: write error: No such device or address
> [/]#
>
> [/]# echo namespace5.0 > /sys/bus/nd/drivers/nd_blk/bind
> [  554.671648] nd_blk namespace5.0: nvdimm_namespace_common_probe: sector size not set
> [  554.674688]  ndbus1: nd_blk.probe(namespace5.0) = -19
> sh: write error: No such device
> [/]#
>
> Signed-off-by: Dmitry V. Krivenok <krivenok.dmitry@gmail.com>

Looks good I'll queue it for 4.5.
