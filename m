Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ua0-x234.google.com (mail-ua0-x234.google.com
 [IPv6:2607:f8b0:400c:c08::234])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 05BFB21D49C82
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 13:17:08 -0700 (PDT)
Received: by mail-ua0-x234.google.com with SMTP id d29so162241115uai.2
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jul 2017 13:19:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170728194543.GA20726@linux.intel.com>
References: <20170728180446.GA31104@linux.intel.com>
 <CAPcyv4i5YWK6RHYEkH6C1oPWwhPLOD-atmkMVXDXc-qdv_0hgw@mail.gmail.com>
 <20170728194543.GA20726@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Jul 2017 13:19:11 -0700
Message-ID: <CAPcyv4i9nY8tjx_AuqHGZ4bRvazao=-u+r+O9mvkw1vdR0Dacg@mail.gmail.com>
Subject: Re: QEMU NVDIMM as type 7 in e820 table
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, Qemu Developers <qemu-devel@nongnu.org>, Xiao Guangrong <guangrong.xiao@gmail.com>, Igor Mammedov <imammedo@redhat.com>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jul 28, 2017 at 12:45 PM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Fri, Jul 28, 2017 at 11:11:10AM -0700, Dan Williams wrote:
>> On Fri, Jul 28, 2017 at 11:04 AM, Ross Zwisler
[..]
> [ Adding Linda & Toshi to see if they have an opinion. ]
>
> I guess maybe we don't need it.  Yep, /proc/iomem looks good:
>
>   # cat /proc/iomem
>   00000000-00000fff : Reserved
>   00001000-0009fbff : System RAM
>   ...
>   100000000-23fffffff : System RAM
>   240000000-a3fffffff : Persistent Memory
>     240000000-a3fffffff : namespace0.0
>
> I was just worried that this was an inconsistency between the way that virtual
> NVDIMMs are presented vs the way that they will be presented on bare metal.  I
> at least look at the e820 table to get my bearings of how memory is laid out -
> maybe I just need to look at /proc/iomem instead?

I don't think e820 matters as long as /proc/iomem ends up correct, and
the effective type is "reserved" . There's nothing in the
specification that requires the OS to validate e820 ranges vs NFIT.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
